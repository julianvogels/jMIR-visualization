import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import javax.swing.*; 
import java.awt.Frame; 
import java.awt.BorderLayout; 
import ace.xmlparsers.*; 
import ace.datatypes.*; 
import ace.*; 
import ace.gui.*; 
import java.util.*; 
import java.awt.event.ComponentAdapter; 
import java.awt.event.ComponentEvent; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class jMIR_visualization extends PApplet {

/*
*  jMIR-visualization application
*  Version: 1.0
*  Date: 2013|03|04
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/

// Scaling solution
//int frameHeight = 390;
//int frameWidth = round(frameHeight*1.2);

int frameHeight = 640;
int frameWidth = 960;


boolean DEBUG = true;
int DEBUG_SET_CHOICE = 3;

public void setup() {
  size(frameWidth, frameHeight); 
  if (frame != null) {
    frame.setResizable(true);
  }
     
  // call the jMIR connection setup
  jMIR_connect();
  
  // call the graphical user interface setup
  jMIR_GUI();

}


public void draw() {
  jMIR_GUI_run();
  jMIR_graphics_run();
}

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
  public void update() {
        
    for (int feature = 0; feature < features.size(); feature++) {
        // set the upper bound of the graph to the maximum value of the feature across the datasets
        maxFeatureVal = (float) featureValsMax[feature];
        minFeatureVal = (float) featureValsMin[feature];
        
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
           h = round(abs(map(featureVals.get(feature).get(value).floatValue(), minFeatureVal, maxFeatureVal, 0.0f, -chartHeight)));
           y = groupPosY+chartHeight;
           } else {
           h = round(map(featureVals.get(feature).get(value).floatValue(), minFeatureVal, maxFeatureVal, 0.0f, chartHeight));
           y = round(groupPosY+chartHeight-h);
           }
        } else {
           h = round(map(featureVals.get(feature).get(value).floatValue(), minFeatureVal, maxFeatureVal, 0.0f, chartHeight));
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
          float hNext = round(map(featureVals.get(feature).get(value-1).floatValue(), minFeatureVal, maxFeatureVal, 0.0f, chartHeight));
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
  
  public void draw() {
    // draw vertical feature names
    for (int feature = 0; feature < features.size(); feature++) {
        float x = groupPosX+feature*(barWidth+BAR_SPACING)+(barWidth-10);
        float y = groupPosY+chartHeight;
        drawFeatureName(feature, features.get(feature), x, y+10);
    } 
  }
  
  public void drawBar(int id, String name, String value, float x, float y, float w, float h, CColor ccolor) {
   
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
  
  public void drawTitle(int id, String identifier, float x, float y, float w) {
      datasetTitle = mainGUI.addTextlabel(identifier)
                   .setPosition(x-2, y-30)
                   .setColorValue(0xff000000)
                   .setId(id)
                   ;       
      int maxChars = (int) round(w/6.5f);
      String s  = identifier;
      s = s.substring(0, Math.min(s.length(), maxChars));
      if (identifier.length() != s.length()) {
        s = s.concat("...");
      }
      datasetTitle.setText(s);
  }
  
public void drawFeatureName(int id, String name, float x, float y) {
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
  
  public ArrayList<Bang> getBangArray() {
    return bangArray;
  }

  // setters
  public void setGroupPosition(float groupPosX_, float groupPosY_) {
    groupPosX = groupPosX_;
    groupPosY = groupPosY_;
  }
  
  public void setBarWidth(float barWidth_) {
    barWidth = barWidth_;
  }
  
  public void setSpacing(float groupSpacing_) {
    groupSpacing = groupSpacing_;
  }
  
  public void setFeaturesValsMin(double[] featureValsMin_) {
    featureValsMin = featureValsMin_;
  }
  
  public void setFeaturesValsMax(double[] featureValsMax_) {
    featureValsMax = featureValsMax_;
  }
  
  public void clearBangArray() {
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
  
  public void setBangArray(ArrayList<Bang> bangArray_) {
    bangArray = bangArray_;
  }
  
  // getters
  public DataSet getDataSet() {
    return dataset;
  }
  
  public ArrayList<String> getApprovedFeatures() {
    return features;
  }
  
  public ArrayList<ArrayList<Double>> getFeatureVals() {
   return featureVals;
  }
  
  public float getBarSpacing() {
    return BAR_SPACING;
  }
  
} // END DataDisplay
public class FileSet {
  public String taxonomy;
  public String[] featureKey;
  public String[] featureVectors;
  public String[] classification;
}
/*
*  jMIR-visualization application
*  Graphical User Interface
*  Creates the user interaction elements
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/

/**
filechooser taken from http://processinghacks.com/hacks:filechooser
@author Tom Carden
modified by Julian Vogels
*/

//===============================
// IMPORTS
//===============================

// ControlP5 GUI library


// General UI elements 
 

// Window Management



//===============================
// DECLARATIONS
//===============================

ControlP5 fileCP5;
ControlP5 mainGUI;

// GUI general
Textlabel title;
Textlabel description;
Label confirmButton;
// browseFileGUI components
Label browseBang1;
Textlabel browseLabel1;
Textfield browseField1;
Label browseBang2;
Textlabel browseLabel2;
Textfield browseField2;
Label browseBang3;
Textlabel browseLabel3;
Textfield browseField3;
Label browseBang4;
Textlabel browseLabel4;
Textfield browseField4;

// browseFileGUI
File currentDirectory = new File(dataPath(""));
int fileBrowseGUIyOffset;
int fileBrowseGUIxOffset;

// MainGUI
// ---------------------------
ListBox lDatasets;
ListBox lFeatures;

// Other GUI elements
PImage fileGUIbg;

// Flags and runtime variables
// ---------------------------
// File path check
boolean errorFlag = false;
// FileGUI fade
boolean fadeGUIFlag = false;
int fadeGUIVal = 0;

// Display background image?
boolean renderBGImage = true;

// Font
PFont pfont;
ControlFont font;


public void jMIR_GUI() {
  smooth();
  
  // adjust window position
  // TODO fix
  //frame.setLocation(displayHeight/2-round(frameHeight/2), displayWidth/2-round(frameWidth/2));
  
  // Font customizations
  pfont = createFont("SansSerif", 20, true);
  font = new ControlFont(pfont,8);
  textFont(pfont);
    
  // set system look and feel 
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
  } 
  catch (Exception e) { 
    e.printStackTrace();  
  }
  
  //===============================
  // CONTROL P5 SETUP | GENERAL
  //===============================
  
  // SETUP CONTROLP5 GUI elements
  fileCP5 = new ControlP5(this);
  fileCP5.setAutoDraw(false);
  
  // change GUI colors
//  fileCP5.setColorForeground(0xffDC241F);
//  fileCP5.setColorBackground(0xff660000);
//  fileCP5.setColorLabel(0xffcccccc);
//  fileCP5.setColorValue(0xffffffff);
//  fileCP5.setColorActive(0xffff0000);
  
  // Offset the whole file chooser block and confirm button
  fileBrowseGUIyOffset = height/2-185; // was 85
  fileBrowseGUIxOffset = width/2-135; // was 20
  
  //===============================
  // CONTROL P5 SETUP | ELEMENTS
  //===============================
  
  // File Browse GUI
  // ------------------------------
  
  // create title and description
  title = fileCP5.addTextlabel("jMIR visualization")
                    .setText("jMIR visualization")
                    .setPosition(fileBrowseGUIxOffset-4,fileBrowseGUIyOffset)
                    .setColorValue(0x00000000)
                    .setFont(pfont)
                    .setId(51)
                    ;
                    
    // create title and description
  description = fileCP5.addTextlabel("description")
                    .setText("Please provide the exported \njMIR ACEXML 1.0 documents.")
                    .setId(52)
                    .setPosition(fileBrowseGUIxOffset-4,fileBrowseGUIyOffset+25)
                    .setColorValue(0x00000000)
                    ;
  
  // create the validation button
  confirmButton = fileCP5.addButton("Confirm")
                   .setId(53)
                   .setPosition(fileBrowseGUIxOffset,330+fileBrowseGUIyOffset)
                   .setSize(271,40)
                   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                   ;
                   
                   
                   
   // FileChooser1
   browseBang1 = fileCP5.addBang("BrowseBang1")
                   .setPosition(fileBrowseGUIxOffset+220,fileBrowseGUIyOffset+90)
                   .setId(11)
                   .setCaptionLabel("Browse")
                   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                   ;    
  
  browseField1 = fileCP5.addTextfield("feature vectors")
                   .setId(10)
                   .setPosition(fileBrowseGUIxOffset,fileBrowseGUIyOffset+90)
                   .setAutoClear(false)
                   ; 
  
  browseLabel1 = fileCP5.addTextlabel("FileBrowseLabel1")
                   .setText("Feature Vectors XML or folder containing XMLs")
                   .setPosition(fileBrowseGUIxOffset-4,fileBrowseGUIyOffset+75)
                   .setColorValue(0x00000000)
                   ;  

   // FileChooser2
   browseBang2 = fileCP5.addBang("BrowseBang2")
                   .setPosition(fileBrowseGUIxOffset+220,fileBrowseGUIyOffset+150)
                   .setId(21)
                   .setCaptionLabel("Browse")
                   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                   ;    
  
  browseField2 = fileCP5.addTextfield("taxonomy")
                   .setId(20)
                   .setPosition(fileBrowseGUIxOffset,fileBrowseGUIyOffset+150)
                   .setAutoClear(false)
                   ; 
  
  browseLabel2 = fileCP5.addTextlabel("FileBrowseLabel2")
                   .setText("Taxonomy XML")
                   .setPosition(fileBrowseGUIxOffset-4,fileBrowseGUIyOffset+135)
                   .setColorValue(0x00000000)
                   ;      
  
     // FileChooser3
   browseBang3 = fileCP5.addBang("BrowseBang3")
                   .setPosition(fileBrowseGUIxOffset+220,fileBrowseGUIyOffset+210)
                   .setId(31)
                   .setCaptionLabel("Browse")
                   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                   ;    
  
  browseField3 = fileCP5.addTextfield("feature key")
                   .setId(30)
                   .setPosition(fileBrowseGUIxOffset,fileBrowseGUIyOffset+210)
                   .setAutoClear(false)
                   ; 
  
  browseLabel3 = fileCP5.addTextlabel("FileBrowseLabel3")
                   .setText("Feature Key XML")
                   .setPosition(fileBrowseGUIxOffset-4,fileBrowseGUIyOffset+195)
                   .setColorValue(0x00000000)
                   ;  
                 
     // FileChooser4
   browseBang4 = fileCP5.addBang("BrowseBang4")
                   .setPosition(fileBrowseGUIxOffset+220,fileBrowseGUIyOffset+270)
                   .setId(41)
                   .setCaptionLabel("Browse")
                   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                   ;    
  
  browseField4 = fileCP5.addTextfield("classification")
                   .setId(40)
                   .setPosition(fileBrowseGUIxOffset,fileBrowseGUIyOffset+270)
                   .setAutoClear(false)
                   ; 
  
  browseLabel4 = fileCP5.addTextlabel("FileBrowseLabel4")
                   .setText("Classification XML")
                   .setPosition(fileBrowseGUIxOffset-4,fileBrowseGUIyOffset+255)
                   .setColorValue(0x00000000)
                   ;   
    
     
  //===============================
  // ADDITIONAL GUI SETUP
  //===============================     
  
  // fileGUI Background image
  fileGUIbg = loadImage("fileGUIbg.png");
  
  //===============================
  // DEBUGGING
  //===============================
  
  // set file paths if DEBUG is set
  if (DEBUG) {
    if(DEBUG_SET_CHOICE == 1) {
    Textfield txt1 = ((Textfield)fileCP5.getController("feature vectors"));
    txt1.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Feature_Values/Combined/combined_cultural_artist_10_class_audio_feature_values.xml,/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Feature_Values/Combined/combined_cultural_artist_10_class_symbolic_feature_values.xml");  
    Textfield txt2 = ((Textfield)fileCP5.getController("feature key"));
    txt2.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Feature_Values/Combined/combined_cultural_artist_10_class_symbolic_audio_feature_defintions.xml");  
    Textfield txt3 = ((Textfield)fileCP5.getController("taxonomy"));
    txt3.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Info_Files/SLAC_taxonomy_10_class.xml");  
    Textfield txt4 = ((Textfield)fileCP5.getController("classification"));
    txt4.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data//SLAC/SLAC_Info_Files/SLAC_model_classifications_10_class.xml");  
    } else if(DEBUG_SET_CHOICE == 2) {
    Textfield txt1 = ((Textfield)fileCP5.getController("feature vectors"));
    txt1.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/FeatureVectors/FeatureVectors.xml");  
    Textfield txt2 = ((Textfield)fileCP5.getController("feature key"));
    txt2.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/FeatureKey.xml");  
    Textfield txt3 = ((Textfield)fileCP5.getController("taxonomy"));
    txt3.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/Taxonomy.xml");  
    Textfield txt4 = ((Textfield)fileCP5.getController("classification"));
    txt4.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/Classifications.xml");  
    } else if(DEBUG_SET_CHOICE == 3) {
    Textfield txt1 = ((Textfield)fileCP5.getController("feature vectors"));
    txt1.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Feature_Values/Lyrics/ashley_final_filtered_feature_values.xml");  
    Textfield txt2 = ((Textfield)fileCP5.getController("feature key"));
    txt2.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Feature_Values/Lyrics/ashley_final_filtered_feature_descriptions.xml");  
    Textfield txt3 = ((Textfield)fileCP5.getController("taxonomy"));
    txt3.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Info_Files/SLAC_taxonomy_10_class.xml");  
    Textfield txt4 = ((Textfield)fileCP5.getController("classification"));
    txt4.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data//SLAC/SLAC_Info_Files/SLAC_model_classifications_10_class.xml");  
    }
    
  }

}

