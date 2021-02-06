// Bakeoff #3 - Escrita de Texto em Smartwatches
// IPM 2019-20, Semestre 2
// Entrega: exclusivamente no dia 22 de Maio, até às 23h59, via Discord

// Processing reference: https://processing.org/reference/

import java.util.Arrays;
import java.util.Collections;
import java.util.Random;
import java.util.ArrayList;
import java.util.HashMap;
import java.lang.Math;
import processing.sound.*;

// Screen resolution vars;
float PPI, PPCM;
float SCALE_FACTOR;

// Finger parameters
PImage fingerOcclusion;
int FINGER_SIZE;
int FINGER_OFFSET;

// Arm/watch parameters
PImage arm;
int ARM_LENGTH;
int ARM_HEIGHT;

// Arrow parameters
PImage leftArrow, rightArrow;
int ARROW_SIZE;

// Study properties
ArrayList<String> mostFrequentWords;
HashMap<Character, Integer> keyboardHash;
HashMap<Integer, ArrayList<String>> mostFrequentWordsHash;
int mostFrequentWordsHashCounter = 0;
String sugestedWord = "";
int keyClicked = -1;
String[] phrases;                   // contains all the phrases that can be tested
int NUM_REPEATS            = 2;     // the total number of phrases to be tested
int currTrialNum           = 0;     // the current trial number (indexes into phrases array above)
String[] typed = new String[NUM_REPEATS];
String currentPhrase       = "";    // the current target phrase
String currentTyped        = "";    // what the user has typed so far

// Performance variables
float startTime            = 0;     // time starts when the user clicks for the first time
float finishTime           = 0;     // records the time of when the final trial ends
float lastTime             = 0;     // the timestamp of when the last trial was completed
float lettersEnteredTotal  = 0;     // a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0;     // a running total of the number of letters expected (correct phrases)
float errorsTotal          = 0;     // a running total of the number of errors (when hitting next)

//Put your audio file name here
SoundFile file;
String audioName = "data/beep.wav";

//Setup window and vars - runs once
void setup()
{
  //size(900, 900);
  fullScreen();
  textFont(createFont("Arial", 24));  // set the font to arial 24
  noCursor();                         // hides the cursor to emulate a watch environment
  
  // Load images
  arm = loadImage("arm_watch.png");
  fingerOcclusion = loadImage("finger.png");
  
  // Creates the HashMap for the smart keyboard
  keyboardHash = new HashMap<Character, Integer>();
  createKeyboardHash();
  
  // Load mostFrequentWords
  mostFrequentWords = new ArrayList<String>(Arrays.asList(loadStrings("count_1w.txt")));
  mostFrequentWordsHash = new HashMap<Integer, ArrayList<String>>();
  createMostFrequentWordsHash();
  

  
  // Load phrases
  phrases = loadStrings("phrases.txt");                       // load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases), new Random());  // randomize the order of the phrases with no seed
  
  // Scale targets and imagens to match screen resolution
  SCALE_FACTOR = 1.0 / displayDensity();          // scale factor for high-density displays
  String[] ppi_string = loadStrings("ppi.txt");   // the text from the file is loaded into an array.
  PPI = float(ppi_string[1]);                     // set PPI, we assume the ppi value is in the second line of the .txt
  PPCM = PPI / 2.54 * SCALE_FACTOR;               // do not change this!
  
  FINGER_SIZE = (int)(11 * PPCM);
  FINGER_OFFSET = (int)(0.8 * PPCM);
  ARM_LENGTH = (int)(19 * PPCM);
  ARM_HEIGHT = (int)(11.2 * PPCM);
  ARROW_SIZE = (int)(2.2 * PPCM);
}

