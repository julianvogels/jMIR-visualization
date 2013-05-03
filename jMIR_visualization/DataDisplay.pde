class DataDisplay {
  DataSet dataset;
  int datasetId;
  ArrayList<String> features;
  ArrayList<ArrayList<Double>> featureVals;
  double[] featureValsMax;
  double[] featureValsMin;
  float barWidth;
  float groupSpacing;
  float groupPosX;
  float groupPosY;
  static final float BAR_SPACING = 1;
  float maxFeatureVal; 
  float minFeatureVal;
  
  // GUI elements
  ArrayList<Bang> bangArray;
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
        
    for (int feature = 0; feature < features.size(); feature++) {
        // set the upper bound of the graph to the maximum value of the feature across the datasets
        maxFeatureVal = (float) featureValsMax[feature];
        minFeatureVal = (float) featureValsMin[feature];
        println("Min: " + minFeatureVal);
        
        // basic drawing variables
        float x = groupPosX+feature*(barWidth+BAR_SPACING);
        float y = groupPosY+chartHeight;
        float yLabel = y;
        float w = barWidth-BAR_SPACING;
        float h;
        
        // Bar Colors
        colorMode(HSB, 100);
        int globalBrightness = 80;
        int hue = 100/(features.size())*feature;
        int colour = color(hue, 100, 80);
        int active = color(hue, 50, 95);
        CColor ccolor = mainGUI.CP5BLUE;
        ccolor.setForeground(colour);
        ccolor.setActive(active);
        
        // sort feature values in ascending order
        Collections.sort(featureVals.get(feature)); 
      for (int value = featureVals.get(feature).size()-1; value > -1; value--) {
        if(!normalizeGraph) {
           minFeatureVal = 0.0f;
           if ((featureVals.get(feature).get(value) < 0)) {
           h = round(abs(map(featureVals.get(feature).get(value).floatValue(), minFeatureVal, maxFeatureVal, 0.0, -chartHeight)));
           y = groupPosY+chartHeight;
           } else {
           h = round(map(featureVals.get(feature).get(value).floatValue(), minFeatureVal, maxFeatureVal, 0.0, chartHeight));
           y = round(groupPosY+chartHeight-h);
           }
        } else {
           h = round(map(featureVals.get(feature).get(value).floatValue(), minFeatureVal, maxFeatureVal, 0.0, chartHeight));
           y = round(groupPosY+chartHeight-h);
        }
         
        if (featureVals.get(feature).size() == 1) {
          drawBar(feature, features.get(feature), featureVals.get(feature).get(value).toString(), x, y, w, h, ccolor);
        } else if (featureVals.get(feature).size() > 1) {
          int saturation = 100-100/(featureVals.get(feature).size())*(featureVals.get(feature).size()-1-value);
          int brightness = globalBrightness+((100-globalBrightness)/featureVals.get(feature).size()*(featureVals.get(feature).size()-1-value));
          ccolor.setForeground(color(hue, saturation, brightness));
          //println("Height ["+value+"]: "+h+", value: "+featureVals.get(feature).get(value));
          if ((value-1) > 0) {
          float hNext = round(map(featureVals.get(feature).get(value-1).floatValue(), minFeatureVal, maxFeatureVal, 0.0, chartHeight));
          float yNext = round(groupPosY+chartHeight-hNext);
          h = h-hNext;
          }
          drawBar(feature, features.get(feature).concat(": ").concat(Integer.toString(value)), featureVals.get(feature).get(value).toString(), x, y, w, h, ccolor);
        }
        
      }// end feature loop
         
        // Display dataset title on top of first value of set
        if (feature == 0) {
        drawTitle(datasetId*1000, dataset.identifier, x, yLabel-chartHeight, (barWidth-BAR_SPACING)*features.size());
        }
    }
    
  }
  
  void draw() {
    // draw vertical feature names
    for (int feature = 0; feature < features.size(); feature++) {
        float x = groupPosX+feature*(barWidth+BAR_SPACING)+(barWidth-10);
        float y = groupPosY+chartHeight;
        drawFeatureName(feature, features.get(feature), x, y+10);
    } 
  }
  
  void drawBar(int id, String name, String value, float x, float y, float w, float h, CColor ccolor) {
   
    bangArray.add(mainGUI.addBang((dataset.identifier.concat(": ").concat(name)))
                   .setPosition(x, y)
                   .setSize((int) w, (int) h)
                   .setColor(ccolor)
                   );
                   
    // trim string
    value = value.substring(0, Math.min(value.length(), 6));

    bangArray.get(bangArray.size()-1).setCaptionLabel(value)
                   .getCaptionLabel().alignX(ControlP5.CENTER)
                   .setColor(0xff000000)
                   .toUpperCase(false)
                   .hide()
                   ;
                   
    Label captionLabel = mainGUI.getController(dataset.identifier+": "+name).getCaptionLabel();
    captionLabel.getStyle().setMarginTop((int)(-h-14));    
  }
  
  void drawTitle(int id, String identifier, float x, float y, float w) {
      datasetTitle = mainGUI.addTextlabel(identifier)
                   .setPosition(x-2, y-30)
                   .setColorValue(0xff000000)
                   .setId(id)
                   ;       
      int maxChars = (int) round(w/6.5);
      String s  = identifier;
      s = s.substring(0, Math.min(s.length(), maxChars));
      if (identifier.length() != s.length()) {
        s = s.concat("...");
      }
      datasetTitle.setText(s);
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
  // getters
  
  ArrayList<Bang> getBangArray() {
    return bangArray;
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
  
  void setFeaturesValsMin(double[] featureValsMin_) {
    featureValsMin = featureValsMin_;
  }
  
  void setFeaturesValsMax(double[] featureValsMax_) {
    featureValsMax = featureValsMax_;
  }
  
  void clearBangArray() {
    //println(bangArray.size());
if (bangArray.size() > 0) {
    for (int i = 0; i < bangArray.size(); i++) {
      try {
      //mainGUI.remove(features.get(i));
      mainGUI.remove(bangArray.get(i).getName());
      //println(bangArray[i].getName());
      } catch (Exception e) {
      println("...couldn't remove Bang instances from DataDisplay.");
      e.printStackTrace();
      }
    }
    mainGUI.remove(datasetTitle.getName());
    //bangArray.clear();
    }
  }
  
  void setBangArray(ArrayList<Bang> bangArray_) {
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
