CREATE TABLE IF NOT EXISTS Test01.address (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	city_id integer,
	state_id integer,
	zip5_id integer,
	location_id integer,
	delivery_line text,
	house_number text,
	street text,
	unit text,
	zip4 text,
	geometry_type text,
	attributor text,
	FOREIGN KEY (city_id) REFERENCES city (id)
	ON DELETE CASCADE ON UPDATE NO ACTION,
	FOREIGN KEY (state_id) REFERENCES state (id)
	ON DELETE CASCADE ON UPDATE NO ACTION,
	FOREIGN KEY (zip5_id) REFERENCES zip5 (id)
	ON DELETE CASCADE ON UPDATE NO ACTION,
	FOREIGN KEY (location_id) REFERENCES location (id)
	ON DELETE CASCADE ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS Test01.city (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name text
);

CREATE TABLE IF NOT EXISTS Test01.state (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	abbreviation text
);
CREATE TABLE IF NOT EXISTS Test01.zip5 (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	zip5 text
);
CREATE TABLE IF NOT EXISTS Test01.location (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	latitude text,
	longitude text
);
