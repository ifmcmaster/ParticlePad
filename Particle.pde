public class Particle {

  float pMass;
  float pWidth;
  float pHeight;

  PVector location;
  PVector velocity;
  PVector acceleration;

  float lifeTime;
  boolean fizzle;

  float nFlt;
  float nTime = 0;
  float nInc = 0.01;

  PVector colorTint;
  PImage texture;

  public Particle(float originX, float originY, PVector tint, 
  PImage img) {
    pMass = random(1, 3);
    pWidth = pMass * 5;
    pHeight = pMass * 5;

    location = new PVector(originX, originY);
    velocity = new PVector(random(-2, 2), random(-2, 2));
    acceleration = new PVector(0, 0);

    lifeTime = 255f;
    fizzle = false;

    colorTint = tint;
    texture = img;
  }

  void run() {
    update();
    display();
  }

  void addForce(PVector inputForce) {
    PVector force =  PVector.div(inputForce, (pMass/2));
    acceleration.add(force);
  }

  PVector getLocation() {
    return location;
  }

  void fizzle() {
    fizzle = true;
  }

  void update() {
    if (fizzle) {
      lifeTime -= 3;
      if ((frameCount % 5) == 0) {
        acceleration.x = map(noise(location.x), 0, 1, -5, 5);
        acceleration.y = map(noise(location.y), 0, 1, -5, 5);
      }
    } 
    velocity.add(acceleration);
    location.add(velocity);
    velocity.limit(5);

    acceleration.mult(0);
  }

  void display() {
    imageMode(CENTER);
    tint(colorTint.x, colorTint.y, colorTint.z, lifeTime);
    image(texture, location.x, location.y, pWidth, pHeight);
  }

  boolean isDead() {
    if (lifeTime < 0f) {
      return true;
    } else {
      return false;
    }
  }
}

