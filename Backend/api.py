import os
from flask import Flask, request, jsonify, g
import cv2
from ultralytics import YOLO
import cvzone
import numpy as np
import pandas as pd
from collections import Counter
import sqlite3
import re
import json

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
    sorted_counts = sorted(counter.items(), key=lambda x: (int(re.findall(r'\d+', x[0])[0]), int(re.findall(r'\d+', x[0])[1])))
    filtered_counts = [(obj, count) for obj, count in sorted_counts if count > 0]
    if len(filtered_counts) == 1:
        # If there is only one non-zero count, return it without zeros
        formatted_counts = str(filtered_counts[0][1])
    else:
        sorted_counts_str = [str(count) for _, count in filtered_counts]
        formatted_counts = ', '.join(sorted_counts_str)
    print("Object Count in Image:")
    for obj, count in filtered_counts:
        print(f"{obj}: {count}")
    print("Formatted counts:", formatted_counts)
    return formatted_counts


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

        # Read the image data from the file object
        image_data = image_file.read()

        # Convert the image data to a numpy array
        img = cv2.imdecode(np.frombuffer(image_data, np.uint8), cv2.IMREAD_COLOR)

        # Call your object detection function
        object_classes = object(img)

        # Count objects in the image and format the counts
        formatted_counts = count_objects_in_image(object_classes)
        if not formatted_counts:
            return jsonify({"error": "All objects have a count of zero"}), 404

        # Convert formatted_counts to a list of integers
        formatted_counts_list = [int(count) for count in formatted_counts.split(', ')]

        # Query the database to find a match for the formatted counts
        conn = get_db()
        c = conn.cursor()

        # Check for an exact match
        c.execute("SELECT image_id, lego_counts FROM legos WHERE lego_counts = ?", (formatted_counts,))
        result = c.fetchone()
        if result:
            image_id, _ = result
            return str(image_id)

        # If no exact match, find the closest match
        c.execute("SELECT image_id, lego_counts FROM legos")
        results = c.fetchall()
        closest_match = None
        min_diff = float('inf')
        for image_id, lego_counts in results:
            lego_counts_list = [int(count) for count in lego_counts.split(', ')]
            if all(lego_count <= formatted_count for lego_count, formatted_count in zip(lego_counts_list, formatted_counts_list)):
                diff = sum(formatted_count - lego_count for formatted_count, lego_count in zip(formatted_counts_list, lego_counts_list))
                if diff < min_diff:
                    min_diff = diff
                    closest_match = image_id

        if closest_match:
            return str(closest_match)
        else:
            return jsonify({"error": "No matching shape found"}), 404

    except Exception as e:
        print("Error processing image:", e)
        return jsonify({"error": "An error occurred while processing the image"}), 500

@app.route("/get_image/<image_id>", methods=["GET"])
def get_image(image_id):
    try:
        # Get the database connection
        conn = get_db()
        c = conn.cursor()

        # Query the database to get the possible_shape
        c.execute("SELECT possible_shape FROM legos WHERE image_id = ?", (image_id,))
        possible_shape_data = c.fetchone()
        if possible_shape_data:
            possible_shape = possible_shape_data[0]
            # Return the possible_shape (URL)
            return jsonify({"possible_shape": possible_shape})
        else:
            return jsonify({"error": "Image not found"}), 404

    except Exception as e:
        # Log any exceptions that occur
        print("Error retrieving image data:", e)
        return jsonify({"error": "An error occurred while retrieving image data"}), 500

if __name__ == "__main__":
    # Create the lego_shapes table and insert data
    app.run(debug=True, host='0.0.0.0')
