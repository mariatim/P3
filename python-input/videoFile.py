# Import libraries (OpenCV, Die object)
import cv2
import numpy as np
from die import Die
import communication as server

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 5001              # Arbitrary non-privileged port

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))

s.listen(1)
conn, addr = s.accept()

# Set up an array for the Die objects
dice = []
currentFrame = 0
server.setup()

# Load the image and process it for the CV to have it easier to analyse
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
cv2.createTrackbar("Dilate", "Trackbars", 1, 50, nothing)
cv2.createTrackbar("Erode", "Trackbars", 1, 50, nothing)
cv2.createTrackbar("Thiccness", "Trackbars", 4, 10, nothing)
cv2.createTrackbar("Contours", "Trackbars", 4, 10, nothing)
#endregion

maskDice = None
maskDots = None

# Output
while True:
    # Read the video and convert the value system to Hue-Sat-Val
    _, frame = video.read()
    if currentFrame % 15 == 0:
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
        maskDots = maskDice
        kernelSizeErodeDice = cv2.getTrackbarPos("Erode", "Trackbars")
        kernelSizeDilateDice = cv2.getTrackbarPos("Dilate", "Trackbars")
        maskDice = cv2.dilate(maskDice, np.ones((kernelSizeDilateDice, kernelSizeDilateDice), np.uint8))
        maskDice = cv2.erode(maskDice, np.ones((kernelSizeErodeDice, kernelSizeErodeDice), np.uint8))

        # Alternative image processing with dots
        # maskDots = maskDice
        maskDots = cv2.blur(maskDots, (9, 9))
        _, maskDots = cv2.threshold(maskDots, 75, 255, cv2.THRESH_BINARY)
        # kernelSizeDots = cv2.getTrackbarPos("Erode", "Trackbars")
        kernelDots = np.ones((1, 1), np.uint8)
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
                coords = [a[0] for a in approx]
                d = Die(coords, 0)
                if (d.isSquare()):
                    color = (0, 200, 0)
                    dice.append(Die(coords, 0))
                else:
                    color = (200, 0, 0)
                cv2.drawContours(frame, [approx], 0, color, cv2.getTrackbarPos("Thiccness", "Trackbars"))
                cv2.drawContours(maskDice, [approx], 0, (90, 90, 90), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                cv2.circle(frame, tuple(d.roundedCenter), int(d.minCenterDistance), (0, 0, 255), 3)
                cv2.circle(frame, tuple(d.roundedCenter), int(d.maxCenterDistance), (255, 255, 255), 3)
        #endregion
        # Dots
        #region
        contours, _ = cv2.findContours(maskDots, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)    

        for c in contours:
            approx = cv2.approxPolyDP(c, 1, False)
            if len(approx) >= cv2.getTrackbarPos("Contours", "Trackbars"):
                x, y, w, h = cv2.boundingRect(approx)
                x2 = x + w
                y2 = y + h
                for d in dice:
                    if (d.isBelongs([x, x2],[y, y2])):
                        d.dots += 1
                        cv2.drawContours(frame, [approx], 0, (0, 200, 200), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                        cv2.drawContours(maskDots, [approx], 0, (90, 90, 90), cv2.getTrackbarPos("Thiccness", "Trackbars"))
                            
        if len(dice) > 6:
            for i in range(len(dice), 7):
                dice.append(Die(0))
        data = ', '.join([str(d.dots) for d in dice])
        server.send(data)
        #endregion

    dicePoints = ', '.join([str(d.dots) for d in dice])
    cv2.putText(frame, dicePoints, (50, 100), cv2.FONT_HERSHEY_COMPLEX, 2, (255, 255, 255), 3)
    currentFrame += 1

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

video.release()
cv2.destroyAllWindows()
server.end()
