# SubjectChangeRequestSystemSQL
Designed a Stored Procedure to manage subject change requests by students with full historical tracking.

Key functionalities included:
✅ Checking if the new subject is different from the currently allotted subject
✅ Marking the previous subject as inactive (Is_Valid = 0)
✅ Inserting the new subject as valid (Is_Valid = 1)
✅ Handling new requests for students with no prior allotment

📊 Tables Used:

SubjectAllotments – Stores current & previous subject mappings

SubjectRequest – Stores new subject requests

The solution involved writing precise SQL logic and ensuring data consistency while preserving history, using CTEs to make the workflow cleaner and more efficient.
