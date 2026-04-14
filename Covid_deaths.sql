select * 
from covid_deaths
order by 3,4;

select * 
from covid_vaccination
order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths
order by 1,2;

describe covid_deaths; 

UPDATE covid_deaths 
SET `date` = STR_TO_DATE(`date`, '%Y/%c/%e');

-- Total cases vs Total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 death_percentage
from covid_deaths
order by 1,2;

-- Total cases vs population

select location, date, total_cases, population, (total_cases/population)*100 percent_of_population_infected
from covid_deaths
order by 1,2;

-- which county has the highest infection rate compared to population

select location, max(total_cases) as highest_infection_count, max((total_cases/population))*100 percent_of_population_infected
from covid_deaths
group by location, population
order by  highest_infection_count desc;

-- countries with highest death count per population

select location, max(total_deaths) as total_death_count
from covid_deaths
where continent IS not null
group by location 
order by total_death_count desc;

-- highest death count per population per continent

select location, max(total_deaths) as total_death_count
from covid_deaths
where continent =''
-- continent is null
group by location 
order by total_death_count desc;

-- Global numbers
select sum(new_cases) as tot_cases, sum(new_deaths) as tot_deaths, (sum(new_deaths)/sum(new_cases))*100
from covid_deaths
where continent=''
-- group by date
order by 1,2;

select * 
from covid_deaths dea
join covid_vaccination vac
	on dea.location=vac.location;

select date from covid_vaccination order by date;
select date from covid_deaths order by date;

-- select str_to_date(`date`,'%d/%m/%Y') from covid_vaccination order by date;

-- SELECT STR_TO_DATE(column_name, '%d/%m/%Y') AS formatted_date FROM table_name;

-- ALTER TABLE covid_vaccination ADD COLUMN new_date_col text;

-- UPDATE covid_vaccination SET new_date_col = STR_TO_DATE(`date`, '%d/%m/%Y');

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vaccination vac
	On dea.location = vac.location
where dea.continent is not null 
order by 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null 
-- order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 









