CREATE OR REPLACE MACRO ls_tables() AS TABLE
SELECT table_name FROM information_schema.tables WHERE table_schema = 'main';
