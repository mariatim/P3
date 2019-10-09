# Python implementation of Boids
# Based on Craig Reynolds “boids” algorithm
# Adapted from Daniel Shiffman's Processing implementation
# https://github.com/CodingTrain/website/tree/master/CodingChallenges/CC_124_Flocking_Boids/Processing/CC124_Flocking_Boids

from pygame import Vector2 as v2

class Boid:

    def __init__(self, position_vector, velocity, acceleration, max_force, max_speed):
        self.position_vector = position_vector
        self.velocity = velocity
        self.acceleration = acceleration
        self.max_force = max_force
        self.max_speed = max_speed



    @classmethod
    def random_boid(cls, width, height) -> 'Boid':
        pass

