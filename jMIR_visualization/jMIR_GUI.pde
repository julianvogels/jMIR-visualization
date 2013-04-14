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

// ControlP5 GUI library
import controlP5.*;

ControlP5 cp5;

// General UI elements 
import javax.swing.*; 

// Window Management
import java.awt.Frame;
import java.awt.BorderLayout;
ControlFrame cf;

// Frame management
float fFrameHeight = (float) frameHeight;

// GUI Groups
Group g1;

// GUI general
Textlabel title;
Textlabel description;
Label confirmButton;

// browseFileGUI
Textlabel myTextlabelA;
File currentDirectory = new File(dataPath(""));

// Assets
PImage fileGUIbg;


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
  
  // SETUP CONTROLP5 GUI elements
  cp5 = new ControlP5(this);
  
  // TODO: use later
//  g1 = cp5.addGroup("g1")
//                .setPosition(20,80)
//                .setWidth(300)
//                ;
                
  // change GUI colors
  cp5.setColorForeground(0xffDC241F);
  cp5.setColorBackground(0xff660000);
  cp5.setColorLabel(0xffcccccc);
  cp5.setColorValue(0xffffffff);
  cp5.setColorActive(0xffff0000);
  
  // Offset the whole file chooser block and confirm button
  int fileBrowseGUIyOffset = width/2-200+85; // was 85
  int fileBrowseGUIxOffset = width/2-150; // was 20
  
  // fileGUI Background image
  fileGUIbg = loadImage("fileGUIbg.png");
  // 
  
  browseFileGUI(fileBrowseGUIxOffset, fileBrowseGUIyOffset, 1, "Feature Vectors XML or folder containing XMLs", "feature vectors");
  browseFileGUI(fileBrowseGUIxOffset, 60+fileBrowseGUIyOffset, 2, "Taxonomy XML", "taxonomy");
  browseFileGUI(fileBrowseGUIxOffset, 120+fileBrowseGUIyOffset, 3, "Feature Key XML", "feature key");
  browseFileGUI(fileBrowseGUIxOffset, 180+fileBrowseGUIyOffset, 4, "Classification XML", "classification");
  
  // create title and description
  title = cp5.addTextlabel("jMIR visualization")
                    .setText("jMIR visualization")
                    .setPosition(fileBrowseGUIxOffset-4,10)
                    .setColorValue(0x00000000)
                    .setFont(font)
                    ;
                    
    // create title and description
  description = cp5.addTextlabel("description")
                    .setText("Please provide the exported \njMIR ACEXML 1.0 documents.")
                    .setPosition(fileBrowseGUIxOffset-4,35)
                    .setColorValue(0x00000000)
                    ;
  
  // create the validation button
  confirmButton = cp5.addButton("Confirm")
     .setPosition(19,245+fileBrowseGUIyOffset)
     .setSize(271,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
     
     
      // set file paths if DEBUG is set
  if (DEBUG) {
    Textfield txt1 = ((Textfield)cp5.getController("feature vectors"));
    txt1.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/FeatureVectors/FeatureVectors.xml");  
    Textfield txt2 = ((Textfield)cp5.getController("feature key"));
    txt2.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/FeatureKey.xml");  
    Textfield txt3 = ((Textfield)cp5.getController("taxonomy"));
    txt3.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/Taxonomy.xml");  
    Textfield txt4 = ((Textfield)cp5.getController("classification"));
    txt4.setValue("/Volumes/Data HD/Users/Julian/Documents/Processing/jMIR-visualization/jMIR_visualization/data/Classifications.xml");  
  
  }
}


void browseFileGUI(int x, int y, int id, String headline, String desc) {
    
    cp5.addBang("Browse"+(id*10+1))
     .setPosition(x+220,y+15)
     .setId(id*10+1)
     .setCaptionLabel("Browse")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
  
  cp5.addTextfield(desc)
     .setId(id*10)
     .setPosition(x,y+15)
     .setAutoClear(false)
     ; 
  
  Textlabel myTextlabelA = cp5.addTextlabel("FileBrowseLabel"+(id*10))
                    .setText(headline)
                    .setPosition(x-4,y)
                    .setColorValue(0x00000000)
                    ;
  
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
    Textfield txt = ((Textfield)cp5.getController("feature vectors"));  
    txt.setValue(""+concatString);  
    //println(concatString);
    }   
    }
        
    // clicking on brwoseFileGUI2 browse button button: on success displays path in textField      
    if(theEvent.controller().getId()==21) {
    String browseFile = fileChooser(0);
    if(browseFile != null) {
    Textfield txt = ((Textfield)cp5.getController("taxonomy"));
    txt.setValue(""+browseFile);  
        }
    } 
 
    // clicking on brwoseFileGUI3 browse button button: on success displays path in textField      
    if(theEvent.controller().getId()==31) {
    String browseFile = fileChooser(0);
    if(browseFile != null) {
    Textfield txt = ((Textfield)cp5.getController("feature key"));
    txt.setValue(""+browseFile);  
        }
    }    
    
    // clicking on brwoseFileGUI4 browse button button: on success displays path in textField      
    if(theEvent.controller().getId()==41) {
    String browseFile = fileChooser(0);
    if(browseFile != null) {
    Textfield txt = ((Textfield)cp5.getController("classification"));
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
  txts[0] = ((Textfield)cp5.getController("taxonomy"));
  txts[1] = ((Textfield)cp5.getController("feature key"));
  txts[2] = ((Textfield)cp5.getController("classification"));

  // Checking for multiple entries in featureVectors field (Comma separated)
  Textfield featureVectors = ((Textfield)cp5.getController("feature vectors"));
  
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
  txts[0] = ((Textfield)cp5.getController("taxonomy"));
  txts[1] = ((Textfield)cp5.getController("feature key"));
  txts[2] = ((Textfield)cp5.getController("classification"));
  txts[3] = ((Textfield)cp5.getController("feature vectors"));
  
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
    //cf = addControlFrame("Data Visualization Panel", 960, 800);
//    while (fFrameHeight <= 960) {
//    fFrameHeight *= 1.05;
//    frame.setSize(round(fFrameHeight*1.2), round(fFrameHeight));
//    frame.setLocation(displayWidth/2-round(fFrameHeight*1.2)/2, displayHeight/2-round(fFrameHeight)/2);
//    }
    frame.setTitle("jMIR Visualization");
    
    // Remove GUI elements that are not needed anymore
    cp5.remove(title.getName());
    // STUPID
    //cp5.remove(description.getName());
    //description.remove();
    // confirmButton.remove();
    println(title.getName());
    
    background(0xFFFFFFFF);
    jMIR_preprocessor();
    }
}

void jMIR_GUI_run() {
image(fileGUIbg, width/2-250, height/2-200);
}

