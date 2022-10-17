

CREATE SCHEMA bkng_db;


CREATE TABLE bkng_db.city
(
  id bigserial NOT NULL,
  city_name text,
  city_latitude float,
  city_longitude float,
  CONSTRAINT city_pk PRIMARY KEY (id)
);

CREATE TABLE bkng_db.hotels
(
  id bigserial NOT NULL,
  city_id bigserial NOT NULL,
  hotel_name text,
  latitude float,
  longitude float,
  address text,
  CONSTRAINT hotel_pk PRIMARY KEY (id),
  CONSTRAINT city_id_fk FOREIGN KEY (city_id)
        REFERENCES bkng_db.city (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX hotel_by_name_index
  ON bkng_db.hotels
  USING btree
  (hotel_name,latitude,longitude);

CREATE INDEX city_by_name_index
  ON bkng_db.city
  USING btree
  (city_name,city_latitude,city_longitude);