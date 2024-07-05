
-- Initial Snowflake setup for Glue --
USE ROLE accountadmin;

-- Create Virtual Warehouse for Glue
CREATE OR REPLACE WAREHOUSE glue_de_wh
    WAREHOUSE_SIZE = 'small'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'Virtual Warehouse for AWS Glue workloads';

-- Create a database
CREATE OR REPLACE DATABASE glue_db;

-- Create a schema
CREATE OR REPLACE SCHEMA glue_db.glue_workshop;

-- Create a role for Glue
CREATE ROLE IF NOT EXISTS glue_de_role
  COMMENT = 'Role for AWS Glue workloads';

-- Grant minimum required permissions to the role
GRANT USAGE ON WAREHOUSE glue_de_wh TO ROLE glue_de_role;
GRANT USAGE ON DATABASE glue_db TO ROLE glue_de_role;
GRANT USAGE ON SCHEMA glue_db.glue_workshop TO ROLE glue_de_role;
GRANT CREATE TABLE ON SCHEMA glue_db.glue_workshop TO ROLE glue_de_role;

-- Create User and assign default role and default warehouse
CREATE USER glue_de_user
  PASSWORD = 'GlueSFDemo123'
  DEFAULT_ROLE = glue_de_role
  DEFAULT_WAREHOUSE = glue_de_wh
  COMMENT = 'User for AWS Glue workloads';
GRANT ROLE glue_de_role TO USER glue_de_user;