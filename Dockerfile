FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ["CloudNativeAction.csproj", "./"]
RUN dotnet restore "CloudNativeAction.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "CloudNativeAction.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CloudNativeAction.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CloudNativeAction.dll"]
