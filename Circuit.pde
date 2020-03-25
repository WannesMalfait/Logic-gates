public abstract class Circuit {
  private int x, y;//world space coordinates
  private int w, h;
  private boolean[] inputs, outputs;//number of node sockets going in and out of the node
  private Spline[] splines;
  private String name;
  private boolean updated;
  int inputOffset, outputOffset;

  public Circuit(int x, int y, int w, int h, int in, int out, String name) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.inputs = new boolean[in];
    this.outputs = new boolean[out];
    this.splines = new Spline[in];
    inputOffset = h/(in+1);
    outputOffset = h/(out+1);
    this.name = name;
    updated = false;
  }


  public void display() {
    stroke(NODE_STROKE_COLOR);
    fill(NODE_FILL_COLOR);
    rect(x, y, w, h, NODE_SMOOTHNESS);
    fill(NODE_TEXT_COLOR);
    textAlign(CENTER);
    text(name, x+w/2, y+NODE_TEXT_SIZE-2);
    line(x, y+NODE_TEXT_SIZE, x+w, y+NODE_TEXT_SIZE);
    int sy = y+inputOffset;
    for (int i=0; i<this.inputs.length; i++) {
      if (this.inputs[i]) {
        fill(SPLINE_ELECTRICITY_COLOR);
        stroke(SPLINE_ELECTRICITY_COLOR);
      } else {
        fill(NODE_STROKE_COLOR);
        stroke(NODE_STROKE_COLOR);
      }
      circle(x, sy, NODE_SOCKET_SIZE);
      if (this.splines[i] != null) {
        splines[i].display(x, sy);
      }
      sy+=inputOffset;
    }
    sy = y+outputOffset;
    for (int i=0; i<this.outputs.length; i++) {
      if (this.outputs[i]) {
        fill(SPLINE_ELECTRICITY_COLOR);
        stroke(SPLINE_ELECTRICITY_COLOR);
      } else {
        fill(NODE_STROKE_COLOR);
        stroke(NODE_STROKE_COLOR);
      }
      circle(x+w, sy, NODE_SOCKET_SIZE);
      sy+=outputOffset;
    }
  }
  public void highlight() {
    fill(NODE_SELECTED_COLOR);
    noStroke();
    rect(x, y, w, h, NODE_SMOOTHNESS);
  }

  public boolean inNode(int x, int y) {
    return ((x>=this.x) && (x<=(this.x+this.w)) && (this.y<=y) &&  y<=(this.y+this.h));
  }
  public void addSpline(int outId, int outsocketId, int id) {
    this.splines[id] = new Spline(outId, outsocketId, getInput(id));
  }

  public boolean getOutput(int index) {
    return this.outputs[index];
  }
  public void setOutput(int index, boolean value) {
    this.outputs[index] = value;
  }
  public abstract  void calcOutput( int index);

  public void calcInput(int index) {
    Spline s = this.splines[index];
    this.inputs[index] = (s == null)? false : s.calcState();
  }
  public boolean getInput(int index) {
    return this.inputs[index];
  }
  public void update() {
    for (int i=0; i<inputs.length; i++) {
      calcInput(i);
    }
    for (int i=0; i<outputs.length; i++) {
      calcOutput(i);
    }
  }
  public void recInput(int index) {
    //println(this.name,"called recInput");
    Spline s = this.splines[index];
    this.inputs[index] = (s == null)? false : s.recCalcState();
  }
  public void recUpdate() {
    for (int i=0; i<inputs.length; i++) {
      recInput(i);
    }
    for (int i=0; i<outputs.length; i++) {
      calcOutput(i);
    }
  }
  public boolean recOutput(int index) {
    if (!updated) {
      recUpdate();
      updated = true;
    }
    return getOutput(index);
  }
  public boolean isUpdated() {
    return updated;
  }
  public void setXY(int x, int y) {
    this.x = x;
    this.y = y;
  }
  public int getX() {
    return this.x;
  }
  public int getY() {
    return this.y;
  }
  public int getWidth() {
    return this.w;
  }
  public int getHeight() {
    return this.h;
  }
}
