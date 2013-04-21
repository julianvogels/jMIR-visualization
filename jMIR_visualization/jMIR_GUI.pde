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
import controlP5.*;

// General UI elements 
import javax.swing.*; 

// Window Management
import java.awt.Frame;
import java.awt.BorderLayout;

//===============================
// DECLARATIONS
//===============================

ControlP5 fileCP5;
ControlP5 mainGUI;

// Frame management
ControlFrame cf;
float fFrameHeight = (float) frameHeight;

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
ListBox l;

// GUI Groups
//Group g1;

// Other GUI elements
PImage fileGUIbg;

// Flags and runtime variables
// ---------------------------
// File path check
boolean errorFlag = false;

// picture fade
boolean fadeGUIFlag = false;
int fadeGUIVal = 0;
// GUI move
boolean moveFileGUIFlag = false;

boolean renderBGImage = true;

void jMIR_GUI() {
  
  smooth();
  
  // adjust window position
  // TODO fix
  //frame.setLocation(displayHeight/2-round(frameHeight/2), displayWidth/2-round(frameWidth/2));
  
  // Font customizations
  PFont  font = createFont("Helvetica", 20);
  textFont(font);
    
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
                    .setFont(font)
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
    
     
    // GROUPS
    // TODO: use later
//  g1 = fileCP5.addGroup("g1")
//                .setPosition(20,80)
//                .setWidth(300)
//                ;   
     
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
    txt1.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Feature_Values/Combined/combined_cultural_artist_10_class_audio_feature_values.xml, /Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/SLAC/SLAC_Feature_Values/Combined/combined_cultural_artist_10_class_symbolic_feature_values.xml");  
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
    }
    
  }

}

String fileChooser() {
  
  String filePath;
  
  // create a file chooser 
  final JFileChooser fc = new JFileChooser();  
  fc.setCurrentDirectory(currentDirectory);  

  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
   
  if (returnVal == JFileChooser.APPROVE_OPTION) {
      File file = fc.getSelectedFile();
      currentDirectory = file.getParentFile();
      //println(currentDirectory);
      
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

String[] filesChooser() {
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
        println("chosen path is directory");
        // TODO implement directory functionality
        } 
        else {
            return null;
        }
      }
    }
  } else { 
    println("Open command cancelled by user."); 
    return null;
  }
  return filePath;
}

FileSet openFiles() {
  //Create a FileSet, containing the file paths to the XML documents
  FileSet fileSet = new FileSet();
  fileSet.taxonomy = fileChooser();
  fileSet.featureKey = filesChooser();
  fileSet.featureVectors = filesChooser();
  fileSet.classification = filesChooser();
  if(fileSet.taxonomy == null || fileSet.featureKey == null || fileSet.featureVectors == null || fileSet.classification == null) {
  // TODO add error
  println("big fat IO file error");
  return null;
  } else {
  return fileSet;
  }
}

void fileSaver() {

}