void draw()
{ 
  // Check if we have reached the end of the study
  if (finishTime != 0)  return;
 
  background(255);                                                         // clear background
  
  // Draw arm and watch background
  imageMode(CENTER);
  image(arm, width/2, height/2, ARM_LENGTH, ARM_HEIGHT);
  
  // Check if we just started the application
  if (startTime == 0 && !mousePressed)
  {
    fill(0);
    textAlign(CENTER);
    text("Tap to start time!", width/2, height/2);
  }
  else if (startTime == 0 && mousePressed) nextTrial();                    // show next sentence
  
  // Check if we are in the middle of a trial
  else if (startTime != 0)
  {
    textAlign(LEFT);
    fill(100);
    text("Phrase " + (currTrialNum + 1) + " of " + NUM_REPEATS, width/2 - 4.0*PPCM, height/2 - 8.1*PPCM);   // write the trial count
    text("Target:    " + currentPhrase, width/2 - 4.0*PPCM, height/2 - 7.1*PPCM);                           // draw the target string
    fill(0);
    text("Entered:  " + currentTyped + "|", width/2 - 4.0*PPCM, height/2 - 6.1*PPCM);                      // draw what the user has entered thus far 
    
    // Draw very basic ACCEPT button - do not change this!
    textAlign(CENTER);
    noStroke();
    fill(0, 250, 0);
    rect(width/2 - 2*PPCM, height/2 - 5.1*PPCM, 4.0*PPCM, 2.0*PPCM);
    fill(0);
    text("ACCEPT >", width/2, height/2 - 4.1*PPCM);
    
    // Draw screen areas
    // simulates text box - not interactive
    stroke(0); 
    fill(175);
    rect(width/2 - 2.0*PPCM, height/2 - 2.0*PPCM, 4.0*PPCM, 1.0*PPCM);
    textAlign(CENTER);
    fill(0);
    if (5 < sugestedWord.length() && sugestedWord.length() < 13) {
      textFont(createFont("Arial", 20));  // set the font to arial 20
    }
    else if (12 < sugestedWord.length() && sugestedWord.length() < 18) {
      textFont(createFont("Arial", 15));  // set the font to arial 15
    }
    else if (17 < sugestedWord.length()) {
      textFont(createFont("Arial", 11));  // set the font to arial 12
    }
    text(sugestedWord, width/2 - 0.5*PPCM, height/2 - 1.3 * PPCM);             // draw current letter
    
    // THIS IS THE ONLY INTERACTIVE AREA (4cm x 3cm); do not change size
    drawKeyboard();
    drawFingerKey();
    }
  
  // Draw the user finger to illustrate the issues with occlusion (the fat finger problem)
  imageMode(CORNER);
  image(fingerOcclusion, mouseX - FINGER_OFFSET, mouseY - FINGER_OFFSET, FINGER_SIZE, FINGER_SIZE);
}


// Check if mouse click was within certain bounds
boolean didMouseClick(float x, float y, float w, float h)
{
  return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
}


void mousePressed()
{
  if (startTime == 0) return;
  else if (didMouseClick(width/2 - 2*PPCM, height/2 - 5.1*PPCM, 4.0*PPCM, 2.0*PPCM)) nextTrial();                         // Test click on 'accept' button - do not change this!
  else if(didMouseClick(width/2 - 2.0*PPCM, height/2 - 1.0*PPCM, 4.0*PPCM, 3.0*PPCM))  // Test click on 'keyboard' area - do not change this condition! 
  {
    keyboard();
    file = new SoundFile(this, audioName);
    file.play();
  }

  else System.out.println("debug: CLICK NOT ACCEPTED");
}


void nextTrial()
{
  if (currTrialNum >= NUM_REPEATS) return;                                            // check to see if experiment is done
  
  // Check if we're in the middle of the tests
  else if (startTime != 0 && finishTime == 0)                                         
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + NUM_REPEATS);
    System.out.println("Target phrase: " + currentPhrase);
    System.out.println("Phrase length: " + currentPhrase.length());
    System.out.println("User typed: " + currentTyped);
    System.out.println("User typed length: " + currentTyped.length());
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim()));
    System.out.println("Time taken on this trial: " + (millis() - lastTime));
    System.out.println("Time taken since beginning: " + (millis() - startTime));
    System.out.println("==================");
    lettersExpectedTotal += currentPhrase.trim().length();
    lettersEnteredTotal += currentTyped.trim().length();
    errorsTotal += computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
    typed[currTrialNum] = currentTyped;
  }
  
  // Check to see if experiment just finished
  if (currTrialNum == NUM_REPEATS - 1)                                           
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime));
    System.out.println("Total letters entered: " + lettersEnteredTotal);
    System.out.println("Total letters expected: " + lettersExpectedTotal);
    System.out.println("Total errors entered: " + errorsTotal);

    float wpm = (lettersEnteredTotal / 5.0f) / ((finishTime - startTime) / 60000f);   // FYI - 60K is number of milliseconds in minute
    float cps = (lettersEnteredTotal) / ((finishTime - startTime) / 1000f);            // lettersEnteredTotal sobre o tempo, utilizando como em cima
    float freebieErrors = lettersExpectedTotal * .05;                                 // no penalty if errors are under 5% of chars
    float penalty = max(0, (errorsTotal - freebieErrors) / ((finishTime - startTime) / 60000f));
    
    System.out.println("Raw WPM: " + wpm);
    System.out.println("Freebie errors: " + freebieErrors);
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm - penalty));                         // yes, minus, because higher WPM is better: NET WPM
    System.out.println("CPS: " + cps);
    System.out.println("==================");
    
    printResults(cps, wpm, freebieErrors, penalty);
    
    currTrialNum++;                                                                   // increment by one so this mesage only appears once when all trials are done
    return;
  }

  else if (startTime == 0)                                                            // first trial starting now
  {
    System.out.println("Trials beginning! Starting timer...");
    startTime = millis();                                                             // start the timer!
  } 
  else currTrialNum++;                                                                // increment trial number

  lastTime = millis();                                                                // record the time of when this trial ended
  currentTyped = "";                                                                  // clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum];                                              // load the next phrase!
}


