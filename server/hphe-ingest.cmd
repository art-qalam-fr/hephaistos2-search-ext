@echo off
rem Ingestion incrementale automatisee (remplace .agent\scripts\ingest-workspace.ps1)
rem Chemins relatifs : %~dp0..\.. = INSTALL ; racine ingeree = env HPHE_INGEST_ROOT ou %CD%.
set HPHE_INSTALL_ROOT=%~dp0..\..
if not defined HPHE_CONTENT_DIR set HPHE_CONTENT_DIR=%HPHE_INSTALL_ROOT%\data\content-index
if not defined HPHE_VEC_DIR set HPHE_VEC_DIR=%HPHE_INSTALL_ROOT%\migrated-vec
if not defined HPHE_INGEST_ROOT set HPHE_INGEST_ROOT=%CD%
"%~dp0hphe-mcp.exe" --tool content_ingest --args "{\"root\":\"%HPHE_INGEST_ROOT%\",\"project_tag\":\"hephaistos2-kit\"}"