public String fileChooser() {
  
  String filePath;
  
  // create a file chooser 
  final JFileChooser fc = new JFileChooser();  
  fc.setCurrentDirectory(currentDirectory);  

  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
   
  if (returnVal == JFileChooser.APPROVE_OPTION) {
      File file = fc.getSelectedFile();
      currentDirectory = file.getParentFile();
      
    // see if it's an xml 
    if (file.getName().endsWith("xml")) { 
      // load the xml using the given file path
      filePath = file.getPath(); 
    } else {
    return null;
    }
  } else { 
    println("Open command cancelled by user."); 
    return null;
  }
  
// do stuff with file according to dataType
return filePath;
}

public String[] filesChooser() {
  // create a file chooser 
  final JFileChooser fc = new JFileChooser(); 
  fc.setCurrentDirectory(currentDirectory);  
    
  // file path array
  String[] filePath;

  // Enable multiple file selection
  fc.setMultiSelectionEnabled(true); 
  
  // Enable direcory selection
  fc.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES); 
  
  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
   
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    File[] files = fc.getSelectedFiles();
    currentDirectory = files[0].getParentFile();
    
    filePath = new String[files.length];
    
    for (int i = 0; i < files.length; i++) {  
    // see if it's an xml 
    if (files[i].getName().endsWith("xml")) { 
      // load the xml using the given file path
      filePath[i] = files[i].getPath(); 
      } else {
        if(files[i].isDirectory()) {
        if (DEBUG) {
          println("chosen path is directory");
        }
        // TODO implement directory functionality
        } 
        else {
            return null;
        }
      }
    }
  } else { 
    if (DEBUG) {
      println("Open command cancelled by user."); 
    }
    return null;
  }
  return filePath;
}