// Print results at the end of the study
void printResults(float cps, float wpm, float freebieErrors, float penalty)
{
  background(0);       // clears screen
  
  textFont(createFont("Arial", 16));    // sets the font to Arial size 16
  fill(255);    //set text fill color to white
  text(day() + "/" + month() + "/" + year() + "  " + hour() + ":" + minute() + ":" + second(), 100, 20);   // display time on screen
  
  text("Finished!", width / 2, height / 2); 
  
  int h = 20;
  for(int i = 0; i < NUM_REPEATS; i++, h += 40 ) {
    text("Target phrase " + (i+1) + ": " + phrases[i], width / 2, height / 2 + h);
    text("User typed " + (i+1) + ": " + typed[i], width / 2, height / 2 + h+20);
  }
  
  text("Raw WPM: " + wpm, width / 2, height / 2 + h+20);
  text("Freebie errors: " + freebieErrors, width / 2, height / 2 + h+40);
  text("Penalty: " + penalty, width / 2, height / 2 + h+60);
  text("WPM with penalty: " + max((wpm - penalty), 0), width / 2, height / 2 + h+80);
  text("CPS (Character per Second): " + cps, width / 2, height / 2 + h+ 100);
  
  saveFrame("results-######.png");    // saves screenshot in current folder    
}


// This computes the error between two strings (i.e., original phrase and user input)
int computeLevenshteinDistance(String phrase1, String phrase2)
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++) distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++) distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}


// This returns just the word, without the tab or the number
String parseSugestedWord(String word){
  return word.split("\t")[0];
} //<>//


String lastTypedWord(){
  return currentTyped.substring(currentTyped.lastIndexOf(" ") + 1);
}


int wordToInt(String word){
  int wordHashed = 0;
  for (int i=0; i != word.length(); i++) {
    wordHashed += keyboardHash.get(word.charAt(i)) * (int) Math.pow(10, word.length() - i -1);
  }
  return wordHashed;
}


// This returns the sugested word to appear at the top of the watch
void findSugestedWord(){
  int wordHashed = wordToInt(lastTypedWord());
  if (!mostFrequentWordsHash.containsKey(wordHashed)) {
    return;
  }
  else if (wordHashed == wordToInt(sugestedWord)) {
    if (mostFrequentWordsHash.get(wordHashed).size() > mostFrequentWordsHashCounter + 1) {
      mostFrequentWordsHashCounter++;
    }
  }
  else {
    mostFrequentWordsHashCounter = 0;
  }
  sugestedWord = mostFrequentWordsHash.get(wordHashed).get(mostFrequentWordsHashCounter);
}


