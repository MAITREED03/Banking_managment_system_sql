SELECT * FROM banking_system.transactions;

DELIMITER $$

CREATE PROCEDURE insert_dummy_transactions()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO transactions (account_id, transaction_type, amount, description)
    VALUES (
      FLOOR(1 + (RAND() * 100)),
      ELT(FLOOR(1 + (RAND() * 6)), 'deposit', 'withdrawal', 'transfer_in', 'transfer_out', 'interest', 'charge'),
      ROUND(RAND() * 50000, 2),
      CONCAT('Transaction ', i)
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

CALL insert_dummy_transactions();
