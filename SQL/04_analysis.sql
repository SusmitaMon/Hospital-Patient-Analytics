
USE HospitalAnalytics;
GO

-- =============================================
-- HOSPITAL PATIENT ANALYTICS
-- Business and operational analysis
-- =============================================

-- =============================================
-- 1. ENCOUNTER ANALYSIS
-- =============================================

-- Encounter volume and percentage distribution by class

SELECT EncounterClass, COUNT(*) AS Encounter_Count,
CAST(
    COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM dbo.encounters)
    AS DECIMAL(12,2)
) AS Encounter_Percentage
FROM dbo.encounters
GROUP BY EncounterClass
ORDER BY Encounter_Count DESC;

-- =============================================
-- 2. FINANCIAL ANALYSIS
-- =============================================


-- Total and average claim cost by encounter class

SELECT 
    EncounterClass,
    SUM(TotalClaimCost) AS TotalClaimCost,
    CAST(AVG(TotalClaimCost) AS DECIMAL(12,2)) AS AverageClaimCost
FROM dbo.encounters
GROUP BY EncounterClass
ORDER BY TotalClaimCost DESC;

-- Payer coverage percentage by encounter class

SELECT EncounterClass, 
CAST(
    SUM(PayerCoverage) * 100.0 /
    SUM(TotalClaimCost) AS DECIMAL(12,2)
) AS PayerCoveragePercentage
FROM dbo.encounters
GROUP BY EncounterClass;

-- Payer coverage percentage by payer

SELECT p.Name, 
CAST(
    SUM(e.PayerCoverage) * 100.0 /
    SUM(e.TotalClaimCost) AS DECIMAL(12,2)
) AS PayerCoveragePercentage
FROM dbo.encounters e 
JOIN dbo.payers p
    ON e.PayerId = p.Id
GROUP BY p.Name
ORDER BY PayerCoveragePercentage DESC;

-- Percentage of zero-coverage encounters by payer

SELECT p.Name, 
CAST(
    SUM(
        CASE 
            WHEN e.PayerCoverage = 0 THEN 1
            ELSE 0
        END
    ) * 100.0
    / COUNT(*)
    AS DECIMAL(12,2)
) AS ZeroPayerCoveragePercentage
FROM dbo.encounters e
JOIN dbo.payers p
ON e.PayerId=p.Id
GROUP BY p.Name
ORDER BY ZeroPayerCoveragePercentage DESC;

-- =============================================
-- 3. PROCEDURE ANALYSIS
-- =============================================


-- Top 10 procedures by frequency

SELECT TOP 10
    Description,
    COUNT(*) AS ProcedureCount
FROM dbo.procedures
GROUP BY Description
ORDER BY ProcedureCount DESC;

-- Top 10 procedures by total cost

SELECT TOP 10
    Description,
    SUM(BaseCost) AS TotalProcedureCost
FROM dbo.procedures
GROUP BY Description
ORDER BY TotalProcedureCost DESC;

-- =============================================
-- 4. ENCOUNTER DURATION ANALYSIS
-- =============================================
-- Average encounter duration in hours by encounter class

SELECT EncounterClass,
    CAST(
        AVG(DATEDIFF(MINUTE, StartDateTime, StopDateTime) / 60.0)
        AS DECIMAL(12,2)
    ) AS AvgDurationHours
FROM dbo.encounters
GROUP BY EncounterClass
ORDER BY AvgDurationHours DESC;

-- =============================================
-- 5. HIGH-COST PATIENT ANALYSIS
-- =============================================

-- Top 10 high-cost patients: claim cost, encounter frequency,
-- average claim cost and uncovered amount

SELECT TOP 10 e.PatientId, p.First, p.Last, 
SUM(e.TotalClaimCost) AS TotalClaimCost,
COUNT(e.Id) AS EncounterNumber,
CAST(
    SUM(e.TotalClaimCost) / COUNT(e.Id)
    AS DECIMAL(12,2)
) AS AvgClaimCostPerEncounter,
SUM(e.TotalClaimCost - e.PayerCoverage) AS TotalUncoveredAmount
FROM dbo.encounters e JOIN dbo.patients p
ON e.PatientId = p.Id
GROUP  BY e.PatientId, p.First, p.Last
ORDER BY TotalClaimCost DESC;

























