SELECT * FROM banking_system.accounts;
DELIMITER $$

CREATE PROCEDURE insert_dummy_accounts()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO accounts (user_id, account_type, balance, interest_rate)
    VALUES (
      FLOOR(1 + (RAND() * 100)),
      ELT(FLOOR(1 + (RAND() * 3)), 'savings', 'current', 'business'),
      ROUND(RAND() * 100000, 2),
      ROUND(RAND() * 5, 2)
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

CALL insert_dummy_accounts();
