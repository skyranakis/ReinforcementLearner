public class GameMap
{
  //Make private!
  private String[][] map;
  private int[] startPosition;
  
  //Default constructor, makes 8x8 with start in top left and goal in botom right
  public GameMap(){
    GameMap template = new GameMap(10,10);
    map = template.map;
    startPosition = template.startPosition;
  }
  
  //Constructor for maps of a particular width (w) and height (h) (necessary for level creation)
  //Start in top left, goal in bottom right, no extra walls
  public GameMap(int w, int h){
    map = new String[w][h];
    for (int i = 0; i < h; i++){
      map[0][i] = "Wall";
      map[w-1][i] = "Wall";
    }
    for (int i = 0; i < w; i++){
      map[i][0] = "Wall";
      map[i][h-1] = "Wall";
    }
    for (int i = 1; i < w-1; i++){
      for (int j = 1; j < h-1; j++){
        map[i][j] = "Normal";
      }
    }
    map[1][1] = "Start";
    startPosition = new int[2];
    startPosition[0] = 1;
    startPosition[1] = 1;
    map[w-2][h-2] = "Goal";
  }
  
  //Constructor that reads in file containing map
  public GameMap(String filename){
    try{
      String[] read = loadStrings(filename);
      
      String[] sizeLine = read[0].split("\\s*,\\s*");
      int[] size = new int[2];
      size[0] = Integer.parseInt(sizeLine[0]);
      size[1] = Integer.parseInt(sizeLine[1]);
      
      String[] startLine = read[1].split("\\s*,\\s*");
      startPosition = new int[2];
      startPosition[0] = Integer.parseInt(startLine[0]);
      startPosition[1] = Integer.parseInt(startLine[1]);
      
      map = new String[size[0]][size[1]];
      for (int r = 2; r < size[0] + 2; r++){
        String[] squares = read[r].split("\\s*,\\s*");
        for (int c = 0; c < size[1]; c++){
          map[r-2][c] = squares[c];
        }
      }
      
    }catch(Exception e){
      print(e + "\n");
      GameMap gm = new GameMap();
      this.map = gm.map;
      this.startPosition = gm.startPosition;
    }
    
  }
  
  public void writeMap(String filename) throws Exception{
    PrintWriter writer = createWriter(filename);
    writer.println(map.length + ", " + map[0].length);
    writer.println(startPosition[0] + ", " + startPosition[1]);
    for (int r = 0; r < map.length; r++){
      for (int c = 0; c < map[0].length; c++){
        writer.print(map[r][c] + ", ");
      }
      writer.println();
    }
    writer.close();
  }
  
  void drawMap(){
    int[] size = getSize();
    int squareSize = getSquareSize();
    for (int r = 0; r < size[0]; r++){
      for (int c = 0; c < size[1]; c++){
        String type = getType(r,c);
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
  
  public int changeType(int row, int col, String type){
    //Don't change if out of bounds
    if ( row < 0 || row > map.length - 1 || col < 0 || col > map[0].length - 1 ){
      return 1; //Would have been out of bounds
    }
    //Don't change if on edge
    if ( row == 0 || row == map.length - 1 || col == 0 || col == map[0].length - 1 ){
      return 2; //Tried to change wall on edge
    }
    //Change if Wall, Normal, or Goal and none of the above apply
    if ( type.equals("Wall") || type.equals("Normal")|| type.equals("Goal") ){
      if (row == startPosition[0] && col == startPosition[1]){
        return 3; //Tried to change start
      }
      map[row][col] = type;
      return 0; //All went well
    }
    //If changing start, move Start
    if ( type.equals("Start") ){
      map[startPosition[0]][startPosition[1]] = "Normal";         //Changes old start to Normal
      map[row][col] = "Start";                                    //Set the new square as start
      startPosition[0] = row;                                     //Changes start position
      startPosition[1] = col;
      return 0; //All went well
    }
    return 4; //Invalid type
  }
  
  public int changeType(int[] pos, String type){
    return changeType(pos[0], pos[1], type);
  }
  
  public String getType(int row, int col){
    return map[row][col];
  }
  
  public String getType(int[] pos){
    return getType(pos[0], pos[1]);
  }
  
  public boolean isEnterable(int row, int col){
    String square = map[row][col];
    if (square.equals("Wall")){
      return false;
    }else{
      return true;
    }
  }
  
  public boolean isEnterable(int[] pos){
    return isEnterable(pos[0], pos[1]);
  }
  
  public double getReward(int row, int col){
    String square = map[row][col];
    if(square.equals("Wall")){
      return -1;
    }else if(square.equals("Normal")){
      return 0;
    }else if(square.equals("Start")){
      return 0;
    }else if(square.equals("Goal")){
      return 10;
    }else{
      return 0;
    }
  }
  
  public double getReward(int[] pos){
    return getReward(pos[0], pos[1]);
  }
  
  public boolean isGoal(int row, int col){
    return map[row][col].equals("Goal");
  }
  
  public boolean isGoal(int[] pos){
    return isGoal(pos[0], pos[1]);
  }
  
  public int[] getSize(){
    int[] size = new int[2];
    size[0] = map.length;
    size[1] = map[0].length;
    return size;
  }
  
  public int[] getStartPosition(){
    return startPosition;
  }
  
  public int getSquareSize(){
    return 400/Math.max(map.length, map[0].length);
  }
}
