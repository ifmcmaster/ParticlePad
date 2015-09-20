import com.rngtng.launchpad.*;

Cell grid[][];
public class PadControl {

  Launchpad lpad;

  public PadControl(Launchpad launchpad) {
    lpad = launchpad;
    lpad.flashingAuto();
    grid = new Cell[8][8];
    initialize();
  }

  void initialize() {
    int x;
    int y;   

    for (y = 0; y<8; y++) {
      for (x = 0; x<3; x++) {
        grid[x][y] = new Cell(LColor.OFF, LColor.GREEN_HIGH, 
        1, x, y);
        grid[x][y].cellOff(lpad);
      }
    }
    for (y = 0; y<5; y++) {
      for (x = 3; x<8; x++) {
        grid[x][y] = new Cell(LColor.RED_LOW, LColor.RED_HIGH, 
        2, x, y);
        grid[x][y].cellOff(lpad);
      }
    }
    for (y = 5; y<8; y++) {
      for (x = 3; x<6; x++) {
        grid[x][y] = new Cell(LColor.YELLOW_LOW, LColor.YELLOW_HIGH, 
        0, x, y);
        grid[x][y].cellOff(lpad);
      }
    }
    for (y = 5; y<8; y++) {
      for (x = 6; x<8; x++) {
        grid[x][y] = new Cell(LColor.OFF, LColor.GREEN_HIGH, 
        1, x, y);
        grid[x][y].cellOff(lpad);
      }
    }
  }

  void gridPressed(int x, int y) {
    gridTrigger(x,y);
  }

  void gridReleased(int x, int y) {
    gridTrigger(x,y);
  }

  void gridTrigger(int x, int y) {
//    println("Grid triggered at: " + x + ", ", + y);
    if (!grid[x][y].isTriggered()) {
      grid[x][y].cellOn(lpad);
    } else {
      grid[x][y].cellOff(lpad);
    }
  }

  void setValues(int x, int y, ParticlePad pad) {
    switch(x) {
    case 0: 
      pad.setParticleCount(y); 
      break;
    case 1: 
      pad.setVectorMagnitude(y); 
      break;
    case 2: 
      pad.setTrailAlpha(y); 
      break;
    }
  }

  void displayValues(int pCount, int vectorMag, int tAlpha) {
//    println("displayValues: " + pCount + ", " + vectorMag + ", " + tAlpha);

    int x;
    int y;

    x = 0;
    for (y = 0; y < 8; y++) {
      if (y >= pCount) {
        grid[x][7-y].cellOff(lpad);
      } else {
        grid[x][7-y].cellOn(lpad);
      }
    }
    x = 1;
    for (y = 0; y < 8; y++) {
      if (y >= vectorMag) {
        grid[x][7-y].cellOff(lpad);
      } else {
        grid[x][7-y].cellOn(lpad);
      }
    }
    x = 2;
    for (y = 0; y < 8; y++) {
      if (y >= tAlpha) {
        grid[x][7-y].cellOff(lpad);
      } else {
        grid[x][7-y].cellOn(lpad);
      }
    }
  }
}

