from db import get_connection

try:
    connection = get_connection()
    print("Successfully connected to MySQL database!")
    connection.close()
except Exception as e:
    print(f"Error: {e}")