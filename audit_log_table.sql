SELECT * FROM banking_system.audit_log;

DELIMITER $$

CREATE PROCEDURE insert_dummy_logs()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO audit_log (user_id, action)
    VALUES (
      FLOOR(1 + (RAND() * 100)),
      CONCAT('User Action ', i)
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

CALL insert_dummy_logs();