// DEPRECATED
public FileSet openFiles() {
  //Create a FileSet, containing the file paths to the XML documents
  FileSet fileSet = new FileSet();
  fileSet.taxonomy = fileChooser();
  fileSet.featureKey = filesChooser();
  fileSet.featureVectors = filesChooser();
  fileSet.classification = filesChooser();
  
  if(fileSet.taxonomy == null || fileSet.featureKey == null || fileSet.featureVectors == null || fileSet.classification == null) {
    // TODO add error handling
    println("... file IO error");
    return null;
  } else {
  return fileSet;
  }
  
}


public void controlEvent(ControlEvent theEvent) {
  
  if(theEvent.isController()) { 
    if (DEBUG) {
      print("control event from : "+theEvent.controller().name()+", ID: "+theEvent.controller().getId());
      println(", value : "+theEvent.controller().value());
    }
    // clicking on brwoseFileGUI1 browse button button: on success displays path in textField  VECTORS    
    if(theEvent.controller().getId()==11) {
    String[] browseFile1 = filesChooser();
    if(browseFile1 != null) {
    String concatString = "";
      for (int i = 0; i < browseFile1.length; i++) {
        if(i!=0) {
        concatString = concatString.concat(",");
        }
      concatString = concatString.concat(browseFile1[i]);
      }
    Textfield txt = ((Textfield)fileCP5.getController("feature vectors"));  
    txt.setValue(""+concatString);  
    }   
    } else
        
    // clicking on brwoseFileGUI2 browse button button: on success displays path in textField  TAXONOMY     
    if(theEvent.controller().getId()==21) {
    String browseFile = fileChooser();
    if(browseFile != null) {
    Textfield txt = ((Textfield)fileCP5.getController("taxonomy"));
    txt.setValue(""+browseFile);  
        }
    } else
 
    // clicking on brwoseFileGUI3 browse button button: on success displays path in textField  KEY
    if(theEvent.controller().getId()==31) {
    String[] browseFile3 = filesChooser();
      if(browseFile3 != null) {
        String concatString = "";
        for (int i = 0; i < browseFile3.length; i++) {
          if(i!=0) {
          concatString = concatString.concat(",");
          }
          concatString = concatString.concat(browseFile3[i]);
        }
      Textfield txt = ((Textfield)fileCP5.getController("feature key"));
      txt.setValue(""+concatString);  
      } 
    } else
    
    // Cicking on brwoseFileGUI4 browse button buttonon success displays path in textField  CLASSIFICATION   
    if(theEvent.controller().getId()==41) {
    String[] browseFile4 = filesChooser();
      if(browseFile4 != null) {
        String concatString = "";
        for (int i = 0; i < browseFile4.length; i++) {
          if(i!=0) {
          concatString = concatString.concat(",");
          }
          concatString = concatString.concat(browseFile4[i]);
        }
      Textfield txt = ((Textfield)fileCP5.getController("classification"));
      txt.setValue(""+concatString);  
      } 
     } else
     
     // Clicking the Normalize Bar Graph Toggle
     if(theEvent.controller().getId()==78) {
       if(theEvent.controller().value() == 1.0f) {
         normalizeGraph = false;
         updateGraph();
       } else {
         normalizeGraph = true;
         updateGraph();
       }
     } else if(theEvent.controller().getId()==79) {
       if(theEvent.controller().value() == 1.0f) {
         showRelated = false;
       } else {
         showRelated = true;
       }
     } else {
     // controller is not one of the above 
     
     }
     
  }  
  
  // ListBoxItem is clicked
  if (theEvent.isGroup()) {
    if (DEBUG) {
      println(theEvent.group().value()+" from "+theEvent.group());
    }
    ListBox l = (ListBox) theEvent.group();

    int index = (int)theEvent.group().value();
    ListBoxItem lbi = l.getItem(index);
    CColor lbiColor = lbi.getColor();
    if(lbiColor.getBackground() == (-16764058)) {
      // selected
      // Datasets
      if (l.getId() == 101) {
        selectDataset(lbi, index, true);
      } 
      // Features
      else if (l.getId() == 102) {
        selectFeature(lbi, index, true);
      }
    } else {
      // deselected  
      // Datasets
      if (l.getId() == 101) {
       selectDataset(lbi, index, false);
      } 
      // Features 
      else if (l.getId() == 102) {
       selectFeature(lbi, index, false);
      }
      
    }
    //printDatasets();
    // calls the method for drawing the graph in jMIR_graphics
    updateGraph();
  }    
  
  if (theEvent.isTab()) {
    if (DEBUG) {
      println("got an event from tab : "+theEvent.getTab().getName()+" with id "+theEvent.getTab().getId());
    }
    switch (theEvent.getTab().getId()) {
      case 1: jMIR_graphics_run = true;
              break;
      case 2: jMIR_graphics_run = false;
              break;
      default: break;
    }
  }
  
  }  

