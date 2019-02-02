# BVdataDeck

The following steps will give you the solution for the "DataDeck Operations Technical Challenge". It is divided by Points, in the same order as the challenge document.
Here you can find also the files what I'm using in some parts next.

## Point 1. Pre-process

1. Open this link (https://notepad-plus-plus.org/download/v7.6.3.html) and download the Notepad++ version for your Operating System. Install or use the zipped version

2. Open the original file with Notepad++

3. Open the replace command (Ctrl + H / Clic on Menu Search and then Replace), 

	set the **Regular Expression Search Mode** 

  put in Find what: field **^"**

  Replace with field must be empty

  This should delete the first double quotes.

4. In the same window Find what: **"\r\n**

  Replace with: **\r\n**

  This should delete the end double quotes.

5. Find what: **","** 

  Replace with: **\t**

6. Save the file with .tab (or .tsv) format. In this case the file has the name **ResultDataset.tsv**

  ** All items have valid latitud and longitude, so no dropped rows



## Point 2. Generate statistics

1. Open SQLite and create datbase with the following command: 

      `sqlite3 Test01.db`

2. Attach the database to the current working environment typing this command: 

      `ATTACH DATABASE 'Test01.db' AS Test01;`

3. Stablish the tab separator to load the data with the following code:

      `.mode tabs`

5. Run the following code to import data into the table TabData, defined in the same command

      `.import ResultDataset.tsv TabData`

6. Check the total rows inserted with this command:

      `select count(1) from TabData;`

7. Count the total amount of records per source that were loaded. For this, run this command:

      `select COUNT(source) from TabData where source is not null;`

  Result: 100000

8. Count the total amount of records per zip5. For this run the following command:

      `select count(zip) from TabData where LENGTH(zip)>5;`

  Result: 2200


  
## Point 3. Remove duplicates.

By running the following queries, the duplicated values will be stored in `tab1`. Just the text within gray spaces should be ran.

The next query will create this table.

`create tab1 from equal to Tabdata
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
quantity integer);`

The next query will insert in the previous table all the items and also will add in `quantity` column the times that each address is repeated. Here the Window function ROW_NUMBER() is grouping repeated addresses.

`insert into tab1
SELECT rowid, upper(longitude), upper(latitude), upper(house_number), upper(street), upper(unit), upper(city), 
	upper(district), upper(region), upper(zip), upper(id), upper(hash), upper(state), upper(version), upper(geometry_type), 
	upper(source), upper(attribution),
	ROW_NUMBER() OVER(PARTITION BY upper(house_number), upper(street), upper(unit), upper(city), 
		upper(district), upper(region), upper(zip), upper(state) ORDER BY house_number, street, unit, city, district, region, zip, state) AS r_num
	FROM TabData
;`

This query will create a table to save the rownumber of items that will be deleted.

`create table if not exists Test01.rownumbers (
	rownumber INTEGER
);`

This query will insert into rownumbers table, the IDs that will be deleted

`insert into rownumbers
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
;`

This query will delete from tab1, the duplicated items.

`DELETE
FROM tab1
WHERE row_id in (select rownumber from rownumbers
)
;`

After applying the deletion, we got 99918 items without duplicates (filtered by run id, as newer is the kept item). Deleted 82 items.
	
## Point 4. Send to production.

1. Copy the file TestDatabase.sql within the folder you are working in. Then run the following query

`.read TestDatabase.sql`
		
2. To fill the tables with the corresponding data, run the following queries

Inserting into City table

`insert into city (name)
select distinct tab1.city from tab1;`

Inserting into State table

`insert into state (abbreviation)
select distinct tab1.state from tab1;`

Inserting into Zip5 table

`insert into zip5 (zip5)
select distinct tab1.zip from tab1;`

Inserting into Location table

`insert into location (latitude, longitude)
select distinct tab1.latitude, tab1.longitude from tab1 order by latitude, longitude;`

Inserting into Address table

`insert into address (city_id, state_id, zip5_id, location_id, delivery_line, house_number, street, unit, zip4, geometry_type, attributor)
select city.id, state.id, zip5.id, location.id,
	'', tab1.house_number, tab1.street, tab1.unit, substr(tab1.zip,7, 4), tab1.geometry_type, tab1.attribution
	from city, state, zip5, location, tab1
	where tab1.city = city.name
		and tab1.state = state.abbreviation
		and tab1.zip = zip5.zip5
		and tab1.latitude = location.latitude
		and tab1.longitude = location.longitude
;`


3. Copy the file indexes.sql within the folder you are working in. Then run the following query

`.read indexes.sql`

In this step I'm creating three indexes:

- address_city

- address_state

- address_zip5


The purpose of them is to increase the velocity in SELECT statements, when the user want to search in table Address by the corresponding column (city_id, state_id or zip5_id).


## Extra Credit

### Features not in SQLite that can help to solve the problem

- Based on description (point 1), "We standardize raw data so we can utilize existing tools whenever possible".

Oracle Data Integrator or Alteryx tool can help us getting data from CSV or TSV file, filtering with corresponding validations and also loading this information to the destination database. This scenario will not generate a script, instead of that, this will provide a plan to run within the same application.

Pros:

- This could be the fastest solution.

- Eliminates some manual steps.

- The process could be reproduced after the creation

Cons:

- Needs commercial software that can increase the budget of the company.

- Depending on the security policies, this software can't be used, due to access policies to databases


