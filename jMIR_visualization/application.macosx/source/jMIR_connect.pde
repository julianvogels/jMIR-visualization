/*
*  jMIR-visualization application
*  ACE XML Parser
*  Passes file paths to the DataBoard instance (if GUI is not used).
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
ArrayList<DataBoard> dataBoard = new ArrayList<DataBoard>();

// pretty mutch DEPRECATED | TODO either delete or update
void jMIR_connect() {
  // get the FeatureVectors folder path
  java.io.File folder = new java.io.File(dataPath("")+"/FeatureVectors/");

  // list the files in the FeatureVectors folder
  String[] filenames = folder.list();

  // get the number of feature vectors
  //println(filenames.length + " files in specified directory");
  
  // count valid XML files in folder
  int XMLcount = 0;
  for (int i = 0; i < filenames.length; i++) {
  if(filenames[i].endsWith(".xml")){ 
  XMLcount++;
  }
  }
  // Create an Array for the feature vectors. There can be multiple feature vector files
  ArrayList<String> featureVectorsAL = new ArrayList<String>();
  
  // get file names and write into array
  for (int i = 0; i < filenames.length; i++) {
  //println("File name: "+filenames[i]+", valid File: "+filenames[i].endsWith(".xml"));
  if(filenames[i].endsWith(".xml")){
  featureVectorsAL.add(folder+"/"+filenames[i]);
  //println(featureVectorsXML[i]);
      } else {
  // do nothing    
      }
  }
  // Load the XML documents
  String taxonomyXML = dataPath("")+"/Taxonomy.xml";
  String featureKeyXML = dataPath("")+"/FeatureKey.xml";
  String classificationXML = dataPath("")+"/Classifications.xml";
  String[] featureVectorsXML =  new String[featureVectorsAL.size()];
  featureVectorsXML = featureVectorsAL.toArray(featureVectorsXML);
  //boolean isError = dataBoard(taxonomyXML, featureKeyXML, featureVectorsXML, classificationXML);
   
}


boolean dataBoard(String taxonomyXML, String featureKeyXML, String[] featureVectorsXML, String classificationXML) {
// Instantiate DataBoard
  try {
    dataBoard.add( new DataBoard(taxonomyXML, featureKeyXML, featureVectorsXML, classificationXML) );

    // call the data preprocessor setup
    return false;
  } catch (Exception e) {
    print("Error creating DataBoard instance. Did you install the dependancies properly? \nError: ");
    e.printStackTrace();
    return true;
  }
}

boolean dataBoardInitWithObjects(Taxonomy taxonomy, FeatureDefinition[] mergedFeatureDefinition, DataSet[] parsedSets, SegmentedClassification[] mergedSegmentedClassification) {
// Instantiate DataBoard
  try {
    dataBoard.add( new DataBoard(taxonomy, mergedFeatureDefinition, parsedSets, mergedSegmentedClassification) );

    // call the data preprocessor setup
    return false;
  } catch (Exception e) {
    print("Error creating DataBoard instance. Did you install the dependancies properly? \nError: ");
    e.printStackTrace();
    return true;
  }
}



