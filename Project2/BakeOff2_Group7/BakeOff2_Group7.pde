// Bakeoff #2 - Seleção de Alvos e Fatores Humanos //<>// //<>//
// IPM 2019-20, Semestre 2
// Bake-off: durante a aula de lab da semana de 20 de Abril
// Submissão via Twitter: exclusivamente no dia 24 de Abril, até às 23h59

// Processing reference: https://processing.org/reference/

import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import processing.sound.*;
import geomerative.RShape;


// Target properties
float PPI, PPCM;
float SCALE_FACTOR;
float TARGET_SIZE;
float TARGET_PADDING, MARGIN, LEFT_PADDING, TOP_PADDING;


// Study properties
ArrayList<Integer> trials  = new ArrayList<Integer>();    // contains the order of targets that activate in the test
int trialNum               = 0;                           // the current trial number (indexes into trials array above)
final int NUM_REPEATS      = 3;                           // sets the number of times each target repeats in the test - FOR THE BAKEOFF NEEDS TO BE 3!
boolean ended              = false;
String[] fip               = new String [48];
ArrayList<Integer> closestTargets;
RShape cursorShape;


//put your audio file name here
SoundFile file;
String audioName = "data/beep.wav";


// Performance variables
int startTime              = 0;      // time starts when the first click is captured
int finishTime             = 0;      // records the time of the final click
int hits                   = 0;      // number of successful clicks
int misses                 = 0;      // number of missed clicks


// Class used to store properties of a target
class Target {
  int x, y;
  float w;

  Target(int posx, int posy, float twidth) {
    x = posx;
    y = posy;
    w = twidth;
  }
}


// Setup window and vars - runs once
void setup() {
  fullScreen();                // USE THIS DURING THE BAKEOFF!
  noCursor();
  
  SCALE_FACTOR    = 1.0 / displayDensity();            // scale factor for high-density displays
  String[] ppi_string = loadStrings("ppi.txt");        // The text from the file is loaded into an array.
  PPI            = float(ppi_string[1]);               // set PPI, we assume the ppi value is in the second line of the .txt
  PPCM           = PPI / 2.54 * SCALE_FACTOR;          // do not change this!
  TARGET_SIZE    = 1.5 * PPCM;                         // set the target size in cm; do not change this!
  TARGET_PADDING = 1.5 * PPCM;                         // set the padding around the targets in cm; do not change this!
  MARGIN         = 1.5 * PPCM;                         // set the margin around the targets in cm; do not change this!
  LEFT_PADDING   = width/2 - TARGET_SIZE - 1.5*TARGET_PADDING - 1.5*MARGIN;        // set the margin of the grid of targets to the left of the canvas; do not change this!
  TOP_PADDING    = height/2 - TARGET_SIZE - 1.5*TARGET_PADDING - 1.5*MARGIN;       // set the margin of the grid of targets to the top of the canvas; do not change this!
  
  noStroke();        // draw shapes without outlines
  frameRate(60);     // set frame rate

  // Text and font setup
  textFont(createFont("Arial", 16));    // sets the font to Arial size 16
  textAlign(CENTER);                    // align text
  
  randomizeTrials();    // randomize the trial order for each participant
  closestTargets = new ArrayList<Integer>(new HashSet<Integer>(trials));
}


// Updates UI - this method is constantly being called and drawing targets
void draw() {
  if (hasEnded()) return; // nothing else to do; study is over

  background(0);       // set background to black

  // Print trial count
  fill(255);          // set text fill color to black
  textSize(32);
  textAlign(CENTER);
  text("Trial " + (trialNum + 1) + " of " + trials.size(), width/2, height/10);    // display what trial the participant is on (the top-left corner)
  
  textSize(16);      //  make sure the next text will have size 16

  // Draw targets
  for (int i = 0; i < 16; i++) drawTarget(i);
  
  drawArrow();
  drawCursor();
}


boolean hasEnded() {
  if (ended) return true;    // returns if test has ended before

  // Check if the study is over
  if (trialNum >= trials.size()) {
    float timeTaken = (finishTime-startTime) / 1000f;     // convert to seconds - DO NOT CHANGE!
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f), 0, 100);    // calculate penalty - DO NOT CHANGE!

    printResults(timeTaken, penalty);    // prints study results on-screen
    ended = true;
  }

  return ended;
}


// Randomize the order in the targets to be selected
// DO NOT CHANGE THIS METHOD!
void randomizeTrials()
{
  for (int i = 0; i < 16; i++)             // 4 rows times 4 columns = 16 target
    for (int k = 0; k < NUM_REPEATS; k++)  // each target will repeat 'NUM_REPEATS' times
      trials.add(i);
  Collections.shuffle(trials);             // randomize the trial order

  System.out.println("trial order: " + trials);    // prints trial order - for debug purposes
}


