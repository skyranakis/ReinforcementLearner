import java.util.*;

public class SimpleLearner{
  Map<String,Double> model;    //Will drive decisions
  double explore;              //Exploration rate
  String mem;                    //Path to remember
  
  //Default Constructor
  public SimpleLearner(){
    model = new HashMap<String,Double>();
    model.put("u", new Double(0.25));
    model.put("d", new Double(0.25));
    model.put("l", new Double(0.25));
    model.put("r", new Double(0.25));
    explore = 0;
    mem = "";
  }
  
  //Outputs a character corresponding to the move that should be made
  public char move(){
    
    char c = ' ';
    
    //Determines whether to explore
    double e = Math.random();
    
    //Explores
    if (e <= explore){
      int rand = (int)(Math.random()*4);
      switch (rand){
        case 0: c = 'u'; break;
        case 1: c = 'd'; break;
        case 2: c = 'l'; break;
        case 3: c = 'r'; break;
      }
    }
    
    //Exploits
    else{
      double v = Math.random();
      double total = 0;
      Set< Map.Entry<String,Double> > st = model.entrySet();
      for (Map.Entry<String,Double> me:st){  //Iterates over map
        total += me.getValue();
        if (v<=total){
          c = me.getKey().charAt(0);
          break;
        }
      }
    }
    
    mem += c;
    return c;
  }
  
  //Adjusts the model according to the reward
  public void reward(int r){
    
    if (r==1){
      
      //Creates a new model
      int len = mem.length();
      Map<String,Double> newModel = new HashMap<String,Double>();
      for (int i=0; i<len; i++){
        char curChar = mem.charAt(i);
        if (!newModel.containsKey(""+curChar)){
          newModel.put(""+curChar, new Double(0));
        }
        newModel.put(""+curChar, newModel.get(""+curChar)+1./len); //adds 1/len to the value associated with the current char
      }
      
      //Ensures new model has all the right keys
      Set< Map.Entry<String,Double> > st = model.entrySet();
      for (Map.Entry<String,Double> me:st){ 
        if (!newModel.containsKey(""+me.getKey())){
          newModel.put(""+me.getKey(), new Double(0));
        }
      }
      
      
      //Updates the actual model based on the new
      Set< Map.Entry<String,Double> > st2 = newModel.entrySet();
      for (Map.Entry<String,Double> me:st2){ 
        String key = me.getKey();
        double newValue = me.getValue();
        model.remove(key);
        model.put(key, newValue);
      }
      
      //Resets the memory
      mem = "";
    }
  }
  
  //outputs the model
  public Map<String,Double> showModel(){
    Map<String,Double> newModel = new HashMap<String,Double>();
    Set< Map.Entry<String,Double> > st = model.entrySet();
    for (Map.Entry<String,Double> me:st){ 
      newModel.put(me.getKey(), me.getValue());
    }
    return newModel;
  }
  
}
