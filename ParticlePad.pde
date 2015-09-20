/*
 * Particle Pad
 * Author: Ian McMaster
 *
 * Use it to make pretty things
 */

import themidibus.*;
import com.rngtng.launchpad.*;

Emitter testEmitter;

PadControl padControl;
Launchpad launchpad;
byte[] data = new byte[64];

int particleCount;
float vectorMagnitude;
int trailAlpha;

Emitter[][] emitters;
int emitterCount;

PVector[] tintArray = {
  new PVector(255, 0, 0), 
  new PVector(0, 255, 0), 
  new PVector(0, 0, 255), 
  new PVector(0, 127, 255), 
  new PVector(90, 255, 90), 
  new PVector(255, 127, 0), 
  new PVector(255, 255, 255), 
  new PVector(50, 156, 145), 
  new PVector(178, 143, 34)
  };
  ;


PVector mousV;
PVector gravitator;
PVector toGravitator;
PVector[][] gravitators = new PVector[6][6];

boolean mouseMode;
boolean triggerMode;
Emitter triggerEmitter;

void setup() {
  size(800, 800, P2D);
  noCursor();
  filter(BLUR); 
  MidiBus.list();
  launchpad = new Launchpad(this, "Launchpad", "Launchpad");
  padControl = new PadControl(launchpad);
  PVector location = new PVector(width/2, height/2);

  gravitator = new PVector(width/2, height/2);
  toGravitator = gravitator;

  emitters = new Emitter[3][3];
  emitterCount = 9;

  int colorIndex = 0;
  for (int y = 0; y < 3; y++) {
    for (int x = 0; x < 3; x++) {
      emitters[x][y] = new Emitter(new PVector((x+1)*(width/4), (y+1)*(width/4)), 
      tintArray[colorIndex], "particle1.png");
      colorIndex++;
    }
  }

  for (int y = 0; y < 6; y++) {
    for (int x = 0; x < 6; x++) {
      gravitators[x][y] = new PVector((x+1)*(width/6), (y+1)*(width/6));
    }
  }

  testEmitter = new Emitter(location, new PVector(0, 255, 0), "particle1.png");

  particleCount = 5;
  vectorMagnitude = 0.1;
  trailAlpha = 50;

  mouseMode = false;

  padControl.displayValues(particleCount, vMagToGrid(vectorMagnitude), tAlphaToGrid(trailAlpha));

  background(0);
  smooth();
}

void draw() {
  //  background(0);
  blendMode(BLEND);
  fill(255);
  textSize(8);
  text("FPS: " + frameRate, 0, 8);
  noStroke();
  fill(0, 0, 0, trailAlpha);
  rect(0, 0, width, height);

  blendMode(ADD);
  gravitator.x = lerp(gravitator.x, toGravitator.x, 0.1);
  gravitator.y = lerp(gravitator.y, toGravitator.y, 0.1);
  rect(gravitator.x, gravitator.y, 20, 20);

  if (triggerMode == true) {
    triggerEmitter.emit(triggerEmitter.getLocation(), particleCount);
  }

  if (mouseMode == true) {
    mousV = new PVector(mouseX, mouseY);
    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        emitters[x][y].addForce(mousV, vectorMagnitude, false);
        emitters[x][y].update();
      }
    }
  } else {
    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        emitters[x][y].addForce(gravitator, vectorMagnitude, false);
        emitters[x][y].update();
      }
    }
  }

  testEmitter.addForce(mousV, vectorMagnitude, false);
  testEmitter.update();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      testEmitter.emit(testEmitter.getLocation(), particleCount);
    }

    if (keyCode == LEFT) {
      testEmitter.fizzleParticles();
    }

    if (keyCode == DOWN) {
      testEmitter.clear();
    }
  }
}

void setParticleCount(int pCount) {
  particleCount = 8 - pCount;
}

void setVectorMagnitude(int vMag) {
  vectorMagnitude = gridToVMag(vMag);
}

void setTrailAlpha(int tAlpha) {
  trailAlpha = gridToTAlpha(tAlpha);
}

int vMagToGrid(float vMag) {
  int tempVMag = (int) (vMag * 1000);
  switch(tempVMag) {
  case 1: 
    return 1;
  case 25: 
    return 2;
  case 50: 
    return 3;
  case 100: 
    return 4;
  case 500: 
    return 5;
  case 1000: 
    return 6;
  case 2000: 
    return 7;
  case 5000: 
    return 8;
  }

  return 7;
}

float gridToVMag(int vMag) {
  switch(vMag) {
  case 0: 
    return 5f;
  case 1: 
    return 2f;
  case 2: 
    return 1f;
  case 3: 
    return .5f;
  case 4: 
    return .1f;
  case 5: 
    return .05f;
  case 6: 
    return .025f;
  case 7: 
    return .001f;
  }

  return .1f;
}

int tAlphaToGrid(int tAlpha) {
  switch(tAlpha) {
  case 255: 
    return 1;
  case 200: 
    return 2;
  case 150: 
    return 3;
  case 100: 
    return 4;
  case 50: 
    return 5;
  case 15: 
    return 6;
  case 5: 
    return 7;
  case 0: 
    return 8;
  }

  return 1;
}

int gridToTAlpha(int tAlpha) {
  switch(tAlpha) {
  case 0: 
    return 0;
  case 1: 
    return 5;
  case 2: 
    return 15;
  case 3: 
    return 50;
  case 4: 
    return 100;
  case 5: 
    return 150;
  case 6: 
    return 200;
  case 7: 
    return 255;
  }

  return 0;
}


public void launchpadGridPressed(int x, int y) {
  if (x < 3) {
    padControl.setValues(x, y, this);
    println("VARIABLES: ", particleCount, vectorMagnitude, trailAlpha);
    padControl.displayValues(particleCount, vMagToGrid(vectorMagnitude), tAlphaToGrid(trailAlpha));
  }
  if ((x > 2) && (y < 5)) {
    toGravitator = gravitators[x-3][y];
    padControl.gridPressed(x, y);
  }
  if ((x > 2) && (x < 6) && (y > 4)) {
    int cX = x-3;
    int cY = y-5;

    triggerEmitter = emitters[x-3][y-5];

    emitters[x-3][y-5].emit(emitters[x-3][y-5].getLocation(), particleCount);
    padControl.gridPressed(x, y);
  }
  if ((x == 7) && (y == 5)) {
    if (!triggerMode) {
      triggerMode = true;
      println("TRIGGER MODE: ON");
    } else {
      triggerMode = false;
      println("TRIGGER MODE: OFF");
    }
    padControl.gridPressed(x, y);
  }
  if ((x == 7) && (y == 6)) {
    if (!mouseMode) {
      mouseMode = true;
      println("MOUSE MODE: ON");
    } else {
      mouseMode = false;
      println("MOUSE MODE: OFF");
    }
    padControl.gridPressed(x, y);
  }
  if ((x == 7) && (y == 7)) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        emitters[j][i].fizzleParticles();
      }
    }
    padControl.gridPressed(x, y);
  }
}

public void launchpadGridReleased(int x, int y) {
  if ((x > 2) && !((x==7) && ((y==5) || (y==6)))) {
    padControl.gridReleased(x, y);
  }
}

void stop() {
  launchpad.reset();
}

