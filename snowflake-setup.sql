
-- Initial Snowflake setup for Glue --

USE ROLE sysadmin;

-- Create Virtual Warehouse for Glue
CREATE OR REPLACE WAREHOUSE glue_de_wh
    WAREHOUSE_SIZE = 'small'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'Virtual Warehouse for AWS Glue workloads';

-- Create a schema
CREATE OR REPLACE SCHEMA tb_101.glue_workshop;

-- Create a role for Glue
CREATE ROLE IF NOT EXISTS glue_de_role
  COMMENT = 'Role for AWS Glue workloads';

-- Grant minimum required permissions to the role
GRANT USAGE ON WAREHOUSE glue_de_wh TO ROLE glue_de_role;
GRANT USAGE ON DATABASE tb_101 TO ROLE glue_de_role;
GRANT USAGE ON SCHEMA tb_101.glue_workshop TO ROLE glue_de_role;
GRANT CREATE TABLE ON SCHEMA tb_101.glue_workshop TO ROLE glue_de_role;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA tb_101.glue_workshop TO ROLE glue_de_role;

-- Create User and assign default role and default warehouse
CREATE USER glue_de_user
  PASSWORD = 'GlueSFDemo123'
  DEFAULT_ROLE = glue_de_role
  DEFAULT_WAREHOUSE = glue_de_wh
  COMMENT = 'User for AWS Glue workloads';
GRANT ROLE glue_de_role TO USER glue_de_user;

-- Create a View
CREATE VIEW orders_view COMMENT='Limited orders view' AS SELECT UUID, COUNTRY, "item type", "sales channel", "order priority", "order date", region, "ship date", "units sold" FROM glue_workshop.orders;
GRANT SELECT ON ALL VIEWS IN SCHEMA tb_101.glue_workshop TO ROLE glue_de_role;
SHOW VIEWS;
  
-- Commands to validate and read from new table
GRANT ROLE glue_de_role TO ROLE sysadmin;
SELECT * from glue_workshop.orders LIMIT 50;
SELECT COUNT(*) from glue_workshop.orders;


-- Other useful commands
SELECT CURRENT_ACCOUNT_NAME(); -- retrieve the name of the current account
SELECT CURRENT_ORGANIZATION_NAME(); -- retrieve the organization of the current account

SHOW ROLES LIKE 'GLUE_DE_ROLE';
SHOW GRANTS TO ROLE GLUE_DE_ROLE;
SHOW GRANTS OF ROLE GLUE_DE_ROLE;

-- REVOKE ALL PRIVILEGES ON DATABASE tb_101 FROM ROLE GLUE_DE_ROLE;
-- REVOKE ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE tb_101 FROM ROLE GLUE_DE_ROLE;
-- REVOKE ALL PRIVILEGES ON ALL TABLES IN DATABASE tb_101 FROM ROLE GLUE_DE_ROLE;
-- DROP TABLE glue_workshop.orders;