// Add/Remove the dataset corrensponding to the selected ListBoxItem
public void selectDataset(ListBoxItem lbi, int index, boolean selection) {
  // selected
  if (selection) {
    if (DEBUG) {
      println("User Action: Selected Dataset \""+pPdatasets[index].identifier+"\"");
    }
    selectedDatasets.add(pPdatasets[index]);
    lbi.setColorBackground(0xfffe5656);
  } 
  // deselected
  else {
   if (DEBUG) {
      println("User Action: Deselected Dataset \""+pPdatasets[index].identifier+"\"");
    }
    selectedDatasets.remove(pPdatasets[index]);
    lbi.setColorBackground(0xFF003366);
  }
}

public void selectFeature(ListBoxItem lbi, int index, boolean selection) {
  if (selection) {
    if (DEBUG) {
      println("User Action: Selected Feature \""+featureNames[index]+"\"");
    }
    selectedFeatures.add(featureNames[index]);
    lbi.setColorBackground(0xfffe5656);
  } else {
   if (DEBUG) {
      println("User Action: Deselected Feature \""+featureNames[index]+"\"");
    }
    selectedFeatures.remove(featureNames[index]);
    lbi.setColorBackground(0xFF003366);
  }
}

// Function is called if the confirm button is clicked
public void Confirm(int theValue) {
  //println("a button event from validation Button: "+theValue);
  if(theValue==1) {
    
  // if error occurs, error flag will be set
  errorFlag = false;  
    
//  // Declarations
//  String[] featureVecInput = new String[0];  
    
  // Storing the values in the single file fields
  Textfield TFTaxonomy = ((Textfield)fileCP5.getController("taxonomy"));

  // Checking for multiple entries in featureVectors field (Comma separated)
  Textfield TFFeatureVectors = ((Textfield)fileCP5.getController("feature vectors"));
  Textfield TFFeatureKeys =     ((Textfield)fileCP5.getController("feature key"));
  Textfield TFClassifications = ((Textfield)fileCP5.getController("classification"));
  
  //=================
  // Check and store the file paths for the multplie file path fields
  //=================
  String[] featureVectorsXML = checkMultipleFiles(TFFeatureVectors);
  String[] featureKeyXML = checkMultipleFiles(TFFeatureKeys);
  String[] classificationXML = checkMultipleFiles(TFClassifications);


  // Parse Feature Definition files
  FeatureDefinition[][] featureDefinition = new FeatureDefinition[featureKeyXML.length][];
  
  for (int i = 0; i < featureKeyXML.length; i++) {
    try {
        featureDefinition[i] = FeatureDefinition.parseFeatureDefinitionsFile(featureKeyXML[i]); 
    } catch (Exception e) {
        errorFlag = true;
        TFFeatureKeys.setText("DATA INPUT ERROR!");
        println("...could not parse feature definitions.");
        e.printStackTrace();
    }
  }
  FeatureDefinition[] mergedFeatureDefinition = new FeatureDefinition[0];
  try {
      mergedFeatureDefinition = FeatureDefinition.getMergedFeatureDefinitions(featureDefinition);
  } catch (Exception e) {
      errorFlag = true;
      TFFeatureKeys.setText("COULDN\'T MERGE FEATURE DEFINITIONS!");
      println("...could not merge feature definitions.");
      e.printStackTrace();
  }
  
  
  // Parse Classification files
  SegmentedClassification[][] segmentedClassification = new SegmentedClassification[classificationXML.length][];  
  //int sCTotalLength = 0;
  for (int i = 0; i < classificationXML.length; i++) {
    try {  
      segmentedClassification[i] = SegmentedClassification.parseClassificationsFile(classificationXML[i]);
    } catch (Exception e) {
      errorFlag = true;
      TFClassifications.setText("DATA INPUT ERROR!");
      println("...could not parse classifications.");
      e.printStackTrace();
    }
  //sCTotalLength += segmentedClassification[i].length;
  }
  //SegmentedClassification[] mergedSegmentedClassification = new SegmentedClassification[sCTotalLength];
  SegmentedClassification[] mergedSegmentedClassification = new SegmentedClassification[0];
  for(int i = 0; i < segmentedClassification.length; i++) {
     for(int j = 0; j < segmentedClassification[i].length; j++) {
       append(mergedSegmentedClassification, segmentedClassification[i][j]);
     }
  }
  if (DEBUG) {
    println("Length of merged segmented classification: "+mergedSegmentedClassification.length);
  }
  if (mergedSegmentedClassification.length > 1) {
    boolean classificationIsUnique = SegmentedClassification.verifyUniquenessOfIdentifiers(mergedSegmentedClassification);
    if(!classificationIsUnique) {
      errorFlag = true;
      TFClassifications.setText("IDENTIFIERS ARE NOT UNIQUE");
    }
  }
  
  // Parse Feature Vector files
  DataSet[] parsedSets = new DataSet[0];
  try {
  parsedSets = DataSet.parseDataSetFiles(featureVectorsXML, mergedFeatureDefinition);
  } catch (Exception e) {
      errorFlag = true;
      TFFeatureVectors.setText("DATA INPUT ERROR!");
      println("...could not parse feature vectors.");
      e.printStackTrace();
  }
  
  //=================
  // Check and store the file paths for the single file path field
  //=================
  // Instantiate File Objects
  File taxonomyPath;
  // Cycle through single file fields

    if(TFTaxonomy.getText().endsWith(".xml")) {        
      taxonomyPath = new File(TFTaxonomy.getText());
      // Check if file exists
      if(!taxonomyPath.exists()) {
      TFTaxonomy.setText("FILE DOESN\'T EXIST!");
      errorFlag = true;
      }
    } else {
      // Label: Only XML files!
      errorFlag = true;
      TFTaxonomy.setText("ONLY XML FILES!");
    }
    
    // Instantiate Taxonomy Object with file path
    String taxonomyXML = TFTaxonomy.getText();
    Taxonomy taxonomy = new Taxonomy();
    try {
    taxonomy = Taxonomy.parseTaxonomyFile(taxonomyXML);
    if (DEBUG) {
      println("Taxonomy tree from file: \n"+taxonomy.getFormattedTreeStructure());
    }
    } catch (Exception e) {
    errorFlag = true;
    TFTaxonomy.setText("DATA INPUT ERROR!");
    println("...could not parse taxonomy.");
    e.printStackTrace();
    }
      
    // If no error occured during tile path testing
    // INSTANTIATE DATABOARD
    if (!errorFlag) {
      // Instantiate DataBoard and get the error boolean
      boolean isDataBoardError = dataBoardInitWithObjects(null, mergedFeatureDefinition, parsedSets, mergedSegmentedClassification);
      
      // checks if DataBoard returned an error, evokes an error handling function or initializes the visualization accordingly
      if (isDataBoardError) {
        dataBoardError();
      } else {
        initVisualization();
      }

    }
      //println("errorFlag "+errorFlag);
  }
}

