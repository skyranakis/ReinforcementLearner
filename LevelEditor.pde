//Allows for creation of new levels

import controlP5.*;

public class LevelEditor
{
    
  private GameMap newMap;
  private String name;
  int w;
  int h;
  //ControlP5 lECP5;
  //PApplet mainObject;
  
  //Constructor.  PApplet here because of ControlP5's constructor, see https://forum.processing.org/two/discussion/13625/how-to-use-controlp5-inside-classes
  public LevelEditor(){
    newMap = new GameMap();
    name = "";
    w = newMap.getSize()[0];
    h = newMap.getSize()[1];
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
      
    cp5.addTextfield("height")
      .setPosition(100,570);
      
    drawLevel();
  }
  
  public void drawLevel(){
    background(255);
    text("Level Editor", 420, 20);
    text("Level Name:", 20, 522);
    text(name, 310, 522);
    text("Width:", 20, 552);
    text(w, 310, 552);
    text("Height:", 20, 582);
    text(h, 310, 582);
    checkFieldsAndAct();
    newMap.drawMap();
  }
  
  public void end(){
    cp5.getController("returnToMenu").remove();
    cp5.getController("levelName").remove();
    cp5.getController("width").remove();
    cp5.getController("height").remove();
  }
  
  //Checks the fields and changes things if necessary
  public void checkFieldsAndAct(){
    
    //Updates map name
    name = cp5.get(Textfield.class, "levelName").getText();
    
    //Checks width and height fields
    int newWidth = 10;
    String strWidth = cp5.get(Textfield.class, "width").getText();
    try {
      newWidth = Integer.parseInt(strWidth);
    }catch(Exception e){}
    
    int newHeight = 10;
    String strHeight = cp5.get(Textfield.class, "height").getText();
    try {
      newHeight = Integer.parseInt(strHeight);
    }catch(Exception e){}
    
    //Changes things if necessary
    boolean changesNecessary = false;
    if (newWidth != w && newWidth >= 4){
      w = newWidth;
      changesNecessary = true;
    }
    if (newHeight != h && newHeight >= 4){
      h = newHeight;
      changesNecessary = true;
    }
    if (changesNecessary){
      newMap = new GameMap(w, h);
    }
    
  }
  
}
