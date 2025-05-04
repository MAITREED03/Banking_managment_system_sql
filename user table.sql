SELECT * FROM banking_system.users;
DELIMITER $$
## Insert data to user table

DELIMITER $$

CREATE PROCEDURE insert_dummy_users()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO users (name, email, hashed_password, role)
    VALUES (
      CONCAT('User', i),
      CONCAT('user', i, '@example.com'),
      SHA2(CONCAT('pass', i), 256),
      ELT(FLOOR(1 + (RAND() * 4)), 'customer', 'teller', 'manager', 'admin')
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

