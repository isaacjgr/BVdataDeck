CREATE TABLE IF NOT EXISTS address (
	id integer PRIMARY KEY,
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
	ON DELETE CASCADE ON UPDATE NO ACTION,
);

CREATE TABLE IF NOT EXISTS city (
	id integer PRIMARY KEY,
	name text
);

CREATE TABLE IF NOT EXISTS state (
	id integer PRIMARY KEY,
	abbreviation text
);
CREATE TABLE IF NOT EXISTS zip5 (
	id integer PRIMARY KEY,
	zip5 text
);
CREATE TABLE IF NOT EXISTS location (
	id integer PRIMARY KEY,
	latitude text,
	longitude text
);