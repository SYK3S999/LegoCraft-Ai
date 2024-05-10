import sqlite3

def create_lego_database():
    # Connect to the SQLite database (or create it if it doesn't exist)
    conn = sqlite3.connect('lego_database.db')
    cursor = conn.cursor()
    
    # Create the table
    cursor.execute('''CREATE TABLE legos (
                        id INTEGER PRIMARY KEY,
                        lego_counts TEXT,  -- Storing as a comma-separated string
                        possible_shape BLOB, -- Storing images as BLOBs
                        image_id TEXT -- Storing image ID as a string
                    )''')
    
    # Insert some sample data
    data = [
        ('1, 0, 10', 'https://p.turbosquid.com/ts-thumb/an/NnEJtI/npcxxipY/legobricks_shape_1_collection/jpg/1537086072/1920x1080/fit_q87/8273464ab7bc71f3f66ce5ade1932d3f7065bdbd/legobricks_shape_1_collection.jpg', '1'),
        ('18, 9, 5', 'https://drive.google.com/file/d/1hniNcUuzeGXBWthPFlahP3PdoAOqzUfe/view?usp=drive_link', '2'),
        ('15, 4, 2', 'https://drive.google.com/file/d/1G5X4S3k1badUn_EhsKeVti-Vj558ZdIF/view?usp=drive_link', '3'),
        ('13, 5, 4', 'https://drive.google.com/file/d/1bYphHVWJ9ZMRjkimNuBInQ7Ayn7btU-d/view?usp=drive_link', '4'),
        ('7, 11, 3', 'https://drive.google.com/file/d/1krW5AuE-6iZs-JDs4cUZC4pDdDpH3CHL/view?usp=drive_link', '5'),
        ('6, 6, 7', 'https://drive.google.com/file/d/1yCoGUU9QclD_ILAeH6Zcxuonl2emsEqk/view?usp=drive_link', '6'),
        ('6, 3, 2', 'https://drive.google.com/file/d/1CqA8gdEOjnkrg80LeNita1lWVI6S9J2J/view?usp=drive_link', '7'),
        ('20, 3, 12', 'https://drive.google.com/file/d/1qFHwBddFGnmKMWX8v-hxzGjIbQmk4Cfd/view?usp=drive_link', '8'),
        ('3, 5, 1', 'https://drive.google.com/file/d/155cIV8XBAHGhJV62L4zChcVs4FrLoRj0/view?usp=drive_link', '9'),
        ('1, 3, 1', 'https://drive.google.com/file/d/1xXkWC7HN0teIGXzSiFyv45Q98LDFB68l/view?usp=drive_link', '10'),
        ('1, 2, 2', 'https://p.turbosquid.com/ts-thumb/an/NnEJtI/npcxxipY/legobricks_shape_1_collection/jpg/1537086072/1920x1080/fit_q87/8273464ab7bc71f3f66ce5ade1932d3f7065bdbd/legobricks_shape_1_collection.jpg', '11')
    ]
    
    cursor.executemany('INSERT INTO legos (lego_counts, possible_shape, image_id) VALUES (?, ?, ?)', data)
    
    # Commit changes and close connection
    conn.commit()
    conn.close()

# Create the database
create_lego_database()
