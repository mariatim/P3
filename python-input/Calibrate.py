# Import libraries (OpenCV, Die object)
import cv2
import numpy as np
from die import Die
from datetime import datetime
from statistics import mean

video = cv2.VideoCapture(0)
dice = []

# Trackbar windows to figure out the thresholds and stuff
#region

def nothing(x):
    pass

def TB(name, window, convert=False):
    windowName = "Dice" if window == 1 else "Dots"
    if convert == True:
        return colorConv(cv2.getTrackbarPos(name, windowName), name[-1])
    else:
        return cv2.getTrackbarPos(name, windowName)

def colorConv(value, param):
    ratio = 0.5 if param == "H" else 2.55
    return value*ratio


def populateTBArray():
    arr = []
    arr.append("Dice:")
    arr.append("L-H: " + str(TB("L-H", 1)))
    arr.append("L-S: " + str(TB("L-S", 1)))
    arr.append("L-V: " + str(TB("L-V", 1)))
    arr.append("U-H: " + str(TB("U-H", 1)))
    arr.append("U-S: " + str(TB("U-S", 1)))
    arr.append("U-V: " + str(TB("U-V", 1)))
    arr.append("Epsilon: " + str(TB("Epsilon", 1)))
    arr.append("Dilate: " + str(TB("Dilate", 1)))
    arr.append("Erode: " + str(TB("Erode", 1)))
    arr.append("Open/Close: " + str(TB("Open/Close", 1)))
    arr.append("BL-D: " + str(TB("BL-D", 1)))
    arr.append("BL-sColor: " + str(TB("BL-sColor", 1)))
    arr.append("BL-sSpace: " + str(TB("BL-sSpace", 1)))
    arr.append("\nDots:")
    arr.append("Epsilon: " + str(TB("Epsilon", 2)))
    arr.append("Dilate: " + str(TB("Dilate", 2)))
    arr.append("Erode: " + str(TB("Erode", 2)))
    arr.append("Open/Close: " + str(TB("Open/Close", 2)))
    arr.append("Blur: " + str(TB("Blur", 2)))
    arr.append("Treshold: " + str(TB("Threshold", 2)))
    return arr


def saveColorToFile(clr):
    arr = populateTBArray()

    valueFile = open("python-input/values.txt", "a+")
    print("----------", file=valueFile)

    now = datetime.now()
    now = now.strftime("%d/%m/%Y, %H:%M:%S")
    print(now, file=valueFile)

    print("Red" if clr == 'r' else "Green" if clr == 'g' else "Blue", file=valueFile)


    for item in arr:
        print(item, file=valueFile)

    valueFile.close()

    print(clr, "extracted successfully into values.txt")

cv2.namedWindow("Dice")
cv2.resizeWindow("Dice", 500, 600)
cv2.createTrackbar("L-H", "Dice", 105, 360, nothing)
cv2.createTrackbar("L-S", "Dice", 20, 100, nothing)
cv2.createTrackbar("L-V", "Dice", 8, 100, nothing)
cv2.createTrackbar("U-H", "Dice", 185, 360, nothing)
cv2.createTrackbar("U-S", "Dice", 75, 100, nothing)
cv2.createTrackbar("U-V", "Dice", 60, 100, nothing)
cv2.createTrackbar("Epsilon", "Dice", 25, 50, nothing)
cv2.createTrackbar("Dilate", "Dice", 19, 50, nothing)
cv2.createTrackbar("Erode", "Dice", 3, 50, nothing)
cv2.createTrackbar("Open/Close", "Dice", 1, 1, nothing)
cv2.createTrackbar("BL-D", "Dice", 15, 100, nothing)
cv2.createTrackbar("BL-sColor", "Dice", 140, 200, nothing)
cv2.createTrackbar("BL-sSpace", "Dice", 100, 200, nothing)

cv2.namedWindow("Dots")
cv2.resizeWindow("Dots", 500, 250)
cv2.createTrackbar("Epsilon", "Dots", 1, 50, nothing)
cv2.createTrackbar("Dilate", "Dots", 9, 50, nothing)
cv2.createTrackbar("Erode", "Dots", 2, 50, nothing)
cv2.createTrackbar("Open/Close", "Dots", 1, 1, nothing)
cv2.createTrackbar("Blur", "Dots", 5, 16, nothing)
cv2.createTrackbar("Threshold", "Dots", 75, 250, nothing)
#endregion

maskDice = None
maskDots = None

