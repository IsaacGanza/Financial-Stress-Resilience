use FinanceProject;

select * from FinancialHealth;

--- replace ? with ' in shock_resilience

update FinancialHealth
set Shock_Resilience = REPLACE(Shock_Resilience, '?', '''')
where Shock_Resilience like '%?%'

--- Overall stress baseline

select count(*) as total_respondents,
	SUM(CASE
		When Financial_Stress IN('strongly agree', 'Agree') Then 1
		Else 0
	End) As stressed_count,
	CAST(SUM(CASE
		WHEN Financial_Stress IN('strongly agree', 'Agree') Then 1
		Else 0
		end) * 100.0/count(*) as decimal(5,2)) as stress_related_percent
from FinancialHealth

--- Overall stress income shortfall frequency in the last 12 months.

Select 
	Income_Shortfall_Freq,
	count(*) as respondents,
	CAST(SUM(CASE
		WHEN Financial_Stress in ('strongly agree', 'agree') then 1
		else 0
	end) * 100.0/ count(*) as decimal(5,2)) as stress_rate
from FinancialHealth
group by Income_Shortfall_Freq
order by stress_rate desc

--- Stress caused by not having money last
Select 
	Money_Lasts,
	count(*) as respondents,
	CAST(SUM(CASE
		WHEN Financial_Stress in ('strongly agree', 'agree') then 1
		else 0
	end) * 100.0/ count(*) as decimal(5,2)) as stress_rate
from FinancialHealth
group by Money_Lasts
order by stress_rate

--- Stress by shock resilience

select 
	shock_resilience,
	count(*) as respondents,
	CAST(SUM(CASE
		WHEN Financial_Stress in ('strongly agree', 'agree') then 1
		else 0
	end) * 100.0/ count(*) as decimal(5,2)) as stress_rate
from FinancialHealth
group by Shock_Resilience
order by stress_rate desc

--- Does saving reduce financial stress?
SELECT
    Saves_Money,
    COUNT(*) AS respondents,
    CAST(SUM(CASE 
        WHEN Financial_Stress IN ('Strongly agree', 'Agree') THEN 1 
        ELSE 0 
    END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS stress_rate
FROM FinancialHealth
GROUP BY Saves_Money
order by stress_rate desc;

--- Does having emergency funds reduce stress?
SELECT
    Emergency_Fund,
    COUNT(*) AS respondents,
    CAST(SUM(CASE 
        WHEN Financial_Stress IN ('Strongly agree', 'Agree') THEN 1 
        ELSE 0 
    END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS stress_rate
FROM FinancialHealth
GROUP BY Emergency_Fund;


--- who is at risk of financial stress based on a number of factors

select 
	Income_Shortfall_Freq,
	Saves_Money,
	Emergency_Fund,
	CAST(SUM(CASE 
        WHEN Financial_Stress IN ('Strongly agree', 'Agree') THEN 1 
        ELSE 0 
    END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS stress_rate,
    COUNT(*) AS respondents
from FinancialHealth
group by Income_Shortfall_Freq, Saves_Money, Emergency_Fund
having count(*) >= 30
order by stress_rate desc;