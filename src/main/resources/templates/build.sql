

CREATE SCHEMA bkng_db;

CREATE TABLE bkng_db.hotels
(
  id bigserial NOT NULL,
  hotel_name text,
  CONSTRAINT user_pk PRIMARY KEY (id)
);

CREATE TABLE cf_apps.metadata
(
  sl_no bigserial NOT NULL,
  app_id uuid NOT NULL,
  creation_ts timestamp with time zone NOT NULL DEFAULT now(),
  last_updated_ts timestamp with time zone NOT NULL DEFAULT now(),
  status integer NOT NULL DEFAULT 100,
  version character varying(140) NOT NULL DEFAULT '0.0.0'::character varying,
  application_segment integer NOT NULL DEFAULT 100,
  misc_jsonb jsonb,
  product_type integer NOT NULL DEFAULT 100,
  application_type integer NOT NULL DEFAULT 100,
  app_request_id text,
  third_party_reference_id text,
  application_lifecycle_id integer NOT NULL DEFAULT 0,
  in_process_status integer,
  previous_application_id uuid,
  tags jsonb NOT NULL DEFAULT '[]'::jsonb,
  source_attributes jsonb,
  app_source_name character varying(24) NOT NULL,
  CONSTRAINT apps_pk PRIMARY KEY (app_id),
  CONSTRAINT app_source_fk FOREIGN KEY (app_source_name)
      REFERENCES cf_apps.app_source_details (app_source_name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE cf_apps.business_entity
(
  business_id bigserial NOT NULL,
  registered_name text NOT NULL,
  incorporation_date date,
  application_context integer DEFAULT 0,
  app_id uuid NOT NULL,
  operation_start_date date,
  operate_as integer,
  nature_of_business integer,
  industry_type integer,
  main_product_category integer,
  business_profile text,
  cibil_request_id text,
  services_provided jsonb DEFAULT '[]'::jsonb,
  kyc_status integer NOT NULL,
  CONSTRAINT business_pk PRIMARY KEY (business_id),
  CONSTRAINT business_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
       CONSTRAINT business_entity_industry_type_fkey FOREIGN KEY (industry_type)
            REFERENCES cf_apps.list_industry_type (id) MATCH SIMPLE
            ON UPDATE NO ACTION ON DELETE NO ACTION,
        CONSTRAINT business_entity_main_product_category_fkey FOREIGN KEY (main_product_category)
            REFERENCES cf_apps.list_product_category (id) MATCH SIMPLE
            ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX business_app_index
  ON cf_apps.business_entity
  USING btree
  (app_id);

CREATE TABLE cf_apps.individual_entity
(
  individual_id bigserial NOT NULL,
  first_name text NOT NULL,
  last_name text,
  birth_date date,
  application_context integer DEFAULT 0,
  app_id uuid NOT NULL,
  gender integer DEFAULT 0,
  marital_status integer DEFAULT 0,
  qualification integer DEFAULT 100,
  cibil_request_id text,
  cibil_consent_flag integer DEFAULT 100,
  bu_relationship_type integer DEFAULT 100,
  business_id bigint DEFAULT 0,
  bu_share_percent numeric(5,2) DEFAULT 0.00,
  cibil_consent_mode integer NOT NULL DEFAULT 0,
  work_ex integer,
  kyc_status integer NOT NULL,
  CONSTRAINT individual_pk PRIMARY KEY (individual_id),
  CONSTRAINT individual_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX individual_app_index
  ON cf_apps.individual_entity
  USING btree
  (app_id);



CREATE TABLE cf_apps.address
(
  address_id bigserial NOT NULL,
  latitude numeric(20,18),
  longitude numeric(20,18),
  landmark text,
  address text,
  city text,
  pincode integer NOT NULL,
  state bigint,
  ownership_type integer,
  occupancy_start_date date,
  country integer,
  post_office text,
  district text,
  address_type integer NOT NULL,
  entity_id bigint NOT NULL,
  app_id uuid NOT NULL,
  is_active integer DEFAULT 100,
  is_fi_needed integer DEFAULT 0,
  entity_type integer NOT NULL,
  CONSTRAINT address_pk PRIMARY KEY (address_id),
  CONSTRAINT contacts_address_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX address_app_index
  ON cf_apps.address
  USING btree
  (app_id);

CREATE TABLE cf_apps.contact_details
(
  contact_id bigserial NOT NULL,
  contact_type integer NOT NULL,
  contact_information text NOT NULL,
  entity_id bigint NOT NULL,
  contact_context integer NOT NULL DEFAULT 0,
  app_id uuid NOT NULL,
  entity_type integer NOT NULL,
  CONSTRAINT contacts_pk PRIMARY KEY (contact_id),
  CONSTRAINT contacts_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX contacts_app_index
  ON cf_apps.contact_details
  USING btree
  (app_id);


CREATE TABLE cf_apps.entity_poi
(
  poi_id bigserial NOT NULL,
  entity_id bigint NOT NULL,
  id_type integer NOT NULL,
  id_information text NOT NULL,
  app_id uuid NOT NULL,
  entity_type integer,
  CONSTRAINT poi_pk PRIMARY KEY (poi_id),
  CONSTRAINT poi_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX poi_app_index
  ON cf_apps.entity_poi
  USING btree
  (app_id);


CREATE TABLE cf_apps.ecosystem
(
  ecosystem_id bigserial NOT NULL,
  app_id uuid NOT NULL,
  partner_id bigint NOT NULL,
  type integer NOT NULL DEFAULT 100,
  customer_id text,
  url text,
  username text,
  password text,
  start_date date,
  rating text,
  payment_cycle numeric(8,4),
  return_percentage numeric(4,2),
  CONSTRAINT eco_id_pk PRIMARY KEY (ecosystem_id),
  CONSTRAINT ecosystem_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX ecosystem_app_index
  ON cf_apps.ecosystem
  USING btree
  (app_id);

CREATE TABLE cf_apps.ecosystem_xns
(
  xns_id bigserial NOT NULL,
  ecosystem_id bigint NOT NULL,
  app_id uuid NOT NULL,
  xn_type integer NOT NULL,
  base_month integer NOT NULL,
  months_of_data numeric(5,2) NOT NULL DEFAULT 6,
  base_month_minus_1 numeric(16,2),
  base_month_minus_2 numeric(16,2),
  base_month_minus_3 numeric(16,2),
  base_month_minus_4 numeric(16,2),
  base_month_minus_5 numeric(16,2),
  base_month_minus_6 numeric(16,2),
  base_month_minus_7 numeric(16,2),
  base_month_minus_8 numeric(16,2),
  base_month_minus_9 numeric(16,2),
  base_month_minus_10 numeric(16,2),
  base_month_minus_11 numeric(16,2),
  base_month_minus_12 numeric(16,2),
  CONSTRAINT ecosystem_xns_pk PRIMARY KEY (xns_id),
  CONSTRAINT ecosystem_xns_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT ecosystem_xns_ecosystem_id_fkey FOREIGN KEY (ecosystem_id)
      REFERENCES cf_apps.ecosystem (ecosystem_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX ecosystem_xns_app_index
  ON cf_apps.ecosystem_xns
  USING btree
  (app_id);


CREATE TABLE cf_apps.logs
(
log_id bigserial not null,
action int not null,
actioner text not null,
app_id character varying(100) not null,
datetime timestamp with time zone NOT NULL DEFAULT now(),
data text not null,
CONSTRAINT logs_pk PRIMARY KEY (log_id)
);



CREATE TABLE cf_apps.app_pool_mapping
(
app_pool_id bigserial not null,
pool_id bigint not null,
app_id uuid not null,
CONSTRAINT pool_app_pk PRIMARY KEY (app_pool_id),
CONSTRAINT pool_app_unique UNIQUE (pool_id, app_id)
);

CREATE INDEX app_pool_app_index
  ON cf_apps.app_pool_mapping
  USING btree
  (app_id);
CREATE INDEX app_pool_pool_index
  ON cf_apps.app_pool_mapping
  USING btree
  (pool_id);


CREATE TABLE cf_apps.fund_end_use
(
end_use_id bigserial not null,
usage_type int not null,
loan_amount_required numeric(16,2) not null,
estimated_cost numeric(16,2),
service_attributes_jsonb jsonb,
app_id UUID not null,
CONSTRAINT end_use_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE cf_apps.tags
(
tag_id bigserial not null,
tag_name text not null,
tag_type int not null default 100,
CONSTRAINT tag_pk PRIMARY KEY(tag_id),
CONSTRAINT tag_name_usnique UNIQUE (tag_name)
);

CREATE TABLE cf_apps.tag_context
(
  tag_context_id bigserial NOT NULL PRIMARY KEY,
  context uuid NOT NULL DEFAULT '868bfd65-d519-4f03-b961-1f89aad5c34c'::uuid,
  tag_id bigint NOT NULL,
  CONSTRAINT tag_context_fk FOREIGN KEY (tag_id)
      REFERENCES cf_apps.tags (tag_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE cf_apps.app_source_details
(
app_source_id bigserial not null PRIMARY KEY,
app_source_name character varying (24) not null,
app_source_description text not null,
CONSTRAINT app_source_unique UNIQUE (app_source_name)
);



CREATE TABLE cf_apps.users
(
  user_id bigserial NOT NULL,
  username text,
  CONSTRAINT user_pk PRIMARY KEY (user_id)
);

CREATE TABLE cf_apps.resource_pool
(
  pool_id bigserial NOT NULL,
  pool_description text,
  CONSTRAINT pool_pk PRIMARY KEY (pool_id)
);

CREATE TABLE cf_apps.pool_paths
(
  ancestor bigint NOT NULL,
  descendant bigint NOT NULL,
  CONSTRAINT pool_path_pk PRIMARY KEY (ancestor, descendant),
  CONSTRAINT pool_ancestor_fk FOREIGN KEY (ancestor)
      REFERENCES cf_apps.resource_pool (pool_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pool_descendant_fk FOREIGN KEY (descendant)
      REFERENCES cf_apps.resource_pool (pool_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE cf_apps.user_pool_mapping
(
  user_pool_id bigserial NOT NULL,
  user_id bigint NOT NULL,
  pool_id bigint NOT NULL,
  pool_context integer NOT NULL,
  CONSTRAINT user_pool_mapping_pkey PRIMARY KEY (user_pool_id),
  CONSTRAINT user_pool_pool_fk FOREIGN KEY (pool_id)
      REFERENCES cf_apps.resource_pool (pool_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT user_pool_users_fk FOREIGN KEY (user_id)
      REFERENCES cf_apps.users (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pool_user_context_unique UNIQUE (user_id, pool_id, pool_context)
);

ALTER TABLE cf_apps.ecosystem ADD column branch_code text, ADD column wallet_number text;
ALTER TABLE cf_apps.contact_details ADD column address_type integer not null default 0;

CREATE TABLE cf_apps.list_industry_type
(
id serial NOT NULL PRIMARY KEY,
industry text NOT NULL
);

INSERT INTO cf_apps.list_industry_type (industry)
values
('NA'),
('Auto Service Centres'),
('Ayurvedic Clinics/Alternative Medicines'),
('Bars/Gambling Business/Massage Parlours/Beauty Parlours'),
('Building material Suppliers/Builder/ Building Contractors'),
('Cable Operators/Video Library Owners/Video Parlours'),
('Cold Storage'),
('Cyber Cafes'),
('DSA, Verification Agencies/Collection Agencies/Repossession Agencies'),
('Non IATA Approved Travel Agents'),
('Finance Companies/Pvt Money Lenders'),
('Firms/Companies dealing in Chit funds/Nidhi/ Money lending'),
('Labour Contractors'),
('Manpower Consultants/Placement Agencies'),
('Motor Training Schools'),
('Mining/Oil Drilling and Refining Business'),
('Real Estate Agents/Brokers'),
('Security Agencies'),
('Stock Brokers'),
('Transport Operators with less than 5 Trucks'),
('Vendors that Provide Service to Capital Float'),
('Waste Merchants'),
('Commodity traders (agriculture, metal etc...)'),
('Real Estate developers'),
('Jewellers'),
('Steel traders & manufacturing (including forging and rolling mills)'),
('Solar panel traders and manufacturing'),
('Educational Institute'),
('Others');



CREATE TABLE  cf_apps.list_product_category
(
id serial not null primary key,
product_category text not null
);

insert into cf_apps.list_product_category (product_category)
values
('NA'),
('Apparels'),
       ('Appliances'),
       ('Automotive'),
       ('Baby Care'),
       ('Bags and Luggage'),
       ('Beauty and Personal Care'),
       ('Books'),
       ('Cameras and Accessories'),
       ('Eyewear'),
       ('Fashion Accessories'),
       ('Footwear'),
       ('Fragrances'),
       ('Furniture'),
       ('Gaming'),
       ('Gifting Events'),
       ('Hardware & Sanitary Fittings'),
       ('Health, Wellness & Medicine'),
       ('Hobbies'),
       ('Home Decor'),
       ('Home Furnishing'),
       ('Home Improvement'),
       ('Jewellery'),
       ('Kids Wear'),
       ('Kitchenware'),
       ('Mobiles and Tablets'),
       ('Movies and Music'),
       ('Musical Instruments'),
       ('Mens Ethnic Wear'),
       ('Nutrition & Supplements'),
       ('Office Equipment'),
       ('Online Education'),
       ('Sports & Fitness'),
       ('Stationery'),
       ('Toys & Games'),
       ('TVs, Audio and Video'),
       ('Watches'),
       ('Women Ethnic Wear'),
       ('Other');

ALTER TABLE cf_apps.individual_entity ADD column employment_type integer default 0, ADD column employer_name text;
ALTER TABLE cf_apps.individual_entity ADD column kyc_status integer NOT NULL default 0;
ALTER TABLE cf_apps.individual_entity ADD column individual_relationship_type integer default 0;

CREATE TABLE cf_apps.bank_accounts
(
acc_id bigserial not null primary key,
acc_type text,
acc_context integer not null default 0,
acc_no text not null,
bank_name text,
acc_holder_name text,
ifsc_code text,
branch text,
entry_code int not null default 0,
app_id uuid not null,
CONSTRAINT acc_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE cf_apps.business_financials
(
id bigserial not null primary key,
app_id uuid not null,
base_year integer not null,
turnover_this_year numeric(16,2),
turnover_prev_year numeric(16,2),
profit_this_year numeric(16,2),
profit_prev_year numeric(16,2),
monthly_emi_obligations numeric(16,2),
odcc_limit numeric(16,2),
outstanding_loan_amount numeric(16,2),
home_loan numeric(16,2),
unsecured_loan numeric(16,2),
auto_loan numeric(16,2),
loan_against_property numeric(16,2),
personal_loan numeric(16,2),
CONSTRAINT business_financials_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE UNIQUE INDEX business_financials_app_id_unique on cf_apps.business_financials(app_id);

ALTER TABLE cf_apps.metadata
ADD column is_archived integer default 0,
ADD column hub_or_spoke integer default 0;

ALTER TABLE cf_apps.individual_entity
ADD column father_name text,
ADD column mother_name text;

ALTER TABLE cf_apps.ecosystem
ADD column is_verified integer default 0,
ADD column partner_name text;


CREATE TABLE cf_apps.renewal_tree_path
(
  ancestor bigint NOT NULL,
  descendant bigint NOT NULL,
  CONSTRAINT renewal_pk PRIMARY KEY (ancestor, descendant),
  CONSTRAINT renewal_ancestor_fk FOREIGN KEY (ancestor)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT renewal_descendant_fk FOREIGN KEY (descendant)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

ALTER TABLE cf_apps.metadata
ADD column is_perfios integer default 0;


ALTER TABLE cf_apps.business_entity
add column ca_number text;


CREATE UNIQUE INDEX primary_contact_unique
on cf_apps.contact_details(app_id, contact_context)
where address_id=0 and contact_context=100;

CREATE UNIQUE INDEX main_applicant_individual_unique
on cf_apps.individual_entity(app_id, application_context) where application_context=10;

CREATE UNIQUE INDEX main_applicant_business_unique
on cf_apps.business_entity(app_id, application_context) where application_context=10;

CREATE UNIQUE INDEX ecosystem_xn_type_unique
on cf_apps.ecosystem_xns(ecosystem_id, xn_type);


CREATE UNIQUE INDEX fund_end_use_unique
on cf_apps.fund_end_use(app_id);

ALTER TABLE cf_apps.metadata
 ADD COLUMN pd_type integer,
 ADD COLUMN pd_context integer,
 ADD COLUMN is_fs integer,
 ADD COLUMN fin_calc_year date;

ALTER TABLE cf_apps.address
ADD COLUMN address_owner text;

CREATE TABLE cf_apps.dsa_sm_map
(
id bigserial not null primary key,
dsa_user bigint not null,
sm_user bigint not null,
CONSTRAINT dsa_user_fk FOREIGN KEY (dsa_user)
     REFERENCES cf_apps.users (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT sm_user_fk FOREIGN KEY (sm_user)
      REFERENCES cf_apps.users (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT dsa_sm_map_dsa_user_sm_user_key UNIQUE (dsa_user, sm_user)

);

CREATE TABLE cf_apps.dsa_decision
(
  id bigserial NOT NULL,
  app_id uuid NOT NULL,
  decision_jsonb jsonb,
  CONSTRAINT dsa_decision_pk PRIMARY KEY (id),
  CONSTRAINT dsa_app_fk FOREIGN KEY (app_id)
      REFERENCES cf_apps.metadata (app_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE TABLE cf_apps.bureau_report(
reference_id varchar(36) not null,
request_jsonb jsonb,
response_jsonb jsonb,
updated_time bigint
);

CREATE TABLE cf_apps.app_bureau_mapping(
id bigserial not null primary key,
reference_id varchar(36) not null,
app_id uuid not null,
entity_id bigint not null,
entity_type integer not null,
bureau_name varchar(20) not null
status varchar(30),
message text,
async boolean DEFAULT false,
created_time bigint NOT NULL DEFAULT ((date_part('epoch'::text, timezone('utc'::text, now())))::bigint * 1000),
last_modified_time bigint NOT NULL DEFAULT ((date_part('epoch'::text, timezone('utc'::text, now())))::bigint * 1000)
);

ALTER TABLE cf_apps.migration_status_apps
ADD COLUMN old_id text;

CREATE TABLE cf_apps.migration_renewal_tree(
id bigserial not null,
email text not null primary key,
renewal_array_jsonb jsonb not null default '[]'::jsonb,
is_migrated int default 0
);

--CREATE TABLE cf_apps.migration_id_map(
--id bigserial not null primary key,
--app_id UUID not null,
--table_name text not null,
--old_id bigint not null,
--new_id bigint not null
--);


ALTER TABLE cf_apps.individual_entity
ADD COLUMN old_id bigint;

ALTER TABLE cf_apps.ecosystem
ADD COLUMN old_id bigint;


CREATE TABLE cf_apps.migration_uber_business_identifier
(
id bigserial not null,
app_id text not null primary key
);

ALTER TABLE cf_apps.migration_status_apps
ADD column migration_object_jsonb jsonb default '{}'::jsonb;

ALTER TABLE cf_apps.migration_status_apps
ADD column is_posted_to_sns integer default 0;


ALTER TABLE cf_apps.migration_status_apps
ADD column id bigserial not null;

alter table cf_apps.metadata add column is_ucic smallint default 0;

alter table cf_apps.app_bureau_mapping add column mode varchar(20) default 'hard';

ALTER TABLE user_pool_mapping ADD UNIQUE(user_id,pool_context);

INSERT into cf_apps.app_source_details (app_source_name, app_source_description)
values ("amz_chkfin_v1", "checkout finance apps with ekyc flow"),
("mmt_chkfin_v1", "checkout finance apps with ekyc flow"),
("amz_chkfin_v2", "checkout finance apps with physical kyc flow"),
("mmt_chkfin_v2", "checkout finance apps with physical kyc flow"),
("cf_chkfin_v1", "checkout finance apps with ekyc kyc flow"),
("cf_chkfin_v2", "checkout finance apps with physical kyc flow");

INSERT into cf_apps.app_source_details (app_source_name, app_source_description)
values("amz_b2b_v1", "amazon b2b apps mapped to fs workflow");

create table cf_apps.external_sourced_data (
   id bigserial primary key not null,
   app_id uuid not null,
   entity_id int8 not null,
   entity_type int4 not null,
   data_type int4 not null,
   data_information text not null,
   source_type int4 not null,
   source_reference text not null,
   source_fetched_time bigint,
   created_time bigint
);

create index ext_src_data_app_id on cf_apps.external_sourced_data(app_id);
create index ext_src_data_entity_id on cf_apps.external_sourced_data(entity_id);

alter table cf_apps.metadata add column bureau_migration_status int;

ALTER TABLE cf_apps.loan_offers
ADD COLUMN offer_source int4,
ADD COLUMN source_id text;

ALTER TABLE cf_apps.metadata DROP CONSTRAINT app_source_fk;

ALTER TABLE cf_apps.list_industry_type ADD app_sources varchar NOT NULL DEFAULT 'web_app_form,dsa_loan_app_form';
INSERT INTO cf_apps.list_industry_type (id,industry,app_sources) VALUES
(115,'Manufacturing Unit','fast_app_v1')
,(116,'Textiles and Wearing Apparels','fast_app_v1')
,(117,'Iron & Steel','fast_app_v1')
,(118,'Kirana Store','fast_app_v1')
,(120,'Wholesale Trading','fast_app_v1')
,(121,'Services','fast_app_v1')
,(122,'Restaurants','fast_app_v1')
,(123,'Automobile','fast_app_v1')
,(124,'Bars, Liquor Outlet','fast_app_v1')
,(125,'Agriculture','fast_app_v1')
;
INSERT INTO cf_apps.list_industry_type (id,industry,app_sources) VALUES
(127,'Distributor','fast_app_v1')
,(128,'FMCG','fast_app_v1')
,(119,'Retail Outlet/Showroom','fast_app_v1')
,(126,'Petroleum Products','fast_app_v1')
,(129,'Mobile Phones','fast_app_v1')
,(130,'Healthcare','fast_app_v1')
,(131,'Contractor','fast_app_v1')
,(132,'Pharmacy','fast_app_v1')
;

ALTER TABLE cf_apps.individual_entity ADD kyc_source int4 NULL;
ALTER TABLE cf_apps.business_entity ADD kyc_source int4 NULL;

ALTER TABLE cf_apps.individual_entity ADD religion int4 NULL;


INSERT INTO cf_apps.list_industry_type (id,industry) VALUES
(133,'Advertising and Media'),
(134,'Bars and Restaurant (Restobars)'),
(135,'Departmental Stores, Hypermarket, Superstores, Organised Retail, Grocery and Kirana store'),
(136,'Domestic Electrical products'),
(137,'Domestic/Consumer Appliances (White Goods)'),
(138,'Education-Coaching and Training classes'),
(139,'Financial Activities like Insurance and Pension,Money Exchanges and Lending'),
(140,'FMCG Distributor'),
(141,'Food grains & edible oil - mills and traders'),
(142,'Gift Articles, Stationery, Games And Toys'),
(143,'Information and Communication'),
(144,'Jewellery Outlets'),
(145,'Leather Goods - Footwear, Luggage, Handbags, etc'),
(146,'Manpower, HR Consultancy, Labour Recruitment And Provision Of Personnel'),
(147,'Metals - iron & steel'),
(148,'Metals other than iron & steel'),
(149,'Mobile Phones & Accessories, Mobile & DTH Recharges-Wholesale and Retail'),
(150,'Motor Vehicles, Motorcycles & other Transport Vehicles, Auto Spare parts & Accessories'),
(151,'Petroleum Products'),
(152,'Poultry'),
(153,'Professional Services: Accounting, Book-Keeping And Auditing Activities'),
(154,'Renting Of Machinery And Equipment'),
(155,'Repair And Maintenance and AMC Services'),
(156,'Restaurants (Food only, No Liquor)'),
(157,'Timber, Veneer Sheets, Plywood, Boards'),
(158,'Furniture and Home furnishing'),
(159,'Pharmaceutical And Medical Goods');


UPDATE cf_apps.list_industry_type
set app_sources=''
where id in (30,31,38,45,48,49,112,53,54,55,57,58,60,61,108,64,66,
67,72,73,74,75,111,77,79,83,84,90,93,94,95,122,96,106,98,99,107,104);

ALTER TABLE cf_apps.individual_entity ADD category int4 NULL;

CREATE TABLE cf_apps.comm_cibil_city_state
(
  id serial PRIMARY KEY NOT NULL,
city character varying NOT NULL,
state character varying NOT NULL
);

CREATE INDEX comm_cibil_city_state_index
  ON cf_apps.comm_cibil_city_state
USING btree (city);

CREATE TABLE cf_apps.gstin_state_code
(
  id serial PRIMARY KEY NOT NULL,
  state character varying NOT NULL,
  state_code character varying(10) NOT NULL,
  state_abbreviation character varying NOT NULL
);

INSERT INTO cf_apps.gstin_state_code(state,state_code,state_abbreviation) values
('ANDAMAN & NICOBAR ISLANDS','35','AN'),
('ANDHRA PRADESH','28','AP'),
('ARUNACHAL PRADESH','12','AR'),
('ASSAM','18','AS'),
('BIHAR','10','BH'),
('CHANDIGARH','04','CH'),
('CHATTISGARH','22','CT'),
('DADRA & NAGAR HAVELI','26','DN'),
('DAMAN & DIU','25','DD'),
('DELHI','07','DL'),
('GOA','30','GA'),
('GUJARAT','24','GJ'),
('HARYANA','06','HR'),
('HIMACHAL PRADESH','02','HP'),
('JAMMU & KASHMIR','01','JK'),
('JHARKHAND','20','JH'),
('KARNATAKA','29','KA'),
('KERALA','32','KL'),
('LAKSHADWEEP','31','LD'),
('MADHYA PRADESH','23','MP'),
('MAHARASHTRA','27','MH'),
('MANIPUR','14','MN'),
('MEGHALAYA','17','ME'),
('MIZORAM','15','MI'),
('NAGALAND','13','NL'),
('ODISHA','21','OR'),
('PONDICHERRY','34','PY'),
('PUNJAB','03','PB'),
('RAJASTHAN','08','RJ'),
('SIKKIM','11','SK'),
('TAMIL NADU','33','TN'),
('TELANGANA','36','TS'),
('TRIPURA','16','TR'),
('UTTAR PRADESH','09','UP'),
('UTTARAKHAND','05','UT'),
('WEST BENGAL','19','WB');


ALTER TABLE cf_apps.individual_entity ADD guardian_name text  NULL,
ADD guardian_relation integer  NULL;

update cf_apps.list_industry_type set app_sources='' where industry in
('DSA or commission agents to financial institution','Furniture','Legal Activities','Recharge Shop','Cyber Café');



insert into cf_apps.list_industry_type (id,industry,app_sources) values
(160,'Broadband/ currency/ DTH service','fast_app_v1');
update cf_apps.list_industry_type set app_sources = concat(app_sources,',fast_app_v1') where id in (33,39,40,41,86,103);
update cf_apps.list_industry_type set app_sources = concat(app_sources,'fast_app_v1') where id in (56,38,45,60,67,106,112,122);

ALTER TABLE cf_apps.business_entity ADD column alias text NULL, ADD column cost_per_case numeric(10,2) NULL;

ALTER TABLE cf_apps.metadata ALTER COLUMN app_source_name TYPE varchar(35) USING app_source_name::varchar;

ALTER TABLE cf_apps.address ALTER COLUMN pincode DROP NOT NULL;

CREATE TABLE cf_apps.pincode_details (
  id bigserial NOT NULL,
  pincode int4 NOT NULL,
  city varchar(200),
  division text,
  region text,
  taluk text,
  district text,
  state text,
  state_code varchar(10),
  hub_city varchar(512),
  hub_spoke varchar(512),
  hub_spoke_id int4,
  state_abbr varchar(10),
  CONSTRAINT pincode_details_pk PRIMARY KEY (id)
);

CREATE INDEX pincode_details_pincode_idx ON cf_apps.pincode_details (pincode);
ALTER TABLE cf_apps.individual_entity ADD ckyc_id varchar NULL;

ALTER TABLE cf_apps.address ADD "source" int NULL;

ALTER TABLE cf_apps.individual_entity ADD ckyc_id varchar NULL;
ALTER TABLE cf_apps.address ADD "source" int NULL;
ALTER TABLE cf_apps.contact_details ADD "source" int NULL;

create table cf_apps.address_priority(
  priority_id bigserial PRIMARY KEY NOT NULL,
  app_id uuid NOT NULL,
  priority integer NULL,
  priority_reason integer NULL,
  address_id int8 NOT NULL UNIQUE,
  initiator_id int8 NOT NULL,
CONSTRAINT address_priority_address_fk FOREIGN KEY (address_id) REFERENCES cf_apps.address(address_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE cascade,
CONSTRAINT address_priority_app_fk FOREIGN KEY (app_id) REFERENCES cf_apps.metadata (app_id)
)

create table cf_apps.contact_priority(
  priority_id bigserial PRIMARY KEY NOT NULL,
  app_id uuid NOT NULL,
  priority integer NULL,
  priority_reason integer NULL,
  contact_id int8 NOT NULL UNIQUE,
  initiator_id int8 NOT NULL,
CONSTRAINT contacts_priority_contact_fk FOREIGN KEY (contact_id) REFERENCES cf_apps.contact_details(contact_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE cascade,
CONSTRAINT contact_priority_app_fk FOREIGN KEY (app_id) REFERENCES cf_apps.metadata (app_id)
)

alter table cf_apps.metadata add lan varchar null;

CREATE INDEX metadata_lan_index
  ON cf_apps.metadata
  USING btree
  (lan);

UPDATE cf_apps.list_industry_type SET app_sources='';

INSERT INTO cf_apps.list_industry_type (id, industry, app_sources) VALUES
( 161, 'Agro chemical products (fertilizer, seeds, etc.)/ agri inputs (equipment, implement)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 162, 'Apparels/ accessories/ footwear/ bags/ cosmetics', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 163, 'Automobiles/ car accessories/ tyres/ OEM/ spares/ servicing/ repairs/ commercial vehicles', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 164, 'Capital goods manufacturer (heavy machinery, equipments, components)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 165, 'Chemicals', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 166, 'Computer software/ hardware/ servicing/ AMC/ rentals', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 167, 'Contractor (construction/ industrial/ builder/ govt/ non-govt)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 168, 'Educational, coaching, arts, sports institution', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 169, 'Fleet service/ transport facilities/ logistics/ C&F/ Shipping/ cargo/ courier', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 170, 'FMCG products', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 171, 'Food/ meat/ poultry/ grains/ dairy/ veg/ fruits/ spices/ pulses/ sugar/ flour mills/ sea food/ oil & ghee', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 172, 'Furniture/ timber/ plywood/ carpentry', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 173, 'Hospitals/ clinics/ diagnostic center/ veterinary hospital/ optician/ ayurveda clinics/ homeopathy clinic', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 174, 'Industrial parts, consumables & spares (machinery parts/ forging)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 175, 'Iron & steel manufacturing & trader', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 176, 'Jewelry (includes precious metal & stones) including imitation jewelry', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 178, 'Mobile phones & accessories & related services', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 179, 'Other metals manufacturing & trader (lead/ zinc/ copper/ aluminum/ bronze/ etc.)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 180, 'Paints/ construction materials/ hardware/ marbles & stones/ ceramics/ interior decoration/ fire safety equipment', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 181, 'Paper/ paper products/ printing/ forest products/ cardboard/ publishing/ rubber products', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 182, 'Petrol pump, CNG Pump, LPG Distributors, Lubricants', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 183, 'Pets (animals) shop and pet food', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 184, 'Pharmaceuticals/ medical supplies/ ayurveda/ surgical equipments/ healthcare services/ chemist & druggist', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 185, 'Plastic & plastic products (including household plastic, packaging materials)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 186, 'Professional services (engineers/ accountant/ architect)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 187, 'Rentals of industrial & construction machinery (includes scaffolding)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 188, 'Restaurants/ restaurant-bars/ eateries/ clubs/ hotels/ resorts', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 189, 'Salons/ spas/ gyms/ yoga/ wellness centers', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 190, 'Scrap of any type', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 191, 'Services - Security services/ facility management/ manpower/ recruitment', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 192, 'Services - business services/ IT services/ retail services/ trade services/ catering', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 193, 'Services - Power/ Energy/ Telecom/ Aviation/ Media/ Media/ Aviation/ Industrial services', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 194, 'Sports & music equipment manufacturing and trading', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 195, 'Supermarket/ Hypermarket/ Kirana store/ organized retail (online & offline)', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 196, 'Textiles manufacturer & wholesaler', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1'),
( 197, 'White goods (electronics)/ electrical fittings/ fixtures/ wires & cables', 'web_app_form,dsa_loan_app_form,fast_app_v1,dsa_fast_app_v1');

ALTER TABLE cf_apps.contact_details ADD column verified boolean;

CREATE TABLE cf_apps.address_deduplication (
    id bigserial PRIMARY KEY,
	address_id bigserial NOT NULL,
	duplicate_flag int NULL
);
CREATE TABLE cf_apps.apps_updation_log
(
    id bigserial NOT NULL,
    app_id uuid,
    created timestamp with time zone,
    source text,
    data character varying,
    CONSTRAINT apps_updation_log_pkey PRIMARY KEY (id)
)


alter table cf_apps.app_bureau_mapping add column copied_app_id uuid default null;

CREATE TABLE cf_apps.user_personal_details_mapping(
id bigserial not null primary key,
reference_id varchar(36) not null,
search_key varchar(40) not null,
search_type varchar(40) not null,
vendor_name varchar(40) not null,
status varchar(40),
created_time bigint NOT NULL DEFAULT ((date_part('epoch'::text, timezone('utc'::text, now())))::bigint * 1000),
last_modified_time bigint NOT NULL DEFAULT ((date_part('epoch'::text, timezone('utc'::text, now())))::bigint * 1000)
);

CREATE TABLE cf_apps.user_personal_details_response(
id bigserial not null primary key,
reference_id varchar(36) not null,
pan varchar(20),
dob DATE,
phone varchar(20),
response_s3_url text,
updated_time bigint NOT NULL DEFAULT ((date_part('epoch'::text, timezone('utc'::text, now())))::bigint * 1000)
);

CREATE INDEX user_personal_details_index
ON cf_apps.user_personal_details_mapping
USING btree
(search_key,search_type,vendor_name);

CREATE INDEX user_personal_details_response_index
ON cf_apps.user_personal_details_response
USING btree
(reference_id);

ALTER TABLE cf_apps.user_personal_details_response
DROP COLUMN pan,
DROP COLUMN dob,
DROP COLUMN phone;