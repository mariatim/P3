# Import libraries (OpenCV, Die object)
import cv2
import numpy as np
from die import Die
import communication as server

# Load the image and process it for the CV to have it easier to analyse
# add "vid.mp4" to use test video
#Add 0 for using the videofeed.
video = cv2.VideoCapture(0)

currentFrame = 0
server.setup()

blue = {"lower_threshold" : [100, 50, 0],
        "upper_threshold" : [130, 175, 60],
        "bilateral" : (20, 100, 100),
        "dice_erode" : (0, 0),
        "dice_dilate" : (10, 10),
        "dot_dilate" : (7, 7),
        "dot_erode" : (1, 7),
        "dice_epsilon" : 16,
        "color" : "blue",
        "value" : 1}
red = {"lower_threshold": [0, 135, 80],
        "upper_threshold": [15, 250, 220],
        "bilateral": (20, 75, 75),
        "dice_erode": (0, 0),
        "dice_dilate": (24, 24),
        "dot_dilate": (8, 8),
        "dot_erode": (0, 0),
        "dice_epsilon": 23,
        "color" : "red",
        "value" : 1}
green = {"lower_threshold" : [38, 90, 30],
        "upper_threshold" : [86, 198, 80],
        "bilateral" : (20, 75, 75),
        "dice_erode" : (0, 0),
        "dice_dilate" : (24, 24),
        "dot_dilate" : (7, 7),
        "dot_erode" : (1, 1),
        "dice_epsilon" : 21,
        "color" : "green",
        "value" : 1}

hues = [blue, red, green]

# Output
while True:
    # Read the video and convert the value system to Hue-Sat-Val
    _, frame = video.read()
    if currentFrame % 15 == 0:
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

        for h in hues:
            #region Image processing
            lower_threshold = np.array(h["lower_threshold"])
            upper_threshold = np.array(h["upper_threshold"])

            maskDice = cv2.inRange(hsv, lower_threshold, upper_threshold)
            maskDice = cv2.bilateralFilter(maskDice, h["bilateral"][0], h["bilateral"][1], h["bilateral"][2])
            maskDots = maskDice
            maskDice = cv2.erode(maskDice, np.ones(h["dice_erode"], np.uint8))
            maskDice = cv2.dilate(maskDice, np.ones(h["dice_dilate"], np.uint8))

            # Alternative image processing with dots
            maskDots = cv2.blur(maskDots, (2, 2))
            _, maskDots = cv2.threshold(maskDots, 75, 255, cv2.THRESH_BINARY)
            maskDots = cv2.dilate(maskDots, np.ones(h["dots_dilate"], np.uint8))
            maskDots = cv2.erode(maskDots, np.ones(h["dots_erode"], np.uint8))
            #endregion

            # Find contours and draw them
            #region Dice
            contours, _ = cv2.findContours(maskDice, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

            die = None
            for c in contours:
                approx = cv2.approxPolyDP(c, h["dice_epsilon"], True)
                if len(approx) == 4:
                    coords = [a[0] for a in approx]
                    d = Die(coords, 0)
                    if (d.isSquare()):
                        color = (0, 200, 0)
                        die = Die(coords, 0, h["color"])
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
                    if (die.isBelongs([x, x2], [y, y2])):
                        die.dots += 1 if die.dots < 6 else die.dots
                        cv2.drawContours(frame, [approx], 0, (0, 200, 200), 2)
                        cv2.drawContours(maskDots, [approx], 0, (90, 90, 90), 2)

            if die.dots == 0:
                die.dots = 0
            else:
                die.dots -= 1
            #endregion

            h.value = die.dots

        data = bytes([h.value for h in hues])
        server.send(data)

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
