/*
*  jMIR-visualization application
*  Version: 1.0
*  Date: 2013|03|04
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/

// Scaling solution
//int frameHeight = 390;
//int frameWidth = round(frameHeight*1.2);

int frameHeight = 640;
int frameWidth = 960;

boolean FULLSCREEN = true;

boolean DEBUG = true;
// choose the set of file paths that are loaded on startup (1, 2, or 3)
int DEBUG_SET_CHOICE = 3;

void setup() {
  if (!FULLSCREEN) {
  size(frameWidth, frameHeight); 
  } else {
  size(displayWidth, displayHeight);
  }
  
  if (frame != null) {
    frame.setResizable(true);
  }
  
  // call the graphical user interface setup
  jMIR_GUI();

}

boolean sketchFullScreen() {
  if (FULLSCREEN) {
  return true;
  } else {
  return false;
  }
}

void draw() {
  jMIR_GUI_run();
  jMIR_graphics_run();
}

