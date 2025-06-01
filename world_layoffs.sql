-- Data Cleaning
-- Steps
-- 1. Remove Duplicate
-- 2. Standardize the data
-- 3. Null values or Blank values
-- 4. Remove Any Columns or rows

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- To REMOVE DUPLICATE
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * -- to check and confirm duplicate
FROM layoffs_staging
WHERE company = 'Casper'; 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- TO CONFIRM DELETE
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- Standadizing DATA -- This is to find issues on our data and fix it

-- working on company column
-- SELECT DISTINCT company
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- working on industry column
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
;
-- working on location column
SELECT DISTINCT location -- This look prety good
FROM layoffs_staging2
ORDER BY 1;

-- working on country column
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Working on date column
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
;
SELECT `date`
FROM layoffs_staging2
;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
;

-- NULL OR BLANK VALUES
-- working on total_laid_off also populate values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT DISTINCT industry
FROM layoffs_staging2
;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
 AND t2.industry IS NOT NULL
;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
 AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;




-- Exploratory Data Analysis
SELECT *
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
-- ORDER BY total_laid_off DESC
ORDER BY funds_raised_millions DESC
;
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2
;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT country, MAX(funds_raised_millions)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;

SELECT country, industry, MAX(funds_raised_millions), AVG(funds_raised_millions)
FROM layoffs_staging2
GROUP BY country, industry
ORDER BY 2, 4 DESC;

SELECT *
FROM layoffs_staging2;

SELECT (`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY (`date`)
ORDER BY 1 DESC;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT *
FROM layoffs_staging2;

SELECT SUBSTRING(`date`, 6, 2)AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`
;

SELECT SUBSTRING(`date`, 1, 7)AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7)AS `MONTH`, SUM(total_laid_off)AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`)AS rolling_total
FROM Rolling_Total;


-- total layoffs by each year
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
-- ORDER BY company ASC
-- CHECK THE MOST LAYOFFS YEAR
ORDER BY 3 DESC;

-- USE CTE
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS   -- 2ND CTE
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC)AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
-- ORDER BY Ranking ASC;
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;












