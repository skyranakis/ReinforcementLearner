/*  Similar to RewardAndPunishmentLearner, but with a reward fucntion based on multiplication, not addition
      
*/

public class RewardAndPunishmentLearner2 extends RewardAndPunishmentLearner
{
  
  public RewardAndPunishmentLearner2(Random r){
    super(r);
  }
  
  //Overrides reward to use multiplication instead of addition for exponential gains
  public void reward(int time, double reward, boolean reachedGoal){
    int len = mem.length();    //should = time
    
    for (int i=0; i<len; i++){
      char curChar = mem.charAt(i);
      
      if (len==0){
        len = 1;    //Unscientific, but avoids division by 0
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
    
  }
  
}
