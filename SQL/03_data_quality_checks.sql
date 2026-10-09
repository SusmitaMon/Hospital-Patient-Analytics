
USE HospitalAnalytics;
GO

-- =============================================
-- DATA QUALITY CHECKS
-- Validate completeness and referential integrity
-- =============================================


SELECT Id, COUNT(*) AS DuplicateCount
FROM dbo.encounters_raw
GROUP BY Id
HAVING COUNT(*) > 1;

-- Check for procedures with no matching encounter

SELECT e.Id, p.EncounterId
FROM dbo.procedures p
LEFT JOIN dbo.encounters e
    ON p.EncounterId = e.Id
WHERE e.Id IS NULL;

-- Check for encounters with no matching patient

SELECT e.PatientId, p.Id 
FROM dbo.encounters e 
LEFT JOIN dbo.patients p
    ON e.PatientId = p.Id
WHERE p.Id IS NULL;


-- Validate final row counts after cleaning


SELECT COUNT(*) AS Row_Count 
FROM dbo.patients;

SELECT COUNT(*) AS Row_Count
FROM dbo.encounters;

SELECT COUNT(*) AS Row_Count
FROM dbo.procedures;

SELECT COUNT(*) AS Row_Count
FROM dbo.payers;

SELECT COUNT(*) AS Row_Count
FROM dbo.organizations;






