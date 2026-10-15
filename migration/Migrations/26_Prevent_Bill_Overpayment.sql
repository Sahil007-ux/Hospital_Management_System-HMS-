USE [Hospital_Management_System];
GO

CREATE OR ALTER TRIGGER dbo.TR_Payment_NoOverpayment
ON dbo.Payment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    -- Lock affected bills until the transaction ends.
    DECLARE @LockedBills BIGINT;

    SELECT @LockedBills = COUNT_BIG(*)
    FROM dbo.Bills AS b WITH (UPDLOCK, HOLDLOCK)
    INNER JOIN
    (
        SELECT Bill_ID FROM inserted
        UNION
        SELECT Bill_ID FROM deleted
    ) AS affected
        ON affected.Bill_ID = b.Bill_ID;

    IF EXISTS
    (
        SELECT 1
        FROM
        (
            SELECT Bill_ID FROM inserted
            UNION
            SELECT Bill_ID FROM deleted
        ) AS affected
        OUTER APPLY
        (
            SELECT SUM(p.Payment_Amount) AS Paid_Amount
            FROM dbo.Payment AS p WITH (READCOMMITTEDLOCK)
            WHERE p.Bill_ID = affected.Bill_ID
        ) AS payments
        OUTER APPLY
        (
            SELECT SUM(i.Bill_Item_Line_Total) AS Total_Amount
            FROM dbo.Bill_Item AS i WITH (READCOMMITTEDLOCK)
            WHERE i.Bill_ID = affected.Bill_ID
        ) AS items
        WHERE ISNULL(payments.Paid_Amount, 0)
            > ISNULL(items.Total_Amount, 0)
    )
    BEGIN
        THROW 50012,
            'Total payments cannot exceed the bill total.',
            1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_BillItem_NoOverpayment
ON dbo.Bill_Item
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM deleted)
        RETURN;

    DECLARE @LockedBills BIGINT;

    SELECT @LockedBills = COUNT_BIG(*)
    FROM dbo.Bills AS b WITH (UPDLOCK, HOLDLOCK)
    INNER JOIN
    (
        SELECT Bill_ID FROM inserted
        UNION
        SELECT Bill_ID FROM deleted
    ) AS affected
        ON affected.Bill_ID = b.Bill_ID;

    IF EXISTS
    (
        SELECT 1
        FROM
        (
            SELECT Bill_ID FROM inserted
            UNION
            SELECT Bill_ID FROM deleted
        ) AS affected
        OUTER APPLY
        (
            SELECT SUM(p.Payment_Amount) AS Paid_Amount
            FROM dbo.Payment AS p WITH (READCOMMITTEDLOCK)
            WHERE p.Bill_ID = affected.Bill_ID
        ) AS payments
        OUTER APPLY
        (
            SELECT SUM(i.Bill_Item_Line_Total) AS Total_Amount
            FROM dbo.Bill_Item AS i WITH (READCOMMITTEDLOCK)
            WHERE i.Bill_ID = affected.Bill_ID
        ) AS items
        WHERE ISNULL(payments.Paid_Amount, 0)
            > ISNULL(items.Total_Amount, 0)
    )
    BEGIN
        THROW 50013,
            'Bill changes would make payments exceed the bill total.',
            1;
    END;
END;
GO

SELECT
    name AS Trigger_Name,
    is_disabled AS Is_Disabled
FROM sys.triggers
WHERE parent_id IN
(
    OBJECT_ID(N'dbo.Payment'),
    OBJECT_ID(N'dbo.Bill_Item')
)
AND name IN
(
    N'TR_Payment_NoOverpayment',
    N'TR_BillItem_NoOverpayment'
);