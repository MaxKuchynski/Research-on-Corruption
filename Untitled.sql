#rename columns 
ALTER TABLE `WBR`.`ESG` 
CHANGE COLUMN `Country Name` `country_name` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Country Code` `country_code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Series Name` `series_name` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Series Code` `series_code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `2013` `year_2013` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2014` `year_2014` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2015` `year_2015` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2016` `year_2016` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2017` `year_2017` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2018` `year_2018` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2019` `year_2019` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2020` `year_2020` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `2021` `year_2021` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `2050` `year_2050` TEXT NULL DEFAULT NULL ;

#select all
SELECT *
FROM WBR.ESG;

# Corruption Index
SELECT country_name, country_code, year_2020
FROM WBR.ESG
WHERE series_code = 'CC.EST'
ORDER BY year_2020 DESC;

# Access to electricity (% of population)
SELECT country_name, country_code, year_2020
FROM WBR.ESG
WHERE series_code = 'EG.ELC.ACCS.ZS';

# Ease of doing business rank (1=most business-friendly regulations)
SELECT country_name, country_code, year_2020
FROM WBR.ESG
WHERE series_code ='GE.EST';

# corrilation CC.EST / EG.ELC.ACCS.ZS
SELECT a.country_name, a.country_code, a.year_2020 AS 'control_of_corr', b.year_2020 AS 'access_to_electricity'
FROM WBR.ESG AS a
LEFT JOIN WBR.ESG AS b 
ON a.country_name = b.country_name
WHERE  a.series_code = 'CC.EST' AND b.series_code = 'EG.ELC.ACCS.ZS';

# corrilation CC.EST / SE.XPD.TOTL.GB.ZS
SELECT a.country_name, a.country_code, ROUND(a.year_2020,4) AS 'control_of_corr', ROUND(b.year_2020,4) AS 'government_expenditure'
FROM WBR.ESG AS a
LEFT JOIN WBR.ESG AS b 
ON a.country_code = b.country_code
WHERE  a.series_code = 'CC.EST' AND b.series_code = 'SE.XPD.TOTL.GB.ZS';

# corrilation CC.EST / SI.DST.FRST.20
SELECT a.country_name, a.country_code, ROUND(a.year_2020,4) AS 'control_of_corr', IFNULL(b.year_2020, 'N/A') AS 'income_share_held_by_lower_20%'
FROM WBR.ESG AS a
CROSS JOIN WBR.ESG AS b 
ON a.country_code = b.country_code
WHERE  a.series_code = 'CC.EST' AND b.series_code = 'SI.DST.FRST.20';

# Poverty headcount ratio
SELECT country_name, country_code, year_2020
FROM WBR.ESG
WHERE series_code = 'SI.POV.NAHC'
ORDER BY year_2020 DESC;

# GINI
SELECT country_name, country_code, year_2020
FROM WBR.ESG
WHERE series_code = 'SI.POV.GINI'
ORDER BY year_2020 DESC;

# Control of corruption avarage
SELECT AVG(year_2020)
FROM WBR.ESG
WHERE series_code = 'CC.EST';

# how many countries have 100% access to electricity
SELECT  COUNT(a.year_2020) AS '100%', COUNT(b.year_2020) AS '<100%'
FROM WBR.ESG AS a
INNER JOIN WBR.ESG AS b 
ON a.country_name = b.country_name
WHERE a.series_code = 'EG.ELC.ACCS.ZS' AND b.series_code = 'EG.ELC.ACCS.ZS' AND a.year_2020 = 100 AND b.series_code < 100;