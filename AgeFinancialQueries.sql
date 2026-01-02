use FinanceProject;

alter table FinancialHealth
add age_group varchar(20);

update financialHealth
set age_group = 
	CASE
        WHEN Age BETWEEN 16 AND 24 THEN '16–24'
        WHEN Age BETWEEN 25 AND 34 THEN '25–34'
        WHEN Age BETWEEN 35 AND 44 THEN '35–44'
        WHEN Age BETWEEN 45 AND 54 THEN '45–54'
        WHEN Age >= 55 THEN '55+'
        ELSE 'Unknown'
    END; 

--- Which age group is more financially stressed.
SELECT
    age_group,
    CAST(AVG(
        CASE
            WHEN Financial_Stress IN ('Strongly agree', 'Agree') THEN 1.0
            ELSE 0.0
        END
    ) * 100 AS DECIMAL(5,2)) AS stress_rate,
    COUNT(*) AS respondents
FROM FinancialHealth
GROUP BY age_group
HAVING COUNT(*) >= 30
ORDER BY stress_rate DESC;

--- Which age group is more financially resilient
SELECT
    age_group,
    CAST(AVG(
        CASE
            WHEN Shock_Resilience IN ('You could do it', 'You probably could do it') THEN 1.0
            ELSE 0.0
        END
    ) * 100 AS DECIMAL(5,2)) AS resilience_rate,
    COUNT(*) AS respondents
FROM FinancialHealth
GROUP BY age_group
HAVING COUNT(*) >= 30
ORDER BY resilience_rate DESC;

