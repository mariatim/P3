import cv2, time

# Assign camera to video
video = cv2.VideoCapture(1)

while True:
    # Get the video information 
    check, frame = video.read()

    # Output
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    cv2.imshow("Capturing", gray)
    key = cv2.waitKey(1)

    if key == ord('q'):
        break

# Release the camera
video.release()
cv2.destroyAllWindows()
