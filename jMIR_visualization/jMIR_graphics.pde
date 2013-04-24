/*
*  jMIR-visualization application
*  Graphics 
*  Creates the graphics of the data diagrams
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/

boolean runGraphicsFlag = false;

ArrayList<DataSet> selectedDatasets = new ArrayList<DataSet>();
ArrayList<String> selectedFeatures = new ArrayList<String>();

ArrayList<DataDisplay> displayGroups = new ArrayList<DataDisplay>();


float chartXPos = 260;
float chartYPos = 50;
float chartHeight = 550;
float chartWidth = 690;

void jMIR_graphics() {
  

}

class DataDisplay {
  DataSet dataset;
  String[] features;
  double[][] featureVals;
  float barWidth;
  float groupSpacing;
  float groupPosX;
  float groupPosY;
  float barSpacing = 1;
  float maxFeatureVal = 0; 
  
  DataDisplay(DataSet ds, String[] feautres, double[][] fVals, float barW, float spc, float gPX, float gPY) {
    // setup function
    dataset = ds;
    features = feautres;
    featureVals = fVals;
    barWidth = barW;
    groupSpacing = spc;
    groupPosX = gPX;
    groupPosY = gPY;
  }
 
  // draw function
  void update() {
    for (int i = 0; i < features.length; i++) {
      maxFeatureVal = 0;
      for (double featureVal : featureVals[i]) { 
        // Find maximum feature value in set
        if (maxFeatureVal < featureVal) {
        maxFeatureVal = (float) featureVal;
        }
      }
      for (int j = 0; j < featureVals[i].length; j++) {
        // draws a bar graph
        // TODO change first argument to support drawing bars at same position, change last argument to change opacity accordingly
        drawBar(groupPosX+i*(j*barWidth+barSpacing), (groupPosY+chartHeight-map((float) featureVals[i][j], 0.0, maxFeatureVal, 0.0, chartHeight)), barWidth, map((float) featureVals[i][j], 0.0, maxFeatureVal, 0.0, chartHeight), 1.0 );
      }
    }
  }
  
  void drawBar(float x, float y, float w, float h, float opacity) {
  // TODO implement opacity  
  rect(x, y, w, h);
  // TODO add Feature Labels
  }
  
}

// TODO current work!!! make that class work classy

void updateGraph() {
  int featureValuesTotal = 0;
  // Clear all instances of DataDisplay in displayGroups
  displayGroups.clear();
  println("...printing datasets: "+selectedDatasets.size()+" datasets and "+selectedFeatures.size()+" features");
  // cycle through all activated datasets
  for (DataSet dataset : selectedDatasets) {
    
    // allocate groups according to the size of selected datasets
    for (String feature : selectedFeatures) {
      for (int i = 0; i < dataset.feature_names.length; i++) {
        // If the selected feature is a feature of the selected dataset
        if (dataset.feature_names[i].equals(feature)) {
          
          println("Dataset \""+dataset.identifier+"\" has Feature \""+dataset.feature_names[i]+"\" with values:");
          // instantiate chart (section)
          int featureValuesSingleCount = 0;
          for(double value : dataset.feature_values[i]) {
            // Count the total of feature values
            featureValuesTotal++;
            // Check for multiple values
            featureValuesSingleCount++;
            println(value);
          }
          if (featureValuesSingleCount > 1) {
          // TODO draw on top with opacity corrensponding to number of values
          }
        } 
      }
    }
  // TODO all the width calculations  
  // Initialization of the DataDisplay here
  //displayGroups.add( new DataDisplay(dataset, approvedFeatures, double[][] fVals, float barW, float spc, float gPX, float gPY));  
  }
}


void printDatasets() {
  println("...printing datasets: "+selectedDatasets.size()+" datasets and "+selectedFeatures.size()+" features");
  // cycle through all activated datasets
  for (DataSet dataset : selectedDatasets) {
    for (String feature : selectedFeatures) {
      for (int i = 0; i<dataset.feature_names.length; i++) {
        if (dataset.feature_names[i].equals(feature)) {
          println("Dataset \""+dataset.identifier+"\" has Feature \""+dataset.feature_names[i]+"\" with values:");
          for(double value : dataset.feature_values[i]) {
          println(value);
          }
        } else {
         println("Dataset \""+dataset.identifier+"\" has no Feature \""+dataset.feature_names[i]+"\"");
        }
      }
    }
  }
}
