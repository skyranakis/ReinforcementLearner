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
boolean inLevelEditor;
GameMap map;
LevelEditor lE;
boolean editing;

void setup(){
  size(600,800);

  //initializes start and goal points and position
  //map = new GameMap("Maps\\Basic4by4.txt");
  map = new GameMap();
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
  lE = new LevelEditor();
  turnMenuOn();
  editing = false;
  //turnLevelEditorOn();  //Debugging
  
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
  
  //Makes the level editor do its thing
  else if(inLevelEditor){
    lE.drawLevel();
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
  background(255);
  map.drawMap();
  drawAgent();
  drawInfo();
  drawHeader();
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
  }else if(inLevelEditor){
    turnLevelEditorOff();
  }
  
  inMenu = true;
  
  cp5.addButton("startGame")
    .setPosition(300,200)
    .setSize(100,100)
    .activateBy(ControlP5.RELEASE);
    
  cp5.addButton("levelEditor")
    .setPosition(300, 310)
    .setSize(100, 100)
    .activateBy(ControlP5.RELEASE);
    
  cp5.addTextfield("seed")
    .setPosition(100,160);
  
  List agentTypes = Arrays.asList("Simple Learner", "Speed Demon", "Speed Demon with Exploration",
    "Reward and Punishment Learner", "Exponential Learner", "Linear with Decay", "Exponential with Decay");
  cp5.addScrollableList("whichAgent")
    .setPosition(100,200)
    .addItems(agentTypes);
  
  String[] listOfNames = new String[0];
  try{
    listOfNames = loadStrings("MapList.txt");
  }catch(Exception e){print(e);}
  List mapNames = Arrays.asList(listOfNames);
  cp5.addScrollableList("whichMap")
    .setPosition(100,400)
    .addItems(mapNames);
    
  drawMenu();
}

void turnMenuOff(){
  checkMenu();
  inMenu = false;
  cp5.getController("startGame").remove();
  cp5.getController("seed").remove();
  cp5.getController("whichAgent").remove();
  cp5.getController("levelEditor").remove();
  cp5.getController("whichMap").remove();
}

//Makes sure that seed and agent and map are all up-to-date, and also calls makeHeader()
void checkMenu(){
  
  //Gets seed
  int seed = 0;
  String strSeed = cp5.get(Textfield.class, "seed").getText();
  try {
    seed = Integer.parseInt(strSeed);
  }catch(Exception e){}
  Random rand = new Random(seed);
  
  //Gets agent
  int agentIndex = (int)(cp5.get(ScrollableList.class, "whichAgent").getValue());
  setUpAgent(agentIndex, rand);
  
  //Gets map and resets location of agent
  int mapIndex = (int)(cp5.get(ScrollableList.class, "whichMap").getValue());
  Object oMapName = cp5.get(ScrollableList.class, "whichMap").getItem(mapIndex).get("text");
  String mapName = oMapName.toString();
  map = new GameMap("Maps/" + mapName + ".txt");
  start = map.getStartPosition();
  position = new int[2];
  position[0] = start[0];
  position[1] = start[1];
  
  //Makes the header
  makeHeader(seed);
}

void setUpAgent(int agentIndex, Random rand){
  switch(agentIndex){
    case 0: curA = new SimpleLearner(rand); break;
    case 1: curA = new SpeedDemon(rand); break;
    case 2: curA = new SpeedDemonWExploration(rand); break;
    case 3: curA = new RewardAndPunishmentLearner(rand); break;
    case 4: curA = new ExponentialLearner(rand); break;
    case 5: curA = new LinearWithDecay(rand); break;
    case 6: curA = new ExponentialWithDecay(rand); break;
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
  }else if(inLevelEditor){
    turnLevelEditorOff();
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

//Turns on LevelEditor. Currently does NOT auto-reset when one goes to menu and back
void turnLevelEditorOn(){
  if(inMenu){
    turnMenuOff();
  } else if(inGame){
    turnGameOff();
  }     
  lE.start();
  inLevelEditor = true;
}

void turnLevelEditorOff(){
  lE.end();
  inLevelEditor = false;
}

//Handles button presses for STARTGAME button in menu
void startGame(int value){
  turnGameOn();
}

//Handles button presses for BACKTOMENU button in game
void backToMenu(int value){
  turnMenuOn();
}

//Handles button presses for LEVELEDITOR button in menu
void levelEditor(int value){
  turnLevelEditorOn();
}

//Handles RETURNTOMENU button in LevelEditor
//When I move this to LevelEditor, I get that weird ArrayIndexException again
void returnToMenu(int value){
  turnMenuOn();
}

//Passes handling og SAVEMAP button in LevelEditor to a method in LevelEdito (with access to the map)
void saveMap(int value){
  lE.actuallySaveMap();
}

void totalReset(){
  position[0] = start[0];
  position[1] = start[1];
  numTrials = 1;
  timeTaken = 0;
  info = "";
  shouldDelay = false;
}

//Makes it so that the boxes are changing whenever the mouse is down
void mousePressed(){
  editing = true;
}
  
//Makes it so that when the mouse is released, the boxes aren't changing
void mouseReleased(){
  if (editing && inLevelEditor){
    lE.tryToChange(mouseX, mouseY);
  }
  editing = false;
}
  
//Handles mouse moving when the mouse is down
void mouseDragged(){
  if (editing && inLevelEditor){
    lE.tryToChange(mouseX, mouseY);
  }
}
