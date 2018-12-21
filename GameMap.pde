public class GameMap
{
  //Make private!
  public String[][] map;
  public int[] startPosition;
  
  //Default constructor, makes 8x8 with start in top left and goal in botom right
  public GameMap(){
    map = new String[10][10];
    for (int i = 0; i < 10; i++){
      map[i][0] = "Wall";
      map[i][9] = "Wall";
      map[0][i] = "Wall";
      map[9][i] = "Wall";
    }
    for (int i = 1; i < 9; i++){
      for (int j = 1; j < 9; j++){
        map[i][j] = "Normal";
      }
    }
    map[1][1] = "Start";
    startPosition = new int[2];
    startPosition[0] = 1;
    startPosition[1] = 1;
    map[8][8] = "Goal";
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
}
