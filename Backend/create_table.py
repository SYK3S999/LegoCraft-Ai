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
    #https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/castle.png
    data = [
        ('3, 4, 3', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/airplane.png', '1'),
        ('3, 5, 1', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/animal.png', '2'),
        ('7, 3, 2', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/chicken.png', '4'),
        ('6, 6, 7', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/dino.png', '5'),
        ('7, 11, 3', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/dog.png', '6'),
        ('13, 3, 7', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/elephant.png', '7'),
        ('16, 4, 2', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/heart.png', '8'),
        ('18, 9, 5', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/robot.png', '9'),
        ('1, 0, 10', 'https://raw.githubusercontent.com/SYK3S999/portfolioimages/main/tank.png', '10')
        ]
    
    cursor.executemany('INSERT INTO legos (lego_counts, possible_shape, image_id) VALUES (?, ?, ?)', data)
    
    # Commit changes and close connection
    conn.commit()
    conn.close()

# Create the database
create_lego_database()
