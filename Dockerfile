FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["HelloDockerHubCiCd/HelloDockerHubCiCd.csproj", "HelloDockerHubCiCd/"]
RUN dotnet restore "HelloDockerHubCiCd/HelloDockerHubCiCd.csproj"
COPY . .
WORKDIR "/src/HelloDockerHubCiCd"
RUN dotnet build "./HelloDockerHubCiCd.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./HelloDockerHubCiCd.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloDockerHubCiCd.dll"]