void drawKeyboard() {
    stroke(0);
    noFill();
    textFont(createFont("Arial", 18));  // set the font to arial 18
    
    if (keyClicked == 0) fill(0, 255, 0, 90);
    rect(width/2 - 2.0*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("▲", width/2 - 1.35*PPCM, height/2 - 0.5*PPCM);
    
    if (keyClicked == 3) fill(0, 255, 0, 90);
    rect(width/2 - 2.0*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("ghi", width/2 - 1.35*PPCM, height/2 + 0.25*PPCM);
    
    if (keyClicked == 6) fill(0, 255, 0, 90);
    rect(width/2 - 2.0*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("pqrs", width/2 - 1.35*PPCM, height/2 + 1*PPCM);
    
    if (keyClicked == 9) fill(0, 255, 0, 90);
    rect(width/2 - 2.0*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("Next", width/2 - 1.35*PPCM, height/2 + 1.75*PPCM);
    
    if (keyClicked == 1) fill(0, 255, 0, 90);
    rect(width/2 - 1.34/2*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("abc", width/2, height/2 - 0.5*PPCM);
    
    if (keyClicked == 4) fill(0, 255, 0, 90);
    rect(width/2 - 1.34/2*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("jkl", width/2, height/2 + 0.25*PPCM);
    
    if (keyClicked == 7) fill(0, 255, 0, 90);
    rect(width/2 - 1.34/2*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("tuv", width/2, height/2 + 1*PPCM);
    
    if (keyClicked == 10) fill(0, 255, 0, 90);
    rect(width/2 - 1.34/2*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("Clear", width/2, height/2 + 1.75*PPCM);
    
    if (keyClicked == 2) fill(0, 255, 0, 90);
    rect(width/2 + 1.34/2*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("def", width/2 + 1.34*PPCM, height/2 - 0.5*PPCM);
    
    if (keyClicked == 5) fill(0, 255, 0, 90);
    rect(width/2 + 1.34/2*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("mno", width/2 + 1.34*PPCM, height/2 + 0.25*PPCM);
    
    if (keyClicked == 8) fill(0, 255, 0, 90);
    rect(width/2 + 1.34/2*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("xywz", width/2 + 1.34*PPCM, height/2 + 1*PPCM);
    
    if (keyClicked == 11) fill(0, 255, 0, 90);
    rect(width/2 + 1.34/2*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM);
    fill(0);
    noFill();
    text("⌫", width/2 + 1.34*PPCM, height/2 + 1.75*PPCM);
    
    textFont(createFont("Arial", 24));  // set the font to arial 24
}


void drawFingerKey(){
    String fingerKey = "";

    if (didMouseClick(width/2 - 2.0*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "▲";
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "abc";
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "def";
    }
    else if (didMouseClick(width/2 - 2.0*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "ghi";
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "jkl";
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "mno";
    }
    else if (didMouseClick(width/2 - 2.0*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "pqrs";
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "tuv";
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "xywz";
    }
    else if (didMouseClick(width/2 - 2.0*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "Next";
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "Clear";
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      fingerKey = "⌫";
    }
    
    rect(width/2 + 0.9*PPCM, height/2 - 1.75 * PPCM, 0.9*PPCM, 0.6*PPCM);
    textFont(createFont("Arial", 14));  // set the font to arial 16
    text(fingerKey, width/2 + 1.35*PPCM, height/2 - 1.35 * PPCM);
    textFont(createFont("Arial", 24));  // set the font to arial 24

}


void createKeyboardHash() {
  keyboardHash.put('a', 1);
  keyboardHash.put('b', 1);
  keyboardHash.put('c', 1);
  keyboardHash.put('d', 2);
  keyboardHash.put('e', 2);
  keyboardHash.put('f', 2);
  keyboardHash.put('g', 3);
  keyboardHash.put('h', 3);
  keyboardHash.put('i', 3);
  keyboardHash.put('j', 4);
  keyboardHash.put('k', 4);
  keyboardHash.put('l', 4);
  keyboardHash.put('m', 5);
  keyboardHash.put('n', 5);
  keyboardHash.put('o', 5);
  keyboardHash.put('p', 6);
  keyboardHash.put('q', 6);
  keyboardHash.put('r', 6);
  keyboardHash.put('s', 6);
  keyboardHash.put('t', 7);
  keyboardHash.put('u', 7);
  keyboardHash.put('v', 7);
  keyboardHash.put('x', 8);
  keyboardHash.put('w', 8);
  keyboardHash.put('y', 8);
  keyboardHash.put('z', 8);
}


void createMostFrequentWordsHash() {
  int wordHashed = 0;
  for (String word : mostFrequentWords){
    word = parseSugestedWord(word);
    wordHashed = wordToInt(word);
    //if (word.equals("the")){  // debug
    //  System.out.println("the = " + wordHashed);
    //}
    if (mostFrequentWordsHash.containsKey(wordHashed)){
      mostFrequentWordsHash.get(wordHashed).add(word);
    }
    else {
      mostFrequentWordsHash.put(wordHashed, new ArrayList<String>(Arrays.asList(word)));
    }
  }
}

void mouseReleased() {
  keyClicked = -1;
}

void keyboard() {
    fill(0,255,0,70);
    
    if (didMouseClick(width/2 - 2.0*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 0;
      currentTyped = currentTyped.substring(0, currentTyped.length() - lastTypedWord().length());
      currentTyped += sugestedWord + " ";
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 1;
      currentTyped += "a";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 - 1.0*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 2;
      currentTyped += "d";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 - 2.0*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 3;
      currentTyped += "g";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 4;
      currentTyped += "j";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 - 0.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 5;
      currentTyped += "m";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 - 2.0*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 6;
      currentTyped += "p";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 7;
      currentTyped += "t";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 + 0.5*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 8;
      currentTyped += "x";
      findSugestedWord();
    }
    else if (didMouseClick(width/2 - 2.0*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 9;
      findSugestedWord();
    }
    else if (didMouseClick(width/2 - 1.34/2*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 10;
      if (currentTyped.length() != 0) {
        if (lastTypedWord().length() == 0) {
          currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
        }
        currentTyped = currentTyped.substring(0, currentTyped.length() - lastTypedWord().length());
        findSugestedWord();
      }
    }
    else if (didMouseClick(width/2 + 1.34/2*PPCM, height/2 + 1.25*PPCM, 1.33*PPCM, 0.75*PPCM)) {
      keyClicked = 11;
      if (currentTyped.length() != 0) {
        currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
        findSugestedWord();
      }
    }
}