public String[] checkMultipleFiles(Textfield tf) {
  // Declarations
  String[] tftemp = new String[0];  
  // Split entry to get the single file paths
  if (tf!=null) {
  //println(featureVectors);
  tftemp = splitTokens(tf.getText(), ",");
  
  // Cycle through Feature Vector field (possible multiple entries)
  for (int i = 0; i < tftemp.length; i++) {
    //check if file is an XML file
    if(tftemp[i].endsWith(".xml")) {  
      // check if file exists
      File checkFile = new File(tftemp[i]);
      if(!checkFile.exists()) {
      errorFlag = true;
      tf.setText("FILE DOESN\'T EXIST!");
      }      
    } else {
      errorFlag = true;
      // Label: Only XML files!
      tf.setText("ONLY XML FILES!");
    }
  }
  } else { 
  // textfield was empty
  errorFlag = true; 
  tf.setText("REQUIRED FIELD!");
  }
  return tftemp; 
}

// handles a dataBoard Error
public void dataBoardError() {
  // Storing the values in the single file fields
  Textfield[] txts = new Textfield[4];
  txts[0] = ((Textfield)fileCP5.getController("taxonomy"));
  txts[1] = ((Textfield)fileCP5.getController("feature key"));
  txts[2] = ((Textfield)fileCP5.getController("classification"));
  txts[3] = ((Textfield)fileCP5.getController("feature vectors"));
  
  for (Textfield txt : txts) {
  txt.setText("DATABOARD ERROR!");
  }
}

