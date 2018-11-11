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
    s = "";
  }
  
  public char move(){
    
    char c = ' ';
    
    //Determines whether to explore
    double e = Math.random();
    
    //Explores
    if (e <= explore){
      int rand = (int)(Math.random()*model.size());
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
    
    s += c;
    print(s+"\n");
    return c;
  }
}
