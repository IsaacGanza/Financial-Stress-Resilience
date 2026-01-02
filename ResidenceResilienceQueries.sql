use FinanceProject;

--- Stress rate by urban vs Rural

select 
	Residence,
	CAST(AVG(
        CASE
            WHEN Financial_Stress IN ('Strongly agree', 'Agree') THEN 1.0
            ELSE 0.0
        END
    ) * 100 AS DECIMAL(5,2)) AS stress_rate,
    COUNT(*) AS respondents
from FinancialHealth
group by Residence;

--- Income shortfall by residence
SELECT
    Residence,
    CAST(AVG(
        CASE
            WHEN Income_Shortfall_Freq IN ('On a Monthly basis', 'Someties') THEN 1.0
            ELSE 0.0
        END
    ) * 100 AS DECIMAL(5,2)) AS income_instability_rate
FROM FinancialHealth
GROUP BY Residence;

--- Vulnerability by a number of factors
SELECT
    Residence,
    CAST(AVG(
        CASE WHEN Financial_Stress IN ('Strongly agree', 'Agree') THEN 1.0 ELSE 0.0 END
    ) * 100 AS DECIMAL(5,2)) AS stress_rate,

    CAST(AVG(
        CASE WHEN Shock_Resilience IN ('You could do it', 'You probably could do it') THEN 1.0 ELSE 0.0 END
    ) * 100 AS DECIMAL(5,2)) AS resilience_rate,

    CAST(AVG(
        CASE WHEN Emergency_Fund = 'Yes' THEN 1.0 ELSE 0.0 END
    ) * 100 AS DECIMAL(5,2)) AS emergency_fund_rate,

    CAST(AVG(
        CASE WHEN Has_Bank_Account = 'Yes' THEN 1.0 ELSE 0.0 END
    ) * 100 AS DECIMAL(5,2)) AS bank_access_rate,

    COUNT(*) AS respondents
FROM FinancialHealth
GROUP BY Residence;


