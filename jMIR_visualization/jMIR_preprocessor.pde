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

void jMIR_preprocessor() {
  
  // Prints the Feature Names
  featureNames = dataBoard.getFeatureNames();
  println("Feature Names: ");
  for (int i = 0; i < featureNames.length; i++) {
    println(featureNames[i]);
  }
  println();
  
  featureDefinition = dataBoard.getFeatureDefinitions();
  println("Feature Description: ");
  for (int i = 0; i < featureDefinition.length; i++) {
    println(featureDefinition[i].getFeatureDescription());
  }
  println();
  

  datasets = dataBoard.getFeatureVectors();
  println("Dataset Description: \n\n"+datasets[0].getDataSetDescription(0));
  

  taxonomy = dataBoard.getTaxonomy();
  println("Taxonomy Structure: \n\n"+taxonomy.getFormattedTreeStructure());
}
