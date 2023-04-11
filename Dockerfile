FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5265

ENV ASPNETCORE_URLS=http://+:5265

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["nifemi.csproj", "./"]
RUN dotnet restore "nifemi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "nifemi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "nifemi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "nifemi.dll"]
