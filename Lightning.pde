ArrayList<Segment> segmentList = new ArrayList<Segment>();
boolean doLightning = false;
float xpos;
float ypos;

void setup() {
  size(1000,1000);
  background(0);
  fill(0,100);
}
void draw() {
  noStroke();
  quad(0,0,0,1000,1000,1000,1000,0);
  float x1 = xpos;
  float y1 = ypos;
  float x2 = mouseX;
  float y2 = mouseY;
  if (doLightning) drawLightning(x1,y1,x2,y2);
}
void mousePressed() {
  //left click toggles lightning
  if (mouseButton == 37) {
    doLightning = !doLightning;
  }
  //right click moves set point
  else if (mouseButton == 39) {
    xpos = mouseX;
    ypos = mouseY;
  }
}

void drawLightning(float x1, float y1, float x2, float y2) {
  calcLightning(x1,y1,x2,y2);
  for (int seg = 0; seg < segmentList.size(); seg++) {
    Segment s = segmentList.get(seg);
    stroke(#B4DEFF);
    strokeWeight(5);
    line(s.xstart,s.ystart,s.xend,s.yend);
  }
}

void calcLightning(float x1,float y1,float x2,float y2) {
  int numGen = 5+(int)sqrt((float)(Math.pow(x2-x1,2)+Math.pow(y2-y1,2)))/250;
  float offsetAmt = (int)sqrt((float)(Math.pow(x2-x1,2)+Math.pow(y2-y1,2)))/2.5;
  //sets lightning params
  
  segmentList.clear();
  segmentList.add(new Segment(x1,y1,x2,y2));
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
      
      Segment s1 = new Segment(s.xstart, s.ystart, xmidpoint, ymidpoint);
      Segment s2 = new Segment(xmidpoint, ymidpoint, s.xend, s.yend);
      segmentList.add(s1);
      segmentList.add(s2);
      //adds 2 new segments btwn old endpoints and new midpoint
    }
    offsetAmt /= 3.0;
  }
}

class Segment {
  float xstart = 0;
  float ystart = 0;
  float xend = 0;
  float yend = 0;
  Segment(float x1, float y1, float x2, float y2) {
    xstart = x1;
    ystart = y1;
    xend = x2;
    yend = y2;
  }
}
