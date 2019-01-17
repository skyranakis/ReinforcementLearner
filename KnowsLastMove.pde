/* Agent that makes decisions based on the last move and probability
    Note: it REMEMBERS all moves for training purposes but only decides based on last one
    Note: Does NOT know if it's hit a wall
    Note: Fundamentally the same reward algorithm as exponential with decay
*/

import java.util.*;

public class KnowsLastMove implements Agent{
  
  protected Map<String, Map<String,Double> > model;  //Outer map allows for lookup by preceding move
                                                     //Inner is sub-model for that scenario
  protected String mem;
  protected Random rand;
  protected final double DECAY;
  protected final double CORRECTION_FACTOR;
  
  public KnowsLastMove(Random r){
    
    Map<String,Double> afterStart = new HashMap<String,Double>();
    afterStart.put("u", new Double(1));
    afterStart.put("d", new Double(1));
    afterStart.put("l", new Double(1));
    afterStart.put("r", new Double(1));
    
    Map<String,Double> afterUp = new HashMap<String,Double>();
    afterUp.put("u", new Double(1));
    afterUp.put("d", new Double(1));
    afterUp.put("l", new Double(1));
    afterUp.put("r", new Double(1));
    
    Map<String,Double> afterDown = new HashMap<String,Double>();
    afterDown.put("u", new Double(1));
    afterDown.put("d", new Double(1));
    afterDown.put("l", new Double(1));
    afterDown.put("r", new Double(1));
    
    Map<String,Double> afterLeft = new HashMap<String,Double>();
    afterLeft.put("u", new Double(1));
    afterLeft.put("d", new Double(1));
    afterLeft.put("l", new Double(1));
    afterLeft.put("r", new Double(1));
    
    Map<String,Double> afterRight = new HashMap<String,Double>();
    afterRight.put("u", new Double(1));
    afterRight.put("d", new Double(1));
    afterRight.put("l", new Double(1));
    afterRight.put("r", new Double(1));
    
    model = new HashMap<String, Map<String,Double> >();
    model.put("_", afterStart);
    model.put("u", afterUp);
    model.put("d", afterDown);
    model.put("l", afterLeft);
    model.put("r", afterRight);
    
    mem = "_";      //Underscore shall indicate start
    rand = r;
    DECAY = 0.8;
    CORRECTION_FACTOR = 1;
  }
  
  //Same as in ExponentialWithDecay, but it gets the right thing based on the 
  public int reward(int time, double reward, boolean reachedGoal){
    
    int len = mem.length();    //should be equal to the time
    
    for (int i=len-1; i>0; i--){
      char curChar = mem.charAt(i);
      char prevChar = mem.charAt(i-1);
      double currentVal = model.get(""+prevChar).get(""+curChar);
      double newVal = currentVal * (1 + (reward * CORRECTION_FACTOR) );
      if (newVal != 0){
        model.get(""+prevChar).put(""+curChar, newVal); 
      }
      reward *= DECAY; 
    }
    
    if (reachedGoal){
      softReset();
    }
    
    return 0;
  }
  
  public char move(){
    
    //Selects proper model to choose from randomly based on last move
    String prev = "_";
    if (mem.length() > 0){
      prev = "" + mem.charAt( mem.length()-1 );
    }
    Map<String,Double> subModel = model.get(prev);
    
    //Finds total of the values for the four options
    double tValue = 0;
    Set< Map.Entry<String,Double> > st = subModel.entrySet();
    for (Map.Entry<String,Double> me:st){  //Iterates over map
      tValue += me.getValue();
    }
    
    //Chooses one of the four move options randomly
    char c = ' ';
    double v = rand.nextDouble()*tValue;
    double total = 0;
    Set< Map.Entry<String,Double> > set = subModel.entrySet();
    for (Map.Entry<String,Double> me:set){  //Iterates over map
      total += me.getValue();
      if (v<=total){
        c = me.getKey().charAt(0);
        break;
      }
    }
    
    //Choose randomly if it's 0 all around, so it's stuck
    if ( total==0 ){    
      double d2 = rand.nextDouble();
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
  
  public String toString(){
    return("I'll do this later");
  }
  
  public void softReset(){
    mem = "_";
  }
  
}
