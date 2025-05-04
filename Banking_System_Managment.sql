CREATE DATABASE banking_system;
USE banking_system;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hashed_password VARCHAR(256) NOT NULL,
    role ENUM('customer', 'teller', 'manager', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    account_type ENUM('savings', 'current', 'business') NOT NULL,
    balance DECIMAL(12,2) DEFAULT 0.00,
    interest_rate DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer_in', 'transfer_out', 'interest', 'charge'),
    amount DECIMAL(12,2) NOT NULL,
    description VARCHAR(255),
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    loan_amount DECIMAL(12,2) NOT NULL,
    interest_rate DECIMAL(5,2),
    status ENUM('pending', 'approved', 'repaid', 'defaulted') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE sensitive_info (
    user_id INT PRIMARY KEY,
    encrypted_national_id VARBINARY(255),
    encrypted_phone VARBINARY(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

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







