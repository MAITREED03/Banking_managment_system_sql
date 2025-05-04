import streamlit as st
from db import get_connection
from auth import check_password
import mysql.connector

st.set_page_config(page_title="Banking Dashboard", layout="centered")

st.title("🏦 Banking Management System")

# --- Login Section ---
username = st.text_input("username")
password = st.text_input("password", type="password")

if st.button("Login"):
    conn = get_connection()
    cursor = conn.cursor()

    # Add debug information
    st.write("Debug Info:")
    st.write(f"Attempting login for user: {username}")
    
    cursor.execute("SELECT user_id, hashed_password, name FROM users WHERE name = %s", (username,))
    result = cursor.fetchone()
    
    if result:
        user_id, stored_hash, name = result
        # Show hash comparison
        if check_password(username, stored_hash):
            st.session_state['logged_in'] = True
            st.session_state['user_id'] = user_id
            st.success(f"Welcome, {name}!")


            
            # --- Show Account Info ---
            cursor.execute("SELECT account_id, account_type, balance FROM accounts WHERE user_id = %s", (user_id,))
            accounts = cursor.fetchall()
            st.subheader("💼 Your Accounts")
            for acc_id, acc_type, balance in accounts:
                st.write(f"**{acc_type.title()} Account #{acc_id}:** ₹{balance:.2f}")

            # --- Deposit / Withdraw ---
            st.subheader("💸 Transaction")
            selected_account = st.selectbox("Choose Account", [acc[0] for acc in accounts])
            action = st.radio("Type", ["Deposit", "Withdraw"])
            amount = st.number_input("Amount", min_value=1.0)

            if st.button("Submit Transaction"):
                txn_type = "deposit" if action == "Deposit" else "withdrawal"
                if txn_type == "withdrawal":
                    cursor.execute("SELECT balance FROM accounts WHERE account_id = %s", (selected_account,))
                    bal = cursor.fetchone()[0]
                    if amount > bal:
                        st.error("Overdraft not allowed!")
                    else:
                        cursor.execute("INSERT INTO transactions (account_id, transaction_type, amount, description) VALUES (%s, %s, %s, %s)",
                                       (selected_account, txn_type, amount, f"{txn_type.title()} via app"))
                        cursor.execute("UPDATE accounts SET balance = balance - %s WHERE account_id = %s", (amount, selected_account))
                        conn.commit()
                        st.success("Transaction complete!")
                else:
                    cursor.execute("INSERT INTO transactions (account_id, transaction_type, amount, description) VALUES (%s, %s, %s, %s)",
                                   (selected_account, txn_type, amount, f"{txn_type.title()} via app"))
                    cursor.execute("UPDATE accounts SET balance = balance + %s WHERE account_id = %s", (amount, selected_account))
                    conn.commit()
                    st.success("Transaction complete!")
                
            # --- Show Transaction History ---
            st.subheader("📜 Transaction History")
            cursor.execute("""
                SELECT transaction_type, amount, description, transaction_time 
                FROM transactions 
                WHERE account_id = %s 
                ORDER BY transaction_time DESC 
                LIMIT 10""", (selected_account,))

            transactions = cursor.fetchall()
            if transactions:
                for transaction in transactions:
                    txn_type, amount, desc, time = transaction
                    formatted_time = time.strftime('%Y-%m-%d %H:%M:%S') if time else 'N/A'
                    if txn_type == 'withdrawal':
                        st.write(f"🔴 [{formatted_time}] -₹{amount:.2f} ({txn_type}) – {desc}")
                    else:
                        st.write(f"🟢 [{formatted_time}] +₹{amount:.2f} ({txn_type}) – {desc}")
            else:
                st.info("No transactions found for this account")

        else:
            st.error(f"Incorrect password for user {username}")
    else:
        st.error("User not found")