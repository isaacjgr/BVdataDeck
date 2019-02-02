--------------------------------------------------------------******
-- create tab1 from equal to Tabdata
CREATE TABLE Test01.tab1(
row_id integer,
longitude TEXT,
latitude TEXT,
house_number TEXT,
street TEXT,
unit TEXT,
city TEXT,
district TEXT,
region TEXT,
zip TEXT,
id TEXT,
hash TEXT,
state TEXT,
version TEXT,
geometry_type TEXT,
source TEXT,
attribution TEXT,
quantity integer);

--
insert into tab1
SELECT rowid, upper(longitude), upper(latitude), upper(house_number), upper(street), upper(unit), upper(city), 
	upper(district), upper(region), upper(zip), upper(id), upper(hash), upper(state), upper(version), upper(geometry_type), 
	upper(source), upper(attribution),
	ROW_NUMBER() OVER(PARTITION BY upper(house_number), upper(street), upper(unit), upper(city), 
		upper(district), upper(region), upper(zip), upper(state) ORDER BY house_number, street, unit, city, district, region, zip, state) AS r_num
	FROM TabData
;




create table if not exists Test01.rownumbers (
	rownumber INTEGER
);



insert into rownumbers
select tab1.row_id
from tab1, TabData 
where upper(tab1.house_number) = upper(TabData.house_number)
	and upper(tab1.street) = upper(TabData.street)
	and upper(tab1.unit) = upper(TabData.unit)
	and upper(tab1.city) = upper(TabData.city)
	and upper(tab1.district) = upper(TabData.district)
	and upper(tab1.region) = upper(TabData.region)
	and upper(tab1.state) = upper(TabData.state)
	and upper(tab1.zip) = upper(TabData.zip)
	and tab1.quantity > 1
	and substr(tab1.source, 6, 6) < substr(TabData.source, 6, 6)
;

DELETE
FROM tab1
WHERE row_id in (select rownumber from rownumbers
)
;
--99918 without duplicates (filtered by run id, as newer is the kept item). Deleted 82 items.














insert into city (name)
select distinct tab1.city from tab1;

insert into state (abbreviation)
select distinct tab1.state from tab1;

insert into zip5 (zip5)
select distinct tab1.zip from tab1;

insert into location (latitude, longitude)
select distinct tab1.latitude, tab1.longitude from tab1 order by latitude, longitude;


insert into address (city_id, state_id, zip5_id, location_id, delivery_line, house_number, street, unit, zip4, geometry_type, attributor)
select city.id, state.id, zip5.id, location.id,
	'', tab1.house_number, tab1.street, tab1.unit, substr(tab1.zip,7, 4), tab1.geometry_type, tab1.attribution
	from city, state, zip5, location, tab1
	where tab1.city = city.name
		and tab1.state = state.abbreviation
		and tab1.zip = zip5.zip5
		and tab1.latitude = location.latitude
		and tab1.longitude = location.longitude
;
