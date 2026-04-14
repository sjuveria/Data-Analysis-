-- Data cleaning --

select * from layoffs;

-- 1. Remove duplicates 
-- 2. Standarize data 
-- 3.  Null values/ Blank values 
-- 4. Remove Columns 

-- 1. Remove Duplicates

-- Make a table just like layoffs to make any changes
Create Table layoffs_staging
like layoffs;

-- Insert data from layoffs table
insert layoffs_staging
select *
from layoffs;

Select * from layoffs_staging;

select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;	

-- As we can not use Row_num directly with where clause
-- we are making CTE here(you can use sub query as well)
-- No semi column after with bracket ends and need to use the query exactly after making CTE

with duplicate_CTE as(
	select *,
	row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off,
	`date`, stage, country, funds_raised_millions) as row_num
	from layoffs_staging
)
select * 
from duplicate_CTE
where row_num >1;

-- delete rows with row_num>1. These rows are duplicates
-- As older versions of mysql does not allow create/ update/ delete with CTE 
-- we need to make another table to perforn delete operation


-- we can make tabke like another table but can not make table from a query
-- to make table just like duplicate_CTE we can copy columns from
-- table world_layoffs and add one more row i.e 'row_num'

create table layoff_staging_2
like layoffs_staging;

select * 
from layoff_staging_2;

alter table layoff_staging_2
add row_num int;

insert  into layoff_staging_2
select *,
	row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off,
	`date`, stage, country, funds_raised_millions) as row_num
	from layoffs_staging;
    
select * 
from layoff_staging_2
where row_num>1;

delete 
from layoff_staging_2
where row_num>1;











