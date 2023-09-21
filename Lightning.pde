ArrayList<Segment> segmentList = new ArrayList<Segment>();
ArrayList<Bolt> boltList = new ArrayList<Bolt>();
ArrayList<Conductor> conductorList = new ArrayList<Conductor>();

void setup() {
  size(1000,1000);
  background(0);
  conductorList.add(new Conductor(0.0,1000.0));
}
void draw() {
  noStroke();
  fill(0,100);
  quad(0,0,0,1000,1000,1000,1000,0);
  boltList.clear();
  for (int cond = 1; cond < conductorList.size(); cond++) {
    //adds a bolt between each conductor
    Conductor c1 = conductorList.get(cond-1);
    Conductor c2 = conductorList.get(cond);
    boltList.add(new Bolt(c1.x, c1.y, c2.x, c2.y));
    boltList.add(new Bolt(c1.x, c1.y, c2.x, c2.y));
    noStroke();
    fill(100);
    ellipse(c2.x,c2.y,27.5,27.5);
    fill(#086183);
    ellipse(c2.x,c2.y,25,25);
    fill(150);
    ellipse(c2.x,c2.y,20,20);
    fill(#086183);
    ellipse(c2.x,c2.y,15,15);
  }
  drawLightning();
  for (int cond = 1; cond < conductorList.size(); cond++) {
    Conductor c = conductorList.get(cond);
    noStroke();
    fill(200);
    ellipse(c.x,c.y,10,10);
  }
}
void mousePressed() {
  //left click resets
  if (mouseButton == 37) {
    conductorList.clear();
    conductorList.add(new Conductor(0.0,1000.0));
  }
  //right click adds point
  else if (mouseButton == 39) {
    conductorList.add(new Conductor(mouseX,mouseY));
  }
}

void drawLightning() {
  for (int bolt = 0; bolt < boltList.size(); bolt++) {
    Bolt b = boltList.get(bolt);
    calcLightning(b.xstart,b.ystart,b.xend,b.yend);
    //calculate lightning segments for each bolt
    for (int seg = 0; seg < segmentList.size(); seg++) {
      Segment s = segmentList.get(seg);
      stroke(s.bright);
      strokeWeight(s.wide);
      line(s.xstart,s.ystart,s.xend,s.yend);
      //draw lines for each segment
    }
  }
}

void bolt(float x1,float y1,float x2,float y2) {
  if (boltList.size() > 0) boltList.remove(0);
  boltList.add(new Bolt(x1,y1,x2,y2));
  //replaces old bolts with new bolts
}

void calcLightning(float x1,float y1,float x2,float y2) {
  int numGen = 5+(int)sqrt((float)(Math.pow(x2-x1,2)+Math.pow(y2-y1,2)))/250;
  float offsetAmt = (int)sqrt((float)(Math.pow(x2-x1,2)+Math.pow(y2-y1,2)))/2.5;
  float splitLen = 0.7;
  //sets lightning params
  
  segmentList.clear();
  segmentList.add(new Segment(x1,y1,x2,y2,2,255));
  //resets segment list and adds new segment from start to end point
  
  for (int gen = 0; gen < numGen; gen++) {
    int size = segmentList.size();
    
    for(int segment = 0; segment < size; segment++) {
      Segment s = segmentList.get(0);
      segmentList.remove(0);
      
      float xmidpoint = (s.xstart+s.xend)/2.0;
      float ymidpoint = (s.ystart+s.yend)/2.0;
      //calc midpoint of segment
      float xmidptOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
      float ymidptOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
      //calc random offset to midpoint
      xmidpoint += xmidptOffset;
      ymidpoint += ymidptOffset;
      
      Segment s1 = new Segment(s.xstart, s.ystart, xmidpoint, ymidpoint, s.wide, s.bright);
      Segment s2 = new Segment(xmidpoint, ymidpoint, s.xend, s.yend, s.wide, s.bright);
      segmentList.add(s1);
      segmentList.add(s2);
      //adds 2 new segments btwn old endpoints and new midpoint
      
      //randomly generates offshoots
      if (Math.random() > 0.65 && gen < 3) {
        float xsplitOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
        float ysplitOffset = (float)(offsetAmt*Math.random())-offsetAmt/2.0;
        //calculates diff btwn midpoint and start point
        float xsplit = xmidpoint+splitLen*(xmidpoint-s.xstart)+xsplitOffset;
        float ysplit = ymidpoint+splitLen*(ymidpoint-s.ystart)+ysplitOffset;
        //calculates new split point position
        Segment sP = new Segment(xmidpoint,ymidpoint,xsplit,ysplit, 1, #A5D2E3);
        segmentList.add(sP);
      }
    }
    offsetAmt /= 3.0;
  }
}

class Segment {
  float xstart = 0;
  float ystart = 0;
  float xend = 0;
  float yend = 0;
  int wide = 2;
  color bright = #C1EEFF;
  Segment(float x1, float y1, float x2, float y2, int w, color b) {
    xstart = x1;
    ystart = y1;
    xend = x2;
    yend = y2;
    wide = w;
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

class Conductor {
  float x = 0;
  float y = 0;
  Conductor(float xpo, float ypo) {
    x = xpo;
    y = ypo;
  }
}
