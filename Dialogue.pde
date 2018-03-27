class Dialogue {

  int state; //states: 0 = opening 1 = main loop 2 = closing

  int shift = 1;
  int indexShift = 0;

  float textOpacity;
  String title;

  StringList desc;

  PImage image;

  PVector origin;

  PVector tDim;
  PVector cDim;

  PGraphics textbox;
  PImage text;

  boolean error;
  int errorLife;


  int font;


  Dialogue(String d) {

    error = true;

    font = 50;
    textSize(font);
    title = "ERROR";

    cDim = new PVector(0, 0);
    tDim = new PVector(500, 300);

    desc = wordWrap(d, round(tDim.x));
    print(desc.size());

    origin = new PVector(random(400), 700+random(700));

    textH = round(textAscent()*desc.size());

    textbox = createGraphics(round(tDim.x), textH);

    tDim.y = textH+textAscent()*0.5;

    text = createImage(round(tDim.x), round(tDim.y), ARGB);

    textOpacity = 0;

    state = 0;

    errorLife = 150;
    
  }

  Dialogue(String t, String d, String i, PVector o, PVector dim) {

    font = 50;
    textSize(font);
    title = t;
    image = loadImage(i);

    origin = new PVector(o.x, o.y);

    image.resize(300, 300);

    String[]split = d.split("\n");
    print(split.length);
    desc = wordWrap(split[1], int(dim.x));


    cDim = new PVector(0, 0);
    tDim = dim;

    textH = round(textAscent()*desc.size());

    textbox = createGraphics(round(dim.x-20), textH);

    text = createImage(textbox.width, round(tDim.y), ARGB);

    textOpacity = 0;

    state = -1;

    desc.insert(0, "");
    desc.insert(0, "");
    desc.insert(0, "");
  }

  void mainLoop() {

    if (state!=-1) {



      if (state == 0) {

        if (cDim.x<tDim.x) {

          cDim.x = ceil(lerp(cDim.x, tDim.x, 0.3));
        } else if (cDim.y<tDim.y) {

          cDim.y = ceil(lerp(cDim.y, tDim.y, 0.3));
        } else if (textOpacity<255) {

          textOpacity = ceil(lerp(textOpacity, 255, 0.3));
        } else {

          state = 1;
        }
      } else if (state == 1) {

        if (error) {

          errorLife-=1;

          if (errorLife<=0) {

            state = 2;
          }
        }
      } else if (state == 2) {

        if (textOpacity>0) {
          textOpacity = floor(lerp(textOpacity, 0, 0.3));
        } else if (cDim.y>0) {

          cDim.y = floor(lerp(cDim.y, 0, 0.3));
        } else if (cDim.x>0) {

          cDim.x=floor(lerp(cDim.x, 0, 0.3));
          ;
        } else {
          this.reset();
        }
      }




      if(error){

        fill(255, 0, 0);
      
        
      }else{
        
        fill(66, 132, 255);
      
        
      }
      rect(origin.x, origin.y-textAscent()-5, cDim.x, textAscent()+5, 10, 10, 0, 0);
      fill(224, 224, 224);
      rect(origin.x, origin.y, cDim.x, cDim.y, 0, 0, 10, 10);



      textbox.beginDraw();
      textbox.clear();
      //textbox.text(d, 0, 0, 300, textbox.height);
      textbox.textSize(font);
      textbox.fill(0, textOpacity);

      if(!error){
      shift = (frameCount)%floor(textAscent());

      if (shift == 0) {

        indexShift+=1;
      }
      
      for (int i=0; i<textbox.height/textAscent(); i++) {

        textbox.text(desc.array()[(i+indexShift)%desc.array().length], 0, i*textAscent()-shift);
      }/*
    for (int i=0; i<desc.array().length; i++) {
       
       textbox.text(desc.array()[i], 0, i*textAscent());
       
       }*/
      }else{
       
        for(int i=0; i<desc.size();i++){
          
          textbox.text(desc.get(i),0,i*textAscent()+textAscent());
          
        }
        
      }
      textbox.endDraw();
      if(!error){
      text.copy(textbox, 0, 0, text.width, text.height, 0, 0, text.width, text.height);
      }else{
      text.copy(textbox, 0, 0, textbox.width, textbox.height, 0, 0, text.width, text.height);
      }
      if(!error){
      tint(255, textOpacity);
      image(image, origin.x+tDim.x*0.5-image.width*0.5, origin.y+10);
      }
      fill(0, textOpacity);
      if(!error){
      image(text, origin.x+10, origin.y+image.height+20);
      }else{
      image(textbox, origin.x+10, origin.y);  
      }
      text(title, origin.x+10, origin.y-10);
    }
  }

  void open() {

    state = 0;
  }
  void close() {

    state = 2;
  }

  void reset() {

    state = -1;
    textOpacity = 0;
    cDim = new PVector(0, 0);
  }
};