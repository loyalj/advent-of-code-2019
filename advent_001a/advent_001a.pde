PFont fontMain;
PFont fontLight;

PVector[] answers = new PVector[25];
PVector ev = new PVector(0, 0); // Empty vector to backfill future days

color bgColor, bannerColor, borderColor, titleColor, dayColor, puzzleColor, answerColor;

void setup() {
  size(1300,900);
  pixelDensity(displayDensity());
  
  colorMode(HSB, 360, 100, 100, 100);
  
  bgColor = color(0,0,0);
  bannerColor = color(180, 50, 30);
  borderColor = color(0, 0, 80);
  titleColor = color(0, 00, 100);
  dayColor = color(0, 00, 100);
  puzzleColor = color(0, 0, 100);
  answerColor = color(80, 75, 100);
  
  // Load the fonts
  fontMain = loadFont("Arial-Black-48.vlw");
  fontLight = loadFont("ArialMT-48.vlw");


  // Run the daily codez
  answers[0] = solveDay01();
  answers[1] = solveDay02();
  answers[2] = solveDay03();
  answers[3] = solveDay04();
  answers[4] = ev;
  answers[5] = ev;
  answers[6] = ev;
  answers[7] = ev;
  answers[8] = ev;
  answers[9] = ev;
  answers[10] = ev;
  answers[11] = ev;
  answers[12] = ev;
  answers[13] = ev;
  answers[14] = ev;
  answers[15] = ev;
  answers[16] = ev;
  answers[17] = ev;
  answers[18] = ev;
  answers[19] = ev;
  answers[20] = ev;
  answers[21] = ev;
  answers[22] = ev;
  answers[23] = ev;
  answers[24] = ev;
  
}


void draw() {
  drawBackground();
  
  int leftMargin = 25;
  int topMargin = 150;
  
  for(int w = 0; w < 4; w++) {
    
    // Generally speaking, weeks have 7 days
    int days = 7;
    
    // Final week isn't a full week, so trim the number of days
    if(w == 3) {
      days = 4;
    }
    
    // Draw the calendar boxes
    for(int i = 0; i < days; i++) {
      drawDay(i + 1 + (7 * w), answers[i + (7 * w)], leftMargin + (180 * i), topMargin + (170 * w));
    }
  }
}



//*************************
//*  Draw background
//****************
void drawBackground() {
  push();
    background(bgColor);
    
    fill(bannerColor);
    rect(0, 25, width, 85);
    
    fill(titleColor);
    textFont(fontMain, 48);
    textAlign(CENTER, TOP);
    
    text("Advent of Code 2019", width/2, 50);
  pop();
}


//*************************
//*  Draw one of the day's answers
//****************
void drawDay(int day, PVector answer, int xOff, int yOff) {
  push();
    textFont(fontMain, 24);
    textAlign(LEFT, TOP);
    
    
    
    fill(bannerColor);
    noStroke();
    rect(xOff - 2, yOff - 4, 180, 24 + 8);
    
    stroke(borderColor);
    line(xOff - 2, yOff - 4, xOff - 2, yOff + 170 - 4);
    
    fill(dayColor);
    text("Dec " + day, xOff, yOff);
    
    textFont(fontLight, 18);
    
    fill(puzzleColor);
    text("Puzzle 1", xOff + 5, yOff + 40);
    text("Puzzle 2", xOff + 5, yOff + 90);
    
    textFont(fontMain, 18);
    
    fill(answerColor);
    text(int(answer.x), xOff + 5, yOff + 60);
    text(int(answer.y), xOff + 5, yOff + 110);
  pop();
}
