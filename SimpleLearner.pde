//Simple form of reinforcement learner that holds expected values of each direction using doubles


/* Notes on SimpleLearner:
    Any set of values (barring r=0 or d=0 for Map1, for example) will work given enough time, so maybe it doesn't
      necesssarily converge to optimal solution (I don't want to do that math right now)
    It can also diverge FROM optimal solution (that's frustrating)
    Wouldn't work for large maps
    Can't adjust mid-trial (not sure if feature or bug)
*/

import java.util.*;

public class SimpleLearner implements Agent
{
  Map<String,Double> model;    //Will drive decisions
  String mem;                    //Path to remember
  
  //Default Constructor
  public SimpleLearner(){
    model = new HashMap<String,Double>();
    model.put("u", new Double(0.25));
    model.put("d", new Double(0.25));
    model.put("l", new Double(0.25));
    model.put("r", new Double(0.25));
    mem = "";
  }
  
  //Outputs a character corresponding to the move that should be made
  public char move(){
    char c = ' ';
    double v = Math.random();
    double total = 0;
    Set< Map.Entry<String,Double> > st = model.entrySet();
    for (Map.Entry<String,Double> me:st){  //Iterates over map
      total += me.getValue();
      if (v<=total){
        c = me.getKey().charAt(0);
        break;
      }
    }
    mem += c;
    return c;
  }
  
  //Adjusts the model according to the reward
  public void reward(int time, double reward){
    
    //Causes it to ignore punishment
    if(reward>0){
      
      //Creates a new model
      int len = mem.length();
      Map<String,Double> newModel = new HashMap<String,Double>();
      for (int i=0; i<len; i++){
        char curChar = mem.charAt(i);
        if (!newModel.containsKey(""+curChar)){
          newModel.put(""+curChar, new Double(0));
        }
        newModel.put(""+curChar, newModel.get(""+curChar)+1./len); //adds 1/len to the value associated with the current char
      }
      
      //Ensures new model has all the right keys
      Set< Map.Entry<String,Double> > st = model.entrySet();
      for (Map.Entry<String,Double> me:st){ 
        if (!newModel.containsKey(""+me.getKey())){
          newModel.put(""+me.getKey(), new Double(0));
        }
      }
      
      //Updates the actual model based on the new
      Set< Map.Entry<String,Double> > st2 = newModel.entrySet();
      for (Map.Entry<String,Double> me:st2){ 
        String key = me.getKey();
        double newValue = me.getValue();
        model.remove(key);
        model.put(key, newValue);
      }
      
      //Resets the memory
      mem = "";
    }
    
  }
  
  //outputs the model
  public String toString(){
    String s = "";
    Set< Map.Entry<String,Double> > st = model.entrySet();
    for (Map.Entry<String,Double> me:st){ 
      s += me.getKey() + ": " + String.format("%4.3f" , me.getValue()) + "  ";
    }
    return s;
  }
  
}
