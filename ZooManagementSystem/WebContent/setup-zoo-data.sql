USE zoo_management;

-- The enclosures table already exists in this database; its records are kept.
-- This script adds staff and feeding tables without changing animal records.

CREATE TABLE IF NOT EXISTS staff (
    staff_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    shift VARCHAR(50) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    PRIMARY KEY (staff_id),
    UNIQUE KEY uq_staff_name (name)
);

CREATE TABLE IF NOT EXISTS feeding (
    feeding_id INT NOT NULL AUTO_INCREMENT,
    animal_id INT NOT NULL,
    food VARCHAR(100) NOT NULL,
    quantity VARCHAR(50) NOT NULL,
    feeding_time TIME NOT NULL,
    notes VARCHAR(255) NOT NULL,
    PRIMARY KEY (feeding_id),
    UNIQUE KEY uq_feeding_animal_time (animal_id, feeding_time),
    CONSTRAINT fk_feeding_animal
        FOREIGN KEY (animal_id) REFERENCES animals (animal_id)
        ON DELETE CASCADE
);

INSERT IGNORE INTO staff (name, role, shift, phone) VALUES
    ('Ava Patel', 'Veterinary Assistant', 'Morning', '555-0101'),
    ('Noah Kim', 'Animal Keeper', 'Morning', '555-0102'),
    ('Mia Chen', 'Animal Keeper', 'Evening', '555-0103'),
    ('Ethan Brooks', 'Feeding Coordinator', 'Afternoon', '555-0104');

INSERT IGNORE INTO feeding (animal_id, food, quantity, feeding_time, notes)
SELECT animal_id, 'Meat', '5 kg', '08:00:00', 'Morning meal'
FROM animals
WHERE animal_id = (SELECT MIN(animal_id) FROM animals WHERE name = 'Simba');

INSERT IGNORE INTO feeding (animal_id, food, quantity, feeding_time, notes)
SELECT animal_id, 'Meat', '4 kg', '09:00:00', 'Morning meal'
FROM animals
WHERE animal_id = (SELECT MIN(animal_id) FROM animals WHERE name = 'Luna');

INSERT IGNORE INTO feeding (animal_id, food, quantity, feeding_time, notes)
SELECT animal_id, 'Hay and vegetables', '20 kg', '10:00:00', 'Morning meal'
FROM animals
WHERE animal_id = (SELECT MIN(animal_id) FROM animals WHERE name = 'Raja');

INSERT IGNORE INTO feeding (animal_id, food, quantity, feeding_time, notes)
SELECT animal_id, 'Hay and fruit', '18 kg', '11:00:00', 'Late morning meal'
FROM animals
WHERE animal_id = (SELECT MIN(animal_id) FROM animals WHERE name = 'Maya');
