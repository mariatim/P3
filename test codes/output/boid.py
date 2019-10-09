# Python implementation of Boids
# Based on Craig Reynolds “boids” algorithm
# Adapted from Daniel Shiffman's Processing implementation
# https://github.com/CodingTrain/website/tree/master/CodingChallenges/CC_124_Flocking_Boids/Processing/CC124_Flocking_Boids

from pygame import Vector2
import random
import pygame

class Boid:

    def __init__(self, position_vector, velocity, acceleration, max_force, max_speed):
        self.position_vector = position_vector
        self.velocity = velocity
        self.acceleration = acceleration
        self.max_force = max_force
        self.max_speed = max_speed

    @classmethod
    def random_boid(cls, width, height) -> 'Boid':
        #TODO change randint to random (to get float)
        return cls(position_vector= Vector2(random.randint(0, width), random.randint(0, height)),
                   velocity=random.randint(0, 2),
                   acceleration=random.randint(0, width),
                   max_force=3,
                   max_speed=3)

    def edges(self, width, height):
        if (self.position_vector.x > width):
            self.position_vector.x = 0
        elif(self.position_vector.x < 0):
            self.position_vector.x = width

        if(self.position_vector.y > height):
            self.position_vector.y = 0
        elif(self.position_vector.y < 0):
            self.position_vector.y = height

    def align(self, *args):
        pass

    def separation(self, *args):
        pass

    def cohesion(self, *args):
        pass

    def flock(self, *args):
        pass

    def update(self):
        pass

    def show(self, window, color, x, y, width):
        pygame.draw.circle(window, color, (x, y), width)