// Initialize the visualization
public void initVisualization() {
    // DataBoard returned all is fine

    frame.setTitle("jMIR Visualization - Choose your data");
    
    // By setting the fadeGUIFlag, the run function calles the setupMainGUI after everything faded away
    fadeGUIFlag = true;
    //moveFileGUIFlag = true;
    
    // Launch the Preprocessor
    jMIR_preprocessor();
}





public void setupMainGUI() {
  mainGUI = new ControlP5(this);
  mainGUI.setAutoDraw(false);
  
  //===============================
  // GENERAL GUI ELEMENTS
  //===============================
  renderBGImage = false;
  
  title = mainGUI.addTextlabel("jMIR visualization")
                    .setText("jMIR visualization")
                    .setPosition(10,10)
                    .setColorValue(0x00000000)
                    .setId(1)
                    .moveTo("global");
                    ;
  //===============================
  // Listboxes
  //===============================

  // Maximum displayed chars in the listitem, then the String gets truncated and "..." is displayed 
  int maxChars = 42;

  lDatasets = mainGUI.addListBox("Datasets")
         .setPosition(10, 50)
         .setSize(240, 120)
         .setBarHeight(15)
         .setId(101)
         .moveTo("global");
         ;  
         
  //lDatasets.captionLabel().toUpperCase(true);
  lDatasets.captionLabel().set("Datasets");
  lDatasets.captionLabel().style().marginTop = 3;
  lDatasets.valueLabel().style().marginTop = 3; 

    for (int i = 0; i < pPdatasets.length; i++) {
    String identifier = pPdatasets[i].identifier.substring(0, Math.min(pPdatasets[i].identifier.length(), maxChars));
    if (identifier.length() != pPdatasets[i].identifier.length()) {
      identifier = identifier+"...";
    }
    ListBoxItem lbiDatasets = lDatasets.addItem(identifier, i);
    lbiDatasets.toUpperCase(false);
    lbiDatasets.setColorBackground(0xFF003366);
  }
  
  int lDatasetsItemHeight;
  
  if(pPdatasets.length < 10) {  
    lDatasetsItemHeight = 20;
    lDatasets.setItemHeight(lDatasetsItemHeight);
  } else {
    lDatasetsItemHeight = 15;
    lDatasets.setItemHeight(lDatasetsItemHeight);
  }
  int lDatasetsHeight = lDatasetsItemHeight*(pPdatasets.length+1);
  if (lDatasetsHeight > (height/2-40)) {
    lDatasetsHeight = height/2-40;
    lDatasets.setHeight(lDatasetsHeight);
  } else {
    lDatasets.setHeight(lDatasetsHeight);
  }
    
  lFeatures = mainGUI.addListBox("Features")
         .setPosition(10, 50+lDatasetsHeight+30)
         .setSize(240, 120)
         .setBarHeight(15)
         .setId(102)
         .moveTo("global");
         ;  
         
  //lFeatures.captionLabel().toUpperCase(true);
  lFeatures.captionLabel().set("Features");
  lFeatures.captionLabel().style().marginTop = 3;
  lFeatures.valueLabel().style().marginTop = 3; 


    for (int i = 0; i < featureNames.length; i++) {
      String identifier = featureNames[i].substring(0, Math.min(featureNames[i].length(), maxChars));
    if (identifier.length() != featureNames[i].length()) {
      identifier = identifier+"...";
    }
    ListBoxItem lbiFeatures = lFeatures.addItem(featureNames[i], i);
    lbiFeatures.toUpperCase(false);
    lbiFeatures.setColorBackground(0xff003366);
  }
  
  int lFeaturesItemHeight;
  
  if(featureNames.length < 10) {
    lFeaturesItemHeight = 20;
    lFeatures.setItemHeight(lFeaturesItemHeight);
  } else {
    lFeaturesItemHeight = 15;
    lFeatures.setItemHeight(lFeaturesItemHeight);
  }
  int lFeaturesHeight = lFeaturesItemHeight*(featureNames.length+1);
  if (lFeaturesHeight > (height/2-50)) {
    lFeatures.setHeight(height/2-50);
  } else {
    lFeatures.setHeight(lFeaturesItemHeight*(featureNames.length+1));
  }
  
  //===============================
  // Tabs
  //===============================
    mainGUI.addTab("PieChart");
     
    mainGUI.getTab("default")
     .activateEvent(true)
     .setLabel("BarGraph")
     .setId(1)
     ;

    mainGUI.getTab("PieChart")
     .activateEvent(true)
     .setId(2)
     ;  
     
   mainGUI.window().setPositionOfTabs(260, 33);
   
//    mainGUI.getController("Datasets").moveTo("global"); 
//    mainGUI.getController("Features").moveTo("global");

  runGraphicsFlag = true;

  //===============================
  // Graph
  //===============================
  // call the graphics setup
  jMIR_graphics();
}

