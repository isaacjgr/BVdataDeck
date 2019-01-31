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

    ------********************************************************--------------
	
## Point 4. Send to production.

1. Copy the file TestDatabase.sql within the folder you are working in. Then run the following query

        `.read TestDatabase.sql`
		
2. To fill the tables with the corresponding data, run the following query

        ------********************************************************--------------

3. Copy the file indexes.sql within the folder you are working in. Then run the following query

        `.read indexes.sql`

