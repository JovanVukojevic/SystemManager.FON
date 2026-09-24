# SystemManager

Admin application over two small business domains — exam records and project/payroll
records — built as a student project for **Data Access Programming**
(*Програмирање приступа подацима*) at the Faculty of Organizational Sciences,
University of Belgrade.

The point of the assignment was to keep business logic in the database and build an
application on top of it that never writes an ad-hoc SQL statement.

- `SystemManager.Api/` — .NET 9 solution (Domain, Application, Infrastructure, Api) and
  the SQL scripts for both databases
- `SystemManager.Web/` — Angular 21 admin frontend

Two independent subsystems — **ISPIT** (students, subjects, teachers, exams) and
**PROJEKAT** (workers, departments, projects, payments) — with separate databases,
connection factories and route prefixes. The frontend asks which one you want on the
landing page.

## Database

Each database exists twice, on SQL Server and on PostgreSQL, and both are split into three
schemas with a strict dependency direction:

| Schema | Holds | May reference |
|---|---|---|
| `impl` | tables, audit tables, triggers, error log | its own objects only |
| `spec` | validation, error handling, CRUD procedures (`spr_*`) | `impl` |
| `api` | thin wrappers (`usp_*`) | `spec` |

The application only ever calls `api.usp_*`, so the physical schema can be reworked without
touching a line of C#. Validation and business rules live in `spec` procedures and `impl`
triggers; every table has a matching `_Audit` table, and failures are logged through
`spec.HandleError` before being rethrown.

Scripts are numbered 01–09 under `Database/SqlServer/` and `Database/Postgresql/`, each with
an `IspitDB` and a `ProjekatDB` folder. Postman collections are in `Database/Postman/`.

## API

ASP.NET Core 9, layered Domain → Application → Infrastructure → Api. Dapper only, no Entity
Framework. Services work with domain entities; mapping to DTOs happens in controllers via
AutoMapper. Navigation properties come back fully populated from a single procedure call
using Dapper multi-mapping.

Switching between engines is one line in `appsettings.json`:

```json
"DatabaseSettings": { "Provider": "SqlServer" }
```

`Program.cs` then registers the matching set of repositories — nothing above the
Infrastructure layer changes. `GET /api/config` reports which provider is running.

Controllers and services contain no try/catch. One middleware maps database exceptions to
422 (trigger or validation rejection), 409 (duplicate key) or 500, passing the database's own
message through so the UI can show why a write was refused.

## Frontend

Angular 21 — standalone components, signals, Angular Material, no NgRx. List page plus
create/edit dialogs per entity, reactive forms, a shared searchable autocomplete built as a
`ControlValueAccessor`, and Serbian date formatting through a custom adapter. Client-side
validation is deliberately thin — the database is the authority, and its error message is
what the user sees.

## Not included

Written for an exam, so: no authentication, no test suite beyond the CLI scaffold, and
connection strings sitting in `appsettings.json` as plain text.
