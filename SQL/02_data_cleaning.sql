
USE HospitalAnalytics;
GO

-- =============================================
-- DATA CLEANING AND TRANSFORMATION
-- Raw data to clean relational tables
-- =============================================
-- Prerequisites:
-- 1. Import all five CSV files into the raw tables.
-- 2. Create the clean tables using 01_database_setup.sql.
--
-- This script loads validated data into the clean tables.
-- Run only once on initially empty clean tables.
-- Re-running it may cause duplicate records or primary-key errors.

-- Patient data validation

-- Check for invalid BirthDate values

SELECT BirthDate
FROM dbo.patients_raw
WHERE BirthDate IS NOT NULL
  AND TRY_CONVERT(DATE, BirthDate) IS NULL;


SELECT DeathDate
FROM dbo.patients_raw
WHERE DeathDate IS NOT NULL
  AND TRY_CONVERT(DATE, DeathDate) IS NULL;

  SELECT BirthDate, DeathDate
FROM dbo.patients_raw
WHERE TRY_CONVERT(DATE, BirthDate) > TRY_CONVERT(DATE, DeathDate);

-- Load validated patient data into clean table

INSERT INTO dbo.patients (

Id, BirthDate, DeathDate, Prefix, First, Last,
Suffix, Maiden, Marital, Race, Ethnicity, Gender,
BirthPlace, Address, City, State, Country, Zip,
LAT, LON)
  
 -- Convert validated date fields to DATE during load 
  
  SELECT
    Id,
    CONVERT(DATE, BirthDate),
    CONVERT(DATE, DeathDate),
    Prefix, 
    First, Last, 
    Suffix,
    Maiden,
    Marital, 
    Race,
    Ethnicity,
    Gender,
    BirthPlace,
    Address,
    City,
    State,
    Country, Zip, LAT, LON
FROM dbo.patients_raw;

-- =============================================
-- Organization data load
-- =============================================
    
INSERT INTO dbo.organizations(
Id, Name, Address,
City, State, Zip,
Latitude, Longitude)

SELECT Id, 
Name,
Address,
City,
State,
Zip,
Latitude,
Longitude
FROM dbo.organizations_raw;

-- =============================================
-- Payer data load
-- =============================================

INSERT INTO dbo.payers(
Id, Name, 
Address, City, 
StateHeadQuartered,
Zip, Phone)

SELECT Id, Name, 
Address, City, 
StateHeadQuartered,
Zip, Phone
FROM dbo.payers_raw;

-- =============================================
-- Encounter data validation and load
-- =============================================

SELECT Start
FROM dbo.encounters_raw
WHERE Start IS NOT NULL
  AND TRY_CONVERT(DATETIME2, Start) IS NULL;


SELECT Stop
FROM dbo.encounters_raw
WHERE Stop IS NOT NULL
  AND TRY_CONVERT(DATETIME2, Stop) IS NULL;


-- Load validated encounter data into clean table

INSERT INTO dbo.encounters (
Id,
StartDateTime,
   StopDateTime,
PatientId,
OrganizationId, PayerId,
EncounterClass, Code, 
Description, BaseEncounterCost,
TotalClaimCost, PayerCoverage,
ReasonCode, ReasonDescription )

SELECT
    Id,
    CONVERT(DATETIME2, Start),
    CONVERT(DATETIME2, Stop),
PATIENT,
ORGANIZATION, PAYER,
ENCOUNTERCLASS, CODE, 
DESCRIPTION, BASE_ENCOUNTER_COST,
TOTAL_CLAIM_COST, PAYER_COVERAGE,
REASONCODE, REASONDESCRIPTION
FROM dbo.encounters_raw;

-- =============================================
-- Procedure data validation and load
-- =============================================


SELECT Start
FROM dbo.procedures_raw
WHERE Start IS NOT NULL
  AND TRY_CONVERT(DATETIME2, Start) IS NULL;


SELECT Stop
FROM dbo.procedures_raw
WHERE Stop IS NOT NULL
  AND TRY_CONVERT(DATETIME2, Stop) IS NULL;

-- Load validated procedure data into clean table

INSERT INTO dbo.procedures (

StartDateTime,
StopDateTime,
PatientId,
EncounterId,
Code, Description,
BaseCost, ReasonCode,
ReasonDescription)

SELECT 
CONVERT(DATETIME2, START),
CONVERT(DATETIME2, STOP),
PATIENT,ENCOUNTER, 
CODE, DESCRIPTION,
BASE_COST, REASONCODE,
REASONDESCRIPTION
FROM dbo.procedures_raw ;










































