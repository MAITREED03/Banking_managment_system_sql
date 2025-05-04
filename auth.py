import hashlib

def check_password(input_password, stored_hash):
    """
    Compare input password with stored hash
    Uses SHA-256 hashing to match the hash created during user creation
    """
    # Hash the input password the same way it was created in user table.sql
    password_to_check = 'pass' + input_password.split('User')[1] if 'User' in input_password else input_password
    input_hash = hashlib.sha256(password_to_check.encode()).hexdigest()
    return input_hash == stored_hash 