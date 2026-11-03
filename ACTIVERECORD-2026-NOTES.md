# ActiveRecord for Xojo 2026r3: Work Summary and How It Works

Prepared 3 November 2026. Branch `activerecord-xojo2026-fixes`, pushed to
`supcumps/ActiveRecord` (remote `fork`). The original `origin`
(`undtec/ActiveRecord`) is unchanged.

---

## Part 1. What has been done

### 1.1 Repository layout

| Folder | Contents | Status |
|---|---|---|
| `ActiveRecord/` | The older BKeeney ActiveRecord (`BKS_ActiveRecord`), API 1, with a desktop demo | Fixed to compile and run in 2026r3 (commit `089e537`) |
| `API 2/` | The newer TP_ActiveRecord library (API 2) with a desktop demo | Bugs fixed, converted to true API 2, working demo (commit `d1d7063`) |
| `API 2/ACTIVE RECORD iOS/` | New iOS project that shares the `API 2` library | New, working demo (commit `d1d7063`) |
| `API 1/` | Older TP_ActiveRecord, API 1 | Untouched. Five files were already deleted on disk before this work and remain unstaged |
| `iOS/` | Old iOS version written for the retired iOS framework (`iOSSQLiteDatabase`, `Text`, `Auto`) | Untouched. Kept for reference only; it will not compile in modern Xojo |

### 1.2 BKeeney ActiveRecord (`ActiveRecord/`)

The project did not compile in 2026r3: 48 errors, all caused by
`REALSQLDatabase`, which Xojo removed years ago. The fix was to set
`kIncludeREALSQLDatabase` to `False` and remove the `REALSQLDatabaseAdapter`
class from the project manifest (the file is still on disk).

Bugs fixed in the library and demo:

1. `GetTableInfo` declared its exception without `New`, so a missing table
   raised a NilObjectException instead of the real message.
2. Editing a loaded `Date` in place (for example `p.DateOfBirth.Day = 5`) was
   never saved, because the property and the saved-values snapshot shared one
   `Date` object. Dates are now copied and compared by value.
3. A failed `Save` rolled the database back but left the object holding the
   new ID, so the next `Save` updated a row that did not exist. The ID and
   saved values are now restored on rollback.
4. `Delete` did not reset the ID, so the object still looked saved. It now
   resets to 0 after a successful delete.
5. Unrecognised column types (Char, Currency, Decimal, Long Text, String and
   others) silently became integers. They are now mapped properly, and
   anything unknown defaults to text.
6. `winConnect` validated the server-name field instead of the database-file
   field.

Not fixed in the BKeeney version (left as known issues): dates are shifted to
GMT on save, nested transactions on SQLite can commit partial work,
`BaseList` misaligns if rows are deleted while it is open, and the PostgreSQL,
Oracle and MSSQL adapters have SQL and ID problems. These matter only if the
BKeeney version is used further; the API 2 version is the one to carry forward.

### 1.3 API 2 library (`API 2/TP_ActiveRecord`)

The library was already written in API 2 but had its own bugs:

1. The same `GetTableInfo` missing-`New` bug as BKeeney.
2. `IsNew` was always `True` for tables with a GUID (string) primary key, so
   every `Save` inserted a duplicate row. It now checks the key type.
3. `Save` did not restore the object after a rollback (same as BKeeney item 3).
4. `Delete` did not reset the ID or GUID.
5. Unknown column types defaulted to integer.
6. `FindMatchingTable`'s `cls` prefix check never worked (zero-based index
   and wrong comparison values).
7. `DateTime` properties were passed to the database as raw objects. They are
   now written explicitly in local time, as date-only text for `DATE` columns.
8. `IsRecordModified` compared `DateTime` objects by reference, so every save
   counted as a change. It now compares their values.

Three further changes make the library compile for iOS. Each also works on
desktop:

| Not available on iOS | Replaced with |
|---|---|
| `Mutex` | `CriticalSection` |
| `Encoding(s)`, `DefineEncoding(s, enc)` | `s.Encoding`, `s.DefineEncoding(enc)` |
| `Format(n, "#########")` | `n.ToString` |

### 1.4 API 2 desktop demo

