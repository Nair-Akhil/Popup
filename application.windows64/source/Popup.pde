class Dialogue {

  int state; //states: 0 = opening 1 = main loop 2 = closing

  String title;

  StringList desc;

  PImage image;

  PVector origin;


  PGraphics textbox;
  PImage text;

  Dialogue(String t, String d, String i, PVector o) {

    title = t;
    image = loadImage(i);

    origin = new PVector(o.x, o.y);

    image.resize(180, 180);

    desc = wordWrap(d, 300);

    desc.append(" ");
    desc.append(" ");
    desc.append(" ");


    textH = round(textAscent()*(textWidth(d)/250));

    textbox = createGraphics(280, textH);

    text = createImage(280, 190, ARGB);
  }

  void main() {

    fill(66, 132, 255);
    rect(origin.x, origin.y-20, 300, 20, 10, 10, 0, 0);
    fill(224, 224, 224);
    rect(origin.x, origin.y, 300, 400, 0, 0, 10, 10);

    textbox.beginDraw();
    textbox.clear();
    //textbox.text(d, 0, 0, 300, textbox.height);
    textbox.fill(0);
    shift = ((frameCount)%12);

    if (shift == 0) {

      indexShift+=1;
    }
    for (int i=0; i<380/textAscent(); i++) {

      textbox.text(desc.array()[(i+indexShift)%desc.array().length], 0, i*textAscent()+12-shift);
    }
    print(indexShift);
    textbox.endDraw();
    text.copy(textbox, 0, 0, 280, 380, 0, 0, 280, 380);

    image(i, o.x+60, o.y+10);

    image(text, o.x+10, o.y+200);
    text(n, o.x+10, o.y-5);
  }
}


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

import controlP5.*;

String n;
String d;
StringList desc;
String im;
PImage i;
PVector o;
int textH;
//ArrayList<Dialogue> posts;

Dialogue post;

void setup() {

  size(1000, 1000);

  n = "LOREM IPSUM";

  d = "A flower, sometimes known as a bloom or blossom, is the reproductive structure found in flowering plants (plants of the division Magnoliophyta, also called angiosperms). The biological function of a flower is to effect reproduction, usually by providing a mechanism for the union of sperm with eggs. Flowers may facilitate outcrossing (fusion of sperm and eggs from different individuals in a population) or allow selfing (fusion of sperm and egg from the same flower). Some flowers produce diaspores without fertilization (parthenocarpy). Flowers contain sporangia and are the site where gametophytes develop. Many flowers have evolved to be attractive to animals, so as to cause them to be vectors for the transfer of pollen. After fertilization, the ovary of the flower develops into fruit containing seeds. In addition to facilitating the reproduction of flowering plants, flowers have long been admired and used by humans to bring beauty to their environment, and also as objects of romance, ritual, religion, medicine and as a source of food.Many common terms for seeds and fruit do not correspond to the botanical classifications. In culinary terminology, a fruit is usually any sweet-tasting plant part, especially a botanical fruit; a nut is any hard, oily, and shelled plant product; and a vegetable is any savory or less sweet plant product.[5] However, in botany, a fruit is the ripened ovary or carpel that contains seeds, a nut is a type of fruit and not a seed, and a seed is a ripened ovule.[6]Examples of culinary vegetables and nuts that are botanically fruit include corn, cucurbits (e.g., cucumber, pumpkin, and squash), eggplant, legumes (beans, peanuts, and peas), sweet pepper, and tomato. In addition, some spices, such as allspice and chili pepper, are fruits, botanically speaking.[6] In contrast, rhubarb is often referred to as a fruit, because it is used to make sweet desserts such as pies, though only the petiole (leaf stalk) of the rhubarb plant is edible,[7] and edible gymnosperm seeds are often given fruit names, e.g., ginkgo nuts and pine nuts.Botanically, a cereal grain, such as corn, rice, or wheat, is also a kind of fruit, termed a caryopsis. However, the fruit wall is very thin and is fused to the seed coat, so almost all of the edible grain is actually a seed.[8]";
  im = "image1.jpg";

  o = new PVector(100, 100);

  post = new Dialogue(n,d,im,o);

  noStroke();


  print(textAscent());
}
int shift = 1;
int indexShift = 0;

void draw() {

  background(255);
  
  post.main();
}