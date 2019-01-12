//Allows for creation of new levels

import controlP5.*;

public class LevelEditor
{
    
  private String[][] newMap;
  //ControlP5 lECP5;
  //PApplet mainObject;
  
  //Constructor.  PApplet here because of ControlP5's constructor, see https://forum.processing.org/two/discussion/13625/how-to-use-controlp5-inside-classes
  public LevelEditor(){
    newMap = new String[0][0];
  }
  
  public void start(){
    drawLevel();
  }
  
  public void drawLevel(){
    background(255);
  }
  
  public void end(){}
  
}
