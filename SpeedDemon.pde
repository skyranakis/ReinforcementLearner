//SimpleLearner, except it only updates if the new time is a record 
/* SpeedDemon notes:
    Should prevent divergence from optimal solution
    Seems to get stuck on first goodish solution (20-30 for Map1) can't prove
*/


public class SpeedDemon extends SimpleLearner{
  
  int recordTime;  //Records record time
  
  //Constructor
  public SpeedDemon(Random r){
    super(r);
    recordTime = Integer.MAX_VALUE;
  }
  
  //Overrides the other reward function to only work if the new time sets a record
  public void reward(int time, double reward, boolean reachedGoal){
    if ( time<recordTime && reachedGoal ){
      super.reward(time, reward, reachedGoal);
      recordTime = time;
    }
  }
  
}
