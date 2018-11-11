import java.util.*;

public class SimpleLearner{
  Map<String,Double> model;    //Will drive decisions
  double explore;              //Exploration rate
  String s;                    //Path to remember
  
  //Default Constructor
  public SimpleLearner(){
    model = new HashMap<String,Double>();
    model.put("u", new Double(0.25));
    model.put("d", new Double(0.25));
    model.put("l", new Double(0.25));
    model.put("r", new Double(0.25));
    explore = .1;
  }
  
  public char move(){
    
    //Determines whether to explore
    double e = Math.random();
    
    //Explores
    if (e <= explore){
      int rand = (int)(Math.random()*model.size());
      switch (rand){
        case 0: return 'u';
        case 1: return 'd';
        case 2: return 'l';
        case 3: return 'r';
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
          return me.getKey().charAt(0);
        }
      }
    }
    
    return ' ';
  }
}
