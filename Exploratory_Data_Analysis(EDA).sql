-- Exploratory DATA analysis

select max(total_laid_off), max(percentage_laid_off)
from layoff_staging_2;

select * 
from layoff_staging_2
where percentage_laid_off=1
order by total_laid_off desc;


select * 
from layoff_staging_2
where percentage_laid_off=1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoff_staging_2
group by company 
order by 2 desc;

select company, sum(total_laid_off)
from layoff_staging_2
group by industry 
order by 2 desc;

select max(`date`), min(`date`)
from layoff_staging_2;


select stage, sum(total_laid_off)
from layoff_staging_2
group by stage 
order by 2 desc;

ALTER TABLE layoff_staging_2
RENAME COLUMN  my_date TO `date`;

select `date`, str_to_date(`date`,'%m/%d/%y')
from layoff_staging_2;

select * from layoff_staging_2;



