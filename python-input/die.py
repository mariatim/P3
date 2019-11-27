from scipy.spatial import distance as dist

class Die:
    def __init__(self, _coords = None, _dots = 1, _color="undefined"):
        self.coords = _coords
        self.dots = _dots
        self.color = _color

        if self.coords != None:
            self.a = self.coords[0]
            self.b = self.coords[1]
            self.c = self.coords[2]
            self.d = self.coords[3]

            self.x = tuple([coor[0] for coor in self.coords])
            self.y = tuple([coor[1] for coor in self.coords])

            self.xSpan = (min(self.x), max(self.x))
            self.ySpan = (min(self.y), max(self.y))
            self.center = (sum(self.x)/len(self.x), sum(self.y)/len(self.y))
            self.roundedCenter = tuple([int(c) for c in self.center])
            self.width = abs(self.xSpan[1]-self.xSpan[0])
            self.height = abs(self.xSpan[1]-self.xSpan[0])
            self.distances = (dist.euclidean(self.a, self.b),
                                dist.euclidean(self.b, self.c),
                                dist.euclidean(self.c, self.d),
                                dist.euclidean(self.d, self.a))
            self.centerDistances = tuple(map(lambda x : dist.euclidean(x, self.center), self.coords))
            self.maxCenterDistance = max(self.centerDistances)
            self.minCenterDistance = min(self.centerDistances)

    def isSquare(self):
        return True if abs(min(self.distances)-max(self.distances)) < min(self.distances)/3 else False

    def isBelongs(self, dotCoordsX, dotCoordsY):
        response = True
        for dcx in dotCoordsX:
            if not (self.xSpan[0] < dcx < self.xSpan[1]):
                return False
        for dcy in dotCoordsY:
            if not (self.ySpan[0] < dcy < self.ySpan[1]):
                return False
        return True

    def value(self):
        return self.color + ": " + str(self.dots)
