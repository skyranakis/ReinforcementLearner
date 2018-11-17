/*  Similar to RewardAndPunishmentLearner, but with a reward fucntion based on multiplication, not addition
      
*/

public class RewardAndPunishmentLearner2 extends RewardAndPunishmentLearner
{
  
  public RewardAndPunishmentLearner2(){
    super();
  }
  
  //Overrides reward to use multiplication instead of addition for exponential gains
  public void reward(int time, double reward){
    int len = mem.length();    //should = time
    
    for (int i=0; i<len; i++){
      char curChar = mem.charAt(i);
      
      if (len==0){
        len = 1;    //Unscientific, but avoids division by 0
      }

      double currentVal = model.get(""+curChar);
      double newVal = currentVal * (1 + (reward / len) ) + 0.0001;  //Exponential improvement, not linear (0.0001 to avoid 0s)
      model.put(""+curChar, newVal); 
      updateTValue();
      
    }
    
  }
  
}
