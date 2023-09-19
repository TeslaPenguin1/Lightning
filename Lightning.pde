ArrayList<Segment> segmentList = new ArrayList<Segment>();
ArrayList<Bolt> boltList = new ArrayList<Bolt>();
boolean doLightning = false;
float xpos;
float ypos;

void setup() {
  size(1000,1000);
  background(0);
}
void draw() {
  noStroke();
  fill(0,100);
  quad(0,0,0,1000,1000,1000,1000,0);
  fill(onColor());
  quad(1000,0,1000,30,970,30,970,0);
  boltList.add(new Bolt(xpos,ypos,mouseX,mouseY));
  if (doLightning) drawLightning();
  System.out.println(boltList.size());
}
void mousePressed() {
  //left click toggles lightning
  if (mouseButton == 37) {
    doLightning = !doLightning;
    //drawLightning(xpos,ypos,mouseX,mouseY);
  }
  //right click moves set point
  else if (mouseButton == 39) {
    xpos = mouseX;
    ypos = mouseY;
  }
}

void drawLightning() {
  for (int bolt = 0; bolt < boltList.size(); bolt++) {
    Bolt b = boltList.get(bolt);
    calcLightning(b.xstart,b.ystart,b.xend,b.yend);
    for (int seg = 0; seg < segmentList.size(); seg++) {
      Segment s = segmentList.get(seg);
      stroke(s.bright);
      strokeWeight(lightningWeight(s.bright));
      line(s.xstart,s.ystart,s.xend,s.yend);
    }
  }
}

void bolt(float x1,float y1,float x2,float y2) {
  if (boltList.size() > 0) boltList.remove(0);
  boltList.add(new Bolt(x1,y1,x2,y2));
}

void calcLightning(float x1,float y1,float x2,float y2) {
  int numGen = 5+(int)sqrt((float)(Math.pow(x2-x1,2)+Math.pow(y2-y1,2)))/250;
  float offsetAmt = (int)sqrt((float)(Math.pow(x2-x1,2)+Math.pow(y2-y1,2)))/2.5;
  float splitLen = 0.7;
  //sets lightning params
  
  segmentList.clear();
  segmentList.add(new Segment(x1,y1,x2,y2,255));
  //resets segment list and adds new segment from start to end point
  
  for (int gen = 0; gen < numGen; gen++) {
    int size = segmentList.size();
    
    for(int segment = 0; segment < size; segment++) {
      Segment s = segmentList.get(0);
      segmentList.remove(0); //this segment isnt needed anymore
      
      float xmidpoint = (s.xstart+s.xend)/2.0;
      float ymidpoint = (s.ystart+s.yend)/2.0;
      float xmidptOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
      float ymidptOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
      xmidpoint += xmidptOffset;
      ymidpoint += ymidptOffset;
      //calculate new midpoint
      
      Segment s1 = new Segment(s.xstart, s.ystart, xmidpoint, ymidpoint, s.bright);
      Segment s2 = new Segment(xmidpoint, ymidpoint, s.xend, s.yend, s.bright);
      segmentList.add(s1);
      segmentList.add(s2);
      //adds 2 new segments btwn old endpoints and new midpoint
      
      //randomly generates offshoots
      if (Math.random() > 0.65 && gen < 3) {
        float xsplitOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
        float ysplitOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
        float xsplit = xmidpoint+splitLen*(xmidpoint-s.xstart)+xsplitOffset;
        float ysplit = ymidpoint+splitLen*(ymidpoint-s.ystart)+ysplitOffset;
        Segment sP = new Segment(xmidpoint,ymidpoint,xsplit,ysplit, 200);
        segmentList.add(sP);
      }
    }
    offsetAmt /= 3.0;
  }
}

int lightningWeight(int stroke) {
  if (stroke >=250) return 3;
  else return 1;
}

color onColor() {
  if (doLightning) return #00FF00;
  else return #FF0000;
}

class Segment {
  float xstart = 0;
  float ystart = 0;
  float xend = 0;
  float yend = 0;
  int bright = 255;
  Segment(float x1, float y1, float x2, float y2, int b) {
    xstart = x1;
    ystart = y1;
    xend = x2;
    yend = y2;
    bright = b;
  }
}

class Bolt {
  float xstart = 0;
  float ystart = 0;
  float xend = 0;
  float yend = 0;
  Bolt(float x1, float y1, float x2, float y2) {
    xstart = x1;
    ystart = y1;
    xend = x2;
    yend = y2;
  }
}