//===============================
// Run function is executed at every iteration of the processing cycle
//===============================
public void jMIR_GUI_run() {
  background(0xFFFFFFFF);
  if (renderBGImage)
    image(fileGUIbg, fileBrowseGUIxOffset-65, fileBrowseGUIyOffset-65);
  fileCP5.draw();
  fill(255, fadeGUIVal*2.55f);
  fadeGUI(fadeGUIFlag);
  rect(0,0,width,height);
}

public void fadeGUI(boolean fadeGUIFlag_) {
  if (fadeGUIFlag_) {
    
    if (fadeGUIVal < 100) {
      fadeGUIVal++;  
      fill(255, fadeGUIVal*2.55f);
    } else {
      fadeGUIFlag = false;
      fadeGUIVal = 0; 
      fileCP5.hide();
      // Setup the mainGUI
      setupMainGUI();
      runGraphicsFlag = true;
    }
  }
}


/*
*  jMIR-visualization application
*  ACE XML Parser
*  Passes file paths to the DataBoard instance (if GUI is not used).
*
*  Authors:
*  Julian Vogels (julian.vogels@mail.mcgill.ca)
*  Benjamin Bacon (benjamin.bacon@mail.mcgill.ca)
*/






// Declaration of the DataBoard class (jMIR library)
ArrayList<DataBoard> dataBoard = new ArrayList<DataBoard>();