void controlEvent(ControlEvent theEvent) {
  
  if(theEvent.isController()) { 
    
    print("control event from : "+theEvent.controller().name()+", ID: "+theEvent.controller().getId());
    println(", value : "+theEvent.controller().value());
    
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
      //println("file: "+browseFile1[i]+", concatenated String "+concatString);
      }
    Textfield txt = ((Textfield)fileCP5.getController("feature vectors"));  
    txt.setValue(""+concatString);  
    //println(concatString);
    }   
    }
        
    // clicking on brwoseFileGUI2 browse button button: on success displays path in textField  TAXONOMY     
    if(theEvent.controller().getId()==21) {
    String browseFile = fileChooser();
    if(browseFile != null) {
    Textfield txt = ((Textfield)fileCP5.getController("taxonomy"));
    txt.setValue(""+browseFile);  
        }
    } 
 
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
          //println("file: "+browseFile1[i]+", concatenated String "+concatString);
        }
      Textfield txt = ((Textfield)fileCP5.getController("feature key"));
      txt.setValue(""+concatString);  
      //println(concatString);
      } 
    }    
    
    // clicking on brwoseFileGUI4 browse button button: on success displays path in textField  CLASSIFICATION   
    if(theEvent.controller().getId()==41) {
    String[] browseFile4 = filesChooser();
      if(browseFile4 != null) {
        String concatString = "";
        for (int i = 0; i < browseFile4.length; i++) {
          if(i!=0) {
          concatString = concatString.concat(",");
          }
          concatString = concatString.concat(browseFile4[i]);
          //println("file: "+browseFile1[i]+", concatenated String "+concatString);
        }
      Textfield txt = ((Textfield)fileCP5.getController("classification"));
      txt.setValue(""+concatString);  
      //println(concatString);
      } 
   }   
   
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
    try {
    Taxonomy taxonomy = Taxonomy.parseTaxonomyFile(taxonomyXML);
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
      boolean isDataBoardError = dataBoardInitWithObjects(taxonomy, mergedFeatureDefinition, parsedSets, mergedSegmentedClassification);
      
      // Method parsing file paths (not allowing multiple classification or feature key files)
      // boolean isDataBoardError = dataBoard(taxonomyXML, featureKeyXML, featureVectorsXML, classificationXML);
      
      if (DEBUG) {
      println("dataBoard error: "+isDataBoardError);
      }
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

String[] checkMultipleFiles(Textfield tf) {
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
void dataBoardError() {
  // TODO: only display where the error was produced
  
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
void initVisualization() {
    // DataBoard returned all is fine
    
    // Second frame
    //cf = addControlFrame("Data Visualization Panel", 960, 800);
//    while (fFrameHeight <= 960) {
//    fFrameHeight *= 1.05;
//    frame.setSize(round(fFrameHeight*1.2), round(fFrameHeight));
//    frame.setLocation(displayWidth/2-round(fFrameHeight*1.2)/2, displayHeight/2-round(fFrameHeight)/2);
//    }

    frame.setTitle("jMIR Visualization - Choose your data");
    
    // By setting the fadeGUIFlag, the run function calles the setupMainGUI after everything faded away
    fadeGUIFlag = true;
    //moveFileGUIFlag = true;
    
    // Launch the Preprocessor
    jMIR_preprocessor();
}

void fadeGUI(boolean fadeGUIFlag_) {
  if (fadeGUIFlag_) {
    
    if (fadeGUIVal < 100) {
      fadeGUIVal++;  
      fill(255, fadeGUIVal*2.55);
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

void moveGUI(boolean moveFileGUIFlag_) {
  if (moveFileGUIFlag_) {
    
    if (fileBrowseGUIxOffset >= (-300)) {
      fileBrowseGUIxOffset = fileBrowseGUIxOffset-2; 
//      PVector titlevec = title.getPosition();
//      titlevec.x = titlevec.x-2; 
//      title.setPosition(titlevec);
      println(title.getAbsolutePosition());
    } else {
      moveFileGUIFlag = false;
    }
  }
}



void setupMainGUI() {
  mainGUI = new ControlP5(this);
  
  //===============================
  // GENERAL GUI ELEMENTS
  //===============================
  renderBGImage = false;
  
  title = mainGUI.addTextlabel("jMIR visualization")
                    .setText("jMIR visualization")
                    .setPosition(10,10)
                    .setColorValue(0x00000000)
                    .setId(1)
                    ;
  //===============================
  // Listboxes
  //===============================

  l = mainGUI.addListBox("Features")
         .setPosition(10, 50)
         .setSize(240, 120)
         .setBarHeight(15)
         ;  
         
  //l.captionLabel().toUpperCase(true);
  l.captionLabel().set("Feature Names");
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3; 


    for (int i = 0; i < featureNames.length; i++) {
    ListBoxItem lbi = l.addItem(featureNames[i], i);
    //lbi.setColorBackground(0xffff0000);
  }
  
  int itemHeight = 15;
  
  if(featureNames.length < 20) {
  l.setItemHeight(15);
  itemHeight = 15;
  } else {
  l.setItemHeight(10);
  itemHeight = 10;
  }
  int lbheight = itemHeight*(featureNames.length+1);
  if (lbheight > (height-70)) {
  l.setHeight(height-70);
  } else {
  l.setHeight(itemHeight*(featureNames.length+1));
  }
  //===============================
  // Graph
  //===============================
  // call the graphics setup
  jMIR_graphics();
}




void jMIR_GUI_run() {
  background(0xFFFFFFFF);
  if (renderBGImage)
    image(fileGUIbg, fileBrowseGUIxOffset-65, fileBrowseGUIyOffset-65);
  fileCP5.draw();
  fill(255, fadeGUIVal*2.55);
  fadeGUI(fadeGUIFlag);
  rect(0,0,width,height);
  //moveGUI(moveFileGUIFlag);
}
