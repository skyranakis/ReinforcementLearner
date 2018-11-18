/*SpeedDemon, except now with exploration rate
    Will hopefully prevent the noted issue in SpeedDemon where it seems to accept good enough
*/

public class SpeedDemonWExploration extends SpeedDemon
{
  
  double explore;
  
  //Constructor
  public SpeedDemonWExploration(Random r){
    super(r);
    explore = 0.1;
  }
  
  //Overrides move function to explore
  public char move(){
    double d = rand.nextDouble();
    //Sometimes explore by chossing randomly
    if(d<=explore){
      double d2 = rand.nextDouble();
      char c = ' ';
      if (d2<0.25){
        c = 'u';
      }else if (d2<0.5){
        c = 'd';
      }else if (d2<0.75){
        c = 'l';
      }else{
        c = 'r';
      }
      return c;
    }
    //Otherwise, exploit using established model
    else{
      return super.move();
    }
  }
  
}
