public abstract class Circuit {
  private int x, y;//world space coordinates
  private int w, h;
  private boolean[] inputs, outputs;//number of node sockets going in and out of the node
  private String name;
  int inputOffset, outputOffset;

  public Circuit(int x, int y, int w, int h, int in, int out, String name) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.inputs = new boolean[in];
    this.outputs = new boolean[out];
    inputOffset = h/(in+1);
    outputOffset = h/(out+1);
    this.name = name;
  }

  public void display() {
    stroke(255);
    fill(0);
    rect(x, y, w, h, NODE_SMOOTHNESS);
    fill(255);
    textAlign(CENTER);
    text(name, x+w/2, y+NODE_TEXT_SIZE-2);
    line(x, y+NODE_TEXT_SIZE, x+w, y+NODE_TEXT_SIZE);
    int sy = y+inputOffset;
    for (int i=0; i<this.inputs.length; i++) {
      circle(x, sy, NODE_SOCKET_SIZE);
      sy+=inputOffset;
    }
    sy = y+outputOffset;
    for (int i=0; i<this.outputs.length; i++) {
      circle(x+w, sy, NODE_SOCKET_SIZE);
      sy+=outputOffset;
    }
  }

  public boolean getOutput(int index) {
    return this.outputs[index];
  }
  public void setOutput(int index, boolean value) {
    this.outputs[index] = value;
  }
  public abstract  void calcOutput( int index);

  public boolean getInput(int index) {
    return this.inputs[index];
  }

  public void setXY(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

public class AndGate extends Circuit {
  public AndGate(int x, int y) {
    super(x, y, 100, 150, 2, 1, "AND");
  }

  public void calcOutput(int index) {
    this.setOutput(index, getInput(0) && getInput(1));
  }
}

public class OrGate extends Circuit {
  public OrGate(int x, int y) {
    super(x, y, 100, 150, 2, 1, "OR");
  }

  public void calcOutput(int index) {
    this.setOutput(index, getInput(0) || getInput(1));
  }
}

public class NotGate extends Circuit {
  public NotGate(int x, int y) {
    super(x, y, 100, 55, 1, 1, "NOT");
  }

  public void calcOutput(int index) {
    this.setOutput(index, getInput(0));
  }
}
