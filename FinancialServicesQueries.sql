use FinanceProject;

select * from FinancialHealth;

alter table FinancialHealth
add is_resilient int;

update FinancialHealth
set is_resilient = 
	case
		when Shock_Resilience in ('You could do it', 'You probably could do it') then 1.0
		else 0.0
	end;

--- Does having access to bank account improve resilience?

SELECT
    Has_Bank_Account,
    CAST(AVG(
        CASE
            WHEN Shock_Resilience IN ('You could do it', 'You probably could do it') THEN 1.0
            ELSE 0.0
        END
    ) * 100 AS DECIMAL(5,2)) AS resilience_rate,
    COUNT(*) AS respondents
FROM FinancialHealth
GROUP BY Has_Bank_Account;

--- Does having access to mobile money improve resilience?
SELECT
    Has_Mobile_Money,
    CAST(AVG(
        CASE
            WHEN Shock_Resilience IN ('You could do it', 'You probably could do it') THEN 1.0
            ELSE 0.0
        END
    ) * 100 AS DECIMAL(5,2)) AS resilience_rate,
    COUNT(*) AS respondents
FROM FinancialHealth
GROUP BY Has_Mobile_Money;

--- Having both mobile money and bank account

SELECT
    Has_Bank_Account,
	Has_Mobile_Money,
    CAST(AVG(
        CASE
            WHEN Shock_Resilience IN ('You could do it', 'You probably could do it') THEN 1.0
            ELSE 0.0
        END
    ) * 100 AS DECIMAL(5,2)) AS resilience_rate,
    COUNT(*) AS respondents
FROM FinancialHealth
GROUP BY Has_Bank_Account, Has_Mobile_Money
order by resilience_rate desc;