# Import libraries (OpenCV, Die object)
import cv2
import numpy as np
from die import Die
import communication as server

# Load the image and process it for the CV to have it easier to analyse
# add "vid.mp4" to use test video
#Add 0 for using the videofeed.
video = cv2.VideoCapture(0)

dice = []
values = [1, 1, 1]
currentFrame = 0
server.setup()

blue = {"lower_threshold" : [100, 160, 0],
        "upper_threshold" : [130, 255, 110],
        "bilateral" : (40, 100, 100),
        "dice_erode" : (1, 1),
        "dice_dilate" : (7, 7),
        "dot_dilate" : (5, 5),
        "dot_erode" : (1, 7),
        "dice_epsilon" : 20,
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
    if currentFrame % 30 == 0:
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

        values = [1, 1, 1]
        for hue in hues:
            #region Image processing
            lower_threshold = np.array(hue["lower_threshold"])
            upper_threshold = np.array(hue["upper_threshold"])

            maskDice = cv2.inRange(hsv, lower_threshold, upper_threshold)
            maskDice = cv2.bilateralFilter(maskDice, hue["bilateral"][0], hue["bilateral"][1], hue["bilateral"][2])
            maskDots = maskDice
            maskDice = cv2.erode(maskDice, np.ones(hue["dice_erode"], np.uint8))
            maskDice = cv2.dilate(maskDice, np.ones(hue["dice_dilate"], np.uint8))

            # Alternative image processing with dots
            maskDots = cv2.blur(maskDots, (2, 2))
            _, maskDots = cv2.threshold(maskDots, 75, 255, cv2.THRESH_BINARY)
            maskDots = cv2.dilate(maskDots, np.ones(hue["dot_dilate"], np.uint8))
            maskDots = cv2.erode(maskDots, np.ones(hue["dot_erode"], np.uint8))
            #endregion

            # Find contours and draw them
            #region Dice
            contours, _ = cv2.findContours(maskDice, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

            dice = []
            for c in contours:
                approx = cv2.approxPolyDP(c, hue["dice_epsilon"], True)
                if len(approx) == 4:
                    coords = [a[0] for a in approx]
                    d = Die(coords, 0)
                    if (d.isSquare()):
                        color = (0, 200, 0)
                        dice.append(Die(coords, 0, hue["color"]))
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
                            if d.dots < 7:
                                d.dots += 1
                            cv2.drawContours(frame, [approx], 0, (0, 200, 200), 2)
                            cv2.drawContours(maskDots, [approx], 0, (90, 90, 90), 2)

            for d in dice:
                if d.dots == 0:
                    d.dots = 0
                else:
                    d.dots -= 1
            #endregion

            if len(dice) > 0:
                if hue["color"] == "red":
                    values[0] = dice[0].dots
                elif hue["color"] == "green":
                    values[1] = dice[0].dots
                elif hue["color"] == "blue":
                    values[2] = dice[0].dots

        data = str(values)[1:-1]
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
