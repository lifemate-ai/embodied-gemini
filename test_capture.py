import sys
import os
import cv2
from PIL import Image

def capture_test():
    camera_index = 0
    cap = cv2.VideoCapture(camera_index)
    if not cap.isOpened():
        print(f"Error: Cannot open camera {camera_index}")
        return

    try:
        # 安定させるために数フレーム捨てる
        for _ in range(10):
            cap.read()
        
        ret, frame = cap.read()
        if not ret:
            print("Error: Failed to capture frame")
            return

        # BGRからRGBへ
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image = Image.fromarray(frame_rgb)
        
        save_path = "capture.jpg"
        image.save(save_path)
        print(f"Success! Image saved to {save_path}")
        print(f"Resolution: {image.width}x{image.height}")
    finally:
        cap.release()

if __name__ == "__main__":
    capture_test()
