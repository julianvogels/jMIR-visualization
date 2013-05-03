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



