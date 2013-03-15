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

// browseFileGUI
Textlabel myTextlabelA;
File currentDirectory = new File(dataPath(""));

void jMIR_GUI() {
  
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
  
  // TODO SETUP CONTROLP5 GUI elements
  cp5 = new ControlP5(this);
  
  cp5.setColorForeground(0xffDC241F);
  cp5.setColorBackground(0xff660000);
  cp5.setColorLabel(0xffcccccc);
  cp5.setColorValue(0xffffffff);
  cp5.setColorActive(0xffff0000);
  //cp5.setControlFont(font);
  
  browseFileGUI(20, 25, 1, "Feature Vectors XML or folder containing XMLs", "feature vectors");
  browseFileGUI(20, 85, 2, "Taxonomy XML", "taxonomy");
  browseFileGUI(20, 145, 3, "Feature Key XML", "feature key");
  browseFileGUI(20, 205, 4, "Classification XML", "classification");
  
  // create the validation button
  cp5.addButton("Confirm")
     .setPosition(19,270)
     .setSize(271,19)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
}


void browseFileGUI(int x, int y, int id, String headline, String desc) {
    cp5.addBang("Browse"+(id*10))
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
  
  // TODO query for folder
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
      println("file: "+browseFile1[i]+", concatenated String "+concatString);
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
   
    // Validation of the entries made in the four text fields
    if(theEvent.controller().getId()==41) {
    
    }
  }  
}

// function colorA will receive changes from 
// controller with name colorA
public void Confirm(int theValue) {
  println("a button event from validation Button: "+theValue);
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
  Textfield featureVectors = ((Textfield)cp5.getController("feature keys"));
  
  // Split entry to get the single file paths
  //println(((Textfield)cp5.getController("feature vectors")).getText());
  //println(((Textfield)cp5.getController("taxonomy")));
  if (((Textfield)cp5.getController("feature vectors"))!=null) {
  featureVecInput = splitTokens(featureVectors.getText(), ",");

  // Cycle through Feature Vector field (possible multiple entries)
  for (int i = 0; i < featureVecInput.length; i++) {
    //check if file is an XML file
    if(featureVecInput[i].endsWith(".xml")) {  
      // check if file exists
      //File checkFile = new File(featureVecInput[i]);
      //if(!checkFile.exists()) {
      //errorFlag = true;
      //}      
    } else {
      errorFlag = true;
      println(1);
      // Label: Only XML files!
      featureVectors.setText("ONLY XML FILES!");
    }
  }
  } else { 
  errorFlag = true; 
  println(2);
  }
    

  // Instantiate File Objects
  //File[] filePaths = new File[3];
  // Cycle through single file fields
  for (int i = 0; i < txts.length; i++) {
    // Check if file is an XML file
    if(txts[i].getText().endsWith(".xml")) {        
      //filePaths[i] = new File(txts[i].getText());
      // Check if file exists
      //if(!filePaths[i].exists()) {
      //errorFlag = true;
      //}
    } else {
      // Label: Only XML files!
      errorFlag = true;
      println(3);
      txts[i].setText("ONLY XML FILES!");
    }
  }
    if (!errorFlag) {
    // Window config
    cf = addControlFrame("Data Visualization Panel", 960, 800);
    String taxonomyXML = txts[0].getText();
    String featureKeyXML = txts[1].getText();
    String[] featureVectorsXML = featureVecInput;
    String classificationXML = txts[2].getText();
    //instantiateDataboard(taxonomyXML, featureKeyXML, featureVectorsXML, classificationXML);
    }
      println("Variables: errorFlag "+errorFlag);
  }
}
