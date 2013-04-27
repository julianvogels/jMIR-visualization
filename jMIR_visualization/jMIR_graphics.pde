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
float chartYPos = 85;
float chartHeight = 250;
float chartWidth = 690;
float sectionSpacing = 60;

void jMIR_graphics() {

}

class DataDisplay {
  DataSet dataset;
  int datasetId;
  ArrayList<String> features;
  ArrayList<ArrayList<Double>> featureVals;
  double[] featureValsMax;
  float barWidth;
  float groupSpacing;
  float groupPosX;
  float groupPosY;
  static final float BAR_SPACING = 1;
  float maxFeatureVal = 0; 
  
  // GUI elements
  Label[] bangArray;
  Textlabel datasetTitle;  
  
  DataDisplay(int datasetId_, DataSet dataset_, ArrayList<String> features_, ArrayList<ArrayList<Double>> featureVals_) {
    // setup function
    datasetId = datasetId_;
    dataset = dataset_;
    features = features_;
    featureVals = featureVals_;
  }
 
  // draw function
  void update() {
    clearBangArray();
    
    for (int feature = 0; feature < features.size(); feature++) {
        // set the upper bound of the graph to the maximum value of the feature across the datasets
        maxFeatureVal = (float) featureValsMax[feature];
      for (int value = 0; value < featureVals.get(feature).size(); value++) {
        // draws a bar graph
        // TODO change first argument to support drawing bars at same position, change last argument to change opacity accordingly
        float x = groupPosX+feature*(barWidth+BAR_SPACING);
        float y = groupPosY+chartHeight;
        float w = barWidth-BAR_SPACING;
        float h = -map(featureVals.get(feature).get(value).floatValue(), 0.0, maxFeatureVal, 0.0, chartHeight);
        // TODO maybe try datasetId*1000+feature for the id in order to be able to remove the element
        drawBar(feature, features.get(feature), featureVals.get(feature).get(value).toString(), x, y, w, h, 255, 0xff003366);
        // draw feature names vertically
        drawFeatureName(feature, features.get(feature), x+barWidth, y-50);
        // Display dataset title on top of first value of set
        if (feature == 0) {
        drawTitle(datasetId*1000, dataset.identifier, x, y-chartHeight);
        }
      }
    }
    
  }
  
  void draw() {
    for (int feature = 0; feature < features.size(); feature++) {
        float x = groupPosX+feature*(barWidth+BAR_SPACING);
        float y = groupPosY+chartHeight;
        drawFeatureName(feature, features.get(feature), x, y+20);
    } 
  }
  
  void drawBar(int id, String name, String value, float x, float y, float w, float h, float opacity, int colour) {
    //println("drawBar called with values: "+x+", "+y+", "+w+", "+h);
    // TODO implement opacity  
//    fill(2, 52, 77, opacity);
//    stroke(255, 0);
//    rect(x, y, w, h);

   
    bangArray[id] = mainGUI.addBang(dataset.identifier+": "+name)
                   .setPosition(x, y)
                   .setSize((int) w, (int) h)
                   //.setId(id)
                   .setCaptionLabel(value)
                   .getCaptionLabel().alignX(ControlP5.CENTER)
                   .alignY(ControlP5.CENTER) 
                   .setColor(0xff000000)
                   .toUpperCase(false) 
                   ;
                         
  }
  
  void drawTitle(int id, String identifier, float x, float y) {
     datasetTitle = mainGUI.addTextlabel(identifier)
                   .setText(identifier)
                   .setPosition(x-2, y-15)
                   .setColorValue(0xff000000)
                   .setId(id)
                   ;       
  }
  
void drawFeatureName(int id, String name, float x, float y) {
      pushMatrix();
      fill(0xff000000);
      translate(x,y);
      rotate(HALF_PI);
      translate(-x,-y);
      textFont(pfont);
      textSize(10);
      text(name, x, y);
      popMatrix();
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
  
  void clearBangArray() {
    if (bangArray.length > 0) {
    for (int i = 0; i < bangArray.length; i++) {
      try {
      //mainGUI.remove(features.get(i));
      mainGUI.remove(bangArray[i]);
      } catch (Exception e) {
      println("...couldn't remove Bang instances from DataDisplay.");
      }
    }
    //Arrays.fill(bangArray, null);
    }
  }
  
  void setBangArray(Label[] bangArray_) {
    bangArray = bangArray_;
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
//  for (DataDisplay displayGroup : displayGroups) {
//    displayGroup.clearBangArray();
//  }
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
          
          // Max value initialization (zero)
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
  displayGroups.add( new DataDisplay(a, selectedDatasets.get(a), approvedFeatures, approvedFeaturesVals));  
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
  //clearBarGraph();
  for(int i = 0; i < displayGroups.size(); i++) {
    displayGroups.get(i).setGroupPosition(totalXDistance,chartYPos);
    //displayGroup.get(i).setSpacing(spc);
    displayGroups.get(i).setBarWidth(barWidth_);
    displayGroups.get(i).setFeaturesValsMax(graphMax);
    //displayGroups.get(i).clearBangArray();
    displayGroups.get(i).setBangArray(new Label[selectedFeatures.size()]);
    displayGroups.get(i).update();
    totalXDistance += displayGroups.get(i).getApprovedFeatures().size()*(barWidth_)+spc;
  }
  jMIR_graphics_run = true;
  //println("displayGroups.size: "+displayGroups.size());
  
  mainGUI.printControllerMap();
}

// add toggle button in order to set the bottom bound of the displayed bars to the minimum value if desired
void addToggleButton(int id, String name, float x, float y, int w, int h) {
    int buttonSize = 10;
    Toggle t = mainGUI.addToggle("theToggleName", true, x, y, w, h);
    t.setLabel("The Toggle Name");
    controlP5.Label l = t.captionLabel();
    l.style().marginTop = -12; //move upwards (relative to button size)
    l.style().marginLeft = 15; //move to the right
}

void clearBarGraph() {
  for (DataSet dataset : selectedDatasets) {
    mainGUI.remove(dataset.identifier);
    for (String feature : selectedFeatures) {
    mainGUI.remove(dataset.identifier+": "+feature);
    }
    background(0xFFFFFFFF);
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


void jMIR_graphics_run() {
if(jMIR_graphics_run) {
  for (DataDisplay displayGroup : displayGroups) {
    displayGroup.draw();
  }
}
}
