# Import libraries (OpenCV, Die object)
import cv2
from die import Die

# Set up an array for the Die objects
dice = []

# Load the image and process it for the CV to have it easier to analyse
img = cv2.imread('dice.png')
cv2.medianBlur(img, 5, img)
imgGrey = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# Set the threshold to the image, change it to binary (either black or white); find the contours
temp, thresholdDice = cv2.threshold(imgGrey, 250, 255, cv2.THRESH_BINARY)
contoursDice, temp = cv2.findContours(thresholdDice, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

# For every contour: make an approximate shape, if the shape has more than 4 points,
# consider it as a cube - draw an outline, set the coords and make an instance of the Die object
for c in contoursDice:
    approx = cv2.approxPolyDP(c, 0.01*cv2.arcLength(c, True), True)
    if len(approx) > 4:
        cv2.drawContours(img, [approx], 0, (0, 0, 0), 5)
        x, y, w, h = cv2.boundingRect(approx)
        x2, y2 = x+w, y+h
        dice.append(Die(x, y, x2, y2, 0))

# Set the new threshold, now focusing on the dots; find the contours
temp, thresholdDots = cv2.threshold(imgGrey, 135, 155, cv2.THRESH_BINARY)
contoursDots, temp = cv2.findContours(thresholdDots, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

# For every dot, find the approximate, if the shape has more than 10 points, draw an outline,
# go through all the dice and check the coords to see within which one the dot lies,
# add the dot into the Die object
for c in contoursDots:
    approx = cv2.approxPolyDP(c, 0.01*cv2.arcLength(c, True), True)
    if len(approx) > 10:
        cv2.drawContours(img, [approx], 0, (255, 0, 0), 5)

        for d in dice:
            if (x > d.xb and x < d.xe and y > d.yb and y < d.ye):
                d.dots += 1

# Parse the dot amount into a string and draw it into the die
for d in dice:
    dotsInString = str(d.dots)
    cv2.putText(img, dotsInString, (d.xb+20, d.yb+20), cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 0, 0))

# Draw the processed image
cv2.imshow("shapes", img)
cv2.waitKey(0)
cv2.destroyAllWindows()