# Output
while True:
    _, frame = video.read()
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    #IMAGE PROCESSING DICE
    #region
    lower_threshold = np.array(
        [TB("L-H", 1, True),
         TB("L-S", 1, True),
         TB("L-V", 1, True)])
    upper_threshold = np.array(
        [TB("U-H", 1, True),
         TB("U-S", 1, True),
         TB("U-V", 1, True)])

    maskDice = cv2.inRange(hsv, lower_threshold, upper_threshold)
    maskDots = maskDice
    maskDice = cv2.bilateralFilter(maskDice, TB("BL-D", 1), TB("BL-sColor", 1), TB("BL-sSpace", 1))

    if TB("Open/Close", 1) == 0:
        maskDice = cv2.erode(maskDice, np.ones((TB("Erode", 1), TB("Erode", 1)), np.uint8))
        maskDice = cv2.dilate(maskDice, np.ones((TB("Dilate", 1), TB("Dilate", 1)), np.uint8))
    elif TB("Open/Close", 1) == 1:
        maskDice = cv2.dilate(maskDice, np.ones((TB("Dilate", 1), TB("Dilate", 1)), np.uint8))
        maskDice = cv2.erode(maskDice, np.ones((TB("Erode", 1), TB("Erode", 1)), np.uint8))
    #endregion

    #IMAGE PROCESSING DOTS
    #region
    _, maskDots = cv2.threshold(maskDots, TB("Threshold", 2), 255, cv2.THRESH_BINARY)
    
    if TB("Open/Close", 2) == 0:
        maskDots = cv2.erode(maskDots, np.ones((TB("Erode", 2), TB("Erode", 2)), np.uint8))
        maskDots = cv2.dilate(maskDots, np.ones((TB("Dilate", 2), TB("Dilate", 2)), np.uint8))
    elif TB("Open/Close", 2) == 1:
        maskDots = cv2.dilate(maskDots, np.ones((TB("Dilate", 2), TB("Dilate", 2)), np.uint8))
        maskDots = cv2.erode(maskDots, np.ones((TB("Erode", 2), TB("Erode", 2)), np.uint8))
    #endregion

    # Find contours and draw them
    #region Dice
    contours, _ = cv2.findContours(
        maskDice, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    dice = []
    for c in contours:
        approx = cv2.approxPolyDP(c, TB("Epsilon", 1), True)
        if len(approx) == 4:
            coords = [a[0] for a in approx]
            d = Die(coords, 0)
            if (d.isSquare()):
                color = (0, 200, 0)
            else:
                color = (200, 0, 0)
            dice.append(Die(coords, 0, "blue"))
            cv2.drawContours(frame, [approx], 0, color, 2)
            cv2.drawContours(maskDice, [approx], 0, (90, 90, 90), 2)
            cv2.circle(frame, tuple(d.roundedCenter), int(
                mean([min(d.centerDistances), max(d.centerDistances)])), (0, 0, 255), 3)
    #endregion
    #region Dots
    contours, _ = cv2.findContours(
        maskDots, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)

    for c in contours:
        approx = cv2.approxPolyDP(c, TB("Epsilon", 2), True)
        if len(approx) > 4:
            x, y, w, h = cv2.boundingRect(approx)
            x2 = x + w
            y2 = y + h
            for d in dice:
                if (d.isBelongs([x, x2], [y, y2])):
                    d.dots += 1
                    cv2.drawContours(frame, [approx], 0, (0, 200, 200), 2)
                    cv2.drawContours(maskDots, [approx], 0, (90, 90, 90), 2)

    if len(dice) < 3:
        for i in range(len(dice), 3):
            dice.append(Die())
    for d in dice:
        if d.dots == 0:
            d.dots = 0
        else:
            d.dots = d.dots -1

    data = ', '.join([d.color + ": " + str(d.dots) for d in dice])
    #endregion

    dicePoints = ', '.join([str(d.dots) for d in dice])
    cv2.putText(frame, dicePoints, (50, 100),
                cv2.FONT_HERSHEY_COMPLEX, 2, (255, 255, 255), 3)

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
    elif key == 8:
        rawInput = input("Enter values as (Hue, Saturation, Value)")
        splitInput = rawInput.split(",")
        splitInput = [int(a) for a in splitInput]
        cv2.setTrackbarPos("L-H", "Dice", splitInput[0]-20 if splitInput[0] > 20 else 0)
        cv2.setTrackbarPos("U-H", "Dice", splitInput[0]+20 if splitInput[0] < 340 else 360)
        cv2.setTrackbarPos("L-S", "Dice", splitInput[1]-40 if splitInput[1] > 40 else 0)
        cv2.setTrackbarPos("U-S", "Dice", splitInput[1]+40 if splitInput[1] < 60 else 100)
        cv2.setTrackbarPos("L-V", "Dice", splitInput[2]-20 if splitInput[2] > 20 else 0)
        cv2.setTrackbarPos("U-V", "Dice", splitInput[2]+20 if splitInput[2] < 80 else 100)
    elif key == 13:
        arr = populateTBArray()
        for item in arr:
            print(item)
    elif key == 114:
        saveColorToFile('r')
    elif key == 103:
        saveColorToFile('g')
    elif key == 98:
        saveColorToFile('b')

video.release()
cv2.destroyAllWindows()
