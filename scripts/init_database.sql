/*
====================================================================================================
CREATE DATABASE & SCHEMAS
====================================================================================================
This scrips creates the Data warehouse DB, and since we decided to employ the medallion architecture for this, we will crated three schemas
for the bronze, silver and gold layers

NOTE;
Running this script will drop the entire datawarehouse database if it exists.
All data in the db will be permanently deleted. 
backup before running this script
*/


-- Connect to the "postgres" database before running this script, not "datawarehouse"

-- 1. Disconnect users and drop the database if it exists
DO $$
BEGIN
   IF EXISTS (
      SELECT 1
      FROM pg_database
      WHERE datname = 'datawarehouse'
   ) THEN
      -- Terminate active sessions except this one
      PERFORM pg_terminate_backend(pid)
      FROM pg_stat_activity
      WHERE datname = 'datawarehouse'
        AND pid <> pg_backend_pid();

      -- Drop the database
      EXECUTE 'DROP DATABASE datawarehouse';
   END IF;
END;
$$;

-- 2. Create the new database
CREATE DATABASE datawarehouse;

-- ⚠️ Connect to the newly created `datawarehouse` database before running the schema creation below

-- 3. Create schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

