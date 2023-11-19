class Obstacle {
    float radius;
    PVector position;
    Obstacle(PVector initPosition, float initRadius) {
        position = initPosition;
        radius = initRadius;
    }

    void updatePosition(PVector newPosition) {
        position = newPosition;
    }
}

class Asteroid extends Obstacle {
    PImage texture;
    PShape shape;
    PVector velocity;
    int index;
    Asteroid(PVector initPosition, PVector initVelocity, float initRadius, PImage initTexture, int initIndex) {
        super(initPosition, initRadius);
        texture = initTexture;
        velocity = initVelocity;
        index = initIndex;

        shape = createShape(SPHERE, radius); // Cannot be a normal sphere to add a texture
        shape.setTexture(texture);
        shape.setStroke(false);
        shape.setFill(color(255));
        shape.rotateX(random(0, 2*PI));
        shape.rotateY(random(0, 2*PI));
        shape.rotateZ(random(0, 2*PI));
    }

    void draw() {
        position.add(velocity);
        if (
            position.x > halfBorderLength + radius + 100 || position.x < -halfBorderLength - radius - 100 ||
            position.y > halfBorderLength + radius + 100 || position.y < -halfBorderLength - radius - 100 ||
            position.z > halfBorderLength + radius + 100 || position.z < -halfBorderLength - radius - 100
        ) {
            PVector newPosition = new PVector(random(-halfBorderLength, halfBorderLength), random(-halfBorderLength, halfBorderLength), random(-halfBorderLength, halfBorderLength));
            PVector newVelocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
            int multiplier = int(random(0, 1)) * 2 - 1; // -1 or 1

            // move it to one face
            switch (int(random(0, 3))) {
                case 0:
                    newPosition.x = halfBorderLength * multiplier;
                    newVelocity.x = -multiplier;
                    break;
                case 1:
                    newPosition.y = halfBorderLength * multiplier;
                    newVelocity.y = -multiplier;
                    break;
                case 2:
                    newPosition.z = halfBorderLength * multiplier;
                    newVelocity.z = -multiplier;
                    break;
            }
            

            Asteroid newAsteroid = new Asteroid(
                newPosition, 
                newVelocity.setMag(asteroidSpeed),
                random(50, 100), 
                asteroidTexture,
                index
                );
            asteroids[index] = newAsteroid;
            obstacles[index] = newAsteroid;
        }

        pushMatrix();
        translate(position.x, position.y, position.z);
        shape(shape);
        popMatrix();
    }
}