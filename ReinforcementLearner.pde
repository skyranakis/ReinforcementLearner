//Implements toy demonstration of a reinforcement learner wandering around a field of squares

import controlP5.*;

ArrayList<Agent> a;
int agentIndex;
int[] position;
int[] start;
int[] goal;
boolean shouldDelay;
int numTrials;
int timeTaken;
String info;
Agent curA;
int seed;
Random rand;
ControlP5 cp5;

void setup(){
  size(600,800);
  
  //cp5 = new ControlP5(this);
  //cp5.addTextfield("Seed")
  //  .setPosition(100,100)
  //  .setSize(200,40)
  //  .setFocus(true)
  //  .setColor(color(255,0,0));

  //initializes start and goal points and position
  start = new int[2];
  start[0] = 0;
  start[1] = 0;
  goal = new int[2];
  goal[0] = 7;
  goal[1] = 7;
  position = new int[2];
  position[0] = start[0];
  position[1] = start[1];
  
  numTrials = 1;
  timeTaken = 0;
  info = "";
  shouldDelay = false;
  String strSeed = "0";
  //while ( strSeed.equals("") ){
  //  strSeed = cp5.get(Textfield.class, "Seed").getText();
  //}
  seed = Integer.parseInt(strSeed);
  rand = new Random(seed);
  
  //Creates and sets up the agents
  a = new ArrayList<Agent>();
  a.add(new SimpleLearner(rand));  //0
  a.add(new SpeedDemon(rand));  //1
  a.add(new SpeedDemonWExploration(rand));  //2
  a.add(new RewardAndPunishmentLearner(rand));  //3
  a.add(new RewardAndPunishmentLearner2(rand));  //4
  agentIndex = 4;  //Determines which agent to use
  curA = a.get(agentIndex);
  
  //Displays the map and agent
  drawMap();
  drawAgent();
}

void draw(){
  
  //If the agent reached the goal last turn, delay and move to beginning
  if (shouldDelay){
    delay(2000);
    shouldDelay = false;
    position[0] = start[0];
    position[1] = start[1];
    timeTaken--;  //Because this loop shouldn't count
  }
  else{
    //Moves the agent
    char c;
    c = curA.move();
    
    switch (c){
      case 'u': 
        if (position[1]!=0){       //If it doesn't hit wall
          position[1]--;
        }else{                     //If it hits wall
          punish();
        }break;
      case 'd': 
        if (position[1]!=7){
          position[1]++;
        }else{                     
          punish();
        }break;
      case 'l': 
        if (position[0]!=0){
          position[0]--;
        }else{                     
          punish();
        }break;
      case 'r': 
        if (position[0]!=7){
          position[0]++;
        }else{                     
          punish();
        }break;
    }
  }
  
  //Handles agent reaching goal
  if ((position[0] == goal[0]) && (position[1] == goal[1])){
    handleReachingGoal();
  }
  timeTaken++;
  delay(100);  //Delay necessary to animate
  
  //Displays the map and agent
  drawMap();
  drawAgent();
}

void punish(){
  curA.reward(timeTaken, -1, false);
}

void handleReachingGoal(){
  rewardForGoal();
  shouldDelay = true;
  updateInfo();
  numTrials++;
  timeTaken = 0;
}

void rewardForGoal(){
  curA.reward(timeTaken, 10, true);
}

void drawMap(){
  background(255,255,255);
  line(0,50, 400,50);
  line(0,100, 400,100);
  line(0,150, 400,150);
  line(0,200, 400,200);
  line(0,250, 400,250);
  line(0,300, 400,300);
  line(0,350, 400,350);
  line(0,400, 400,400);
  line(50,0, 50,400);
  line(100,0, 100,400);
  line(150,0, 150,400);
  line(200,0, 200,400);
  line(250,0, 250,400);
  line(300,0, 300,400);
  line(350,0, 350,400);
  line(400,0, 400,400);
  fill(255,0,0);
  rect(start[0]*50, start[1]*50, 50, 50);
  fill(0,255,0);
  rect(goal[0]*50, goal[1]*50, 50, 50);
  fill(0,0,255);
  fill(0);
  textSize(8);
  text(info, 410, 10);
}

void drawAgent(){
  fill(0,0,255);
  ellipse(position[0]*50+25, position[1]*50+25, 30, 30);
}

void updateInfo(){
  info += "Run #" + numTrials + " took " + timeTaken + " steps" + "\n";
  info += curA;
  info += "\n";
}
