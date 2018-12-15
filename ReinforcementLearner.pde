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
boolean inMenu;
boolean inGame;

void setup(){
  size(600,800);

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

  seed = 0;
  rand = new Random(seed);
  
  //Sets the menu mode
  cp5 = new ControlP5(this);
  turnMenuOn();
  
  //Creates and sets up the agents
  a = new ArrayList<Agent>();
  a.add(new SimpleLearner(rand));  //0
  a.add(new SpeedDemon(rand));  //1
  a.add(new SpeedDemonWExploration(rand));  //2
  a.add(new RewardAndPunishmentLearner(rand));  //3
  a.add(new RewardAndPunishmentLearner2(rand));  //4
  agentIndex = 4;  //Determines which agent to use
  curA = a.get(agentIndex);
  
}

void draw(){
  //Makes the menu do its thing
  if(inMenu){
    drawMenu();
  }
  
  //Makes the game do its thing
  else if(inGame){
    if (timeTaken == 0){  //drawsGame when game is first set up to display start state
      drawGame();
    }
    gameLoop();
    drawGame();
    delay(100);  //Delay necessary to animate
  }
}

void gameLoop(){
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
          punishForWall();
        }break;
      case 'd': 
        if (position[1]!=7){
          position[1]++;
        }else{                     
          punishForWall();
        }break;
      case 'l': 
        if (position[0]!=0){
          position[0]--;
        }else{                     
          punishForWall();
        }break;
      case 'r': 
        if (position[0]!=7){
          position[0]++;
        }else{                     
          punishForWall();
        }break;
    }
  }
  
  //Handles agent reaching goal
  if ((position[0] == goal[0]) && (position[1] == goal[1])){
    handleReachingGoal();
  }
  timeTaken++;
}

void punishForWall(){
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

void drawMenu(){
  background(255);
  fill(0);
  textSize(24);
  text("Menu", 100, 100);
  textSize(12);
  text("Seed:", 100, 150);
}

void drawGame(){
  drawMap();
  drawAgent();
  drawInfo();
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
}

void drawAgent(){
  fill(0,0,255);
  ellipse(position[0]*50+25, position[1]*50+25, 30, 30);
}

void drawInfo(){
  fill(0);
  textSize(8);
  text(info, 410, 10);
}

void updateInfo(){
  info += "Run #" + numTrials + " took " + timeTaken + " steps" + "\n";
  info += curA;
  info += "\n";
}

void turnMenuOn(){
  if(inGame){
    turnGameOff();
  }
  inMenu = true;
  cp5.addButton("startGame")
    .setPosition(100,300)
    .setSize(100,100)
    .activateBy(ControlP5.RELEASE);
  cp5.addTextfield("seed")
    .setPosition(100,160);
  drawMenu();
}

void turnMenuOff(){
  checkMenu();
  inMenu = false;
  cp5.getController("startGame").remove();
  cp5.getController("seed").remove();
}

void checkMenu(){
  String strSeed = cp5.get(Textfield.class, "seed").getText();
  try {
    seed = Integer.parseInt(strSeed);
    rand = new Random(seed);
    System.out.println(seed);
  }catch(Exception e){}
  setUpAgent();
}

void setUpAgent(){
  switch(agentIndex){
    case 0: curA = new SimpleLearner(rand); break;
    case 1: curA = new SpeedDemon(rand); break;
    case 2: curA = new SpeedDemonWExploration(rand); break;
    case 3: curA = new RewardAndPunishmentLearner(rand); break;
    case 4: curA = new RewardAndPunishmentLearner2(rand); break;
  }
}

void turnGameOn(){
  if(inMenu){
    turnMenuOff();
  }
  inGame = true;
  cp5.addButton("backToMenu")
    .setPosition(100, 500)
    .setSize(100,100)
    .activateBy(ControlP5.RELEASE);
  drawGame();
}

void turnGameOff(){
  inGame = false;
  cp5.getController("backToMenu").remove();
  totalReset();
}

void startGame(int value){
  turnGameOn();
}

void backToMenu(int value){
  turnMenuOn();
}

void totalReset(){
  position[0] = start[0];
  position[1] = start[1];
  numTrials = 1;
  timeTaken = 0;
  info = "";
  shouldDelay = false;
  rand = new Random(seed);
}
