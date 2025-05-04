# Banking System Management 🏦

A secure and user-friendly banking system built with Python, MySQL, and Streamlit. This application allows users to manage accounts, perform transactions, and view transaction history.

## Features 💡

- **Secure Login System**: Password hashing and authentication
- **Account Management**: View multiple account types and balances
- **Transaction Operations**: 
  - Deposit funds
  - Withdraw funds (with overdraft protection)
- **Transaction History**: View recent transactions with timestamps

## Technologies Used 🛠️

- **Frontend**: Streamlit
- **Backend**: Python
- **Database**: MySQL
- **Security**: SHA-256 password hashing

## Setup Instructions 🚀

1. **Install Dependencies**:
   ```bash
   pip install streamlit mysql-connector-python
   ```

2. **Database Setup**:
   - Create a MySQL database named `banking_system`
   - Run the SQL scripts in this order:
     - `user table.sql`
     - `accounts table.sql`
     - `transactions table.sql`

3. **Configuration**:
   - Update database credentials in `db.py`
   - Ensure MySQL server is running

4. **Run the Application**:
   ```bash
   streamlit run app.py
   ```

## Usage Guide 📝

1. **Login**:
   - Use your username and password
   - Default test account: Username: `User1`, Password: `pass1`

2. **View Accounts**:
   - See all your accounts and balances
   - Different account types supported (Savings, Checking, etc.)

3. **Perform Transactions**:
   - Select account
   - Choose transaction type (Deposit/Withdraw)
   - Enter amount
   - Confirm transaction

4. **View History**:
   - Transaction history shows last 10 transactions
   - Color-coded: 🟢 for deposits, 🔴 for withdrawals

## Security Features 🔒

- Passwords are hashed using SHA-256
- Session management for logged-in users
- Overdraft protection
- Secure database connections

## Database Schema 📊

### Users Table
- user_id (Primary Key)
- name
- email
- hashed_password
- role

### Accounts Table
- account_id (Primary Key)
- user_id (Foreign Key)
- account_type
- balance

### Transactions Table
- transaction_id (Primary Key)
- account_id (Foreign Key)
- transaction_type
- amount
- description
- transaction_time

## Contributing 🤝

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to branch
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.