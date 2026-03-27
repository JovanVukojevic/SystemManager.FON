namespace SystemManager.Api.Middleware;

public record ErrorResponse(int Status, string Error, string Message);
