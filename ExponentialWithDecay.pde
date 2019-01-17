/* Exponential Learner, but with the reward for each past action dampened by the decay factor
    Exponential Learner is ExponentialWithDecay with decay = 1;
*/

public class ExponentialWithDecay extends ExponentialLearner
{
  protected final double DECAY;
  protected final double CORRECTION_FACTOR;
  
  public ExponentialWithDecay(Random r){
    super(r);
    DECAY = 0.8;
    CORRECTION_FACTOR = 1;
  }
  
  //Overrides reward to use decay, but same multiplication technique
  public int reward(int time, double reward, boolean reachedGoal){
    int len = mem.length();    //should be equal to the time time
    
    for (int i=len-1; i>=0; i--){  //Loops backwards to allow for decay
      char curChar = mem.charAt(i);
      double currentVal = model.get(""+curChar);
      double newVal = currentVal * (1 + (reward * CORRECTION_FACTOR) );  //Removed the length bit
      if (newVal != 0){
        model.put(""+curChar, newVal); 
      }
      updateTValue();
      reward *= DECAY;  //This is the decay bit
    }
    
    if (reachedGoal){
      softReset();
    }
    
    return 0;
    
  }
  
}
