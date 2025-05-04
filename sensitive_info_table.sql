SELECT * FROM banking_system.sensitive_info;

DELIMITER $$

CREATE PROCEDURE insert_dummy_sensitive()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO sensitive_info (user_id, encrypted_national_id, encrypted_phone)
    VALUES (
      i,
      AES_ENCRYPT(CONCAT('NID', LPAD(i, 5, '0')), 'my_secret_key'),
      AES_ENCRYPT(CONCAT('98765432', LPAD(i, 2, '0')), 'my_secret_key')
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

CALL insert_dummy_sensitive();
