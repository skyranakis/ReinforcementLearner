interface Agent
{
  public void reward(int time, double reward, boolean reachedGoal);
  public char move();
  public String toString();
}
