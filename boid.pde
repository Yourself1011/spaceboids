class Boid {
    PVector position, 
        velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1)), 
        acceleration = new PVector(0, 0, 0);
    float scale = random(boidSizeMin, boidSizeMax);
    color c = color(random(0, 255), random(0, 255), random(0, 255)); // Any random color

    Boid(float x, float y, float z) {
        position = new PVector(x, y, z);
    }

    void addToAcceleration(PVector vector, float mult) {
        // Add a value to acceleration, at the boid speed
        acceleration.add(vector.setMag(boidSpeed).mult(mult));
    }

    void updatePosition() {
        // Update the position of the boid before drawing
        PVector separation = new PVector(0, 0, 0), 
            cohesion = new PVector(0, 0, 0), 
            alignment = new PVector(0, 0, 0),
            obstacleForce = new PVector(0, 0, 0);

        float sepCount = 0, obsCount = 0, cohesionCount = 0; //cohesion and alignment can use the same count variable

        for (Boid boid : boids) {
            PVector thisToTarget = PVector.sub(position, boid.position);
            if (thisToTarget.mag() == 0) continue; // Don't calculate for this boid

            // separation
            if (thisToTarget.mag() < sepDistance) {
                sepCount++;
                float distFactor = pow(max(0, 1 - thisToTarget.mag() / sepDistance), 2);
                separation.add(thisToTarget.mult(distFactor));
            }

            if (thisToTarget.mag() < sightDistance) {
                cohesionCount++;
                // cohesion
                cohesion.add(thisToTarget);

                // alignment
                alignment.add(boid.velocity);
            }
        }

        for (Obstacle obstacle : obstacles) {
            PVector thisToTarget = PVector.sub(position, obstacle.position);
            if (thisToTarget.mag() < obstacle.radius + obsDistance) {
                obsCount++;
                float distFactor = pow(max(0, 1 - (thisToTarget.mag() + obstacle.radius) / (obstacle.radius + obsDistance)), 2);
                obstacleForce.add(thisToTarget.mult(distFactor));
            }
        }

        addToAcceleration(forceFromWalls(position), -wallStrength);

        // Add the average of these forces
        if (sepCount > 0) {
            addToAcceleration(separation.div(sepCount), sepStrength);
        }
        
        if (obsCount > 0) {
            addToAcceleration(obstacleForce.div(obsCount), obsStrength);
        }

        if (cohesionCount > 0) {
            addToAcceleration(cohesion.div(cohesionCount), -cohesionStrength);
            addToAcceleration(alignment.div(cohesionCount), alignStrength);
        }

        // Update velocity and position
        velocity.add(acceleration.limit(turnSpeed));
        velocity.limit(boidSpeed);
        position.add(velocity);
    }

    void draw() {
        fill(c);
        // stroke(255);
        noStroke();
        pushMatrix();

        translate(position.x, position.y, position.z);

        // Calculate how much the shape needs to rotate to face its velocity
        PVector toRotate = new PVector(atan(velocity.y/velocity.z), atan(velocity.x/velocity.z), atan(velocity.y/velocity.x));

        if (!Float.isNaN(toRotate.z)) rotateZ(toRotate.z);
        if (!Float.isNaN(toRotate.x)) rotateX(toRotate.x);
        if (!Float.isNaN(toRotate.y)) rotateY(velocity.z >= 0 ? toRotate.y : toRotate.y + PI);

        // Drawing the shape
        beginShape();
            vertex(-0.5 * scale, -0.5 * scale, -0.5 * scale);
            vertex(0, 0, 0.5 * scale);
            vertex(-0.5 * scale, 0.5 * scale, -0.5 * scale);
            vertex(-0.5 * scale, -0.5 * scale, -0.5 * scale);
        endShape(CLOSE);
        beginShape();
            vertex(-0.5 * scale, 0.5 * scale, -0.5 * scale);
            vertex(0, 0, 0.5 * scale);
            vertex(0.5 * scale, 0.5 * scale, -0.5 * scale);
            vertex(-0.5 * scale, 0.5 * scale, -0.5 * scale);
        endShape(CLOSE);
        beginShape();
            vertex(0.5 * scale, 0.5 * scale, -0.5 * scale);
            vertex(0, 0, 0.5 * scale);
            vertex(0.5 * scale, -0.5 * scale, -0.5 * scale);
            vertex(0.5 * scale, 0.5 * scale, -0.5 * scale);
        endShape(CLOSE);
        beginShape();
            vertex(0.5 * scale, -0.5 * scale, -0.5 * scale);
            vertex(0, 0, 0.5 * scale);
            vertex(-0.5 * scale, -0.5 * scale, -0.5 * scale);
            vertex(0.5 * scale, -0.5 * scale, -0.5 * scale);
        endShape(CLOSE);
        beginShape();
            vertex(-0.5 * scale, -0.5 * scale, -0.5 * scale);
            vertex(0.5 * scale, -0.5 * scale, -0.5 * scale);
            vertex(0.5 * scale, 0.5 * scale, -0.5 * scale);
            vertex(-0.5 * scale, 0.5 * scale, -0.5 * scale);
        endShape(CLOSE);

        //reset acceleration for the next frame
        acceleration.set(0, 0, 0);

        // "reset" transformations made for this boid
        popMatrix();
    }
}

PVector forceFromWalls(PVector position) {
    PVector force = new PVector(0, 0, 0);
    float wallsInProximity = 0;

    // X walls
    if (position.x + halfBorderLength < wallDistance) {
        float distFactor = pow(max(0, 1 - (position.x - halfBorderLength) / wallDistance), 2);
        force.add((position.x - halfBorderLength) * distFactor, 0, 0);
        wallsInProximity++;
    } else if (position.x - halfBorderLength > -wallDistance) {
        float distFactor = pow(max(0, 1 - (position.x + halfBorderLength) / -wallDistance), 2);
        force.add((position.x + halfBorderLength) * distFactor, 0, 0);
        wallsInProximity++;
    }

    // Y walls
    if (position.y + halfBorderLength < wallDistance) {
        float distFactor = pow(max(0, 1 - (position.y - halfBorderLength) / wallDistance), 2);
        force.add(0, (position.y - halfBorderLength) * distFactor, 0);
        wallsInProximity++;
    } else if (position.y - halfBorderLength > -wallDistance) {
        float distFactor = pow(max(0, 1 - (position.y + halfBorderLength) / -wallDistance), 2);
        force.add(0, (position.y + halfBorderLength) * distFactor, 0);
        wallsInProximity++;
    }

    // Z walls
    if (position.z + halfBorderLength < wallDistance) {
        float distFactor = pow(max(0, 1 - (position.z - halfBorderLength) / wallDistance), 2);
        force.add(0, 0, (position.z - halfBorderLength) * distFactor);
        wallsInProximity++;
    } else if (position.z - halfBorderLength > -wallDistance) {
        float distFactor = pow(max(0, 1 - (position.z + halfBorderLength) / -wallDistance), 2);
        force.add(0, 0, (position.z + halfBorderLength) * distFactor);
        wallsInProximity++;
    }

    // return average of forces
    return wallsInProximity == 0 ? force : force.div(wallsInProximity);
}