// pretty mutch DEPRECATED | TODO either delete or update
public void jMIR_connect() {
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


public boolean dataBoard(String taxonomyXML, String featureKeyXML, String[] featureVectorsXML, String classificationXML) {
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

public boolean dataBoardInitWithObjects(Taxonomy taxonomy, FeatureDefinition[] mergedFeatureDefinition, DataSet[] parsedSets, SegmentedClassification[] mergedSegmentedClassification) {
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

boolean jMIR_graphics_run = false;
boolean normalizeGraph = false;
boolean showRelated = false;

float chartXPos = 260;
float chartYPos = 85;
float chartHeight = 250;
float chartWidth = 690;
float sectionSpacing = 60;

public void jMIR_graphics() {
    
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
public void updateGraph() {
  
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
          approvedFeaturesValsMax.get(a).add((double) 0.0f);
          approvedFeaturesValsMin.get(a).add((double) 0.0f);
          
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
  max = 0.0f;
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
    min = 0.0f;
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
public void addToggleButton(String name, float x, float y, int id) {
    Toggle t = mainGUI.addToggle(name, true, x, y, 12, 12);
    t.setLabel(name);
    t.setId(id);
    controlP5.Label l = t.captionLabel();
    l.setColor(0xff000000);
    l.style().marginTop = -14; //move upwards (relative to button size)
    l.style().marginLeft = 15; //move to the right
}

public void clearBarGraph() {
  for (DataSet dataset : selectedDatasets) {
    mainGUI.remove(dataset.identifier);
    for (String feature : selectedFeatures) {
    mainGUI.remove(dataset.identifier+": "+feature);
    }
    background(0xFFFFFFFF);
  }
    
}

public void printDatasets() {
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


public void jMIR_graphics_run() {
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

public void drawBangLineCaption(Bang bang) {
    mainGUI.getController(bang.getName()).getCaptionLabel().show();
    float x = bang.getPosition().x;
    float w = (float) bang.getWidth();
    float x2 = x+w-1;
    line(x, bang.getPosition().y-1, x2, bang.getPosition().y-1);
}
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

public void jMIR_preprocessor() {

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
  
  float maxTopLevelFeatureValue = 0;
  //ArrayList<float> featureValuesTopLevelToFloat = new ArrayList<float>;
  for (int j = 0; j < featureValuesTopLevel.length; j++) {
    //println("\nDataset Top Level Feature Values ["+j+"]: "+pPdatasets[j].identifier);
    if (featureValuesTopLevel[j] != null) {
    for (int k = 0; k < featureValuesTopLevel[j].length; k++) {
      //println("["+j+"]["+k+"]: "+pPdatasets[j].feature_names[k]);
      for (int l = 0; l < featureValuesTopLevel[j][k].length; l++) {
        //println("["+j+"]["+k+"]["+l+"]: "+featureValuesTopLevel[j][k][l]);
        //featureValuesTopLevelToFloat.add(valueOf(featureValuesTopLevel[j][k][l]));
        try {
        if (PApplet.parseFloat(featureValuesTopLevel[j][k][l]) > maxTopLevelFeatureValue) {
        maxTopLevelFeatureValue = PApplet.parseFloat(featureValuesTopLevel[j][k][l]);
        }
        } catch (Exception e) {
        println("featureValuesTopLevel: ...could not parse float from String");
        e.printStackTrace();
        }
      }       
    }
    } else {println("print: is null");}    
  }
  println("maxTopLevelFeatureValue: "+maxTopLevelFeatureValue);
  println();
  
//  // SubLevelFeatures  
//  for (int j = 0; j < featureValuesSubLevels.length; j++) {
//    println("\nDataset Sub Levels Feature Values ["+j+"]: ");
//    if (featureValuesSubLevels[j] != null) {
//    for (int k = 0; k < featureValuesSubLevels[j].length; k++) {
//      if (featureValuesSubLevels[j][k] != null) {
//      for (int l = 0; l < featureValuesSubLevels[j][k].length; l++) {
//        if (featureValuesSubLevels[j][k][l] != null) {
//        for (int m = 0; m < featureValuesSubLevels[j][k][l].length; m++) {
//          println("["+j+"]["+k+"]["+l+"]["+m+"]: "+featureValuesSubLevels[j][k][l][m]);
//        }
//        } else {println("print: is null");}
//      }
//      } else {println("print: is null");}    
//    }  
//    } else {println("print: is null");}   
//  }

  pPtaxonomy = dataBoard.get(0).getTaxonomy();
  //println("Taxonomy Structure: \n\n"+pPtaxonomy.getFormattedTreeStructure());
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "jMIR_visualization" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
