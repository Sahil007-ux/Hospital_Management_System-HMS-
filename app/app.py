"""HMS GUI backend - Flask + pyodbc, schema-driven CRUD over SQL Server.

Run:  python app.py      then open http://127.0.0.1:5000
Config via env vars: HMS_SERVER (default "."), HMS_DB, HMS_DRIVER, HMS_UID/HMS_PWD (else Windows auth)
"""
import os
import re
import datetime as dt
from decimal import Decimal

import pyodbc
from flask import Flask, jsonify, request, send_from_directory

SERVER = os.environ.get("HMS_SERVER", ".")
DB = os.environ.get("HMS_DB", "Hospital_Management_System")
DRIVER = os.environ.get("HMS_DRIVER", "ODBC Driver 18 for SQL Server")
UID, PWD = os.environ.get("HMS_UID"), os.environ.get("HMS_PWD")

app = Flask(__name__, static_folder="static", static_url_path="")


def conn():
    auth = f"UID={UID};PWD={PWD};" if UID else "Trusted_Connection=yes;"
    return pyodbc.connect(
        f"DRIVER={{{DRIVER}}};SERVER={SERVER};DATABASE={DB};{auth}TrustServerCertificate=yes;",
        autocommit=False,
    )


def jsonable(v):
    if isinstance(v, Decimal):
        return float(v)
    if isinstance(v, (dt.datetime, dt.date, dt.time)):
        return v.isoformat()
    return v


def rows(cur):
    cols = [c[0] for c in cur.description]
    return [{c: jsonable(v) for c, v in zip(cols, r)} for r in cur.fetchall()]


def query(sql, params=()):
    with conn() as c:
        cur = c.cursor()
        cur.execute(sql, params)
        return rows(cur)


# ---------------------------------------------------------------- metadata
_meta = None


def load_meta():
    global _meta
    if _meta:
        return _meta
    cols = query("""
        SELECT c.TABLE_NAME t, c.COLUMN_NAME n, c.DATA_TYPE dtype, c.IS_NULLABLE nul,
               c.CHARACTER_MAXIMUM_LENGTH len, c.NUMERIC_SCALE scale,
               COLUMNPROPERTY(OBJECT_ID(c.TABLE_SCHEMA+'.'+c.TABLE_NAME), c.COLUMN_NAME,'IsIdentity') ident,
               c.COLUMN_DEFAULT dflt
        FROM INFORMATION_SCHEMA.COLUMNS c
        JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_NAME=c.TABLE_NAME AND t.TABLE_TYPE='BASE TABLE'
        ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION""")
    pks = query("""
        SELECT t.name t, c.name n FROM sys.indexes i
        JOIN sys.index_columns ic ON ic.object_id=i.object_id AND ic.index_id=i.index_id
        JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
        JOIN sys.tables t ON t.object_id=i.object_id WHERE i.is_primary_key=1""")
    fks = query("""
        SELECT tp.name t, cp.name n, tr.name ref_t, cr.name ref_n
        FROM sys.foreign_key_columns fkc
        JOIN sys.tables tp ON tp.object_id=fkc.parent_object_id
        JOIN sys.columns cp ON cp.object_id=fkc.parent_object_id AND cp.column_id=fkc.parent_column_id
        JOIN sys.tables tr ON tr.object_id=fkc.referenced_object_id
        JOIN sys.columns cr ON cr.object_id=fkc.referenced_object_id AND cr.column_id=fkc.referenced_column_id""")
    meta = {}
    for c in cols:
        meta.setdefault(c["t"], {"name": c["t"], "columns": [], "pk": None})["columns"].append({
            "name": c["n"], "type": c["dtype"], "nullable": c["nul"] == "YES",
            "length": c["len"], "scale": c["scale"], "identity": bool(c["ident"]), "fk": None})
    for p in pks:
        meta[p["t"]]["pk"] = p["n"]
    for f in fks:
        for col in meta[f["t"]]["columns"]:
            if col["name"] == f["n"]:
                col["fk"] = {"table": f["ref_t"], "column": f["ref_n"]}
    _meta = meta
    return meta


def table_or_404(name):
    m = load_meta()
    if name not in m:
        raise KeyError(f"Unknown table {name}")
    return m[name]


