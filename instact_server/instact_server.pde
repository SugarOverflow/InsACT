// this is a server that demonstrates 
// how to handle multiple people logging in

//Required for bear constraint
int bear;
String[] receive;
String[] words;

// these are the LIBRARIES
import oscP5.*;
import netP5.*;

// this is how many clients to allow
int MAXCLIENTS = 100;
// kick people off after 600 frames
int TTD = 600; 

// this is the listening object
OscP5 thelistener;

// this is a font to draw with
PFont thefont;

// data structures to maintain all the clients
String[] names = new String[MAXCLIENTS];
boolean[] active = new boolean[MAXCLIENTS];
int[] answer = new int[MAXCLIENTS];
int[] lifetime = new int[MAXCLIENTS];
int[] score = new int[MAXCLIENTS];
int p2clicktype;
int p2lifepoints;

String [] questions = new String[25]; 
int[] answers = new int[25];
int index;
int theAnswer;
boolean result;
boolean playing = true;
int timer;
int start_time;
int LEFTCLICK = 0;
int SCROLLCLICK = 1;
int RIGHTCLICK = 2;

PImage logo;
PImage right;
PImage wrong;

class Player{
  int lifepoints;
  String name;
  boolean correct;
  
  Player(int lifepoints, String name){}
  
  void addPoint(){
    lifepoints++;
  }
  
  void subtractPoint(){
    lifepoints--;
  }
  
  boolean checkAnswer(int clicktype, int answer ){
    if(clicktype == answer)
    {
      return true;
    }
    else{
      return false;
    }
  }
  
  void printResult(boolean result){
    if(result == true){
     textSize(18);
     text("You're right!", 700, 250);
     
     player.correct = true;
     textSize(15);
     text("Your Score: " + player.lifepoints, 700, 300);
     //text("Opponent's Score:" + p2lifepoints, 700, 315);
     
    }
    else {
      textSize(28);
      text("You're wrong!", 700, 250);
      player.correct = false;
      textSize(15);
      text("Your Score: " + player.lifepoints, 700, 300);
      text("Opponent's Score:" + p2lifepoints, 700, 315);

     
    }
  }
}


Player player = new Player(10, "Player1");
    
void setup(){

    size(1080, 720);
    start_time = millis();
    //stores PC time at start of game
    logo = loadImage("background.png");
    right = loadImage("correctt.png");
    wrong = loadImage("incorrectt.png");
  
    questions[0] = ("3+3? "+ '\n' + "A: 6" + '\n' + "B: 5" + '\n' + "C: 7" + '\n');
    questions[1] = ("GUI stands for" + '\n' + "A: graphics under internet" + '\n' + "B: graphics user internet" + "\n" + "C: graphical user interface" + '\n');
    questions[2] = ("In Photography, what does SLR mean? "+ '\n' + "A: single lens reflex" + '\n' + "B: single lens readjustment" + '\n' + "C: swimming lens resistance" + '\n');
   
    answers[0]=0;
    answers[1]=2;
    answers[2]=0;
   

    questions[3] = ("7+22?" + '\n' + "A: 46" + '\n' + "B: 29" + "\n" + "C: 11" + '\n');
    questions[4] = ("8+55?" + '\n' + "A: 16" + '\n' + "B: 15" + "\n" + "C: 63" + '\n');
    questions[5] = ("9+6?" + '\n' + "A: 12" + '\n' + "B: 15" + "\n" + "C: 7" + '\n');
    questions[6] = ("6+12?" + '\n' + "A: 9" + '\n' + "B: 18" + "\n" + "C: 27" + '\n');
    questions[7] = ("What is the name given to half of 4 bits/a byte? "+ '\n' + "A: a byte half" + '\n' + "B: a quark" + '\n' + "C: a nibble" + '\n');
    
    answers[3]=1;
    answers[4]=2;
    answers[5]=1;
    answers[6]=1;
    answers[7]=2;
    
    questions[8] = ("9 in binary? "+ '\n' + "A: 1000" + '\n' + "B: 1001" + '\n' + "C: 10001" + '\n');
    questions[9] = ("There are approximately 1.6 million of these in every mile. What are they?? "+ '\n' + "A: roads" + '\n' + "B: milli-meters" + '\n' + "C:  yards" + '\n');
    questions[10] = ("How many prime numbers are there between 50 and 70?" + '\n' + "A: 6" + '\n' + "B: 3" + '\n' + "C: 4" + '\n');
    questions[11] = ("What is the three-word motto of the Olympic Games?"+ '\n' + "A: FASTER, HIGHER, STRONGER" + '\n' + "B: FASTER, TALLER, WINNER" + '\n' + "C: QUICKER, SMARTER, SHARPER" + '\n');
    questions[12] = ("How many teeth do cats have? "+ '\n' + "A: 16" + '\n' + "B: 30" + '\n' + "C: 27" + '\n');
     
    answers[8]=1;
    answers[9]=1;
    answers[10]=2;
    answers[11]=0;
    answers[12]=1;

    questions[13] = ("Feline refers to...? "+ '\n' + "A: Cats" + '\n' + "B: Dogs" + '\n' + "C: Animals" + '\n');
    questions[14] = ("Asinine refers to...? "+ '\n' + "A: Horses" + '\n' + "B: Dogs" + '\n' + "C: Donkeys" + '\n');
    questions[15] = ("A baby horse is called...? "+ '\n' + "A: Horsie" + '\n' + "B: Foal" + '\n' + "C: Cob" + '\n');
    questions[16] = ("What is the national emblem of Canada ? "+ '\n' + "A: Banana" + '\n' + "B: Maple Leaf" + '\n' + "C: Conifer Leaf" + '\n');

    answers[13]=0;
    answers[14]=2;
    answers[15]=1;
    answers[16]=1;

    questions[17] = ("The US declared war on which country after the bombing of Pearl Harbor?? "+ '\n' + "A: Japan" + '\n' + "B: Russia" + '\n' + "C: France" + '\n');
    questions[18] = ("In which decade did people last get the chance to see Halley's Comet? "+ '\n' + "A: 1920s." + '\n' + "B: 1980s." + '\n' + "C: 1950s." + '\n');
    questions[19] = ("Ask not what your country can do for you, but what you can for your country.. "+ '\n' + "A: -Roosevelt" + '\n' + "B: -Kennedy" + '\n' + "C: -Clinton" + '\n');
    questions[20] = ("What color is the M in McDonald's? "+ '\n' + "A: Yellow" + '\n' + "B: Red" + '\n' + "C: Purple" + '\n');
   
    answers[17]=0;
    answers[18]=1;
    answers[19]=1;
    answers[20]=1;
    
    questions[21] = ("Give me liberty or give me death.. "+ '\n' + "A: Patrick-Henry" + '\n' + "B: Lord Byron" + '\n' + "C: Robespierre" + '\n');
    questions[22] = ("In this world nothing can be said to be certain, except death and taxes "+ '\n' + "A: Benjamin Franklin" + '\n' + "B: Al Capone" + '\n' + "C: Will Rogers"+ '\n');
    questions[23] = ("What is # actually called ? "+ '\n' + "A: Vinculum" + '\n' + "B: Criss cross" + '\n' + "C: Obelus" + '\n');
    questions[24] = ("It's a beautiful day in the neighborhood... "+ '\n' + "A: A beautiful day for a neighbor." + '\n' + "B: Would you be mine?" + '\n' + "C: Please won't you be my neighbor?" + '\n');

    
    answers[21]=0;
    answers[22]=0;
    answers[23]=0;
    answers[24]=0;
    
    receive = loadStrings("http://54.243.21.85/");
    String word = receive[0];
    words = split(word, '=');
    bear = int(words[1]);
    
    // make a new socket receiving on port 8000
    thelistener = new OscP5(this, 8000);

    
    // initialize all the clients
    for (int i  = 0;i<MAXCLIENTS;i++)
    {
      lifetime[i] = 0;
      names[i] = ""; 
      active[i] = false;
    }
    
}


