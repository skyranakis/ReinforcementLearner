//Allows for creation of new levels

import controlP5.*;

public class LevelEditor
{
    
  private GameMap newMap;
  private String name;
  //ControlP5 lECP5;
  //PApplet mainObject;
  
  //Constructor.  PApplet here because of ControlP5's constructor, see https://forum.processing.org/two/discussion/13625/how-to-use-controlp5-inside-classes
  public LevelEditor(){
    newMap = new GameMap();
    name = "";
  }
  
  public void start(){
    
    cp5.addButton("returnToMenu")
      .setPosition(450,450)
      .setSize(100,100)
      .activateBy(ControlP5.RELEASE);
      
    cp5.addTextfield("levelName")
      .setPosition(100,510);
    
    cp5.addTextfield("width")
      .setPosition(100,540);
      
    //cp5.addTextfield("height")
    //  .setPosition(100,570);
      
    drawLevel();
  }
  
  public void drawLevel(){
    background(255);
    text("Level Editor", 420, 20);
    text("Level Name:", 20, 522);
    text("Width:", 20, 552);
    text("Height:", 20, 582);
    checkFieldsAndAct();
    newMap.drawMap();
  }
  
  public void end(){
    cp5.getController("returnToMenu").remove();
    cp5.getController("levelName").remove();
    cp5.getController("width").remove();
    //cp5.getController("height").remove();
  }
  
  //Checks the fields and changes things if necessary
  public void checkFieldsAndAct(){
    
    //Updates map name
    name = cp5.get(Textfield.class, "levelName").getText();
    
    //Checks width and height fields
    int newWidth = 0;
    String strWidth = cp5.get(Textfield.class, "width").getText();
    try {
      newWidth = Integer.parseInt(strWidth);
    }catch(Exception e){}
    
    //int newHeight = 0;
    //String strHeight = cp5.get(Textfield.class, "height").getText();
    //try {
    //  newHeight = Integer.parseInt(strHeight);
    //}catch(Exception e){}
    
    //Changes things if necessary
    if (newWidth != newMap.getSize()[0]){
      newMap = new GameMap(newWidth, newMap.getSize()[1]);
    }
    //if (newHeight != newMap.getSize()[1]){
    //  newMap = new GameMap(newMap.getSize()[0], newHeight);
    //}
    
  }
  
}
