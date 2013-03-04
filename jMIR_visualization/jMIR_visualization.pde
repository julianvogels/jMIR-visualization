/*
*  jMIR-visualization application
*  ACE XML Parser
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/

import ace.xmlparsers.*;
import ace.datatypes.*;
import ace.*;
import ace.gui.*;

// Declaration of the DataBoard class (jMIR library)
DataBoard[] dataBoard;

void setup() {
  size(640, 360);
  
  // Load the XML documents
  String taxonomyXML = loadXML("Taxonomy.xml");
  XML featureKeyXML = loadXML("FeatureKey.xml");
  // TODO: This can be multiple files - design array structure and change DataBoard Instantiation
  XML featureVectorsXML = loadXML("FeatureVectors.xml");
  XML classificationXML = loadXML("Classification.xml");

  // Instantiate DataBoard
  dataBoard = new DataBoard(taxonomyXML, featureKeyXML, featureVectorsXML, classificationXML);
  println(databoard);
}


void draw() {
  background(255);
}

