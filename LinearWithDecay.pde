/*  Similar to RewardAndPunishmentLearner, but with decay (see ExponentialWithDecay for explanation)
      
*/

public class LinearWithDecay extends RewardAndPunishmentLearner
{
  protected final double DECAY;
  protected final double CORRECTION_FACTOR;
  
  public LinearWithDecay(Random r){
    super(r);
    DECAY = 0.8;
    CORRECTION_FACTOR = 1;
  }
  
  //Overrides reward to use decay, but same addition technique
  public int reward(int time, double reward, boolean reachedGoal){
    int len = mem.length();    //should = time
    
    //Loops backwards to allow for decay
    for (int i=len-1; i>0; i--){
      char curChar = mem.charAt(i);
      model.put(""+curChar, model.get(""+curChar)+ (reward * CORRECTION_FACTOR) );  //Removed the length bit
      tValue += reward * CORRECTION_FACTOR;
      
      double newVal = model.get(""+curChar);
      if ( newVal<0 ){    //Makes sure no valuses are negative
        model.put(""+curChar, new Double(0));
        tValue -= newVal;
      }
      
      reward *= DECAY;  //This is the decay bit
      
    }
    
    if (reachedGoal){
      softReset();
    }
    
    return 0;
    
  }
  
}
