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
 
import javax.swing.*; 
import controlP5.*;


void jMIR_GUI() {
  // set system look and feel 
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
  } 
  catch (Exception e) { 
    e.printStackTrace();  
  }
  
  // TODO SETUP CONTROLP5 GUI elements
  
}

String fileChooser(int dataType) {
  
  String filePath;
  
  // create a file chooser 
  final JFileChooser fc = new JFileChooser();  
  
  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
   
  if (returnVal == JFileChooser.APPROVE_OPTION) {
      File file = fc.getSelectedFile();

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
  

  
  // file path array
  String[] filePath;

  // Enable multiple file selection
  fc.setMultiSelectionEnabled(true); 
  
  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
   
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    
    File[] files = fc.getSelectedFiles();

    filePath = new String[files.length];
    
    for (int i = 0; i < files.length; i++) {  
    // see if it's an xml 
    if (files[i].getName().endsWith("xml")) { 
      // load the xml using the given file path
      filePath[i] = files[i].getPath(); 
      } else {
      return null;
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