- `App` now inherits `DesktopApplication` (events `Opening` and `Closing`,
  menu handlers `MenuItemSelected`), and `MenuBar1` uses `DesktopMenuItem`.
- `DataFile.GetDatabase` creates a real SQLite file instead of the ARGen
  placeholder, and the PostgreSQL template functions only compile when
  PostgreSQL is enabled.
- New `t_person` table, `DataFile.Person` class and `wndPeople` window.

### 1.5 iOS demo

A new iOS project in `API 2/ACTIVE RECORD iOS/` uses the same library,
`DataFile` and `Extras` files as the desktop project through `../` paths. It
has a People list screen and a Person edit screen. Tested in the iPhone 11
Simulator.

### 1.6 Testing

Both demos were tested by hand: add, edit, blank weight and delete on desktop
and iOS. On desktop the IDE analyser reports zero errors and one harmless
template warning (`sValue` unused in `ActiveRecordClass.IsDuplicate`); on
iOS it reports zero errors and zero warnings.

A side finding: the CLAUDE.md rule that numeric constants with quoted defaults
evaluate to 0 did not reproduce. `kDoubleNullSentinal` and `kDBVersion` both
evaluated correctly at run time in 2026r3.

### 1.7 Skills

New XMCP and Xojo findings from this work were added to the `xmcp` and
`xojo-platform` skills and uploaded to claude.ai.

---

## Part 2. How the application works

### 2.1 The idea

ActiveRecord maps each database table to a Xojo class. One instance of the
class is one row. You set properties and call `Save`, `Load` or `Delete`;
the library writes the SQL, binds the values safely through prepared
statements, and handles transactions.

```xojo
Var p As New DataFile.Person
p.FirstName = "Fred"
p.LastName = "Dagg"
p.Save                       // INSERT, and p.id is filled in

p.Weight = 82.5
p.Save                       // UPDATE, only if something changed

Var q As New DataFile.Person
If q.Load(p.id) Then         // SELECT by primary key
  q.Delete                   // DELETE, and q.id goes back to 0
End If
```

### 2.2 The layers

| Layer | Where | Job |
|---|---|---|
| Library | `TP_ActiveRecord` module and classes | Maps classes to tables and does all database work |
| Data layer | `DataFile` module and `DataFile.*` classes | Your app's database: where the file lives, schema updates, which classes map to which tables |
| Schema updates | `Extras/TP_DBUpdates` | Creates and upgrades tables, tracked by a version number |
| User interface | `wndPeople` (desktop); `Screen1` and `PersonScreen` (iOS) | Shows and edits records; contains no SQL |

The library and data layer are shared by the desktop and iOS projects; only
the user interface differs.

### 2.3 Start-up sequence

The first call to `DataFile.DB` sets everything up. On desktop this happens
in `App.Opening`; on iOS it happens the first time a screen asks for data.

1. `DataFile.GetDatabase` points a `SQLiteDatabase` at
   `ActiveRecordDemo.sqlite`, creating the file if it does not exist.
   On desktop the file is in `~/Library/Application Support/ActiveRecordDemo/`;
   on iOS it is in the app's own Documents folder.
2. `DataFile.OpenDB` connects, then calls `TP_DBUpdates.UpdateDB`.
3. `UpdateDB` creates the `t_tp_dbversion` table if needed, reads the current
   schema version, and runs each `UpdateVersion_00n` method that has not yet
   been applied. Version 1 creates `t_person`. It then records the new version.
4. `TP_ActiveRecord.Connect` attaches the database to `DataFile.ActiveRecordBase`,
   so every class that inherits from it uses this database.
