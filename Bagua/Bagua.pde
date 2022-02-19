PFont f;
boolean textHasBeenClicked = false;
String[] hexagram = {"\u4DC0", "\u4DC1", "\u4DC2", "\u4DC3", "\u4DC4", "\u4DC5"};  

void setup() {
  f = createFont("Segoe UI Symbol",16,true);
  size(1200, 600);
}

void draw(){
  //textFont(f,36);
  //textSize(128);
  //fill(0);
  //text(RandomStr(hexagram) , 30, 180); 
  background(196);
  if (textHasBeenClicked) {
      textFont(f,36);
      textSize(128);
      fill(0);
      text(RandomStr(hexagram), 30, 180);}
//  else  {
//        // display text 1
//      textFont(f,36);
//      textSize(128);
//      fill(0);
//      text(RandomStr(hexagram) , 30, 180); 
//    }    
      saveFrame("frames/");
}

void mouseClicked() {
    // toggle 
    noLoop();
    textHasBeenClicked = ! textHasBeenClicked;
}

void mouseReleased() {
    loop();
}

public static String RandomStr(String[] strs){
    int random_index = (int) (Math.random()*strs.length);
    return strs[random_index];
}
