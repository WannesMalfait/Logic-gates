public final int NODE_SMOOTHNESS = 10;
public final int NODE_SOCKET_SIZE = 7;
public final int NODE_TEXT_SIZE = 14;
public final int SPLINE_THICKNESS = 2;
public final int SPLINE_NOODLENESS = 20;
public final color NODE_FILL_COLOR = color(0);
public final color NODE_STROKE_COLOR = color(255);
public final color NODE_TEXT_COLOR = color(255);
public final color SPLINE_ELECTRICITY_COLOR = color(0, 255, 0);
public final color NODE_SELECTED_COLOR = color(140, 0, 200, 75);
public final color GRID_COLOR = color(20,150,0);
public int ORIGIN_X = 0;
public int ORIGIN_Y = 0;
public int OFFSET_X =0;
public int OFFSET_Y =0;
public boolean setOffset = true;
public int smouseX;
public int smouseY;
public float SCALE = 1;
public float SCALE_AMOUNT = 0.1;
public float SCALE_MIN = 0.3;
public float SCALE_MAX = 7.0;
public boolean addMenu = false;
public ArrayList<Circuit> nodes = new ArrayList();
public ArrayList<Lamp> lamps = new ArrayList();
public Circuit selected;
public boolean PLAY = true;
public boolean DEBUG = true;


void setup() {
  size(500, 500);
  //fullScreen();
  background(0);
  textSize(NODE_TEXT_SIZE);
  ORIGIN_X = width/2;
  ORIGIN_Y = height/2;
  smouseX = int((mouseX-ORIGIN_X)/SCALE);
  smouseY = int((mouseY-ORIGIN_Y)/SCALE);
  nodes.add(new Clock(-150, 150, 10));
  nodes.add(new AndGate(10, 50));
  nodes.add(new NotGate(-150, 0));
  nodes.get(1).addSpline(0, 0, 0);
  nodes.get(1).addSpline(2, 0, 1);
  lamps.add(new Lamp(100, 0));
  lamps.get(0).addSpline(1, 0, 0);
}

//rendering
void draw() {
  background(0);
  smouseX = int((mouseX-ORIGIN_X)/SCALE);
  smouseY = int((mouseY-ORIGIN_Y)/SCALE);
  pushMatrix();
  translate(ORIGIN_X, ORIGIN_Y);
  scale(SCALE);
  //drawGrid();
  for (Lamp l : lamps) {
    if (PLAY) l.recInput(0);
    l.display();
  }
  for (Circuit node : nodes) {
    if (!node.isUpdated() && PLAY) {
      node.update();
    }
    node.display();
    node.updated = false;
  }
  if (setOffset && !underCursor()) selected = null;
  if (selected != null) selected.highlight();
  popMatrix();
  if (addMenu) rect(mouseX, mouseY, 50, 50);
  if (DEBUG) PLAY = false;
}



public void drawGrid() {
  stroke(GRID_COLOR);
  for(int i =0; i<(height/SCALE)/2;i+=20) {
    line(-ORIGIN_X/SCALE,i,(width-ORIGIN_X)/SCALE,i);
    line(-ORIGIN_X/SCALE,-i,(width-ORIGIN_X)/SCALE,-i);
  }
  for(int i =0; i<(width)/SCALE/2;i+=20) {
  line(i,-ORIGIN_Y/SCALE,i,(height-ORIGIN_Y)/SCALE);
  line(-i,-ORIGIN_Y/SCALE,-i,(height-ORIGIN_Y)/SCALE);
  }
}

public void connectSelected(Circuit node) {
  if (selected != null && !(selected instanceof Lamp)) {
    node.addSpline(nodes.indexOf(selected), 0, 0);
  }
}

public boolean underCursor() {
  for ( int i=nodes.size()-1; i>=0; i--) {
    Circuit n = nodes.get(i);
    if (n.inNode(smouseX, smouseY)) {
      n.highlight();
      if ( mousePressed && mouseButton == LEFT) {
        selected = n;
        if (setOffset) {
          OFFSET_X = selected.getX() - smouseX;
          OFFSET_Y = selected.getY() - smouseY;
          setOffset = false;
        }
      }
      return true;
    }
  }
  for (int i= lamps.size()-1; i>=0; i--) {
    Lamp l = lamps.get(i);
    if (l.inNode(smouseX, smouseY)) {
      l.highlight();
      if ( mousePressed && mouseButton == LEFT) {
        selected = l;
        if (setOffset) {
          OFFSET_X = selected.getX() - smouseX;
          OFFSET_Y = selected.getY() - smouseY;
          setOffset = false;
        }
      }
      return true;
    }
  }

  return !(mousePressed && mouseButton == LEFT);
}
//keyboard and mouse controls
void keyPressed() {
  if (addMenu) {
  } else if ( keyCode == RIGHT) {
    PLAY = true;
  } else {
    switch (key) {
    case ' ':
      PLAY = !PLAY;
      DEBUG = !PLAY;
      break;
    case 'a':
      nodes.add(new AndGate(smouseX, smouseY));
      connectSelected(nodes.get(nodes.size()-1));
      break;
    case 'o':
      nodes.add(new OrGate(smouseX, smouseY));
      connectSelected(nodes.get(nodes.size()-1));
      break;
    case 'n':
      nodes.add(new NotGate(smouseX, smouseY));
      connectSelected(nodes.get(nodes.size()-1));
      break;
    case 'c':
      nodes.add(new Clock(smouseX, smouseY, 20));
      break;
    case 'l':
      lamps.add(new Lamp(smouseX, smouseY));
      connectSelected(lamps.get(lamps.size()-1));
      break;
    default: 
      break;
    }
  }
}
void mousePressed() {
  addMenu = mouseButton == RIGHT;
}
void mouseReleased() {
  setOffset = true;
  addMenu = mouseButton == RIGHT;
}
void mouseDragged() {
  if (mouseButton == CENTER) { //Pan around the scene
    int deltaX = mouseX - pmouseX;
    int deltaY = mouseY - pmouseY;
    ORIGIN_X += deltaX;
    ORIGIN_Y += deltaY;
  } else if (mouseButton == LEFT) {
    if (selected != null) {
      selected.setXY(smouseX+OFFSET_X, smouseY+OFFSET_Y);
    }
  }
}

void mouseWheel(MouseEvent event) {// Zoom in on the mouse cursors location
  ORIGIN_X-=mouseX;
  ORIGIN_Y-=mouseY;
  float ds = pow(2, -event.getCount()*SCALE_AMOUNT);
  SCALE *= ds;
  if (SCALE <SCALE_MIN) SCALE = SCALE_MIN;
  else if (SCALE > SCALE_MAX) SCALE = SCALE_MAX;
  else {
    ORIGIN_X*=ds;
    ORIGIN_Y*=ds;
  }
  ORIGIN_X+=mouseX;
  ORIGIN_Y+=mouseY;
}
