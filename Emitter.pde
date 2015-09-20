public class Emitter {

  PVector emitLocation;

  int listLength;

  ArrayList<Particle> particleList;
  Particle currentParticle;
  
  PVector particleTint;

  PImage particleTexture;

  public Emitter(PVector location, PVector tint, String texture) {
    emitLocation = location;
    particleList = new ArrayList<Particle>();
    particleTexture = loadImage(texture);
    particleTint = tint;
  }

  PVector getLocation() {
    return emitLocation;
  }

  void emit(PVector location, int count) {
    for (int i = 0; i < count; i++) {
      addParticle(location);
    }
  }

  void clear() {
    for (int i = particleList.size ()-1; i >= 0; i--) {
      particleList.remove(i);
    }
  }
  
  void fizzleParticles() {
    for(int i = particleList.size()-1; i>=0; i--) {
      particleList.get(i).fizzle();
    }
  }


  void addParticle(PVector location) {
    particleList.add(new Particle(location.x + random(-5, 5), 
    location.y + random(-5, 5), particleTint, particleTexture));
  }

  void addForce(PVector inputForce, float magnitude, boolean natural) {
    PVector force;
    for (int i = particleList.size ()-1; i >= 0; i--) {
      force = PVector.sub(inputForce, particleList.get(i).getLocation());
      force.setMag(magnitude);
      particleList.get(i).addForce(force);
    }
  }

  void update() {
    for (int i = particleList.size ()-1; i >= 0; i-- ) {
      currentParticle = particleList.get(i);
      currentParticle.update();
      if (currentParticle.isDead()) {
        particleList.remove(i);
      } else {
        currentParticle.display();
      }
    }
  }
}

