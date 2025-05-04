SELECT * FROM banking_system.loans;



CREATE PROCEDURE insert_dummy_loans()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO loans (user_id, loan_amount, interest_rate, status)
    VALUES (
      FLOOR(1 + (RAND() * 100)),
      ROUND(5000 + (RAND() * 95000), 2),
      ROUND(2 + (RAND() * 10), 2),
      ELT(FLOOR(1 + (RAND() * 4)), 'pending', 'approved', 'repaid', 'defaulted')
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

CALL insert_dummy_loans();



