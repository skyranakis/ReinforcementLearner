/* Agent that makes decisions based on the position and probability
    Note: Fundamentally the same reward algorithm as exponential with decay
*/

import java.util.*;

public class KnowsPosition implements Agent{
  
  protected Map< Position, Map<String,Double> > model; //Pair represents the position
                                                                    //Inner is sub-model for that scenario
  protected String mem;
  protected Random rand;
  protected final double DECAY;
  protected final double CORRECTION_FACTOR;
  protected final double EXPLORATION_RATE;
  //protected final int HEIGHT;
  //protected final int WIDTH;
  
  public KnowsPosition(Random rnd, int[] size){
    
    //Initialize model
    model = new HashMap< Position, Map<String,Double> >();
    int h = size[0];
    int w = size[1];
    for (int r=0; r<h; r++){
      for (int c=0; c<w; c++){
        Position pos = new Position(r,c);
        Map<String,Double> innerModel = new HashMap<String,Double>();;
        innerModel.put("u", new Double(1));
        innerModel.put("d", new Double(1));
        innerModel.put("l", new Double(1));
        innerModel.put("r", new Double(1));
        model.put(pos, innerModel);
      }
    }
    
    //Initialize the rest
    mem = "";
    rand = rnd;
    DECAY = 0.8;
    CORRECTION_FACTOR = 1;
    EXPLORATION_RATE = 0.1;
    //HEIGHT = size[0];
    //WIDTH = size[1];
  }
  
  public int reward(int time, double reward, boolean reachedGoal){
    
    String steps[] = mem.split("\\r?\\n");
    int len = steps.length;    //should be equal to the time
    
    for (int i=len-1; i>0; i--){
      
      //Parse line of mem
      String step = steps[i];
      int firstComma = step.indexOf(',');
      String sX = step.substring(0, firstComma);
      step = step.substring(firstComma+1);
      int secondComma = step.indexOf(',');
      String sY = step.substring(0, secondComma);
      String sMove = step.substring(secondComma+1);
      int x = Integer.parseInt(sX);
      int y = Integer.parseInt(sY);
      char move = sMove.charAt(0);
      Position pos = new Position(x,y);
      
      //Reinforce that move
      double currentVal = model.get(pos).get(""+move);
      double newVal = currentVal * (1 + (reward * CORRECTION_FACTOR) );
      if (newVal != 0){
        model.get(pos).put(""+move, newVal); 
      }
      reward *= DECAY; 
    }
    
    if (reachedGoal){
      softReset();
    }
    
    return 0;
  }
  
  public char move(Position pos){
    Map<String,Double> subModel = model.get(pos);
    
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
    
    //Choose randomly if it's 0 all around, so it's stuck, or it's time to explore instead
    double explore = rand.nextDouble();
    if ( total==0 || explore<EXPLORATION_RATE ){    
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
    
    //Updates the memory with both the position and the outcome, delineated by commas and newlines
    mem += (pos.x + ",");
    mem += (pos.y + ",");
    mem += (c + "\n");
    
    return c;
  }
  
  public char move(){
    return move( new Position(0,0) );
  }
  
  public void softReset(){
    mem = "";
  }
  
  public String toString(){
    return "Haven't done this yet either";
  }
  
}
