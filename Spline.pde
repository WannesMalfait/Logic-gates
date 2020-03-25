public class Spline {
  private boolean state;
  int outNodeID, outNodeSocketID;
  public Spline(int outNodeID, int outNodeSocketID, boolean state) {
    this.state = state;
    this.outNodeID = outNodeID;
    this.outNodeSocketID = outNodeSocketID;
  }
  public boolean getState() {
    return state;
  }
  public boolean calcState() {
    this.state = nodes.get(outNodeID).getOutput(outNodeSocketID); //<>//
    return this.state;
  } 
  public boolean recCalcState() {
    this.state = nodes.get(outNodeID).recOutput(outNodeSocketID);
    return this.state;
  }
  public void display(int x, int y) {
    if(this.state) stroke(SPLINE_ELECTRICITY_COLOR);
    else stroke(NODE_STROKE_COLOR);
    strokeWeight(SPLINE_THICKNESS);
    Circuit n = nodes.get(outNodeID);
    int l = SPLINE_NOODLENESS;
    noFill();
    bezier(x, y,x-l, y, n.x+n.w+l, n.y+n.outputOffset*(this.outNodeSocketID+1), n.x+n.w, n.y+n.outputOffset*(this.outNodeSocketID+1));
    stroke(NODE_STROKE_COLOR);
    strokeWeight(1);
  }
}
