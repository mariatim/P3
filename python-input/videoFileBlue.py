# Import libraries (OpenCV, Die object)
import cv2
import numpy as np
from die import Die
import communication as server

# Load the image and process it for the CV to have it easier to analyse
# add "vid.mp4" to use test video
#Add 0 for using the videofeed.
video = cv2.VideoCapture(0)

# Set up an array for the Die objects
dice = []
currentFrame = 0
server.setup()

# Output
while True:
    # Read the video and convert the value system to Hue-Sat-Val
    _, frame = video.read()
    if currentFrame % 15 == 0:
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

        #region Image processing
        lower_threshold = np.array([100, 50, 0])
        upper_threshold = np.array([130, 175, 60])

        maskDice = cv2.inRange(hsv, lower_threshold, upper_threshold)
        maskDice = cv2.bilateralFilter(maskDice, 20, 100, 100)
        maskDots = maskDice
        maskDice = cv2.erode(maskDice, np.ones((0, 0), np.uint8))
        maskDice = cv2.dilate(maskDice, np.ones((10, 10), np.uint8))

        # Alternative image processing with dots
        maskDots = cv2.blur(maskDots, (2, 2))
        _, maskDots = cv2.threshold(maskDots, 75, 255, cv2.THRESH_BINARY)
        maskDots = cv2.dilate(maskDots, np.ones((7, 7), np.uint8))
        #endregion

        # Find contours and draw them
        #region Dice
        contours, _ = cv2.findContours(maskDice, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

        dice = []
        for c in contours:
            approx = cv2.approxPolyDP(c, 16, True)
            if len(approx) == 4:
                coords = [a[0] for a in approx]
                d = Die(coords, 0)
                if (d.isSquare()):
                    color = (0, 200, 0)
                    dice.append(Die(coords, 0, "blue"))
                else:
                    color = (200, 0, 0)
                cv2.drawContours(frame, [approx], 0, color, 2)
                cv2.drawContours(maskDice, [approx], 0, (90, 90, 90), 2)
                cv2.circle(frame, tuple(d.roundedCenter), int(
                    d.minCenterDistance), (0, 0, 255), 3)
                cv2.circle(frame, tuple(d.roundedCenter), int(
                    d.maxCenterDistance), (255, 255, 255), 3)
        #endregion
        #region Dots
        contours, _ = cv2.findContours(maskDots, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

        for c in contours:
            approx = cv2.approxPolyDP(c, 1, False)
            if len(approx) >= 4:
                x, y, w, h = cv2.boundingRect(approx)
                x2 = x + w
                y2 = y + h
                for d in dice:
                    if (d.isBelongs([x, x2], [y, y2])):
                        d.dots += 1 if d.dots < 6 else d.dots
                        cv2.drawContours(frame, [approx], 0, (0, 200, 200), 2)
                        cv2.drawContours(maskDots, [approx], 0, (90, 90, 90), 2)

        for d in dice:
            if d.dots == 0:
                d.dots = 0
            else:
                d.dots -= 1

        data = ', '.join([d.color + ": " + str(d.dots) for d in dice])
        server.send(data)
        #endregion

    cv2.putText(frame, dice[0].dots, (50, 100), cv2.FONT_HERSHEY_COMPLEX, 2, (255, 255, 255), 3)
    currentFrame += 1

    #region Draw the frames
    cv2.namedWindow("Analysed", 0)
    cv2.resizeWindow("Analysed", 640, 360)
    cv2.imshow("Analysed", frame)
    cv2.namedWindow("Processed-dice", 0)
    cv2.resizeWindow("Processed-dice", 640, 360)
    cv2.imshow("Processed-dice", maskDice)
    cv2.namedWindow("Processed-dots", 0)
    cv2.resizeWindow("Processed-dots", 640, 360)
    cv2.imshow("Processed-dots", maskDots)
    #endregion

    key = cv2.waitKey(1)
    if key == 27:
        break

video.release()
cv2.destroyAllWindows()
server.end()
