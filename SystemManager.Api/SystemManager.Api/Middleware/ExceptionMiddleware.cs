using AutoMapper;
using Microsoft.Data.SqlClient;
using Npgsql;

namespace SystemManager.Api.Middleware;

public class ExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionMiddleware> _logger;

    public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception");
            await HandleExceptionAsync(context, ex);
        }
    }

    private static async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        var (status, error, message) = exception switch
        {
            SqlException sqlEx when sqlEx.Number == 2627 || sqlEx.Number == 2601
                || (sqlEx.Number == 50000 && (
                       sqlEx.Message.Contains("UNIQUE KEY", StringComparison.OrdinalIgnoreCase)
                    || sqlEx.Message.Contains("PRIMARY KEY", StringComparison.OrdinalIgnoreCase)
                    || sqlEx.Message.Contains("duplicate key", StringComparison.OrdinalIgnoreCase)))
                => (409, "Conflict", sqlEx.Errors[0].Message),
            SqlException sqlEx when sqlEx.Number == 547
                => (422, "Unprocessable Entity", sqlEx.Errors[0].Message),
            SqlException sqlEx
                => IsTriggerException(sqlEx)
                    ? (422, "Unprocessable Entity", sqlEx.Errors[0].Message)
                    : (500, "Internal Server Error", "An unexpected database error occurred."),
            PostgresException pgEx when pgEx.SqlState == "23505"
                => (409, "Conflict", pgEx.MessageText),
            PostgresException pgEx when pgEx.SqlState == "23503"
                => (422, "Unprocessable Entity", pgEx.MessageText),
            PostgresException pgEx when pgEx.SqlState == "P0001"
                => (422, "Unprocessable Entity", pgEx.MessageText),
            PostgresException
                => (500, "Internal Server Error", "An unexpected database error occurred."),
            AutoMapperMappingException mapEx
                => (400, "Bad Request", mapEx.InnerException?.Message ?? mapEx.Message),
            _
                => (500, "Internal Server Error", "An unexpected error occurred.")
        };

        context.Response.ContentType = "application/json";
        context.Response.StatusCode = status;

        var response = new ErrorResponse(status, error, message);

        await context.Response.WriteAsJsonAsync(response);
    }

    private static bool IsTriggerException(SqlException ex)
    {
        return ex.Errors.Cast<SqlError>().Any(e => e.Class == 16 && e.Number >= 50000)
            || ex.Message.StartsWith("Greška:", StringComparison.OrdinalIgnoreCase)
            || ex.Message.Contains("nije dozvoljeno", StringComparison.OrdinalIgnoreCase);
    }

}
