public final int NODE_SMOOTHNESS = 10;
public final int NODE_SOCKET_SIZE = 7;
public final int NODE_TEXT_SIZE = 14;
public int ORIGIN_X = 0;
public int ORIGIN_Y = 0;
//public int OLD_ORIGIN_X = 0;
//public int OLD_ORIGIN_Y = 0;
//public int OLD_MOUSE_X = 0;
//public int OLD_MOUSE_Y = 0;
public float SCALE = 1;
public float SCALE_AMOUNT = 0.1;
public float SCALE_MIN = 0.05;

void setup() {
  size(500, 500);
  background(0);
  textSize(NODE_TEXT_SIZE);
  ORIGIN_X = width/2;
  ORIGIN_Y = height/2;
  //OLD_ORIGIN_X = width/2;
  //OLD_ORIGIN_Y = height/2;
}
void mousePressed() {
  //if (mouseButton == CENTER) {
  //  OLD_MOUSE_X = mouseX;
  //  OLD_MOUSE_Y = mouseY;
  //  OLD_ORIGIN_X = ORIGIN_X;
  //  OLD_ORIGIN_Y = ORIGIN_Y;
  //}
}
void mouseDragged() {
  if (mouseButton == CENTER) {
    //int deltaX = mouseX - OLD_MOUSE_X;
    //int deltaY = mouseY - OLD_MOUSE_Y;
    //ORIGIN_X = OLD_ORIGIN_X + deltaX;
    //ORIGIN_Y = OLD_ORIGIN_Y + deltaY;
    int deltaX = mouseX - pmouseX;
    int deltaY = mouseY - pmouseY;
    ORIGIN_X += deltaX;
    ORIGIN_Y += deltaY;
  }
}

void mouseWheel(MouseEvent event) {
  int ds = event.getCount();

  SCALE -= ds*SCALE_AMOUNT;
  if (SCALE<SCALE_MIN) SCALE  = SCALE_MIN;
}

void draw() {
  background(0);
  //translate(mouseX,mouseY);
  //scale(SCALE);
  //translate(-1/SCALE*mouseX,-1/SCALE*mouseY);
  translate(ORIGIN_X, ORIGIN_Y);
  scale(SCALE);
  AndGate a = new AndGate(50, 50);
  OrGate o = new OrGate(100, 100);
  NotGate n = new NotGate(0, 0);
  a.display();
  o.display();
  n.display();
}
