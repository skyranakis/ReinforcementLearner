SimpleLearner a;
int[] position;
int[] start;
int[] goal;
boolean shouldDelay;

void setup(){
  size(400,400);

  //initializes start and goal points
  start = new int[2];
  start[0] = 0;
  start[1] = 0;
  goal = new int[2];
  goal[0] = 3;
  goal[1] = 3;
  
  //Creates and sets up the agent
  a = new SimpleLearner();
  position = new int[2];
  position[0] = start[0];
  position[1] = start[1];
  
  shouldDelay = false;
  
  //Displays the map and agent
  drawMap();
  ellipse(position[0]*100+50, position[1]*100+50, 75, 75);
}

void draw(){
  
  //Displays the map
  drawMap();
  
  //If the agent reached the goal last turn, delay
  if (shouldDelay){
    delay(2000);
    shouldDelay = false;
    //Draws map and agent at starting position
    ellipse(position[0]*100+50, position[1]*100+50, 75, 75);
    drawMap();
    delay(200);
  }

  
  //Moves the agent and displays again
  char c = a.move();
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
  ellipse(position[0]*100+50, position[1]*100+50, 75, 75);

  if ((position[0] == goal[0]) && (position[1] == goal[1])){
    //a.reward(1);
    shouldDelay = true;
    position[0] = start[0];
    position[1] = start[1];
  }
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
  fill(255,0,0);
  rect(start[0]*100, start[1]*100, start[0]*100+100, start[1]*100+100);
  fill(0,255,0);
  rect(goal[0]*100, goal[1]*100, goal[0]*100+100, goal[1]*100+100);
  fill(0,0,255);
}
