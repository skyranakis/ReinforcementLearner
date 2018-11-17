interface Agent
{
  public void reward(int time, double reward);
  public char move();
  public String toString();
  public void softReset();
}
