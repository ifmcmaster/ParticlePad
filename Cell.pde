import com.rngtng.launchpad.*;

public class Cell {
  
  int x;
  int y;
  
  int type;
    // 0 = Emitter
    // 1 = Slider
    // 2 = Force
    
  int cOff;
  int cOn;
  
  boolean triggered;
  
  public Cell(int off, int on, int cat, int xPos, int yPos) {
    cOff = off;
    cOn = on;
    type = cat;
    x = xPos;
    y = yPos;
    triggered = false;
  }
  
  void cellOff(Launchpad lpad) {
    lpad.changeGrid(x,y,cOff);
    triggered = false;
  }
  
  void cellOn(Launchpad lpad) {
    lpad.changeGrid(x,y,cOn);
    triggered = true;
  }
  
  boolean isTriggered() {
    return triggered;
  }
}
