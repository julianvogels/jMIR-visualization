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
// picture fade
boolean fadeGUIFlag = false;
int fadeGUIVal = 0;
// GUI move
boolean moveFileGUIFlag = false;

boolean renderBGImage = false;

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

String fileChooser(int dataType) {
  
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

String[] filesChooser(int dataType) {
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
  fileSet.taxonomy = fileChooser(0);
  fileSet.featureKey = fileChooser(1);
  fileSet.featureVectors = filesChooser(2);
  fileSet.classification = fileChooser(3);
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
    
    // clicking on brwoseFileGUI1 browse button button: on success displays path in textField      
    if(theEvent.controller().getId()==11) {
    String[] browseFile1 = filesChooser(0);
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
        
    // clicking on brwoseFileGUI2 browse button button: on success displays path in textField      
    if(theEvent.controller().getId()==21) {
    String browseFile = fileChooser(0);
    if(browseFile != null) {
    Textfield txt = ((Textfield)fileCP5.getController("taxonomy"));
    txt.setValue(""+browseFile);  
        }
    } 
 
    // clicking on brwoseFileGUI3 browse button button: on success displays path in textField      
    if(theEvent.controller().getId()==31) {
    String browseFile = fileChooser(0);
    if(browseFile != null) {
    Textfield txt = ((Textfield)fileCP5.getController("feature key"));
    txt.setValue(""+browseFile);  
        }
    }    
    
    // clicking on brwoseFileGUI4 browse button button: on success displays path in textField      
    if(theEvent.controller().getId()==41) {
    String browseFile = fileChooser(0);
    if(browseFile != null) {
    Textfield txt = ((Textfield)fileCP5.getController("classification"));
    txt.setValue(""+browseFile);  
        } 
    }   
   
  }  
}

// function colorA will receive changes from 
// controller with name colorA
public void Confirm(int theValue) {
  //println("a button event from validation Button: "+theValue);
  if(theValue==1) {
    
  // if error occurs, error flag will be set
  boolean errorFlag = false;  
    
  // Declarations
  String[] featureVecInput = new String[0];  
    
  // Storing the values in the single file fields
  Textfield[] txts = new Textfield[3];
  txts[0] = ((Textfield)fileCP5.getController("taxonomy"));
  txts[1] = ((Textfield)fileCP5.getController("feature key"));
  txts[2] = ((Textfield)fileCP5.getController("classification"));

  // Checking for multiple entries in featureVectors field (Comma separated)
  Textfield featureVectors = ((Textfield)fileCP5.getController("feature vectors"));
  
  // Split entry to get the single file paths
  if (featureVectors!=null) {
  //println(featureVectors);
  featureVecInput = splitTokens(featureVectors.getText(), ",");

  // Cycle through Feature Vector field (possible multiple entries)
  for (int i = 0; i < featureVecInput.length; i++) {
    //check if file is an XML file
    if(featureVecInput[i].endsWith(".xml")) {  
      // check if file exists
      File checkFile = new File(featureVecInput[i]);
      if(!checkFile.exists()) {
      errorFlag = true;
      featureVectors.setText("FILE DOESN\'T EXIST!");
      }      
    } else {
      errorFlag = true;
      // Label: Only XML files!
      featureVectors.setText("ONLY XML FILES!");
    }
  }
  } else { 
  // textfield was empty
  errorFlag = true; 
  featureVectors.setText("REQUIRED FIELD!");
  }
    

  // Instantiate File Objects
  File[] filePaths = new File[3];
  // Cycle through single file fields
  for (int i = 0; i < txts.length; i++) {
    // Check if file is an XML file
    if(txts[i].getText().endsWith(".xml")) {        
      filePaths[i] = new File(txts[i].getText());
      // Check if file exists
      if(!filePaths[i].exists()) {
      txts[i].setText("FILE DOESN\'T EXIST!");
      errorFlag = true;
      }
    } else {
      // Label: Only XML files!
      errorFlag = true;
      txts[i].setText("ONLY XML FILES!");
    }
  }
    if (!errorFlag) {
    // Window config
    String taxonomyXML = txts[0].getText();
    String featureKeyXML = txts[1].getText();
    String[] featureVectorsXML = featureVecInput;
    String classificationXML = txts[2].getText();
    //instantiateDataboard(taxonomyXML, featureKeyXML, featureVectorsXML, classificationXML);
    boolean isError = dataBoard(taxonomyXML, featureKeyXML, featureVectorsXML, classificationXML);
    println("dataBoard error: "+isError);
    initVisualization(isError);

    }
      //println("errorFlag "+errorFlag);
  }
}

void dataBoardError() {
  // TODO: only display where the error was produced
  
  // Storing the values in the single file fields
  Textfield[] txts = new Textfield[4];
  txts[0] = ((Textfield)fileCP5.getController("taxonomy"));
  txts[1] = ((Textfield)fileCP5.getController("feature key"));
  txts[2] = ((Textfield)fileCP5.getController("classification"));
  txts[3] = ((Textfield)fileCP5.getController("feature vectors"));
  
  for (int i = 0; i < txts.length; i++) {
  txts[i].setText("DATA ERROR!");
  }
}

// checks if dataBoard produced an error and calls either
// dataBoardError() or initializes the Visualization
void initVisualization(boolean isError) {
    if(isError) {
    // databoard is angry
    dataBoardError();
    } else {
    // DataBoard returned all is fine
    
    // Second frame
    //cf = addControlFrame("Data Visualization Panel", 960, 800);
//    while (fFrameHeight <= 960) {
//    fFrameHeight *= 1.05;
//    frame.setSize(round(fFrameHeight*1.2), round(fFrameHeight));
//    frame.setLocation(displayWidth/2-round(fFrameHeight*1.2)/2, displayHeight/2-round(fFrameHeight)/2);
//    }


    frame.setTitle("jMIR Visualization - Choose your data");
    fadeGUIFlag = true;
    //moveFileGUIFlag = true;
    
    
      
//    title.hide();
//    description.hide();
//    confirmButton.hide();
//    browseBang1.hide();
//    browseField1.hide();
//    browseLabel1.hide();
//    browseBang2.hide();
//    browseField2.hide();
//    browseLabel2.hide();
//    browseBang3.hide();
//    browseField3.hide();
//    browseLabel3.hide();
//    browseBang4.hide();
//    browseField4.hide();
//    browseLabel4.hide();
    
    // Launch the Preprocessor
    jMIR_preprocessor();
    
    }
}

void fadeGUI(boolean fadeGUIFlag_) {
  if (fadeGUIFlag_) {
    
    if (fadeGUIVal < 100) {
      fadeGUIVal = fadeGUIVal+1;  
      fill(255, fadeGUIVal*2.55);
    } else {
      fadeGUIFlag = false;
      fadeGUIVal = 0; 
      fileCP5.hide();
      // Setup the mainGUI
      setupMainGUI();
    }
  }
}

void moveFileGUI(boolean moveFileGUIFlag_) {
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

void jMIR_GUI_run() {
  background(0xFFFFFFFF);
  fileCP5.draw();
  fill(255, fadeGUIVal*2.55);
  fadeGUI(fadeGUIFlag);
  rect(0,0,width,height);
  //moveFileGUI(moveFileGUIFlag);
  
  if (renderBGImage)
    image(fileGUIbg, fileBrowseGUIxOffset-65, fileBrowseGUIyOffset-65);

}

void setupMainGUI() {
  mainGUI = new ControlP5(this);
    
  title = mainGUI.addTextlabel("jMIR visualization")
                    .setText("jMIR visualization")
                    .setPosition(10,10)
                    .setColorValue(0x00000000)
                    .setId(1)
                    ;
                    
  l = mainGUI.addListBox("Feature Names")
         .setPosition(10, 50)
         .setSize(120, 120)
         .setBarHeight(15)
         ;  
         
  l.captionLabel().toUpperCase(true);
  l.captionLabel().set("Feature Names");
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3; 


    for (int i = 0; i < featureNames.length; i++) {
    ListBoxItem lbi = l.addItem(featureNames[i], i);
    lbi.setColorBackground(0xffff0000);
  }
  
  int itemHeight = 15;
  
  if(featureNames.length < 20) {
  l.setItemHeight(15);
  itemHeight = 15;
  } else {
  l.setItemHeight(10);
  itemHeight = 10;
  }
  l.setHeight(itemHeight*(featureNames.length+1));

}

