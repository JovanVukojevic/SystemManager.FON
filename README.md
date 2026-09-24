# SystemManager

Admin application for two small business domains, exam records and project/payroll
records, built as a student project for **Data Access Programming**
(*Programiranje pristupa podacima*) at the Faculty of Organizational Sciences,
University of Belgrade.

The assignment was to keep the business logic in the database and build an application
on top of it that doesn't write any ad-hoc SQL.

- `SystemManager.Api/`: .NET 9 solution (Domain, Application, Infrastructure, Api) and
  the SQL scripts for both databases
- `SystemManager.Web/`: Angular 21 admin frontend

There are two independent subsystems, **ISPIT** (students, subjects, teachers, exams) and
**PROJEKAT** (workers, departments, projects, payments), with separate databases,
connection factories and route prefixes. You pick one on the landing page.

## Database

Each database exists twice, on SQL Server and on PostgreSQL, and both are split into three
schemas with a strict dependency direction:

| Schema | Holds | May reference |
|---|---|---|
| `impl` | tables, audit tables, triggers, error log | its own objects only |
| `spec` | validation, error handling, CRUD procedures | `impl` |
| `api` | thin wrappers  | `spec` |

The application only calls `api.*`, so the physical schema can change without any
changes to the C# code. Validation and business rules are in `spec` procedures and `impl`
triggers. Every table has a matching `_Audit` table, and errors are logged through
`spec.HandleError` before being rethrown.

Scripts are numbered 01-09 under `Database/SqlServer/` and `Database/Postgresql/`, each with
an `IspitDB` and a `ProjekatDB` folder. Postman collections are in `Database/Postman/`.

## API

ASP.NET Core 9, layered Domain → Application → Infrastructure → Api. Dapper only, no Entity
Framework. Services work with domain entities, and mapping to DTOs is done in controllers
with AutoMapper. Navigation properties are populated from a single procedure call
using Dapper multi-mapping.

Switching between engines is one line in `appsettings.json`:

```json
"DatabaseSettings": { "Provider": "SqlServer" }
```

`Program.cs` then registers the matching set of repositories, and nothing above the
Infrastructure layer changes. `GET /api/config` returns the provider currently in use.

Controllers and services contain no try/catch. A middleware maps database exceptions to
422 (trigger or validation rejection), 409 (duplicate key) or 500, and passes the database
error message through so the UI can show why a write failed.

## Frontend

Angular 21 with standalone components, signals and Angular Material, no NgRx. Each entity
has a list page with create/edit dialogs and reactive forms. There's a shared searchable
autocomplete implemented as a `ControlValueAccessor`, and Serbian date formatting through
a custom adapter. Client-side validation is minimal since the database handles it, and the
user sees the database error message.

## Not included

This was written for an exam, so there's no authentication, no tests beyond the CLI
scaffold, and connection strings are in plain text in `appsettings.json`.
