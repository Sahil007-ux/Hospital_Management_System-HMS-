HMS final schema update — 2026-10-15

Copy migration and Schema into the existing project root and replace matching files.
Keep Seed and migration/Migrations unchanged. This package contains no seed data.
The updated master contains all 22 tables, 27 foreign keys, 9 triggers and 1 view.
The three separate table files are reference scripts, already included in the master.
The original HMS_Final_Schema.sql export remains the source snapshot.

Existing database: do not run the master again.
Fresh installation test: create a NEW empty database named HMS_Final_Verification,
select it in SSMS, open migration/_Master_Query.sql, execute the full file once.
Then execute Schema/Verify_Final_Schema.sql in that same database.
Expected counts: 22, 27, 9, 1. All three exception results must be empty.
Do not run historical migrations after a fresh master installation.

Validation: object counts and foreign-key targets checked against the supplied export;
master DDL body preserved verbatim after line-ending normalization.
Database creation, machine-specific file paths and database-wide settings omitted.
No SQL Server execution was performed here; fresh installation requires user testing.
This remains a teaching project; the check does not establish clinical suitability.
