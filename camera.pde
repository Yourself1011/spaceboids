class Camera {
    PVector position, velocity, rotation, rotVelocity;
    float qeVelocity = 0; // to make q and e go up and down based on the global axis
    Camera() {
        position = new PVector(0, 0, 0);
        velocity = new PVector(0, 0, 0);
        rotation = new PVector(0, 0);
        rotVelocity = new PVector(0, 0);
    }
    void draw() {
        // update rotation of camera
        rotation.add(rotVelocity);
        rotation.x = constrain(rotation.x, -PI/2, PI/2); // prevent from rotating upside down
        rotation.y %= TWO_PI; // not necessary but nice to have
    
        // update position of camera
        PVector absVelocity = velocity.copy();
        // Rotate the velocity to our current direction. Must be done in two parts since Processing does not have 3D vector rotation
        // Rotate velocity in the y axis
        PVector tempVelocity = new PVector(absVelocity.x, absVelocity.z);
        tempVelocity.rotate(rotation.y);
        absVelocity.x = tempVelocity.x;
        absVelocity.z = tempVelocity.y;
        
        // Rotate velocity in the x axis
        tempVelocity = new PVector(absVelocity.y, absVelocity.z);
        tempVelocity.rotate(-rotation.x);
        absVelocity.y = abs(rotation.y) > PI/2 && abs(rotation.y) < 3*PI/2 ? -tempVelocity.x : tempVelocity.x;
        absVelocity.z = tempVelocity.y;

        absVelocity.y += qeVelocity; // Q and E are relative to the global axis

        position.add(absVelocity.setMag(cameraSpeed));

        // Apply transformations
        beginCamera();
        camera(0, 0, (height/2.0) / tan(PI*30.0 / 180.0), 0, 0, 0, 0, 1, 0);

        translate(0, 0, (height/2.0) / tan(PI*30.0 / 180.0));
        rotateX(rotation.x);
        rotateY(rotation.y);
        translate(position.x, position.y, position.z);
        translate(0, 0, -(height/2.0) / tan(PI*30.0 / 180.0));

        endCamera();
    }
}