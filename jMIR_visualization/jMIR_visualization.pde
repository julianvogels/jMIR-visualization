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


boolean DEBUG = true;

void setup() {
  size(frameWidth, frameHeight, P2D); 
  
  // call the jMIR connection setup
  jMIR_connect();
  
  // call the graphical user interface setup
  jMIR_GUI();
  
  // call the graphics setup
  jMIR_graphics();
    
  // Ask user for files
  //openFiles();

}


void draw() {
  background(255);
  jMIR_GUI_run();
}

