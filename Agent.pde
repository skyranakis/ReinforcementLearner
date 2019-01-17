interface Agent
{
  public int reward(int time, double reward, boolean reachedGoal);
  public char move();
  public String toString();
}
