import sqlite3

def create_lego_database():
    # Connect to the SQLite database (or create it if it doesn't exist)
    conn = sqlite3.connect('lego_database.db')
    cursor = conn.cursor()
    
    # Create the table
    cursor.execute('''CREATE TABLE legos (
                        id INTEGER PRIMARY KEY,
                        lego_counts TEXT,  -- Storing as a comma-separated string
                        possible_shape BLOB -- Storing images as BLOBs
                    )''')
    
    # Insert some sample data
    data = [
        ('1, 0, 10', 'https://drive.google.com/file/d/17NmVaIZ7-uqBvSZF_4HPSgLCUwHOTzDw/view?usp=drive_link'),
        ('18, 9, 5', 'https://drive.google.com/file/d/1hniNcUuzeGXBWthPFlahP3PdoAOqzUfe/view?usp=drive_link'),
        ('15, 4, 2', 'https://drive.google.com/file/d/1G5X4S3k1badUn_EhsKeVti-Vj558ZdIF/view?usp=drive_link'),
        ('13, 5, 4', 'https://drive.google.com/file/d/1bYphHVWJ9ZMRjkimNuBInQ7Ayn7btU-d/view?usp=drive_link'),
        ('7, 11, 3', 'https://drive.google.com/file/d/1krW5AuE-6iZs-JDs4cUZC4pDdDpH3CHL/view?usp=drive_link'),
        ('6, 6, 7', 'https://drive.google.com/file/d/1yCoGUU9QclD_ILAeH6Zcxuonl2emsEqk/view?usp=drive_link'),
        ('6, 3, 2', 'https://drive.google.com/file/d/1CqA8gdEOjnkrg80LeNita1lWVI6S9J2J/view?usp=drive_link'),
        ('20, 3, 12', 'https://drive.google.com/file/d/1qFHwBddFGnmKMWX8v-hxzGjIbQmk4Cfd/view?usp=drive_link'),
        ('3, 5, 1', 'https://drive.google.com/file/d/155cIV8XBAHGhJV62L4zChcVs4FrLoRj0/view?usp=drive_link'),
        ('3, 4, 3', 'https://drive.google.com/file/d/1xXkWC7HN0teIGXzSiFyv45Q98LDFB68l/view?usp=drive_link'),
        ('1, 2, 2', 'https://drive.google.com/file/d/1PoOWYTxfBWaQ3xJcaMK1zwNgQ5mkUk5v/view?usp=drive_link')
    ]
    
    cursor.executemany('INSERT INTO legos (lego_counts, possible_shape) VALUES (?, ?)', data)
    
    # Commit changes and close connection
    conn.commit()
    conn.close()

# Create the database
create_lego_database()
