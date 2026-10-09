
CREATE DATABASE HospitalAnalytics;
GO

USE HospitalAnalytics;
GO

-- =============================================
-- RAW DATA IMPORT
-- =============================================
-- Source: Maven Analytics Hospital Patient Records dataset
-- Import the five CSV files using the SSMS Import Flat File Wizard.
--
-- Destination database: HospitalAnalytics
--
-- Raw tables:
-- dbo.patients_raw
-- dbo.organizations_raw
-- dbo.payers_raw
-- dbo.encounters_raw
-- dbo.procedures_raw
--
-- Complete the raw-data import before running
-- 02_data_cleaning.sql.

-- Create clean patients table

CREATE TABLE dbo.patients (
Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
BirthDate DATE NULL, 
DeathDate Date NULL,
Prefix VARCHAR(10) NULL,
First VARCHAR(100) NULL,
Last VARCHAR(100) NULL,
Suffix VARCHAR(10) NULL,
Maiden VARCHAR(100) NULL,
Marital VARCHAR(10) NULL,
Race  VARCHAR(100) NULL,
Ethnicity VARCHAR(100) NULL,
Gender VARCHAR(10) NULL,
BirthPlace VARCHAR(50) NULL,
Address VARCHAR(100) NULL,
City VARCHAR(50) NULL,
State VARCHAR(50) NULL,
Country VARCHAR(50) NULL,
ZIP VARCHAR(50) NULL,
LAT DECIMAL(9,6) NULL,
LON DECIMAL(9,6) NULL 
);

-- Create clean organizations table

CREATE TABLE dbo.organizations (
Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
NAME VARCHAR(100) NULL,
ADDRESS VARCHAR(100) NULL,
CITY VARCHAR(50) NULL,
STATE VARCHAR(50) NULL,
ZIP VARCHAR(20) NULL,
Latitude DECIMAL(9,6) NULL,
Longitude DECIMAL(9,6) NULL
);


-- Create clean payers table
CREATE TABLE dbo.payers (
Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
NAME VARCHAR(100) NULL,
ADDRESS VARCHAR(100) NULL,
CITY VARCHAR(50) NULL,
STATEHEADQUARTERED VARCHAR(50) NULL,
ZIP VARCHAR(20) NULL,
PHONE VARCHAR(50) NULL
);

-- Create clean encounters table

CREATE TABLE dbo.encounters(
Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
StartDateTime DATETIME2(7) NULL,
StopDateTime DATETIME2(7)  NULL,
PatientId UNIQUEIDENTIFIER  NOT NULL,
OrganizationId UNIQUEIDENTIFIER  NOT NULL,
PayerId UNIQUEIDENTIFIER  NOT NULL, 
EncounterClass VARCHAR(50) NULL,
Code VARCHAR(20) NULL,
Description VARCHAR(500) NULL,
BaseEncounterCost DECIMAL(12,2) NULL,
TotalClaimCost DECIMAL(12,2) NULL,
PayerCoverage DECIMAL(12,2) NULL,
ReasonCode  VARCHAR(20) NULL,
ReasonDescription VARCHAR(500) NULL 
);

-- Create clean procedures table

CREATE TABLE dbo.procedures(
ProcedureId INT IDENTITY PRIMARY KEY NOT NULL,
StartDateTime DATETIME2(7) NOT NULL,
StopDateTime DATETIME2(7) NOT NULL,
PatientId UNIQUEIDENTIFIER NOT NULL,
EncounterId UNIQUEIDENTIFIER NOT NULL,
Code VARCHAR(50) NOT NULL,
Description VARCHAR(500) NOT NULL,
BaseCost DECIMAL(12,2) NOT NULL,
ReasonCode VARCHAR(50) NULL,
ReasonDescription VARCHAR(500) NULL
);

-- Add foreign key relationships

ALTER TABLE dbo.encounters
ADD CONSTRAINT FK_Encounters_Patients
FOREIGN KEY (PatientId)
REFERENCES dbo.Patients(Id);


ALTER TABLE dbo.encounters
ADD CONSTRAINT FK_Encounters_Organizations
FOREIGN KEY (OrganizationId)
REFERENCES dbo.organizations(Id);

ALTER TABLE dbo.encounters
ADD CONSTRAINT FK_Encounters_Payers
FOREIGN KEY (PayerId)
REFERENCES dbo.payers(Id);


ALTER TABLE dbo.procedures
ADD CONSTRAINT FK_Procedures_Patients
FOREIGN KEY (PatientId)
REFERENCES dbo.Patients(Id);



ALTER TABLE dbo.procedures
ADD CONSTRAINT FK_Procedures_Encounters
FOREIGN KEY (EncounterId)
REFERENCES dbo.encounters(Id);
