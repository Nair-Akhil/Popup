import netP5.*;
import oscP5.*;


/*
Dialogue class:

the dialogue class creates a popup and takes the following parameters where
n=the title of the popup
d=the description text to be displayed in the popup
im=the file path of the image(which for some reason doesnt work right now so i have it disabled)
o=the origin point of the popup(the popup top bar is drawn 20 pixels above the origin so allow for it)
dim= the dimensions of the popup(the text area doesnt scale with this yet)

Dialogue(n,d,im,o,dim);

*/


StringList wordWrap(String s, int maxWidth) {
  // Make an empty ArrayList
  StringList a = new StringList();
  float w = 0;    // Accumulate width of chars
  int i = 0;      // Count through chars
  int rememberSpace = 0; // Remember where the last space was
  // As long as we are not at the end of the String
  while (i < s.length()) {
    // Current char
    char c = s.charAt(i);
    w += textWidth(c); // accumulate width
    if (c == ' ') rememberSpace = i; // Are we a blank space?
    if (w > maxWidth) {  // Have we reached the end of a line?
      String sub = s.substring(0, rememberSpace); // Make a substring
      // Chop off space at beginning
      if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1, sub.length());
      // Add substring to the list
      a.append(sub);
      // Reset everything
      s = s.substring(rememberSpace, s.length());
      i = 0;
      w = 0;
    } else {
      i++;  // Keep going!
    }
  }

  // Take care of the last remaining line
  if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1, s.length());
  a.append(s);

  return a;
}

/*
String n;
String d;
StringList desc;
String im;
PImage i;
PVector o;
*/
int textH;

Dialogue[] p;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {

  
  size(1000, 1000);

  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  XML input;
  input = loadXML("Entries1.xml");



  XML[] children = input.getChildren("post");
  p = new Dialogue[children.length];
  
  for(int i=0; i<children.length;i++){
   
    int id = children[i].getInt("id");
    String t = children[i].getString("title");
    String im = children[i].getContent("image");
    String d = children[i].getContent();
    PVector o = new PVector(100,100);
    PVector dim = new PVector(300,400);
    p[i] = new Dialogue(t,d,im,o,dim);
  }

  noStroke();
}

int postIndex = -1;
int pPostIndex = -1;


void draw() {

  background(0);
  
  if(!(postIndex==pPostIndex)){
    
    if(pPostIndex!=-1){
     
      p[pPostIndex].close();
      
    }
    if(postIndex!=-1){
     
      p[postIndex].open();
      
    }
    
    postIndex = pPostIndex;
    
    
  }
  
  for(int i=0; i<p.length;i++){
   
    p[i].mainLoop();
  }
  
  
}

void oscEvent(OscMessage theOscMessage){
  
  if(theOscMessage.checkAddrPattern("/popup")==true){
    
    postIndex = theOscMessage.get(0).intValue();
    print(postIndex);
  }
  
}

void keyPressed(){
  
  OscMessage myMessage = new OscMessage("/popup");
    
  
  if(key == '1'){
   
    myMessage.add(0);
    oscP5.send(myMessage,myRemoteLocation);
   
  }else if(key == '2'){
    
    myMessage.add(1);
    oscP5.send(myMessage,myRemoteLocation);
   
    
  }else if (key =='3'){
    
    myMessage.add(2);
    oscP5.send(myMessage,myRemoteLocation);
   
  
  }else if (key =='4'){
   
    myMessage.add(3);
    oscP5.send(myMessage,myRemoteLocation);
    
  }else if (key == 'm'){
   
     
  }else{
    myMessage.add(-1);
    oscP5.send(myMessage,myRemoteLocation);
    
  }
  
}

class Dialogue {

  int state; //states: 0 = opening 1 = main loop 2 = closing

int shift = 1;
int indexShift = 0;

  float opacity;
  float textOpacity;
  String title;

  StringList desc;

  PImage image;

  PVector origin;

  PVector tDim;
  PVector cDim;

  
  PGraphics textbox;
  PImage text;

  Dialogue(String t, String d, String i, PVector o,PVector dim) {

    title = t;
    //image = loadImage(i);

    origin = new PVector(o.x, o.y);

    //image.resize(180, 180);

    desc = wordWrap(d, 300);

    desc.append(" ");
    desc.append(" ");
    desc.append(" ");


    cDim = new PVector(0,0);
    tDim = dim;

    textH = round(textAscent()*desc.size());

    textbox = createGraphics(round(dim.x-20), round(dim.y-20));

    text = createImage(round(dim.x-20), round((dim.y*0.5f)-20), ARGB);
    
    opacity = 0;
    textOpacity = 0;

    state = -1;
  }

  void mainLoop() {
    
    if(state!=-1){
    
    
     
      if(state == 0){
        
        if(cDim.x<tDim.x&&opacity<255){
         
          cDim.x = ceil(lerp(cDim.x,tDim.x,0.1));
          opacity = ceil(lerp(opacity,255,0.1));
          
        }else if(cDim.y<tDim.y){
          
          cDim.y = ceil(lerp(cDim.y,tDim.y,0.1));
          
        }else if(textOpacity<255){
         
          textOpacity = ceil(lerp(textOpacity,255,0.1));
          
        }else{
         
          state = 1;
        }
        
      }else if (state == 2){
       
        if(textOpacity>0){
          textOpacity = floor(lerp(textOpacity,0,0.1));
        }else if(cDim.y>0){
         
          cDim.y = floor(lerp(cDim.y,0,0.1));
        }else if(cDim.x>0&&opacity>0){
         
          cDim.x=floor(lerp(cDim.x,0,0.1));
          opacity = floor(lerp(opacity,0,0.1));
        }
        
      }
     
    
    
    
    print(opacity);
    fill(66, 132, 255,opacity);
    rect(origin.x, origin.y-20, cDim.x, 20, 10, 10, 0, 0);
    fill(224, 224, 224,opacity);
    rect(origin.x, origin.y, cDim.x, cDim.y, 0, 0, 10, 10);



    textbox.beginDraw();
    textbox.clear();
    //textbox.text(d, 0, 0, 300, textbox.height);
    textbox.fill(0,textOpacity);
   
    shift = ((frameCount)%12);

    if (shift == 0) {

      indexShift+=1;
    }
    for (int i=0; i<380/textAscent(); i++) {

      textbox.text(desc.array()[(i+indexShift)%desc.array().length], 0, i*textAscent()+12-shift);
    }
    
    textbox.endDraw();
    text.copy(textbox, 0, 0, 280, 380, 0, 0, 280, 380);

    //tint(255,textOpacity);
    //image(image, origin.x+60, origin.y+10);

    fill(0,textOpacity);
    image(text, origin.x+10, origin.y+200);
    text(title, origin.x+10, origin.y-5);
    }
  }
  
  void open(){
   
    state = 0;
  }
  void close(){
     
      state = 2;
      
    }
};