# Human-readable label SQL for lookups / foreign-key display
LABELS = {
    "Patient": "CONCAT(Patient_First_Name,' ',Patient_Last_Name)",
    "Employee": "Employee_Name",
    "Doctor": "(SELECT 'Dr. '+e.Employee_Name FROM Employee e WHERE e.Employee_ID=x.Employee_ID)",
    "Nurse": "(SELECT e.Employee_Name FROM Employee e WHERE e.Employee_ID=x.Employee_ID)",
    "Receptionist": "(SELECT e.Employee_Name FROM Employee e WHERE e.Employee_ID=x.Employee_ID)",
    "Hospital": "Hospital_Name",
    "Department": "Department_Name",
    "Rooms": "CONCAT('Room ',Room_Number,' (',Room_Type,')')",
    "Bed": "CONCAT('Bed ',Bed_Number,' / Room ',(SELECT r.Room_Number FROM Rooms r WHERE r.Room_ID=x.Room_ID))",
    "Medicine": "CONCAT(Medicine_Name,' ',Medicine_Strength)",
    "Service": "Service_Name",
    "Admission": "CONCAT('#',Admission_ID,' - ',(SELECT p.Patient_First_Name+' '+p.Patient_Last_Name FROM Patient p WHERE p.Patient_ID=x.Patient_ID))",
    "Bills": "CONCAT('Bill #',Bill_ID,' - ',(SELECT p.Patient_First_Name+' '+p.Patient_Last_Name FROM Patient p WHERE p.Patient_ID=x.Patient_ID))",
    "Appointment": "CONCAT('#',Appointment_ID,' - ',CONVERT(varchar(10),Appointment_Date))",
    "Medical_Record": "CONCAT('#',Medical_Record_ID,' - ',CONVERT(varchar(10),Medical_Record_Date))",
    "Prescription": "CONCAT('Rx #',Prescription_ID)",
}


def label_sql(t):
    m = load_meta()[t]
    return LABELS.get(t) or f"CAST({m['pk']} AS varchar(20))"


# ---------------------------------------------------------------- routes
@app.get("/")
def index():
    return send_from_directory(app.static_folder, "index.html")


@app.errorhandler(Exception)
def on_error(e):
    msg = str(e)
    if isinstance(e, pyodbc.Error) and e.args and len(e.args) > 1:
        msg = e.args[1]
        # strip ODBC driver noise: "[Microsoft][ODBC Driver 18 for SQL Server][SQL Server]actual message (51000) ..."
        msg = msg.lstrip()
        while msg.startswith("["):
            msg = msg.split("]", 1)[1].lstrip()
        msg = re.sub(r"\s*\(\d+\)\s*\(SQLExecDirectW\)\s*$", "", msg)
        if "conflicted with the REFERENCE" in msg:
            msg = "This record is referenced by other records and cannot be deleted."
        msg = msg.split("\n")[0]
    code = 404 if isinstance(e, KeyError) else 400
    return jsonify(error=msg.strip()), code


@app.get("/api/meta")
def api_meta():
    return jsonify(list(load_meta().values()))


@app.get("/api/lookup/<table>")
def api_lookup(table):
    m = table_or_404(table)
    return jsonify(query(f"SELECT {m['pk']} AS id, {label_sql(table)} AS label FROM [{table}] x ORDER BY 2"))


@app.get("/api/distinct/<table>/<column>")
def api_distinct(table, column):
    m = table_or_404(table)
    if column not in [c["name"] for c in m["columns"]]:
        raise KeyError("Unknown column")
    r = query(f"SELECT DISTINCT [{column}] v FROM [{table}] WHERE [{column}] IS NOT NULL ORDER BY 1")
    return jsonify([x["v"] for x in r])


@app.get("/api/t/<table>")
def api_list(table):
    m = table_or_404(table)
    q = request.args.get("q", "").strip()
    sort = request.args.get("sort") or m["pk"]
    desc = request.args.get("dir") == "desc"
    names = [c["name"] for c in m["columns"]]
    if sort not in names:
        sort = m["pk"]
    page = max(int(request.args.get("page", 1)), 1)
    size = min(int(request.args.get("size", 15)), 100)
    where, params = "", []
    if q:
        textcols = [c["name"] for c in m["columns"] if c["type"] in ("varchar", "nvarchar", "char")]
        parts = [f"[{c}] LIKE ?" for c in textcols] + [f"CAST([{m['pk']}] AS varchar(20)) = ?"]
        where = "WHERE " + " OR ".join(parts)
        params = [f"%{q}%"] * len(textcols) + [q]
    total = query(f"SELECT COUNT(*) n FROM [{table}] {where}", params)[0]["n"]
    data = query(
        f"SELECT * FROM [{table}] {where} ORDER BY [{sort}] {'DESC' if desc else 'ASC'} "
        f"OFFSET ? ROWS FETCH NEXT ? ROWS ONLY", params + [(page - 1) * size, size])
    return jsonify(rows=data, total=total, page=page, size=size)


