//Allows for creation of new levels

import controlP5.*;

public class LevelEditor
{
    
  private GameMap newMap;
  private String name;
  int w;
  int h;
  RadioButton rb;
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
    
    rb = cp5.addRadioButton("typeSelector")
      .setPosition(450,50)
      .setSize(20,20)
      .addItem("Normal",1)
      .addItem("Wall",2)
      .addItem("Start",3)
      .addItem("Goal",4);
    
    cp5.addButton("returnToMenu")
      .setPosition(450,550)
      .setSize(100,100)
      .activateBy(ControlP5.RELEASE);
      
    cp5.addButton("saveMap")
      .setPosition(450,400)
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
    textSize(30);
    text("Level Editor", 410, 35);
    textSize(12);
    text("Level Name:", 20, 522);
    text(name, 310, 522);
    text("Width:", 20, 552);
    text(w, 310, 552);
    text("Height:", 20, 582);
    text(h, 310, 582);
    text("Normal",500,65);
    text("Wall",500,85);
    text("Start",500,105);
    text("Goal",500,125);
    checkFieldsAndAct();
    newMap.drawMap();
  }
  
  public void end(){
    rb.remove();
    cp5.getController("returnToMenu").remove();
    cp5.getController("saveMap").remove();
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
  
  //Actually handles SAVEMAP button
  public void actuallySaveMap(){
    try{
      newMap.writeMap( "Maps/" + name + ".txt" );
    }catch(Exception e){}
  }
  
  public void tryToChange(int x, int y){
    int squareSize = newMap.getSquareSize();
    int squareX = x/squareSize;
    int squareY = y/squareSize;
    String type = "";
    for(Toggle t:rb.getItems()){
      if (t.getBooleanValue()){
        type = t.getCaptionLabel().getText();
      }
    }
    newMap.changeType(squareX, squareY, type);
  }
  
}
