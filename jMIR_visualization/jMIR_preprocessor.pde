/*
*  jMIR-visualization application
 *  DataBoard Data Preprocessor
 *  Organizes the retrieved data
 *
 *  Authors:
 *  Julian Vogels (julian.vogels@mail.mcgill.ca)
 *  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
 */

String[] featureNames;
FeatureDefinition[] featureDefinition;
DataSet[] datasets;
Taxonomy taxonomy;

String[][] featureValuesTopLevel;

void jMIR_preprocessor() {

  // Prints the Feature Names
  featureNames = dataBoard.get(0).getFeatureNames();
  //println("Feature Names: ");
  for (int i = 0; i < featureNames.length; i++) {
    //println(featureNames[i]);
  }
  println();

  featureDefinition = dataBoard.get(0).getFeatureDefinitions();
  //println("Feature Description: ");
  for (int i = 0; i < featureDefinition.length; i++) {
   // println(featureDefinition[i].getFeatureDescription());
  }
  println();

  datasets = dataBoard.get(0).getFeatureVectors();
  int columns = datasets.length;
  int rows = 0;
  for (int i = 0; i < datasets.length; i++) {
    // check for the row length maximum
    if (datasets[i].getFeatureValuesOfTopLevel(featureDefinition).length > rows) {
      rows = datasets[i].getFeatureValuesOfTopLevel(featureDefinition).length;
      println("rows : "+rows);
    }
  }
  featureValuesTopLevel = new String[columns][rows]; 
  for (int i = 0; i < columns; i++) {
    //println("Dataset Description: \n\n"+datasets[i].getDataSetDescription(i));
    //for (int j = 0; j < rows; j++) {
    // MISTAKE!!!!!!!! FIX THAT
    featureValuesTopLevel = datasets[i].getFeatureValuesOfTopLevel(featureDefinition);
    //}
  }
//  for (int i = 0; i < columns; i++) {
//      for (int j = 0; j < rows; j++) {
//      // MISTAKE!!!!!!!! FIX THAT
//      println(featureValuesTopLevel[i][j]);
//      }
//  }
  
  for (int j = 0; j < featureValuesTopLevel.length; j++) {
    for (int k = 0; k < featureValuesTopLevel[j].length; k++) {
      println("Dataset feature values: \n\n"+featureValuesTopLevel[j][k]);
    }      
    //println("Dataset feature values: \n\n"+datasets[i].getFeatureValuesOfSubSections(featureDefinition));
  }
  println();


  taxonomy = dataBoard.get(0).getTaxonomy();
  //println("Taxonomy Structure: \n\n"+taxonomy.getFormattedTreeStructure());
}