void draw(){

  image(logo, 0,0);
  
      if(playing == false && millis() - timer > start_time){
          playing = true;
      }
      if(playing == true){
          text(questions[index], 250, 300);
          textSize(25);
      }
      else{
          if(player.correct == true){
            image(right, 550, 150);
          }
          else{
            image(wrong, 550, 150);
          }
          player.printResult(result);
      }
      
      bear = score;
      String send = str(score);
      String[] words = new String[1];
      words[0] = send;
      loadStrings("http://54.243.21.85/?bear=" + send);
}

// RUN ANYTIME YOU GET A NETWORK PACKET
void oscEvent(OscMessage themessage)
{
  int i;
  
  // what does the message start with?
  String m = themessage.addrPattern();
  
  // this is someone joining the group
  if (m.equals("ping"))
  {
    // figure out their IP address (argument to 'ping') and talk back
    String name = themessage.get(0).stringValue();
    println("new connection from " + name);
    // open a connection back to them
    NetAddress whereimsending = new NetAddress(name, 12000);
    OscMessage pingmessage = new OscMessage("number");
    for (i = 0;i<MAXCLIENTS;i++) // find first free slot
    {
      if (active[i]==false) {
        active[i]=true;
        break;
      }
    }
    // tell them their slot
    pingmessage.add(i);
    // send the UDP message back
    thelistener.send(pingmessage, whereimsending);
  }

  // this is someone leaving the group
  if (m.equals("leaving"))
  {
    println("someone is leaving");
    int leavingnumber =  themessage.get(0).intValue();
    active[leavingnumber] = false;
  }

  // this is someone participating
  if (m.equals("draw"))
  {
    // find their number and update their data
    int mynum = themessage.get(3).intValue(); // which one am i?
    answer[mynum] = themessage.get(0).intValue();
    p2clicktype = themessage.get(1).intValue();
    p2lifepoints = themessage.get(2).intValue();

  }
}


void mousePressed(){
  if( mouseButton == LEFT){
    playing = false;
    startTimer();
    print("LEFT CLICK" + '\n' );
    result = player.checkAnswer(LEFTCLICK, answers[index]);
    player.printResult(result);
    index++;    
    if(player.correct == true){
      player.addPoint();
    }
    
    else{
     
      player.subtractPoint();
    }
  }
  else if(mouseButton != LEFT || mouseButton != RIGHT){
    playing = false;
    startTimer();
    print("SCROLL CLICK" + '\n' );
    result = player.checkAnswer(SCROLLCLICK, answers[index]);
    player.printResult(result);
        index++;
    if(player.correct == true){
      player.addPoint();
    }
    else{
      player.subtractPoint();
    }
  }
  else if( (mouseButton == RIGHT)){
    playing = false;
    startTimer(); 
    print("RIGHT CLICK" + '\n' );
    result = player.checkAnswer(RIGHTCLICK, answers[index]);
    player.printResult(result);  
    index++;  
    if(player.correct == true){
      player.addPoint();
    }
    else{
      player.subtractPoint();
    }
  }
    
}

void startTimer(){
  timer = 500;
  start_time = millis();
}
  


