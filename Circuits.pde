public class AndGate extends Circuit {
  public AndGate(int x, int y) {
    super(x, y, 70, 80, 2, 1, "AND");
  }

  public void calcOutput(int index) {
    this.setOutput(index, getInput(0) && getInput(1));
  }
}

public class OrGate extends Circuit {
  public OrGate(int x, int y) {
    super(x, y, 70, 80, 2, 1, "OR");
  }

  public void calcOutput(int index) {
    this.setOutput(index, getInput(0) || getInput(1));
  }
}

public class NotGate extends Circuit {
  public NotGate(int x, int y) {
    super(x, y, 70, 40, 1, 1, "NOT");
  }

  public void calcOutput(int index) {
    this.setOutput(index, !getInput(0));
  }
}

public class Clock extends Circuit {
  int msDelay;
  int localTime;
  public Clock(int x, int y, int msDelay) {
    super(x, y, 70, 40, 0, 1, "CLOCK");
    this.msDelay = msDelay;
    if (msDelay<=0) {
      println("Error invalid clock time:", msDelay);
      println("Clock time set to: 10");
      this.msDelay = 10;
    }
    this.localTime = 0;
  }
  @Override
    public void display() {
    super.display();
    rect(getX()+10, getY()+20, map(localTime%msDelay, 0, msDelay, 0, 40), 10, 2);
  }
  @Override
    public void update() {
    localTime += 1;
    if (localTime == 2*msDelay) localTime =0;
    calcOutput(0);
  }
  @Override
    public void recUpdate() {
    update();
  }
  public void calcOutput(int index) {
    setOutput(index, boolean(localTime/msDelay%2));
  }
}
public class Lamp extends Circuit {
  public Lamp(int x, int y) {
    super(x, y, 30, 30, 1, 0, "LAMP");
  }
  @Override
  public void display() {
    stroke(NODE_STROKE_COLOR);
    if(getInput(0)) fill(SPLINE_ELECTRICITY_COLOR,200);
    else fill(NODE_FILL_COLOR,200);
    ellipse(getX(),getY(),30,30);
    if( super.splines[0] != null) super.splines[0].display(getX(),getY());
  }
  @Override
  public void highlight(){
    noStroke();
    fill(NODE_SELECTED_COLOR);
    ellipse(getX(),getY(),30,30);
  }
  @Override
  public boolean inNode(int x,int y){
    return (x-getX())*(x-getX())+(y-getY())*(y-getY())<= 30;
  }
  public void calcOutput(int index) {}
}
