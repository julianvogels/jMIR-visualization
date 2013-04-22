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
FeatureDefinition[] pPfeatureDefinition;
DataSet[] pPdatasets;
Taxonomy pPtaxonomy;

String[][][] featureValuesTopLevel;
String[][][][] featureValuesSubLevels;

void jMIR_preprocessor() {

  // Prints the Feature Names
  featureNames = dataBoard.get(0).getFeatureNames();
  //println("Feature Names: ");
  for (int i = 0; i < featureNames.length; i++) {
    //println(featureNames[i]);
  }
  println();

  pPfeatureDefinition = dataBoard.get(0).getFeatureDefinitions();
  //println("Feature Description: ");
  for (int i = 0; i < pPfeatureDefinition.length; i++) {
   // println(featureDefinition[i].getFeatureDescription());
  }
  println();

  // TopLeveLFeatures and SubLevelFeatures
  pPdatasets = dataBoard.get(0).getFeatureVectors();
  featureValuesTopLevel  =  new String[pPdatasets.length][][];
  featureValuesSubLevels =  new String[pPdatasets.length][][][]; 
    for (int i = 0; i < pPdatasets.length; i++) {
    featureValuesTopLevel[i]  = pPdatasets[i].getFeatureValuesOfTopLevel(pPfeatureDefinition);
    featureValuesSubLevels[i] = pPdatasets[i].getFeatureValuesOfSubSections(pPfeatureDefinition);
  }
  
  for (int j = 0; j < featureValuesTopLevel.length; j++) {
    println("\nDataset Top Level Feature Values ["+j+"]: ");
    if (featureValuesTopLevel[j] != null) {
    for (int k = 0; k < featureValuesTopLevel[j].length; k++) {
      for (int l = 0; l < featureValuesTopLevel[j][k].length; l++) {
        println("["+j+"]["+k+"]["+l+"]: "+featureValuesTopLevel[j][k][l]);
      }       
    }
    } else {println("print: is null");}    
  }
  println();
  
  for (int j = 0; j < featureValuesSubLevels.length; j++) {
    println("\nDataset Sub Levels Feature Values ["+j+"]: ");
    if (featureValuesSubLevels[j] != null) {
    for (int k = 0; k < featureValuesSubLevels[j].length; k++) {
      if (featureValuesSubLevels[j][k] != null) {
      for (int l = 0; l < featureValuesSubLevels[j][k].length; l++) {
        if (featureValuesSubLevels[j][k][l] != null) {
        for (int m = 0; m < featureValuesSubLevels[j][k][l].length; m++) {
          println("["+j+"]["+k+"]["+l+"]["+m+"]: "+featureValuesSubLevels[j][k][l][m]);
        }
        } else {println("print: is null");}
      }
      } else {println("print: is null");}    
    }  
    } else {println("print: is null");}   
  }

  pPtaxonomy = dataBoard.get(0).getTaxonomy();
  //println("Taxonomy Structure: \n\n"+pPtaxonomy.getFormattedTreeStructure());
}

