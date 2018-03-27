
import deadpixel.keystone.*;

import netP5.*;
import oscP5.*;


/*
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


//KEYSTONE STUFF
Keystone ks;
CornerPinSurface surface1;

PGraphics offscreen;

int textH;

ArrayList<Dialogue> p;

OscP5 oscP5;
NetAddress myRemoteLocation;

PImage fish;
PShader jitter;

int state = 0;

void effect(){
  
  switch(state){
    
    case 0:
    
      if(random(100)>90){
        
        state = 1;
        
      }
      
      break;
    
    case 1:
      
      tint(random(255),random(255),random(255));
      
      break;
    
  }
  
}

void setup() {

  size(1920,1080,P3D);
  surface.setResizable(true);
  fish = loadImage("fish.png");
  fish.resize(100,50);
  //keystone stuff
  ks = new Keystone(this);
  surface1 = ks.createCornerPinSurface(400,300,20);
  offscreen = createGraphics(400,300,P3D);
  
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  
  XML input;
  input = loadXML("Entries1.xml");



  XML[] children = input.getChildren("post");
  p = new ArrayList<Dialogue>();

  for (int i=0; i<children.length; i++) {


    int id = children[i].getInt("id");
    String t = children[i].getString("title");
    String im = children[i].getString("image");
    String d = children[i].getContent();
    PVector o = new PVector(150, 800);
    PVector dim = new PVector(550, 860);
    p.add( new Dialogue(t, d, im, o, dim));
  }

  noStroke();
  
  jitter = loadShader("jitterFRAG.glsl");
  jitter.set("s",frameCount);
  
}


Boolean newMessage = false;
Boolean postBool = false;
int postIndex = -1;
boolean waiting = false;
int r;


void draw() {
  
  effect();
  
  //jitter.set("s",frameCount);
  filter(jitter);
  background(0);

  
  if (newMessage) {

    if (postIndex!=-1) {
      
      if (postBool) {

        if (p.get(postIndex).state==-1) {

          p.get(postIndex).open();
        }
      } else {

        if (p.get(postIndex).state==1) {

          p.get(postIndex).close();
        }
      }
    } else {

      for (int i=0; i<p.size(); i++) {

        p.get(i).reset();
      }
    }

    newMessage = false;
  }


  for (int i= 0; i<p.size(); i++) {

    p.get(i).mainLoop();
  }
  
  
  //keystone
  if(postIndex==2){
  offscreen.beginDraw();
  offscreen.background(0,100,255);
  offscreen.imageMode(CENTER);
  offscreen.pushMatrix();
  
  offscreen.translate(offscreen.width*0.5+100*sin(frameCount*0.1),offscreen.height*0.5);
  offscreen.rotateY(PI*0.5*cos(frameCount*0.1)-PI*0.5);
  
  offscreen.image(fish,0,0);
  offscreen.popMatrix();
  //offscreen.ellipse(surfaceMouse.x,surfaceMouse.y,75,75);
  offscreen.endDraw();
  tint(random(255),random(255),random(255));
  
  surface1.render(offscreen);
  }
  
}

void oscEvent(OscMessage theOscMessage) {
  
  //print(p.size());

  if (theOscMessage.checkAddrPattern("/popup")==true) {
    
    

    if(theOscMessage.get(0).intValue()!=-2){
    postIndex = theOscMessage.get(0).intValue();
    if (theOscMessage.get(1).intValue()==1) {
      postBool = true;
    } else {
      postBool = false;
    }

    newMessage = true;
    }else{
     
      p.add(new Dialogue("DEFAULT ERROR MESSAGE!!!!!!!!!!!!!"));
      
    }
    
    
    print(postIndex);
    print(" ");
    print(postBool);
    print("\n");
  }
  
  
  
}



void keyPressed() {

  OscMessage myMessage = new OscMessage("/popup");

  if (keyCode==UP) {

    for (int i=0; i<p.size(); i++) {

      p.get(i).origin.add(new PVector(0, -1));
    }
  }
  if (keyCode==DOWN) {

    for (int i=0; i<p.size(); i++) {

      p.get(i).origin.add(new PVector(0, 1));
    }
  }
  if (keyCode==LEFT) {

    for (int i=0; i<p.size(); i++) {

      p.get(i).origin.add(new PVector(-1, 0));
    }
  }
  if (keyCode==RIGHT) {

    for (int i=0; i<p.size(); i++) {

      p.get(i).origin.add(new PVector(1, 0));
    }
  }
  if (key == 'i') {

    for (int i=0; i<p.size(); i++) {

      p.get(i).tDim.add(new PVector(1, 0));
      p.get(i).cDim.add(new PVector(1, 0));
    }
  } else if (key == 'o') {

    for (int i=0; i<p.size(); i++) {

      p.get(i).tDim.add(new PVector(0, 1));
      p.get(i).cDim.add(new PVector(1, 0));
    }
  }


  if (key == '1') {

    myMessage.add(0);
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  } else if (key == '2') {

    myMessage.add(1);
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  } else if (key =='3') {

    myMessage.add(2);
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  } else if (key =='4') {

    myMessage.add(3);
    myMessage.add(1);
    oscP5.send(myMessage, myRemoteLocation);
  } else if (key == 'q') {

    myMessage.add(0);
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
  } else if (key == 'w') {

    myMessage.add(1);
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
  } else if (key == 'e') {

    myMessage.add(2);
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
  } else if (key == 'r') {

    myMessage.add(3);
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
  } else if(key == 't') {
    myMessage.add(-1);
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);
  }else if(key == 'a'){
    myMessage.add(-2);
    myMessage.add("DEFAULT ERROR MESSAGE!!!!!!!!!!!!!!!!!!!!!!!!!!");
    oscP5.send(myMessage, myRemoteLocation);
  }
  
  
  if(key=='c'){
   
    ks.toggleCalibration();
    
  }else if(key =='l'){
   
    ks.load();
    
  }else if(key =='s'){
   
    ks.save();
    
  }
}