// Print results at the end of the study
void printResults(float timeTaken, float penalty)
{
  background(0);       // clears screen
  
  fill(255);    //set text fill color to white
  textAlign(CENTER);
  text(day() + "/" + month() + "/" + year() + "  " + hour() + ":" + minute() + ":" + second(), width/2, height/15);   // display time on screen

  text("Finished!", width / 2, height / 8); 
  text("Hits: " + hits, width / 2, height / 8 + 20);
  text("Misses: " + misses, width / 2, height / 8 + 40);
  text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 8 + 60);
  text("Total time taken: " + timeTaken + " sec", width / 2, height / 8 + 80);
  text("Average time for each target: " + nf((timeTaken)/(float)(hits+misses), 0, 3) + " sec", width / 2, height / 8 + 100);
  text("Average time for each target + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty), 0, 3) + " sec", width / 2, height / 8 + 140);
  text("\nFitts Index of Performance", width / 2, height / 8 + 160);
  text("Target 1: ---", width / 2 - 200, height / 8 + 200);
  for (int i=2; i<=24;i++)
    text("Target "+i+": "+fip[i-2], width / 2 - 200, height/8 + 180+i*20);  
  for (int i=25; i<=48;i++)
    text("Target "+i+": "+fip[i-2], width / 2 + 200, height /8 + 180+((i-24)*20));
  saveFrame("results-######.png");    // saves screenshot in current folder
}


String fip_function(Target target,int mouseX,int mouseY){
  float x =  (dist(target.x, target.y, mouseX, mouseY)/target.w);
  float log2 = log(x+1) / log(2) ;
  return String.format("%.3f", log2) ;
}

// Mouse button was released - lets test to see if hit was in the correct target
void mouseReleased() {
  if (trialNum >= trials.size()) return;      // if study is over, just return
  if (trialNum == 0) startTime = millis();    // check if first click, if so, start timer
  if (trialNum == trials.size() - 1) {        // check if final click 
    finishTime = millis();    // save final timestamp
    println("We're done!");
  }
  
  file = new SoundFile(this, audioName);
  file.play();
    
  // Check to see if mouse cursor is inside the target bounds
  if (isCursorInBounds(trials.get(trialNum))) {
    if (trialNum < trials.size()-1)
      fip[trialNum]=fip_function(getTargetBounds(trials.get(trialNum+1)), mouseX, mouseY);
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime));     // success - hit!
    hits++; // increases hits counter
  } 
  else {
    fip[trialNum]="MISSED!";
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime));  // fail
    misses++;   // increases misses counter
  }
  
  trialNum++;   // move on to the next trial; UI will be updated on the next draw() cycle
}  


boolean isCursorInBounds(int targetId) {
  updateClosestTargets();
  return closestTargets.get(0) == targetId;
}


// For a given target ID, returns its location and size
Target getTargetBounds(int i) {
  int x = (int)LEFT_PADDING + (int)((i % 4) * (TARGET_SIZE + TARGET_PADDING) + MARGIN);
  int y = (int)TOP_PADDING + (int)((i / 4) * (TARGET_SIZE + TARGET_PADDING) + MARGIN);

  return new Target(x, y, TARGET_SIZE);
}


// Draw target on-screen
// This method is called in every draw cycle; you can update the target's UI here
void drawTarget(int i) {
  Target target = getTargetBounds(i);   // get the location and size for the circle with ID:i
  
  stroke(155);
  strokeWeight(2);
  // check if the current circle is the intended target
  if (trials.get(trialNum) == i) { 
    // if so ...
    fill(0,255,0);                  // fill bright green
  } 
  else if(trialNum + 1 < 16*NUM_REPEATS && trials.get(trialNum+1) == i) {
    fill(150,0,0);   // fill medium brightness red
  }
  else {
    fill(0);           // fill black
  }
  
  circle(target.x, target.y, target.w);   // draw target
  noStroke();
}


void drawArrow() {
    Target target = getTargetBounds(trials.get(trialNum));  
    
    stroke(255);
    strokeWeight(3);
    
    line(mouseX, mouseY, target.x, target.y);
    pushMatrix();
    translate(target.x, target.y);
    float a = atan2(mouseX-target.x, target.y-mouseY);
    rotate(a);
    line(0, 0, -10, -10);
    line(0, 0, 10, -10);
    popMatrix();
    
    noStroke();    // make sure next object wont have stroke
}


void drawCursor() {
  updateClosestTargets();
  
  Target target1 = getTargetBounds(closestTargets.get(0));
  Target target2 = getTargetBounds(closestTargets.get(1));

  float r1 = 2 * (float) Math.sqrt(Math.pow((mouseX - target1.x),2) + Math.pow((mouseY - target1.y),2)) + target1.w;
  float r2 = 2 * (float) Math.sqrt(Math.pow((mouseX - target2.x),2) + Math.pow((mouseY - target2.y),2)) - target2.w;

  if (closestTargets.get(0) == trials.get(trialNum)) {
    fill(0,255,0,75); //fill opacity 75 green
  }
  else{
    fill(0,0,255,75); //fill opacity 75 blue
  }
  
  cursorShape = new RShape();
  cursorShape.addShape(RShape.createCircle(mouseX, mouseY, Math.min(r1, r2)));
  cursorShape.addShape(RShape.createCircle(target1.x, target1.y, target1.w + 15));
  cursorShape.draw(g);
}


void updateClosestTargets() {
   Collections.sort(closestTargets, new Comparator<Integer>() {
     public int compare(Integer id1, Integer id2) {
       Target target1 = getTargetBounds(id1);
       Target target2 = getTargetBounds(id2);
       
       double r1 = Math.sqrt(Math.pow(mouseX - target1.x, 2) + Math.pow(mouseY - target1.y, 2));
       double r2 = Math.sqrt(Math.pow(mouseX - target2.x, 2) + Math.pow(mouseY - target2.y, 2));
       
       return (int) (r1-r2);
     }
   });
}