def clean(m, body, creating):
    out = {}
    cols = {c["name"]: c for c in m["columns"]}
    for k, v in body.items():
        c = cols.get(k)
        if not c or c["identity"] or (k == m["pk"] and not creating):
            continue
        if v == "" or v is None:
            v = None
        elif c["type"] == "bit":
            v = 1 if v in (True, 1, "1", "true", "on") else 0
        elif c["type"] == "datetime2":
            v = str(v).replace("T", " ")
        out[k] = v
    return out


@app.post("/api/t/<table>")
def api_create(table):
    m = table_or_404(table)
    vals = clean(m, request.get_json(), True)
    pkcol = next(c for c in m["columns"] if c["name"] == m["pk"])
    with conn() as c:
        cur = c.cursor()
        if not pkcol["identity"] and vals.get(m["pk"]) is None:
            cur.execute(f"SELECT ISNULL(MAX([{m['pk']}]),0)+1 FROM [{table}]")
            vals[m["pk"]] = cur.fetchone()[0]
        cols = ",".join(f"[{k}]" for k in vals)
        cur.execute(f"INSERT INTO [{table}] ({cols}) VALUES ({','.join('?' * len(vals))})", list(vals.values()))
        c.commit()
    return jsonify(ok=True)


@app.get("/api/t/<table>/<int:id>")
def api_get(table, id):
    m = table_or_404(table)
    r = query(f"SELECT * FROM [{table}] WHERE [{m['pk']}]=?", [id])
    if not r:
        raise KeyError("Record not found")
    return jsonify(r[0])


@app.put("/api/t/<table>/<int:id>")
def api_update(table, id):
    m = table_or_404(table)
    vals = clean(m, request.get_json(), False)
    with conn() as c:
        c.cursor().execute(
            f"UPDATE [{table}] SET {','.join(f'[{k}]=?' for k in vals)} WHERE [{m['pk']}]=?", list(vals.values()) + [id])
        c.commit()
    return jsonify(ok=True)


@app.delete("/api/t/<table>/<int:id>")
def api_delete(table, id):
    m = table_or_404(table)
    with conn() as c:
        c.cursor().execute(f"DELETE FROM [{table}] WHERE [{m['pk']}]=?", [id])
        c.commit()
    return jsonify(ok=True)


@app.get("/api/dashboard")
def api_dashboard():
    one = lambda sql: query(sql)[0]
    k = one("""SELECT
        (SELECT COUNT(*) FROM Patient) patients,
        (SELECT COUNT(*) FROM Doctor) doctors,
        (SELECT COUNT(*) FROM Nurse) nurses,
        (SELECT COUNT(*) FROM Admission WHERE Admission_Discharge_Date IS NULL) admitted,
        (SELECT COUNT(*) FROM Appointment WHERE Appointment_Status='Scheduled') upcoming,
        (SELECT ISNULL(SUM(Bill_Total),0) FROM vw_Bill_Summary) billed,
        (SELECT ISNULL(SUM(Bill_Paid_Amount),0) FROM vw_Bill_Summary) collected,
        (SELECT ISNULL(SUM(Bill_Balance),0) FROM vw_Bill_Summary) outstanding,
        (SELECT COUNT(*) FROM Rooms) rooms,
        (SELECT COUNT(*) FROM Rooms WHERE Room_Availability_Status='Available') rooms_free""")
    return jsonify(
        kpi=k,
        appt_status=query("SELECT Appointment_Status label, COUNT(*) n FROM Appointment GROUP BY Appointment_Status"),
        pay_status=query("SELECT Bill_Payment_Status label, COUNT(*) n FROM vw_Bill_Summary GROUP BY Bill_Payment_Status"),
        dept=query("""SELECT d.Department_Name label, COUNT(*) n FROM Doctor dr
                      JOIN Department d ON d.Department_ID=dr.Department_ID GROUP BY d.Department_Name ORDER BY 2 DESC"""),
        blood=query("SELECT Patient_Blood_Group label, COUNT(*) n FROM Patient GROUP BY Patient_Blood_Group ORDER BY 2 DESC"),
        revenue=query("""SELECT FORMAT(Payment_Date,'yyyy-MM') label, SUM(Payment_Amount) n FROM Payment
                         GROUP BY FORMAT(Payment_Date,'yyyy-MM') ORDER BY 1"""),
        upcoming=query("""SELECT TOP 6 a.Appointment_ID id, a.Appointment_Date d, CONVERT(varchar(5),a.Appointment_Time) tm,
                          CONCAT(p.Patient_First_Name,' ',p.Patient_Last_Name) patient, e.Employee_Name doctor, a.Appointment_Reason reason
                          FROM Appointment a JOIN Patient p ON p.Patient_ID=a.Patient_ID
                          JOIN Doctor dr ON dr.Doctor_ID=a.Doctor_ID JOIN Employee e ON e.Employee_ID=dr.Employee_ID
                          WHERE a.Appointment_Status='Scheduled' ORDER BY a.Appointment_Date, a.Appointment_Time"""),
    )


