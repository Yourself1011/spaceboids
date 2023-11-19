ArrayList<Boid> boids = new ArrayList<Boid>();
Camera camera = new Camera();
Obstacle[] obstacles;
Asteroid[] asteroids;
PImage asteroidTexture;
PShape space;

// Play around with these values
String spawn = "center"; // "random" or "center"
float cameraSpeed = 5; // speed of camera
float cameraRotSpeed = 2; // rotation speed of camera
float borderLength = 2000; // The size of the bounding box for the simulation
float halfBorderLength = borderLength / 2;
int initPopulation = 200;
int asteroidCount = 10; // boids will try to avoid hitting asteroids
float asteroidSpeed = 0.5;
boolean cameraRepulsion = false; // whether the camera repels boids

float boidSizeMin = 5;
float boidSizeMax = 15; // The random ranges a boid's size can be. Set these to the same value to make all boids have the same size
float boidSpeed = 5; 
float turnSpeed = 0.1; // how fast a boid can turn (0-1)
// strength/weights of rules
float wallStrength = 20;
float obsStrength = 2;
float sepStrength = 1.5;
float alignStrength = 1;
float cohesionStrength = 1;

float wallDistance = 100; // Boids will try to keep this distance from the border
float obsDistance = 250; // Boids will try to keep this distance from obstacles
float sepDistance = 50; // Boids will try to keep this distance from each other's centres
float sightDistance = 250; // Boids will try to cohere and align with other boids at this distance

void setup() {
    size(1400, 800, P3D);
    perspective();

    // add boids
    for (int i = 0; i < initPopulation; ++i) {
        if (spawn.equals("random")) {
            boids.add(new Boid(random(-halfBorderLength, halfBorderLength), random(-halfBorderLength, halfBorderLength), random(-halfBorderLength, halfBorderLength)));
        } else if (spawn.equals("center")) {
            boids.add(new Boid(random(-1, 1), random(-1, 1), random(-1, 1)));
        }
    }

    // Add obstacles
    asteroidTexture = loadImage("asteroid.jpeg");
    obstacles = new Obstacle[asteroidCount + 1 + (cameraRepulsion ? 1 : 0)]; // +1 if camera repels, +1 for instructions to repel
    asteroids = new Asteroid[asteroidCount];

    for (int i = 0; i < asteroidCount; ++i) {
        Asteroid asteroid = new Asteroid(
            new PVector(random(-halfBorderLength, halfBorderLength), random(-halfBorderLength, halfBorderLength), random(-halfBorderLength, halfBorderLength)), // place it anywhere in the box
            new PVector(random(-1, 1), random(-1, 1), random(-1, 1)).setMag(asteroidSpeed), // make it go in a random direction
            random(50, 100), 
            asteroidTexture,
            i
        );
        obstacles[i] = asteroid;
        asteroids[i] = asteroid;
    }

    // add obstacle for instructions in the middle and for camera if it is enabled
    obstacles[asteroidCount] = new Obstacle(new PVector(0, 0, 0), 50);

    if (cameraRepulsion) {
        obstacles[asteroidCount + 1] = new Obstacle(camera.position, (height/2.0) / tan(PI*30.0 / 180.0) /** depth of camera */);
    }

    // Sky
    PImage spaceTexture = loadImage("space.jpeg");
    space = createShape(SPHERE, borderLength * 2);
    space.setTexture(spaceTexture);
    space.setFill(color(255));
    space.setStroke(false);
    space.rotateX(random(0, 2*PI));
    space.rotateY(random(0, 2*PI));
    space.rotateZ(random(0, 2*PI));
}

void draw() {
    background(0);
    lights();
    camera.draw();

    // Update the camera obstacle position
    if (cameraRepulsion) {
        obstacles[asteroidCount + 1].updatePosition(camera.position);
    }

    // "Save" the transformations made by the camera
    pushMatrix();

    for (Boid boid: boids) {
        boid.updatePosition();
        boid.draw();
    }

    // draw asteroids
    for (Asteroid asteroid : asteroids) {
        asteroid.draw();
    }

    // boundary
    noFill();
    // fill(66, 135, 245, 25);
    stroke(255);
    box(borderLength);

    // Instructions
    textAlign(CENTER);
    fill(255);
    text("WASDQE to move\nArrow keys to rotate\nClick to spawn new boid", 10, 10);

    // draw space
    shape(space);

    // remove the camera matrix from the stack for the next frame
    popMatrix();
}
