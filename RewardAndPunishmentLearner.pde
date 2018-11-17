/*Responds to both Reward and Punishment
    Holy crap this works really well, at least for Map1
    Additive reward function prevents good models from pulling too far ahead
*/
import java.util.*;

public class RewardAndPunishmentLearner implements Agent
{
  Map<String,Double> model;     //Will drive decisions
  String mem;                   //Path to remember
  double tValue;                //Tracks sum of all values (for move)
  
  //Default Constructor
  public RewardAndPunishmentLearner(){
    model = new HashMap<String,Double>();
    model.put("u", new Double(1));
    model.put("d", new Double(1));
    model.put("l", new Double(1));
    model.put("r", new Double(1));
    tValue = 4;  
    mem = "";
  }
  
  //Outputs a character corresponding to the move that should be made
  public char move(){
    char c = ' ';
    double v = Math.random()*tValue;
    double total = 0;
    Set< Map.Entry<String,Double> > st = model.entrySet();
    for (Map.Entry<String,Double> me:st){  //Iterates over map
      total += me.getValue();
      if (v<=total){
        c = me.getKey().charAt(0);
        break;
      }
    }
    if ( total==0 ){    //Choose randomly if it's 0 all around, so it's stuck
      double d2 = Math.random();
      if (d2<0.25){
        c = 'u';
      }else if (d2<0.5){
        c = 'd';
      }else if (d2<0.75){
        c = 'l';
      }else{
        c = 'r';
      }
    }
    mem += c;
    return c;
  }
  
  //Adjusts the model according to the reward
  public void reward(int time, double reward){
    int len = mem.length();    //should = time
    
    for (int i=0; i<len; i++){
      char curChar = mem.charAt(i);
      
      if (len==0){
        len = 1;    //Unscientific, but avoids division by 0
      }
      
      model.put(""+curChar, model.get(""+curChar)+reward/len); //adds reward/len to the value associated with the current char
      tValue += reward/len;
      double diff = model.get(""+curChar);
      
      if ( diff<0 ){    //Makes sure no valuses are negative
        model.put(""+curChar, new Double(0));
        tValue -= diff;
      }
      
    }
    
  }
  
  //outputs the model (copied from SimpleLearner)
  public String toString(){
    String s = "";
    Set< Map.Entry<String,Double> > st = model.entrySet();
    for (Map.Entry<String,Double> me:st){ 
      s += me.getKey() + ": " + String.format("%4.3f" , me.getValue()) + "  ";
    }
    return s;
  }
  
  //Updates tValue based on the current model
  public void updateTValue(){
    tValue = 0;
    Set< Map.Entry<String,Double> > st = model.entrySet();
    for (Map.Entry<String,Double> me:st){  //Iterates over map
      tValue += me.getValue();
    }
  }
  
  //Resets memory
  public void softReset(){
    mem = "";
  }
  
}
