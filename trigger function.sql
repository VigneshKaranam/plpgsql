CREATE OR REPLACE FUNCTION fn_insert_or_update(p_id int, p_name varchar, p_age int)
RETURNS void AS
$$
	BEGIN
		IF p_id in (SELECT id FROM dummy_table) THEN
-- 			UPDATE dummy_table SET name = p_name, age = p_age
-- 			WHERE id = p_id;
			DELETE FROM dummy_table
			WHERE id = p_id;
			INSERT INTO dummy_table (id, name, age)
			VALUES (p_id, p_name, p_age);
		END IF;
	END;
$$
LANGUAGE plpgsql

SELECT * FROM dummy_table;

SELECT fn_insert_or_update(5,'Hello',22);

CREATE OR REPLACE FUNCTION fn_check()
RETURNS TRIGGER AS
$$
BEGIN
	PERFORM fn_insert_or_update(NEW.id, NEW.name,NEW.age);
	RETURN NEW;
END;
$$
LANGUAGE plpgsql


CREATE OR REPLACE TRIGGER  trg_dummy_table
BEFORE INSERT OR UPDATE OF name
ON dummy_table
FOR EACH ROW
WHEN (pg_trigger_depth() = 0)
EXECUTE PROCEDURE fn_check()

INSERT INTO dummy_table (id,name,age) VALUES (4,'Raj',25);

-- Create the dummy_table
CREATE TABLE dummy_table (
    id int PRIMARY KEY,
    name VARCHAR(255),
    age INT
);

-- Inserting data into the dummy_table
INSERT INTO dummy_table (id, name, age)
VALUES 
  (1,'John', 25),
  (2,'Alice', 30),
  (3,'Bob', 22);
  
