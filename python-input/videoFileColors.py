# Import libraries (OpenCV, Die object)
import cv2
import numpy as np
from die import Die

# Development variables
# Thresholds ((Hue-min, Hue-max, Sat-min, Sat-max, Val-min, Val-max), ε, Dilate, Erode, Color)
huesND = (((160, 175, 120, 250, 160, 255), 25, 1, 1, "pink"),
          ((50, 65, 200, 255, 0, 170), 15, 12, 1, "green"),
          ((120, 150, 50, 145, 60, 255), 10, 4, 2, "purple"),
          ((0, 3, 170, 230, 95, 190), 10, 1, 1, "red"),
          ((100, 110, 140, 255, 45, 130), 15, 1, 1, "blue"),
          ((0, 120, 0, 65, 0, 50), 20, 1, 1, "black"))
precisionTrackbars = False

# Set up an array for the Die objects
dice = []

# Load the image and process it for the CV to have it easier to analyse
video = cv2.VideoCapture("vidcolor.mp4")

# Trackbar windows to figure out the thresholds and stuff 
#region
def nothing(x):
    pass

cv2.namedWindow("Trackbars")
cv2.resizeWindow("Trackbars", 500, 500)
if precisionTrackbars == True:
    cv2.createTrackbar("L-H", "Trackbars", 0, 180, nothing)
    cv2.createTrackbar("L-S", "Trackbars", 0, 255, nothing)
    cv2.createTrackbar("L-V", "Trackbars", 180, 255, nothing)
    cv2.createTrackbar("U-H", "Trackbars", 40, 180, nothing)
    cv2.createTrackbar("U-S", "Trackbars", 60, 255, nothing)
    cv2.createTrackbar("U-V", "Trackbars", 255, 255, nothing)
else:
    cv2.createTrackbar("Color", "Trackbars", 0, 7, nothing)
cv2.createTrackbar("Epsilon", "Trackbars", 25, 50, nothing)
cv2.createTrackbar("Dilate", "Trackbars", 50, 50, nothing)
cv2.createTrackbar("Erode", "Trackbars", 10, 50, nothing)
cv2.createTrackbar("Thiccness", "Trackbars", 4, 10, nothing)
cv2.createTrackbar("Contours", "Trackbars", 4, 10, nothing)
#endregion

##################
##### Output #####
##################
while True:

    # Load the image and process it for the CV to have it easier to analyse
    _, frame = video.read()
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    dice = []

    for h in huesND:
        #Filters
        #region
        if precisionTrackbars == True:
            lower_threshold = np.array([
                cv2.getTrackbarPos("L-H", "Trackbars"),
                cv2.getTrackbarPos("L-S", "Trackbars"),
                cv2.getTrackbarPos("L-V", "Trackbars")])
            upper_threshold = np.array([
                cv2.getTrackbarPos("U-H", "Trackbars"),
                cv2.getTrackbarPos("U-S", "Trackbars"),
                cv2.getTrackbarPos("U-V", "Trackbars")])
        else:
            lower_threshold = np.array(h[0][0::2])
            upper_threshold = np.array(h[0][1::2])

        maskDice = cv2.inRange(hsv, lower_threshold, upper_threshold)
        maskDots = maskDice
        maskDice = cv2.dilate(maskDice, np.ones((h[-3], h[-3]), np.uint8))
        maskDice = cv2.erode(maskDice, np.ones((h[-2], h[-2]), np.uint8))

        # Alternative image processing with dots
        # maskDots = maskDice
        # maskDots = cv2.blur(maskDots, (4, 4))
        _, maskDots = cv2.threshold(maskDots, 75, 255, cv2.THRESH_BINARY_INV)
        kernelSizeDots = cv2.getTrackbarPos("Erode", "Trackbars")
        kernelDots = np.ones((2, 2), np.uint8)
        maskDots = cv2.erode(maskDots, kernelDots)
        #endregion

        # Find contours and draw them : Dice
        #region
        contours, _ = cv2.findContours(maskDice, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

        for c in contours:
            approx = cv2.approxPolyDP(c, h[1], True)
            if len(approx) >= cv2.getTrackbarPos("Contours", "Trackbars"):
                coords = [a[0] for a in approx]
                d = Die(coords, 0, h[-1])
                if (d.isSquare()):
                    color = (0, 200, 0)
                    dice.append(Die(coords, 0, h[-1]))
                else:
                    color = (200, 0, 0)
                cv2.drawContours(frame, [approx], 0, (0, 200, 0), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                cv2.drawContours(maskDice, [approx], 0, (90, 90, 90), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                cv2.circle(frame, tuple(d.roundedCenter), int(d.minCenterDistance), (0, 0, 255), 1)
                cv2.circle(frame, tuple(d.roundedCenter), int(d.maxCenterDistance), (255, 255, 255), 1)
        #endregion

        # Find contours and draw them : Dots
        #region
        contours, _ = cv2.findContours(maskDots, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)    

        for c in contours:
            approx = cv2.approxPolyDP(c, 1, False)
            if len(approx) >= cv2.getTrackbarPos("Contours", "Trackbars"):
                x, y, w, h = cv2.boundingRect(approx)
                x2 = x + w
                y2 = y + h
                try:
                    d = dice[-1]
                    if (d.isBelongs([x, x2], [y, y2])):
                        d.dots += 1
                        cv2.drawContours(frame, [approx], 0, (0, 200, 200), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                        cv2.drawContours(maskDots, [approx], 0, (90, 90, 90), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                except:
                    pass
                            
        #endregion

        for i in range(len(dice)):
            text = str(dice[i].color) + " = " + str(dice[i].dots)
            cv2.putText(frame, text, (30, (i+1)*30), cv2.FONT_HERSHEY_COMPLEX, 0.8, (255, 255, 255), 1)
            print(text)

        # Draw the frames
        cv2.namedWindow("Analysed", 0)
        cv2.resizeWindow("Analysed", 640, 360)
        cv2.imshow("Analysed", frame)
        cv2.namedWindow("Processed-dice", 0)
        cv2.resizeWindow("Processed-dice", 640, 360)
        cv2.imshow("Processed-dice", maskDice)
        cv2.namedWindow("Processed-dots", 0)
        cv2.resizeWindow("Processed-dots", 640, 360)
        cv2.imshow("Processed-dots", maskDots)

    key = cv2.waitKey(1)
    if key == 27:
        break

for d in dice:
    print(d.value())

video.release()
cv2.destroyAllWindows()
