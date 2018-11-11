ArrayList<Agent> a;
int agentIndex;
int[] position;
int[] start;
int[] goal;
boolean shouldDelay;
int numTrials;
int timeTaken;
String info;

void setup(){
  size(600,400);

  //initializes start and goal points and position
  start = new int[2];
  start[0] = 0;
  start[1] = 0;
  goal = new int[2];
  goal[0] = 3;
  goal[1] = 3;
  position = new int[2];
  position[0] = start[0];
  position[1] = start[1];
  
  numTrials = 0;
  timeTaken = 0;
  info = "";
  
  //Creates and sets up the agents
  a = new ArrayList<Agent>();
  Agent sl = new SimpleLearner();
  Agent sd = new SpeedDemon();
  a.add(sl);
  a.add(sd);
  agentIndex = 1;  //Determines which agent to use
  
  shouldDelay = false;
  
  //Displays the map and agent
  drawMap();
  drawAgent();
}

void draw(){
  
  //Displays the map
  drawMap();
  
  //If the agent reached the goal last turn, delay and move to start
  if (shouldDelay){
    delay(2000);
    shouldDelay = false;
    //Draws map and agent at starting position
    drawAgent();
    drawMap();
    delay(200);
  }else{
    //Moves the agent
    char c;
    c = a.get(agentIndex).move();
    
    switch (c){
      case 'u': if (position[1]!=0){
          position[1]--;
        }break;
      case 'd': if (position[1]!=3){
          position[1]++;
        }break;
      case 'l': if (position[0]!=0){
          position[0]--;
        }break;
      case 'r': if (position[0]!=3){
          position[0]++;
        }break;
    }
  }
  drawAgent();

  if ((position[0] == goal[0]) && (position[1] == goal[1])){
    
    a.get(agentIndex).reward(timeTaken);
    shouldDelay = true;
    
    updateInfo();
    drawMap();
    drawAgent();
    
    numTrials++;
    timeTaken = 0;
    position[0] = start[0];
    position[1] = start[1];
  }
  timeTaken++;
  delay(200);
}

void drawMap(){
  background(255,255,255);
  line(0,100, 400,100);
  line(0,200, 400,200);
  line(0,300, 400,300);
  line(100,0, 100,400);
  line(200,0, 200,400);
  line(300,0, 300,400);
  line(400,0, 400,400);
  fill(255,0,0);
  rect(start[0]*100, start[1]*100, start[0]*100+100, start[1]*100+100);
  fill(0,255,0);
  rect(goal[0]*100, goal[1]*100, 100, 100);
  fill(0,0,255);
  fill(0);
  textSize(8);
  text(info, 410, 10);
}

void drawAgent(){
  fill(0,0,255);
  ellipse(position[0]*100+50, position[1]*100+50, 75, 75);
}

void updateInfo(){
  info += "Run #" + numTrials + " took " + timeTaken + " steps" + "\n";
  info += a.get(agentIndex).showModel();
  info += "\n";
}
