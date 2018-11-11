//SimpleLearner, except it only updates if the new time is a record 
public class SpeedDemon extends SimpleLearner{
  
  int recordTime;  //Records record time
  
  //Constructor
  public SpeedDemon(){
    super();
    recordTime = Integer.MAX_VALUE;
  }
  
  //Overrides the other reward function to only work if the new time sets a record
  public void reward(double r){
    if ( r<recordTime ){
      super.reward(1);
      recordTime = (int)r;
    }
    mem = "";
  }
  
}
