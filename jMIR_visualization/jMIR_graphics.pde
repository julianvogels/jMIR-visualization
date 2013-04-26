/*
*  jMIR-visualization application
*  Graphics 
*  Creates the graphics of the data diagrams
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/

import java.util.*;

boolean runGraphicsFlag = false;

ArrayList<DataSet> selectedDatasets = new ArrayList<DataSet>();
ArrayList<String> selectedFeatures = new ArrayList<String>();


ArrayList<DataDisplay> displayGroups = new ArrayList<DataDisplay>();

boolean jMIR_graphics_run = false;

float chartXPos = 260;
float chartYPos = 65;
float chartHeight = 550;
float chartWidth = 690;
float sectionSpacing = 30;

void jMIR_graphics() {
  

}

class DataDisplay {
  DataSet dataset;
  //String[] features;
  ArrayList<String> features;
  ArrayList<ArrayList<Double>> featureVals;
  double[] featureValsMax;
  float barWidth;
  float groupSpacing;
  float groupPosX;
  float groupPosY;
  static final float BAR_SPACING = 1;
  float maxFeatureVal = 0; 
   
  DataDisplay(DataSet dataset_, ArrayList<String> features_, ArrayList<ArrayList<Double>> featureVals_) {
    // setup function
    dataset = dataset_;
    features = features_;
    featureVals = featureVals_;
  }
 
  // draw function
  void update() {
    for (int feature = 0; feature < features.size(); feature++) {
        // set the upper bound of the graph to the maximum value of the feature across the datasets
        maxFeatureVal = (float) featureValsMax[feature];
      for (int value = 0; value < featureVals.get(feature).size(); value++) {
        // draws a bar graph
        // TODO change first argument to support drawing bars at same position, change last argument to change opacity accordingly
        drawBar(groupPosX+feature*(barWidth+BAR_SPACING), groupPosY+chartHeight, barWidth-BAR_SPACING, -map(featureVals.get(feature).get(value).floatValue(), 0.0, maxFeatureVal, 0.0, chartHeight), 255 );
      }
    }
    
  }
  
  void drawBar(float x, float y, float w, float h, float opacity) {
    //println("drawBar called with values: "+x+", "+y+", "+w+", "+h);
    // TODO implement opacity  
    fill(2, 52, 77, opacity);
    stroke(255, 0);
    rect(x, y, w, h);

  }
  
  // setters
  void setGroupPosition(float groupPosX_, float groupPosY_) {
    groupPosX = groupPosX_;
    groupPosY = groupPosY_;
  }
  
  void setBarWidth(float barWidth_) {
    barWidth = barWidth_;
  }
  
  void setSpacing(float groupSpacing_) {
    groupSpacing = groupSpacing_;
  }
  
  void setFeaturesValsMax(double[] featureValsMax_) {
    featureValsMax = featureValsMax_;

  }
  
  // getters
  DataSet getDataSet() {
    return dataset;
  }
  
  ArrayList<String> getApprovedFeatures() {
    return features;
  }
  
  ArrayList<ArrayList<Double>> getFeatureVals() {
   return featureVals;
  }
  
  public float getBarSpacing() {
    return BAR_SPACING;
  }
  
} // END DataDisplay


void updateGraph() {
  int approvedFeaturesTotal = 0;
  int featureValuesTotal = 0;
  // Clear all instances of DataDisplay in displayGroups
  displayGroups.clear();
  // check if removeAll is needed (computationally more expensive)
  //println("...displaying datasets: "+selectedDatasets.size()+" datasets and "+selectedFeatures.size()+" features");
  
  // Maximum feature values (for displaying the bars in relation to each other)
  ArrayList<ArrayList<Double>> approvedFeaturesValsMax = new ArrayList<ArrayList<Double>>();
  
  // check if selected features are supported by dataset
  // cycle through all activated datasets
  for (int a = 0; a < selectedDatasets.size(); a++) {
    ArrayList<String> approvedFeatures = new ArrayList<String>();
    ArrayList<ArrayList<Double>> approvedFeaturesVals = new ArrayList<ArrayList<Double>>();
    
    // Add a new row to the list of maxima
    approvedFeaturesValsMax.add(new ArrayList<Double>());
    
    // cycle through selected features
    for (String feature : selectedFeatures) {
      for (int i = 0; i < selectedDatasets.get(a).feature_names.length; i++) {

        // If the selected feature is a feature of the selected dataset
        if (selectedDatasets.get(a).feature_names[i].equals(feature)) {

          // Count approved features in total (for the calculation of width)
          approvedFeaturesTotal++;
          
          // Add this feature to the approved features list
          approvedFeatures.add(selectedDatasets.get(a).feature_names[i]);
          
          // Max value
          approvedFeaturesValsMax.get(a).add((double) 0.0);
          
          // Add this features' values to the approved features' values list
          ArrayList<Double> approvedFeaturesValsRow = new ArrayList<Double>();
          for (double fVal : selectedDatasets.get(a).feature_values[i]) {
          approvedFeaturesValsRow.add(fVal);
          }
          approvedFeaturesVals.add(approvedFeaturesValsRow);

                    
          //println("Dataset \""+selectedDatasets.get(a).identifier+"\" has Feature \""+selectedDatasets.get(a).feature_names[i]+"\" with values:");
          // instantiate chart (section)
          int featureValuesSingleCount = 0;
          
          for(double value : selectedDatasets.get(a).feature_values[i]) {
            // Count the total of feature values
            featureValuesTotal++;
            // Check for multiple values
            featureValuesSingleCount++;
            //println(value);
          }
          if (featureValuesSingleCount > 1) {
          // TODO draw on top with opacity corrensponding to number of values
          }
        } 
      }
    }
  
  // Initialization of the DataDisplay here
  displayGroups.add( new DataDisplay(selectedDatasets.get(a), approvedFeatures, approvedFeaturesVals));  
  }
  
  // height calculations
  // calculate the maximum value of the second dimension's size of the approvedFeaturesValsMax arraylist to allocate the array graphMax
  int graphMaxDimension = 0;
  for (ArrayList<Double> dimension : approvedFeaturesValsMax) {
    if (graphMaxDimension < dimension.size()) {
      graphMaxDimension = dimension.size();
    }
  }
  // Resulting array of maximum values for a feature across datasets
  double[] graphMax = new double[graphMaxDimension];
  // initialize with zeroes
  for (double max : graphMax) {
  max = 0.0;
  }
  
  for(int set = 0; set < displayGroups.size(); set++) {
    for (int feature = 0; feature < displayGroups.get(set).getFeatureVals().size(); feature++) {
      for (int value = 0; value < displayGroups.get(set).getFeatureVals().get(feature).size(); value++) {
        // check for maximum value in feature value set of one feature of one dataset
        if (approvedFeaturesValsMax.get(set).get(feature) < displayGroups.get(set).getFeatureVals().get(feature).get(value)) {
          approvedFeaturesValsMax.get(set).set(feature, displayGroups.get(set).getFeatureVals().get(feature).get(value));
        }
      }
       //println("Max of dataset: "+approvedFeaturesValsMax.get(set).get(feature)); 
    }
    // check for maximum value of one feature over all datasets
    for (int feature = 0; feature < approvedFeaturesValsMax.get(set).size(); feature++) {
      if (graphMax[feature] < approvedFeaturesValsMax.get(set).get(feature)) {
          graphMax[feature] = approvedFeaturesValsMax.get(set).get(feature);
          //println("Passed Max ["+feature+"]: "+graphMax[feature]);
          }
    } 
  }
  
  // width calculations  
  // there is an overall spacing (defined at the top), that decreses with the number of selected datasets (i.e., groups of bars)
  float spc = sectionSpacing/selectedDatasets.size();
  if (spc < 5) {
    spc = 5;
  }
  // calculation of the bar width: e.g. ((690-(3-1)(because there are N-1 spaces between the bar groups)*(30/3))/5(bars))-1(the bar spacing)
  float barWidth_ = ((chartWidth-((selectedDatasets.size()-1)*spc))/approvedFeaturesTotal)-DataDisplay.BAR_SPACING;
  // starting x position for the first bar group
  float totalXDistance = chartXPos;
  jMIR_graphics_run = false;
  for(int i = 0; i < displayGroups.size(); i++) {
    displayGroups.get(i).setGroupPosition(totalXDistance,chartYPos);
    //displayGroup.get(i).setSpacing(spc);
    displayGroups.get(i).setBarWidth(barWidth_);
    displayGroups.get(i).setFeaturesValsMax(graphMax);
    displayGroups.get(i).update();
    totalXDistance += displayGroups.get(i).getApprovedFeatures().size()*(barWidth_)+spc;
  }
  jMIR_graphics_run = true;
  //println("displayGroups.size: "+displayGroups.size());
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


void jMIR_graphics_run() {
if(jMIR_graphics_run) {
  for (DataDisplay displayGroup : displayGroups) {
    displayGroup.update();
  }
}
}
