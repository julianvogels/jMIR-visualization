/*
*  jMIR-visualization application
*  Version: 1.0
*  Date: 2013|03|04
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/

void setup() {
  size(640, 360);
  
  // call the jMIR connection setup
  jMIR_connect();
  
  // call the data preprocessor setup
  jMIR_preprocessor();
  
  // call the graphical user interface setup
  jMIR_GUI();
  
  // call the graphics setup
  jMIR_graphics();
    
  // Ask user for files
  //openFiles();
  
}


void draw() {
  background(255);
}

