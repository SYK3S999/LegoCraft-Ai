import os
from flask import Flask, request, jsonify, g
import cv2
from ultralytics import YOLO
import cvzone
import numpy as np
import pandas as pd
from collections import Counter
import glob
import sqlite3
import re


# Initialize the YOLOv8 model
model = YOLO("D:/projects/LegoCraftAi/Backend/yolov8-object-count-in-image-main/yolov8-object-count-in-image-main/best.pt")
my_file = open("D:/projects/LegoCraftAi/Backend/yolov8-object-count-in-image-main/yolov8-object-count-in-image-main/coco.txt", "r")
data = my_file.read()
class_list = data.split("\n")

def object(img):
    results = model.predict(img)
    boxes = results[0].boxes.data
    cpu_boxes = boxes.cpu()
    numpy_array = cpu_boxes.numpy()
    px = pd.DataFrame(numpy_array).astype("float")
    object_classes = []
    for index, row in px.iterrows():
        x1 = int(row[0])
        y1 = int(row[1])
        x2 = int(row[2])
        y2 = int(row[3])
        d = int(row[5])
        c = class_list[d]
        obj_class = class_list[d]
        object_classes.append(obj_class)
        cv2.rectangle(img, (x1, y1), (x2, y2), (255, 0, 255), 2)
        cvzone.putTextRect(img, f'{obj_class}', (x2, y2), 1, 1)
    return object_classes

def count_objects_in_image(object_classes):
    counter = Counter(object_classes)
    print("Object Count in Image:")
    for obj, count in counter.items():
        print(f"{obj}: {count}")

# Create a Flask app
app = Flask(__name__)

# Database initialization
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect("lego_database.db")
    return db

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

@app.route("/process_image", methods=["POST"])
def process_image():
    try:
        # Get the image file from the request
        image_file = request.files["image"]

        # Log information about the received image
        print("Received image:", image_file.filename)
        print("Content type:", image_file.content_type)
        print("File size:", image_file.content_length)

        # Read the image data from the file object
        image_data = image_file.read()

        # Convert the image data to a numpy array
        img = cv2.imdecode(np.frombuffer(image_data, np.uint8), cv2.IMREAD_COLOR)

        # Call your object detection function
        object_classes = object(img)

        # Count objects in the image
        count_objects_in_image(object_classes)

        # Encode the processed image back to bytes
        _, processed_image_data = cv2.imencode('.jpg', img)

        # Return the processed image data
        return processed_image_data.tobytes()

    except Exception as e:
        # Log any exceptions that occur during image processing
        print("Error processing image:", e)
        return jsonify({"error": "An error occurred while processing the image"}), 500

@app.route("/get_image/<image_id>", methods=["GET"])
def get_image(image_id):
    # Get the database connection
    conn = get_db()
    c = conn.cursor()

    # Query the database to get the image data
    c.execute("SELECT possible_shape FROM legos WHERE id = ?", (image_id,))
    image_data = c.fetchone()[0]

    # Return the image data
    return image_data

if __name__ == "__main__":
    # Create the lego_shapes table and insert data
    app.run(debug=True, host='0.0.0.0')
