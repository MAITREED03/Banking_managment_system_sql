SELECT * FROM banking_system.sensitive_info;


### Triggers for Overdraft or Suspicious Activity
### Example: Flag withdrawals that cause negative balance.

DELIMITER $$

CREATE TRIGGER check_overdraft
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
  DECLARE current_balance DECIMAL(12,2);

  IF NEW.transaction_type = 'withdrawal' OR NEW.transaction_type = 'transfer_out' THEN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = NEW.account_id;

    IF current_balance < NEW.amount THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Overdraft not allowed!';
    END IF;
  END IF;
END$$

DELIMITER ;
SELECT account_id, balance FROM accounts LIMIT 100;

### Encrypt/Decrypt Sensitive Info
### To view encrypted data (like phone/NID), use:

SELECT 
  user_id,
  CAST(AES_DECRYPT(encrypted_national_id, 'my_secret_key') AS CHAR) AS national_id,
  CAST(AES_DECRYPT(encrypted_phone, 'my_secret_key') AS CHAR) AS phone
FROM sensitive_info;


## Scheduled Jobs for Monthly Interest
## Use a MySQL Event Scheduler:

SET GLOBAL event_scheduler = ON;

CREATE EVENT apply_monthly_interest
ON SCHEDULE EVERY 1 MONTH
DO
  UPDATE accounts
  SET balance = balance + (balance * (interest_rate / 100))
  WHERE interest_rate > 0;


call apply_monthly_interest;


##Role-Based Access Control (RBAC)
##You can enforce access in application logic or simulate it using views:

-- For tellers: Read-only on user accounts
CREATE VIEW teller_view AS
SELECT name, email, account_type, balance
FROM users
JOIN accounts USING(user_id);


##Analytics Queries
##Examples:Total bank balance by account type:

SELECT account_type, SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type;

## Users with more than 3 accounts:
SELECT user_id, COUNT(*) as total_accounts
FROM accounts
GROUP BY user_id
HAVING COUNT(*) > 3;