@app.get("/api/bills")
def api_bills():
    return jsonify(query("""SELECT b.*, CONCAT(p.Patient_First_Name,' ',p.Patient_Last_Name) Patient_Name
                            FROM vw_Bill_Summary b JOIN Patient p ON p.Patient_ID=b.Patient_ID ORDER BY b.Bill_ID DESC"""))


@app.get("/api/bills/<int:id>")
def api_bill(id):
    return jsonify(
        summary=query("""SELECT b.*, CONCAT(p.Patient_First_Name,' ',p.Patient_Last_Name) Patient_Name
                         FROM vw_Bill_Summary b JOIN Patient p ON p.Patient_ID=b.Patient_ID WHERE b.Bill_ID=?""", [id])[0],
        items=query("""SELECT bi.*, ISNULL(s.Service_Name,'-') Service_Name FROM Bill_Item bi
                       LEFT JOIN Service s ON s.Service_ID=bi.Service_ID WHERE bi.Bill_ID=? ORDER BY 1""", [id]),
        payments=query("SELECT * FROM Payment WHERE Bill_ID=? ORDER BY Payment_Date", [id]))


@app.get("/api/patient/<int:id>")
def api_patient(id):
    p = query("SELECT * FROM Patient WHERE Patient_ID=?", [id])
    if not p:
        raise KeyError("Patient not found")
    return jsonify(
        patient=p[0],
        appointments=query("""SELECT a.Appointment_Date d, CONVERT(varchar(5),a.Appointment_Time) tm, a.Appointment_Status status,
                              a.Appointment_Reason reason, e.Employee_Name doctor FROM Appointment a
                              JOIN Doctor dr ON dr.Doctor_ID=a.Doctor_ID JOIN Employee e ON e.Employee_ID=dr.Employee_ID
                              WHERE a.Patient_ID=? ORDER BY 1 DESC""", [id]),
        records=query("""SELECT m.Medical_Record_Date d, m.Medical_Record_Diagnoses dx, m.Medical_Record_Treatment tx, e.Employee_Name doctor
                         FROM Medical_Record m JOIN Doctor dr ON dr.Doctor_ID=m.Doctor_ID JOIN Employee e ON e.Employee_ID=dr.Employee_ID
                         WHERE m.Patient_ID=? ORDER BY 1 DESC""", [id]),
        tests=query("SELECT Test_Report_Date d, Test_Report_Type type, Test_Report_Result result FROM Test_Report WHERE Patient_ID=? ORDER BY 1 DESC", [id]),
        admissions=query("SELECT Admission_Date a, Admission_Discharge_Date dd, Admission_Reason reason FROM Admission WHERE Patient_ID=? ORDER BY 1 DESC", [id]),
        bills=query("SELECT Bill_ID id, Bill_Date d, Bill_Total total, Bill_Paid_Amount paid, Bill_Balance bal, Bill_Payment_Status status FROM vw_Bill_Summary WHERE Patient_ID=? ORDER BY 2 DESC", [id]),
    )


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)
