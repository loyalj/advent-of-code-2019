//JSONArray wires = new JSONArray();
WireCPU wCPU = new WireCPU();

//*************************
//*  Solve Day 3 Puzzles
//****************
PVector solveDay03() {
  wCPU.loadWirecode("003a_wirecode.json");
  wCPU.createIntersections(0, 1);
  
  float shortestDistance = 0;
  float shortestSignal = 0;
  
  for(WireIntersection intersection: wCPU.wireIntersections) {
    
    if((shortestDistance == 0) || (intersection.distance < shortestDistance)) {
       shortestDistance = intersection.distance;
    }
    
    if((shortestSignal == 0) || (intersection.wireLength.z < shortestDistance)) {
       shortestSignal = intersection.wireLength.z;
    }
  }

  PVector answer = new PVector(shortestDistance, shortestSignal);

  return answer;
}


//*************************
//*  A little CPU to handle the wire data
//****************
class WireCPU {
  public JSONArray wirecode = new JSONArray();
  public ArrayList<WireLayer> wireLayers = new ArrayList<WireLayer>();
  public ArrayList<WireIntersection> wireIntersections = new ArrayList<WireIntersection>();
  
  //*************************
  //*  Reset the data objects in this class so it can be reused with new data
  //****************
  void reset() {
    this.wirecode = new JSONArray();
    this.wireLayers = new ArrayList<WireLayer>();
    this.wireIntersections = new ArrayList<WireIntersection>();
  }
    
  
  //*************************
  //*  Parse the puzzle input data into vector structures
  //****************
  void loadWirecode(String filename) {
    this.reset();
    
    this.wirecode = loadJSONArray(filename);
    
    for(int i = 0; i < this.wirecode.size(); i++) {
     //println("===== Wire: ", i, " =====");
     WireLayer tmpLayer = new WireLayer();
     tmpLayer.createSegments(this.wirecode.getJSONArray(i));
     this.wireLayers.add(tmpLayer); 
    }
  }
  
  void createIntersections(int layerIndex1, int layerIndex2){
     WireLayer layer1 = wireLayers.get(layerIndex1);
     WireLayer layer2 = wireLayers.get(layerIndex2);
     int wireLength1 = 0;
     int wireLength2 = 0;
     
     for(int s1 = 0; s1 < layer1.wireSegments.size(); s1++) {
       
       WireSegment segment1 = layer1.wireSegments.get(s1);
       wireLength1 += segment1.wireLength;
       
       for(int s2 = 0; s2 < layer2.wireSegments.size(); s2++) {
         
         WireSegment segment2 = layer2.wireSegments.get(s2);
         wireLength2 += segment2.wireLength;
         
         float x1 = segment1.start.x;
         float y1 = segment1.start.y;
         float x2 = segment1.end.x;
         float y2 = segment1.end.y;
         
         float x3 = segment2.start.x;
         float y3 = segment2.start.y;
         float x4 = segment2.end.x;
         float y4 = segment2.end.y;
         
         // Intersection check from http://jeffreythompson.org/collision-detection/line-line.php
         float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
         float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
         
         if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
           float intersectionX = x1 + (uA * (x2-x1));
           float intersectionY = y1 + (uA * (y2-y1));
           float distance = abs(intersectionX) + abs(intersectionY);
           float signalDistance1 = wireLength1 - (segment1.wireLength - abs(intersectionY - y1) - abs(intersectionX - x1));
           float signalDistance2 = wireLength2 - (segment2.wireLength - abs(intersectionY - y3) - abs(intersectionX - x3));
             
           this.wireIntersections.add(new WireIntersection(layerIndex1, s1, layerIndex2, s2, new PVector(intersectionX, intersectionY), distance, new PVector(signalDistance1, signalDistance2, signalDistance1 + signalDistance2)));             
         }
       }
       wireLength2 = 0;
     }
  }
  
}


//*************************
//*  A class to hold a wire as a line segment
//****************
class WireSegment {
  public PVector start = new PVector();
  public PVector end = new PVector();
  public int wireLength = 0;
  
  WireSegment(PVector start, PVector end, int wireLength) {
    this.start = start.copy();
    this.end = end.copy();
    this.wireLength = wireLength;
  }
}


//*************************
//*  A structure that stores a single wire intersection
//****************
class WireIntersection {
  public int layer1Index;
  public int segment1Index;
  
  public int layer2Index;
  public int segment2Index;
  
  public PVector location;
  public float distance;
  public PVector wireLength;
  
  WireIntersection(int layer1Index, int segment1Index, int layer2Index, int segment2Index, PVector location, float distance, PVector wireLength) {
    this.layer1Index = layer1Index;
    this.segment1Index = segment1Index;
    
    this.layer2Index = layer2Index;
    this.segment2Index = segment2Index;
    
    this.location = location.copy();
    this.distance = distance;
    this.wireLength = wireLength;
  }
}


//*************************
//*  A structure that stores a single layer of vector wire data
//****************
class WireLayer {
  public JSONArray wirecode = new JSONArray();
  public PVector lastPointer = new PVector();
  public PVector pointer = new PVector();
  public  ArrayList<WireSegment> wireSegments = new ArrayList<WireSegment>();
  
  //*************************
  //*  Convert the string commands from the input file into vector lines
  //****************
  void createSegments(JSONArray wires) {
    for(int i = 0; i < wires.size(); i++) {
      int wireLength = this.movePointer(wires.getString(i));
      
      WireSegment tmpWS = new WireSegment(this.lastPointer, this.pointer, wireLength);
      this.wireSegments.add(tmpWS);
    }
  }
  
  
  //*************************
  //(  Adjust the location of a pointer, used to inform us which line segments to create
  //*  - The puzzle input is basically like a classic Turtle drawing problem
  //****************
  int movePointer(String instruction) {
    int value = int(instruction.substring(1));
    
    this.lastPointer = this.pointer.copy();
    
    switch(instruction.charAt(0)) {
      case 'R':
        this.pointer.x += value;
      break;
      case 'L':
        this.pointer.x -= value;
      break;
      case 'U':
        this.pointer.y += value;
      break;
      case 'D':
        this.pointer.y -= value;
      break;
    }
    
    return value;
  }
}
