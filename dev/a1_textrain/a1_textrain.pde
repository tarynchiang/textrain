/**
    CSci-4611 Assignment #1 Text Rain
**/


import processing.video.*;

// Global variables for handling video data and the input selection screen
String[] cameras;
Capture cam;
Movie mov;
PImage inputImage;
boolean inputMethodSelected = false;
boolean toggleView = false;

//variable I create 
PFont f;
String sentence = "the sky is clear but my world is grey.";
ArrayList<Character> drops = new ArrayList<Character>();
int threshold = 128;
int debugView = 1;


void setup() {
  size(1280, 720);  
  inputImage = createImage(width, height, RGB);
  f = createFont("Arial",16,true); 
}


void draw() {
  // When the program first starts, draw a menu of different options for which camera to use for input
  // The input method is selected by pressing a key 0-9 on the keyboard
  if (!inputMethodSelected) {
    cameras = Capture.list();
    int y=40;
    text("O: Offline mode, test with TextRainInput.mov movie file instead of live camera feed.", 20, y);
    y += 40; 
    for (int i = 0; i < min(9,cameras.length); i++) {
      text(i+1 + ": " + cameras[i], 20, y);
      y += 40;
    }
    return;
  }


  // This part of the draw loop gets called after the input selection screen, during normal execution of the program.

  
  // STEP 1.  Load an image, either from a movie file or from a live camera feed. Store the result in the inputImage variable
  
  if ((cam != null) && (cam.available())) {
    cam.read();
    inputImage.copy(cam, 0,0,cam.width,cam.height, 0,0,inputImage.width,inputImage.height);
  }
  else if ((mov != null) && (mov.available())) {
    mov.read();
    inputImage.copy(mov, 0,0,mov.width,mov.height, 0,0,inputImage.width,inputImage.height);
  }


  // Fill in your code to implement the rest of TextRain here..
  

  // Tip: This code draws the current input image to the screen
  set(0, 0, inputImage);
  
  
  //flip image
  pushMatrix();
  scale(-1.0, 1.0);
  image(inputImage,-inputImage.width,0);
  popMatrix();

  
  //toggle between normal view and debugging view
  if(toggleView){
    filter(THRESHOLD);
  }
  
  
  
  Character newC = new Character();
  drops.add(newC);
  for(int i=0;i<drops.size();i++){
    color eachPix = get(int(drops.get(i).xPos),int(drops.get(i).yPos) + 5);
    if(brightness(eachPix) < threshold){
      drops.get(i).yPos -= 5;
      drops.get(i).update();
      drops.get(i).render();
    }else{
      drops.get(i).update();
      drops.get(i).render();
    }
  }
}



void keyPressed() {
  
  if (!inputMethodSelected) {
    // If we haven't yet selected the input method, then check for 0 to 9 keypresses to select from the input menu
    if ((key >= '0') && (key <= '9')) { 
      int input = key - '0';
      if (input == 0) {
        println("Offline mode selected.");
        mov = new Movie(this, "TextRainInput.mov");
        mov.loop();
        inputMethodSelected = true;
      }
      else if ((input >= 1) && (input <= 9)) {
        println("Camera " + input + " selected.");           
        // The camera can be initialized directly using an element from the array returned by list():
        cam = new Capture(this, cameras[input-1]);
        cam.start();
        inputMethodSelected = true;
      }
    }
    return;
  }


  // This part of the keyPressed routine gets called after the input selection screen during normal execution of the program
  // Fill in your code to handle keypresses here..
  
  if (key == CODED) {
    if (keyCode == UP) {
      // up arrow key pressed
      threshold += 1;
    }
    else if (keyCode == DOWN) {
      // down arrow key pressed
      threshold -= 1;
    }
  }
  else if (key == ' ') {
    // space bar pressed
    if(toggleView){
      toggleView = false;
    }else{
      toggleView = true;
    }
  } 
  
}

//void toggleView(){
//  filter(THRESHOLD);
//}

class Character {
  private char c;
  private float xPos;
  private float yPos;
  private float ySpeed;
  
  Character(){
    c = sentence.charAt(int(random(sentence.length())));
    xPos = random(width);
    yPos = 0.0;
    ySpeed = random(3);
    fill(255,0,0);
    textSize(20);
  }
  
  void update(){
    this.yPos += ySpeed;
  }
  
  void render(){
    text(c,this.xPos,this.yPos);
  }

}
