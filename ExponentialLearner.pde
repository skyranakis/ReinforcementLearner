/*  Similar to RewardAndPunishmentLearner, but with a reward fucntion based on multiplication, not addition
      
*/

public class ExponentialLearner extends RewardAndPunishmentLearner
{
  
  public ExponentialLearner(Random r){
    super(r);
  }
  
  //Overrides reward to use multiplication instead of addition for exponential gains
  public int reward(int time, double reward, boolean reachedGoal){
    int len = mem.length();    //should = time
    
    for (int i=0; i<len; i++){
      char curChar = mem.charAt(i);
      
      if (len==0){
        return 1;   //Error
      }

      double currentVal = model.get(""+curChar);
      double newVal = currentVal * (1 + (reward / len) );
      if (newVal != 0){
        model.put(""+curChar, newVal); 
      }
      updateTValue();
      
    }
    
    if (reachedGoal){
      softReset();
    }
    
    return 0;
    
  }
  
}
