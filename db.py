import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="MOITRI#03",
        database="banking_system"
    )