5. `DataFile.Register` calls `TP_ActiveRecord.Table` for each table. This
   reads the table's columns and matches each one to a property of the same
   name on the class (using Xojo's Introspection), and records which column is
   the primary key. The mapping is cached, so it is worked out once.
6. The connection is kept in a pool. On desktop and iOS the main thread shares
   one connection and each thread gets its own; on Web each session gets its own.

### 2.4 What happens on Save

`Base.Save`:

1. Starts a transaction (the SQLite adapter counts nested calls, so a `Save`
   inside your own transaction does not commit early).
2. Raises `BeforeSave`.
3. If `IsNew` is true (ID below 1, or an empty GUID): raises `BeforeCreate`,
   builds an `INSERT` for every mapped column except the primary key, binds
   the values, runs it, and puts the new row's ID back into the object. Then
   raises `AfterSave` and `AfterCreate`.
4. Otherwise: raises `BeforeUpdate`, and if `IsRecordModified` finds a changed
   property, builds and runs an `UPDATE ... WHERE id = ?`. Then raises
   `AfterSave` and `AfterUpdate`.
5. Commits. If anything raised an exception, it rolls back, restores the
   object's ID and saved values, and re-raises the exception for the caller.

After every load or save, the object keeps a snapshot of its saved values.
`IsModified` compares the current properties against that snapshot (strings
case-sensitively, `DateTime` by value).

`Validate` is available but is not called by `Save`. Call it yourself first
if a class has validation rules.

### 2.5 How values are stored

| Property type | Stored as |
|---|---|
| `String` | Text; text read back without an encoding is treated as UTF-8 |
| `Integer`, `Int64`, `Boolean` | As is |
| `Double` | As is, except the special value `TP_ActiveRecord.kDoubleNullSentinal` (1.7E+308), which is stored as NULL and read back as the sentinel |
| `DateTime` | Local time. `SQLDate` (YYYY-MM-DD) for `DATE` columns, `SQLDateTime` otherwise. Nil is NULL |
| Key fields (primary or foreign) | A value below 1, or an empty string, is stored as NULL |

The sentinel exists because a `Double` cannot be Nil. In the demo, leaving
Weight blank saves NULL, and the screen shows it as blank again.

### 2.6 The demo screens

**Desktop (`wndPeople`).** The list on the left shows every person, ordered
by last then first name. Selecting one fills the fields on the right. New
clears the fields for a new person; Save writes the record and reselects it;
Delete removes it. The status line shows the run-time values of the two
numeric constants, which was used to test the CLAUDE.md constants rule.

**iOS (`Screen1` and `PersonScreen`).** `Screen1` is a table of people with
the date of birth as detail text. Each row's cell carries its `Person` object
in `Tag`. Tapping a row, or Add, pushes `PersonScreen`, which edits that one
`Person` and closes itself after Save or Delete. `Screen1` reloads in its
`Activated` event, so the list is current whenever you return to it.

Dates are typed as `YYYY-MM-DD` on both platforms, and invalid dates are
rejected with a message.

### 2.7 Adding a new table

1. In `Extras/TP_DBUpdates`, add `UpdateVersion_002` with the `CREATE TABLE`
   statement, call it from `UpdateDB` with `If iDBVersion < 2`, and change
   `kDBVersion` to 2.
2. Create a class in `DataFile` that inherits `DataFile.ActiveRecordBase`,
   with one property per column, named exactly as the columns are. Include
   the primary key (for example `id As Int64`).
3. Register it in `DataFile.Register`:
   `TP_ActiveRecord.Table(oLocalDB, "t_mytable", GetTypeInfo(DataFile.MyClass))`.
4. Add a `List` shared method like `Person.List` if you need queries.
5. Add the new class file to both project manifests (desktop and iOS), or
   create it in one IDE and add it to the other.

### 2.8 Things to know

- **SQL injection.** `Person.List(criteria, order)` and
  `TP_ActiveRecord.Query` paste their arguments into SQL. Never pass user
  input to them; use a `PreparedSQLStatement` instead.
- **Plugin adapters.** MySQL, PostgreSQL, MSSQL, ODBC, CubeSQL and Valentina
  adapters exist but are switched off by the `kConfigUse...` constants in
  `TP_ActiveRecord`. They were not tested, and none of them is available on iOS.
- **Audit trail.** `TP_AuditTrail` is included because `Base.Save` uses part
  of it. The full audit trail only runs for classes based on the ARGen
  `ActiveRecordClass` template, which the demo does not use.
- **Sharing files.** Both projects edit the same library files. If both are
  open in Xojo at once, a change saved in one is not seen by the other until
  it reloads. The iOS project has `AgenticMode=True` and reloads changed files
  automatically; the desktop project does not.
- **New records.** A new `Person` starts with Weight `0`, not blank, because
  `Double` defaults to 0. Clear the field to store NULL.
