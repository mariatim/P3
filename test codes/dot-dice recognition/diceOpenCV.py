# Import libraries (OpenCV, Die object)
import cv2
import numpy as np
from die import Die

# Set up an array for the Die objects
dice = []

# Load the image and process it for the CV to have it easier to analyse
img = cv2.imread('dice.png')
video = cv2.VideoCapture("vid.mp4")

# Trackbar windows to figure out the thresholds and stuff 
#region
def nothing(x):
    pass

cv2.namedWindow("Trackbars")
cv2.resizeWindow("Trackbars", 500, 500)
cv2.createTrackbar("L-H", "Trackbars", 0, 180, nothing)
cv2.createTrackbar("L-S", "Trackbars", 0, 255, nothing)
cv2.createTrackbar("L-V", "Trackbars", 180, 255, nothing)
cv2.createTrackbar("U-H", "Trackbars", 40, 180, nothing)
cv2.createTrackbar("U-S", "Trackbars", 60, 255, nothing)
cv2.createTrackbar("U-V", "Trackbars", 255, 255, nothing)
cv2.createTrackbar("Epsilon", "Trackbars", 50, 500, nothing)
cv2.createTrackbar("Erode", "Trackbars", 1, 100, nothing)
cv2.createTrackbar("Thiccness", "Trackbars", 4, 10, nothing)
cv2.createTrackbar("Contours", "Trackbars", 4, 100, nothing)
#endregion

# Output
while True:
    # Read the video and convert the value system to Hue-Sat-Val
    _trash, frame = video.read()
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    
    #region
    # Apply thresholds from the Trackbars
    lower_threshold = np.array(
        [cv2.getTrackbarPos("L-H", "Trackbars"),
         cv2.getTrackbarPos("L-S", "Trackbars"),
         cv2.getTrackbarPos("L-V", "Trackbars")])
    upper_threshold = np.array(
        [cv2.getTrackbarPos("U-H", "Trackbars"),
         cv2.getTrackbarPos("U-S", "Trackbars"),
         cv2.getTrackbarPos("U-V", "Trackbars")])

    maskDice = cv2.inRange(hsv, lower_threshold, upper_threshold)
    kernelSizeDice = cv2.getTrackbarPos("Erode", "Trackbars")
    kernelDice = np.ones((kernelSizeDice, kernelSizeDice), np.uint8)
    maskDice = cv2.erode(maskDice, kernelDice)

    # Alternative image processing with dots
    maskDots = maskDice
    maskDots = cv2.blur(maskDots, (9, 9))
    _, maskDots = cv2.threshold(maskDots, 75, 255, cv2.THRESH_BINARY_INV)
    kernelSizeDots = cv2.getTrackbarPos("Erode", "Trackbars")
    kernelDots = np.ones((kernelSizeDots, kernelSizeDots), np.uint8)
    maskDots = cv2.erode(maskDots, kernelDots)
    #endregion

    # Find contours and draw them
    # Dice
    #region
    contours, _ = cv2.findContours(maskDice, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    
    dice = []
    for c in contours:
        approx = cv2.approxPolyDP(c, cv2.getTrackbarPos("Epsilon", "Trackbars"), True)
        if len(approx) == cv2.getTrackbarPos("Contours", "Trackbars"):
            x, y, w, h = cv2.boundingRect(approx)
            x2 = x + w
            y2 = y + h
            if (0.80 < w/h < 1.20):
                color = (0, 200, 0)
                dice.append(Die(x, y, x2, y2, 0))
            else:
                color = (200, 0, 0)
            cv2.drawContours(frame, [approx], 0, color, cv2.getTrackbarPos("Thiccness", "Trackbars"))
            cv2.drawContours(maskDice, [approx], 0, (90, 90, 90), cv2.getTrackbarPos("Thiccness", "Trackbars"))
    #endregion
    # Dots
    #region
    contours, _ = cv2.findContours(
        maskDots, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    for c in contours:
        approx = cv2.approxPolyDP(c, 1, False)
        if len(approx) >= cv2.getTrackbarPos("Contours", "Trackbars"):
            x, y, w, h = cv2.boundingRect(approx)
            x2 = x + w
            y2 = y + h
            for d in dice:
                if (x > d.x and x2 < d.x2 and y > d.y and y2 < d.y2):
                    d.dots += 1
                    cv2.drawContours(frame, [approx], 0, (0, 200, 200), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                    cv2.drawContours(maskDots, [approx], 0, (90, 90, 90), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                        
    #endregion

    dicePoints = ', '.join([str(d.dots) for d in dice])
    cv2.putText(frame, dicePoints, (50, 100), cv2.FONT_HERSHEY_COMPLEX, 2, (255, 255, 255), 3)
    
    # Draw the frames
    cv2.namedWindow("Original", 0)
    cv2.resizeWindow("Original", 640, 360)
    cv2.imshow("Original", frame)
    cv2.namedWindow("Processed-dice", 0)
    cv2.resizeWindow("Processed-dice", 640, 360)
    cv2.imshow("Processed-dice", maskDice)
    cv2.namedWindow("Processed-dots", 0)
    cv2.resizeWindow("Processed-dots", 640, 360)
    cv2.imshow("Processed-dots", maskDots)
    
    key = cv2.waitKey(1)
    if key == 27:
        break

video.release()
cv2.destroyAllWindows()
