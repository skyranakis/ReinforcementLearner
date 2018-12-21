//Implements toy demonstration of a reinforcement learner wandering around a field of squares

import controlP5.*;

int[] position;
int[] start;
int[] goal;
boolean shouldDelay;
int numTrials;
int timeTaken;
String info;
String header;
Agent curA;
ControlP5 cp5;
boolean inMenu;
boolean inGame;
GameMap map;

void setup(){
  size(600,800);

  //initializes start and goal points and position
  map = new GameMap("");
  start = map.getStartPosition();
  position = new int[2];
  position[0] = start[0];
  position[1] = start[1];
  
  numTrials = 1;
  timeTaken = 0;
  info = "";
  shouldDelay = false;
  
  //Sets the menu mode
  cp5 = new ControlP5(this);
  turnMenuOn();
  
  //Creates default agent
  curA = new SimpleLearner(new Random(0));
  
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
        if (map.isEnterable(position[0], position[1]-1)){       //If it doesn't hit wall
          position[1]--;
        }else{                     //If it hits wall
          curA.reward(timeTaken, map.getReward(position[0], position[1]-1), false);
        }
        curA.reward(timeTaken, map.getReward(position), false);
        break;
      case 'd': 
        if (map.isEnterable(position[0], position[1]+1)){       //If it doesn't hit wall
          position[1]++;
        }else{                     //If it hits wall
          curA.reward(timeTaken, map.getReward(position[0], position[1]+1), false);
        }
        curA.reward(timeTaken, map.getReward(position), false);
        break;
      case 'l': 
        if (map.isEnterable(position[0]-1, position[1])){       //If it doesn't hit wall
          position[0]--;
        }else{                     //If it hits wall
          curA.reward(timeTaken, map.getReward(position[0]-1, position[1]), false);
        }
        curA.reward(timeTaken, map.getReward(position), false);
        break;
      case 'r': 
        if (map.isEnterable(position[0]+1, position[1])){       //If it doesn't hit wall
          position[0]++;
        }else{                     //If it hits wall
          curA.reward(timeTaken, map.getReward(position[0]+1, position[1]), false);
        }
        curA.reward(timeTaken, map.getReward(position), false);
        break;
    }
  }
  
  //Handles agent reaching goal
  if (map.isGoal(position)){
    handleReachingGoal();
  }
  timeTaken++;
}

void punishForWall(){
  curA.reward(timeTaken, -1, false);
}

void handleReachingGoal(){
  curA.reward(timeTaken, map.getReward(position), true);
  shouldDelay = true;
  updateInfo();
  numTrials++;
  timeTaken = 0;
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
  drawHeader();
}

void drawMap(){
  background(255,255,255);
  int[] size = map.getSize();
  int squareSize = 400/Math.max(size[0], size[1]);
  for (int r = 0; r < size[0]; r++){
    for (int c = 0; c < size[1]; c++){
      String type = map.getType(r,c);
      drawSquare(type, r, c, squareSize);
    }
  }
}

void drawSquare(String type, int r, int c, int size){
  if (type.equals("Wall")){
    stroke(0, 0, 0);
    fill(0, 0, 0);
  }else if (type.equals("Normal")){
    stroke(0, 0, 0);
    fill(255, 255, 255);
  }else if (type.equals("Start")){
    stroke(0, 0, 0);
    fill(255, 0, 0);
  }else if (type.equals("Goal")){
    stroke(0, 0, 0);
    fill(0, 255, 0);
  }else{
    stroke(0, 0, 0);
    fill(255, 0, 255);
  }
  rect(r*size, c*size, size, size);
}

void drawAgent(){
  int[] mapSize = map.getSize();
  int squareSize = 400/Math.max(mapSize[0], mapSize[1]);
  int agentSize = squareSize*7/10;
  fill(0,0,255);
  ellipse(position[0]*squareSize+squareSize/2, position[1]*squareSize+squareSize/2, agentSize, agentSize);
}

void drawInfo(){
  fill(0);
  textSize(8);
  text(info, 410, 50);
}

void drawHeader(){
  fill(0);
  textSize(12);
  text(header, 410, 10);
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
    .setPosition(300,200)
    .setSize(100,100)
    .activateBy(ControlP5.RELEASE);
    
  cp5.addTextfield("seed")
    .setPosition(100,160);
  
  List agentTypes = Arrays.asList("Simple Learner", "Speed Demon", "Speed Demon with Exploration",
    "Reward and Punishment Learner", "Exponential Learner");
  cp5.addScrollableList("whichAgent")
    .setPosition(100,200)
    .addItems(agentTypes);
    
  drawMenu();
}

void turnMenuOff(){
  checkMenu();
  inMenu = false;
  cp5.getController("startGame").remove();
  cp5.getController("seed").remove();
  cp5.getController("whichAgent").remove();
}

void checkMenu(){
  int seed = 0;
  String strSeed = cp5.get(Textfield.class, "seed").getText();
  try {
    seed = Integer.parseInt(strSeed);
  }catch(Exception e){}
  Random rand = new Random(seed);
  int agentIndex = (int)(cp5.get(ScrollableList.class, "whichAgent").getValue());
  setUpAgent(agentIndex, rand);
  makeHeader(seed);
}

void setUpAgent(int agentIndex, Random rand){
  switch(agentIndex){
    case 0: curA = new SimpleLearner(rand); break;
    case 1: curA = new SpeedDemon(rand); break;
    case 2: curA = new SpeedDemonWExploration(rand); break;
    case 3: curA = new RewardAndPunishmentLearner(rand); break;
    case 4: curA = new RewardAndPunishmentLearner2(rand); break;
  }
}

void makeHeader(int seed){
  header = "Seed:\t" + seed + "\n";
  ScrollableList scroll = cp5.get(ScrollableList.class, "whichAgent");
  header += "Agent:\t" + scroll.getItem((int)(scroll.getValue())).get("text");
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
}
