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
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

boolean runGraphicsFlag = false;

ArrayList<DataSet> selectedDatasets = new ArrayList<DataSet>();
ArrayList<String> selectedFeatures = new ArrayList<String>();


ArrayList<DataDisplay> displayGroups = new ArrayList<DataDisplay>();

boolean jMIR_graphics_run = false;
boolean normalizeGraph = false;
boolean showRelated = false;

float chartXPos = 260;
float chartYPos = 85;
float chartHeight = 250;
float chartWidth = 690;
float sectionSpacing = 60;

void jMIR_graphics() {
    
  frame.addComponentListener(new ComponentAdapter() {
   public void componentResized(ComponentEvent e) {
     if(e.getSource()==frame) {
       if (DEBUG) {
         println("resize event");
       }
       jMIR_graphics_run = false;
       updateGraph();
       jMIR_graphics_run = true;
     }
   }
 }
 );
 
 addToggleButton("Normalize Bar Graph", chartXPos, 620, 78);
 addToggleButton("Display Related Values on Hover", chartXPos+150, 620, 79);
}

// method updateGraph draws the graph
void updateGraph() {
  
  chartWidth = width-270;
  
  int approvedFeaturesTotal = 0;
  int featureValuesTotal = 0;
  // Clear all instances of DataDisplay in displayGroups
  for (DataDisplay displayGroup : displayGroups) {
    displayGroup.clearBangArray();
  }
  displayGroups.clear();
  // check if removeAll is needed (computationally more expensive)
  //println("...displaying datasets: "+selectedDatasets.size()+" datasets and "+selectedFeatures.size()+" features");
  
  // Maximum feature values (for displaying the bars in relation to each other)
  ArrayList<ArrayList<Double>> approvedFeaturesValsMax = new ArrayList<ArrayList<Double>>();
  ArrayList<ArrayList<Double>> approvedFeaturesValsMin = new ArrayList<ArrayList<Double>>();
  
  // check if selected features are supported by dataset
  // cycle through all activated datasets
  for (int a = 0; a < selectedDatasets.size(); a++) {
    ArrayList<String> approvedFeatures = new ArrayList<String>();
    ArrayList<ArrayList<Double>> approvedFeaturesVals = new ArrayList<ArrayList<Double>>();
    
    // Add a new row to the list of maxima
    approvedFeaturesValsMax.add(new ArrayList<Double>());
    approvedFeaturesValsMin.add(new ArrayList<Double>());
    
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
          approvedFeaturesValsMin.get(a).add((double) 0.0);
          
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
  
    int graphMinDimension = 0;
    for (ArrayList<Double> dimension : approvedFeaturesValsMin) {
      if (graphMinDimension < dimension.size()) {
        graphMinDimension = dimension.size();
      }
    }
    // Resulting array of maximum values for a feature across datasets
    double[] graphMin = new double[graphMaxDimension];
    // initialize with zeroes
    for (double min : graphMin) {
    min = 0.0;
    }
  
    for(int set = 0; set < displayGroups.size(); set++) {
    for (int feature = 0; feature < displayGroups.get(set).getFeatureVals().size(); feature++) {
      for (int value = 0; value < displayGroups.get(set).getFeatureVals().get(feature).size(); value++) {
        // check for Minimum value in feature value set of one feature of one dataset
        if (approvedFeaturesValsMin.get(set).get(feature) > displayGroups.get(set).getFeatureVals().get(feature).get(value)) {
          approvedFeaturesValsMin.get(set).set(feature, displayGroups.get(set).getFeatureVals().get(feature).get(value));
        }
      }
       //println("Min of dataset: "+approvedFeaturesValsMin.get(set).get(feature)); 
    }
    // check for Minimum value of one feature over all datasets
    for (int feature = 0; feature < approvedFeaturesValsMin.get(set).size(); feature++) {
      if (graphMin[feature] > approvedFeaturesValsMin.get(set).get(feature)) {
          graphMin[feature] = approvedFeaturesValsMin.get(set).get(feature);
          //println("Passed Min ["+feature+"]: "+graphMin[feature]);
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
    displayGroups.get(i).setBarWidth(barWidth_);
    displayGroups.get(i).setFeaturesValsMax(graphMax);
    displayGroups.get(i).setFeaturesValsMin(graphMin);
    displayGroups.get(i).setBangArray( new ArrayList<Bang>());
    displayGroups.get(i).update();
    totalXDistance += displayGroups.get(i).getApprovedFeatures().size()*(barWidth_)+spc;
  }
  jMIR_graphics_run = true;
  //mainGUI.printControllerMap();
}

// add toggle button in order to set the bottom bound of the displayed bars to the minimum value if desired
void addToggleButton(String name, float x, float y, int id) {
    Toggle t = mainGUI.addToggle(name, true, x, y, 12, 12);
    t.setLabel(name);
    t.setId(id);
    controlP5.Label l = t.captionLabel();
    l.setColor(0xff000000);
    l.style().marginTop = -14; //move upwards (relative to button size)
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
  if(runGraphicsFlag){
    mainGUI.draw();
    if(jMIR_graphics_run) {
      
      for (DataDisplay displayGroup : displayGroups) {
        displayGroup.draw();
        ArrayList<Bang> bangArray = displayGroup.getBangArray();
        for (int i = 0; i < bangArray.size(); i++) {
          mainGUI.getController(bangArray.get(i).getName()).getCaptionLabel().hide();
          if(mainGUI.isMouseOver(mainGUI.getController(bangArray.get(i).getName()))) {

            if (!showRelated) {
              drawBangLineCaption(bangArray.get(i));
            } else {
             for (DataDisplay group : displayGroups) {
                //mainGUI.getController(group.getBangArray().get(i).getName()).getCaptionLabel().show();
                drawBangLineCaption(group.getBangArray().get(i));
             }
            }
          }
        }
      }
    }
  }
}

void drawBangLineCaption(Bang bang) {
    mainGUI.getController(bang.getName()).getCaptionLabel().show();
    float x = bang.getPosition().x;
    float w = (float) bang.getWidth();
    float x2 = x+w-1;
    line(x, bang.getPosition().y-1, x2, bang.getPosition().y-1);
}
