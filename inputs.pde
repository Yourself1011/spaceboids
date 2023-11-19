void keyPressed() {
    // Update the camera based on keypresses
    switch (key == CODED ? keyCode : key) {
        case 'w':
            camera.velocity.z += cameraSpeed;
            break;
        case 's':
            camera.velocity.z -= cameraSpeed;
            break;
        case 'a':
            camera.velocity.x += cameraSpeed;
            break;
        case 'd':
            camera.velocity.x -= cameraSpeed;
            break;
        case 'q':
            camera.qeVelocity += cameraSpeed;
            break;
        case 'e':
            camera.qeVelocity -= cameraSpeed;
            break;

        case UP:
            camera.rotVelocity.x += radians(cameraRotSpeed);
            break;
        case DOWN:
            camera.rotVelocity.x -= radians(cameraRotSpeed);
            break;
        case LEFT:
            camera.rotVelocity.y -= radians(cameraRotSpeed);
            break;
        case RIGHT:
            camera.rotVelocity.y += radians(cameraRotSpeed);
            break;
            
    }
}

void keyReleased() {
    // Update the camera based on keyreleases
    switch (key == CODED ? keyCode : key) {
        case 'w':
            camera.velocity.z -= cameraSpeed;
            break;
        case 's':
            camera.velocity.z += cameraSpeed;
            break;
        case 'a':
            camera.velocity.x -= cameraSpeed;
            break;
        case 'd':
            camera.velocity.x += cameraSpeed;
            break;
        case 'q':
            camera.qeVelocity -= cameraSpeed;
            break;
        case 'e':
            camera.qeVelocity += cameraSpeed;
            break;


        case UP:
            camera.rotVelocity.x -= radians(cameraRotSpeed);
            break;
        case DOWN:
            camera.rotVelocity.x += radians(cameraRotSpeed);
            break;
        case LEFT:
            camera.rotVelocity.y += radians(cameraRotSpeed);
            break;
        case RIGHT:
            camera.rotVelocity.y -= radians(cameraRotSpeed);
            break;
    }
}

void mousePressed() {
    // Add a new boid
    boids.add(new Boid(-camera.position.x, -camera.position.y, -camera.position.z + (height/2.0) / tan(PI*30.0 / 180.0)));
}