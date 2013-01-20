// Clear Congress Project
// A Model for Transparency and Journalism in a Data Rich World
// by Tom Gibes
// tom@clearcongressproject.com

// tell the sketch about javascript

interface JavaScript {
  void normalizeLF();
  void normalizeIdeology();
  void normalizeBillCount();
}

void bindJavascript(JavaScript js){
  javascript = js;
}

JavaScript javascript;

// initializin'

ArrayList legislators;

// canvas size
int canvas_w;
int canvas_h;
// axes lengths
int xaxis_l;
int yaxis_l;

// these are not used atm
int point_size;
int smallpoint_size;

float x_click;
float y_click;

float transformed_bc; // bill count after transformation for area

boolean collision_on;
boolean active_rollover; // to prevent multiple printing




void setup(){
  

  
  // let's define some stuff

  active_rollover = false;
  collision_on = false;
  transformed_bc = 0;
  
  x_click = 0;
  y_click = 0;
  
//  smallpoint_size = 5;
  
  canvas_h = 700;
  canvas_w = 940;
  
  xaxis_l = 900;
  yaxis_l = 550;
  
  legislators = new ArrayList();
  
  // font default
  
  PFont fontA = loadFont("Verdana");
  PFont fontB = loadFont("Verdana-11.vlw");
  textFont(fontA);
  
  // size & framerate
  
  size(canvas_w,canvas_h);
//  frameRate(30);
  
  // load up legislators array
  
  for (int i = 0; i < 535; i++){
    
    // create slots and add legislators
    
    legislators.add(new Legislator());
    Legislator le = (Legislator) legislators.get(i);
    
    // load it up the basics
    
    le.title = titles[i];
    le.firstname = firstnames[i];
    le.lastname = lastnames[i];
    le.party = party[i];
    le.gender = genders[i];
    le.bioguide_id = bioguide_ids[i];
         
  }   
}

void draw(){

  background(255);
  
  drawAxes();
 // drawLegend();
  drawGuides();

  active_rollover = false; 
  collision_on = collision_js; 

  for(int i=0; i < legislators.size(); i++){  
    
    Legislator leggy = (Legislator) legislators.get(i);
   
    // determine location to draw if collision and jitter not on
    
    if (!collision_on && !jittered){
      leggy.placeMe(i);   
    }
    
    if(collision_on || jitter_mode){
      leggy.checkCollision();
    }
    
    leggy.checkBounds();
    
    // draw stuff, lines first so they're underneath
    
    if (leggy.focus){
      leggy.setCosponsors(i); // define cosponsors, which get updated when a one is clicked (see mousePressed())
      if(draw_network){
        leggy.drawCosponsorLines(); 
      }
    }
    
    leggy.drawMe(i);  // draw the legislator dot, also controls filters for now... 
       
  }
  
  if (jitter_mode){
    jitter_mode = false;
  }
  
   for(int i=0; i < legislators.size(); i++){
     Legislator leggy = (Legislator) legislators.get(i);
      if(!active_rollover && !leggy.focus){
        leggy.drawName(); // rollover text at the top of the viz
      }
      if(draw_labels || leggy.focus){
        leggy.drawLabel();
      }  
   }
}

void drawGuides(){
  stroke(0,0,0,50);
  line(xaxis_l*.5+50,yaxis_l+50,xaxis_l*.5+50,50);
  //line(xaxis_l*.25+50,yaxis_l+50,xaxis_l*.25+50,50);
 // line(xaxis_l*.75+50,yaxis_l+50,xaxis_l*.75+50,50);
  line(100,yaxis_l*.5+50,xaxis_l,yaxis_l*.5+50);
  //line(100,yaxis_l*.25+50,xaxis_l,yaxis_l*.25+50);
  //line(100,yaxis_l*.75+50,xaxis_l,yaxis_l*.75+50);
}

void drawLegend(){
  
  // white lines
  stroke(250);
  line(canvas_w-170,175,canvas_w-170,165);
  line(canvas_w-150,180,canvas_w-140,180);
  line(canvas_w-150,220,canvas_w-140,220);
  line(canvas_w-140,180,canvas_w-140,220);
  line(canvas_w-150,300,canvas_w-140,300);
  line(canvas_w-160,250,canvas_w-140,250);
  line(canvas_w-155,395,canvas_w-140,395);
  line(canvas_w-155,415,canvas_w-140,415);
  line(canvas_w-155,435,canvas_w-140,435);
  fill(250);
  //text
  text("Sponsor",canvas_w-180,155);
  text("Cosponsor",canvas_w-135,305);
  text("# of Bills",canvas_w-135,195);
  text("Sponsored",canvas_w-135,210);
  text("Cosponsor",canvas_w-135,250);
  text("Attracted",canvas_w-135,265);
  text("Democrat",canvas_w-135,400);
  text("Republican",canvas_w-135,420);
  text("Independent",canvas_w-135,440);
  // shapes and colors
  stroke(150,50,150,150);
  strokeWeight(2);
  line(canvas_w-170,200,canvas_w-170,300);
  noStroke();
  fill(150,0,50,150);
  rect(canvas_w-170,410,10,10);
  ellipse(canvas_w-170,300,35,35);
  fill(0,100,150,250);
  rect(canvas_w-170,390,10,10);
  ellipse(canvas_w-170,200,40,40);
  fill(150,150,0,250);
  rect(canvas_w-170,430,10,10);
}

void drawAxes(){
  stroke(0);
  fill(0);
  
  // y-axis
  line(70,50,70,50+yaxis_l);
  line(70,50,80,60);
  line(70,50,60,60);
  line(70,50+yaxis_l,80,40+yaxis_l);
  line(70,50+yaxis_l,60,40+yaxis_l);
  textAlign(CENTER);
  rotate(-PI/2);
  text("Legislative",-(yaxis_l+115)/2,35);
  text("Legislative",-(yaxis_l+117)/2,35); //easy bolding
  text("Activity",-(yaxis_l+115)/2,50);
  text("Activity",-(yaxis_l+117)/2,50); //easy bolding  
  text("cosponors many bills",-(yaxis_l-225)/2,50);
  text("attracts many cosponsors",-(yaxis_l-225)/2,35);
  text("does not cosponsor bills",-(yaxis_l+425)/2,50);
  text("does not attract cosponors",-(yaxis_l+425)/2,35);
  rotate(PI/2);
  
  // x-axis
  line(100,canvas_h-70,xaxis_l,canvas_h-70);
  line(100,canvas_h-70,110,canvas_h-80);
  line(100,canvas_h-70,110,canvas_h-60);
  line(xaxis_l,canvas_h-70,xaxis_l-10,canvas_h-80);
  line(xaxis_l,canvas_h-70,xaxis_l-10,canvas_h-60);
  text("Legislative Partisanship",(xaxis_l+100)/2,canvas_h-10);
  text("Legislative Partisanship",(xaxis_l+102)/2,canvas_h-10); //easy bolding
  text("sponsors & cosponsors bipartisan legislation",(xaxis_l+100)/2,canvas_h-40);
  
  text("sponsors & cosponsors",(xaxis_l+700)/2,canvas_h-40);
  text("Republican legislation",(xaxis_l+700)/2,canvas_h-25);
  
  text("sponsors & cosponsors",(xaxis_l-500)/2,canvas_h-40);
  text("Democratic legislation",(xaxis_l-500)/2,canvas_h-25);
  
  textAlign(LEFT);
  
}
 
class Legislator {
  
  // positions
  
  float xpos;
  float ypos;
  float small_xpos;
  float small_ypos;
  
  boolean focus;
  boolean cosponsors_set; // to tell if we've setup the cosponsors for this yet - stops redundent adding
  boolean filtered; // is this legislator currently being filtered out.
  
  // attributes
  
  float w; // circle size width
  
  String title;
  String firstname;
  String lastname;
  char party;
  String state;
  String district;
  char gender;
  String bioguide_id;
  ArrayList cosponsors; // an ArrayList of Legislators that are cosponsors of the legislator's bills
  
  // test fields
  
  float spectrum;
  float lf; // this was leader-follower, will become MQ (media quotient)
  
  Legislator(){
    
    filtered = false;
    focus = false;
    cosponsors_set = false;
    cosponsors = new ArrayList();
    
  }
  /*
  void setPos(x,y){
    
    xpos = x;
    ypos = y;
    
  }
  */
  
  void placeMe(int i) {  
       
    // set the spectrum and xpos of each legislator
    spectrum = normalized_ideology_array[i];  
    xpos = 100 + (spectrum * 775);
    
    // set the leadership score and y pose of each legislator
    lf = normalized_lf_array[i];
    ypos = canvas_h-125 - (lf * (canvas_h-200));

    // determine circle size, can't do this in setup, because I have to wait for the billCount to load...  
    transformed_bc = 2 * sqrt(normalized_bill_count[i]/PI);   
    w = 10 + (40 * transformed_bc);
    
  }
  
  // animationMe is not used right now...
  
  void animateMe(float tarx, float tary){
    
      // incriment to animate
    
      if (xpos < tarx){
        xpos+=1;
      }
      if (xpos > tarx){
        xpos-=1;
      }
      if (ypos < tary){
        ypos+=1;
      }         
      if (ypos > tary){
        ypos-=1;
      }
  }
  
  /// drawing the legislator dot - controls size, color, alpha (filters)
  
  void drawMe(int legislatorKey){

    // focus is solid, else translucent
         
    int a = 125; // alpha
    
    // filters
    
    if (filter_array[legislatorKey] == 0){
      filtered = false;
    }
    else if (filter_array[legislatorKey] == 1){
      filtered = true;
    }
    
    if(focus){
      filtered = false;
    }
    
    if(filtered){
      a = 25;
    }
            
    if (focus){
      a = 250;
    }
      
    if (mouseX > xpos && mouseX < xpos + w && mouseY > ypos && mouseY < ypos + w){
      stroke(0);
    }
    else{
      noStroke(); // no outline
    }
          
    // color encodes party
    
      
      if (party == "D"){
        fill(0,100,150,a);
      }
      else if (party == "R"){
        fill(150,0,50,a);
      }
      else {
        fill(150,150,0,a);
      }      
   
 //  boolean draw_filtered_processing = draw_filtered;
   
    if(draw_filtered || (!draw_filtered && !filtered)){ // only draw if draw_filter is false and not filtered 
      if(dots_mode){ // draw simple dots if in dots_mode
        ellipse(xpos+w/2,ypos+w/2,10,10);
      }
      else{
        ellipse(xpos+w/2,ypos+w/2,w,w); // should've switched to ellipse central positioning mode - future improvement
      }
    }
    
  }
  
  void drawLabel(){
    if(draw_filtered || (!draw_filtered && !filtered)){
    if (xpos < canvas_w/2){
       textAlign(LEFT);
    }
    else {
       textAlign(RIGHT);
    }
    text(title + " " + firstname + " " + lastname,xpos+w/2,ypos+w/2);
    }
  }
  
  void drawSmall(){
    
    rect(small_xpos,small_ypos,smallpoint_size,smallpoint_size);
    stroke(0);
   
  }
  
  void drawName(){
    if(draw_filtered || (!draw_filtered && !filtered)){
    fill(0);
    
    if (mouseX > xpos && mouseX < xpos + w && mouseY > ypos && mouseY < ypos + w){
     // fill(250);
     // rect(mouseX,mouseY-20,150,20);
     // fill(0);
      if (mouseX < canvas_w/2){
        textAlign(LEFT);
        text(title + " " + firstname + " " + lastname,mouseX+5,mouseY-5 );
        text(title + " " + firstname + " " + lastname,mouseX+6,mouseY-5 ); // bold trick      
      }
      else {
        textAlign(RIGHT);
        text(title + " " + firstname + " " + lastname,mouseX-5,mouseY-5 );
        text(title + " " + firstname + " " + lastname,mouseX-6,mouseY-5 ); // bold trick    
      }
      active_rollover = true;
    }
    }
  }
  
  // collision check

  void checkCollision(){
    float lx, ly, la;
    if (draw_filtered || (!draw_filtered && !this.filtered)){
    for (int i=0; i < legislators.size(); i++){
      
      Legislator le = (Legislator) legislators.get(i);
      
      if (le!=this){
        lx = xpos-le.xpos;
        ly = ypos-le.ypos;
        float distance = sqrt(lx*lx+ly*ly);
        float minDist = le.w/2 + w/2;

        if(distance < minDist){
          // find the angle between us
          la = atan2(ly,lx);
          // adjust both circles position - there's a better way to do this, I"m sure...
          xpos += (cos(la) * 2);
          ypos += (sin(la) * 2);
          le.xpos -= (cos(la) * 2);
          le.ypos -= (sin(la) * 2);

        }
      }
    }
    }
  }
  
  void checkBounds(){
    if (xpos < (100-w/2)){
      xpos=100-w/2;
    }
    if (xpos > xaxis_l-w/2){
      xpos=xaxis_l-w/2;
    }
    if (ypos < 50+w/2){
      ypos=50+w/2;
    }
    if (ypos > canvas_h-(100+w/2)){
      ypos=canvas_h-(100+w/2);
    }
  }
  
  
  void setCosponsors(int legislatorKey){  
  
    array holderArray = cosponsors_all[legislatorKey];    
 
    if (holderArray.length > this.cosponsors.size()){  // this is required to prevent redundent adds
    
      for (int j = 0; j < holderArray.length; j++){
   
         this.cosponsors.add(new Legislator());

         for (int i = 0; i < legislators.size(); i++){
         
           Legislator leg = (Legislator) legislators.get(i);
           if (leg.bioguide_id == holderArray[j]){
             this.cosponsors.set(j, leg);
           }
         }
       }
       cosponsors_set = true; 
    }
  }
    
  void drawCosponsorLines(){
    if (focus){

    for (int i = 0; i < cosponsors.size(); i++){
      
      // get cosponsors
      
      Legislator cosponsor = (Legislator) cosponsors.get(i);
     
      for (int j = 0; j < legislators.size(); j++){
        Legislator le = (Legislator) legislators.get(j);

        // test against legislators list
        
        if (cosponsor.bioguide_id == le.bioguide_id){
          
          if (party == "D" && cosponsor.party == "D"){
            stroke(0,100,150,50);
          }
          else if (party == "R" && cosponsor.party == "R"){
            stroke(150,0,50,50);
          }
          else {
            stroke(150,50,150,50);
          }
          strokeWeight(2);
          line(xpos+w/2,ypos+w/2,cosponsor.xpos+cosponsor.w/2,cosponsor.ypos+cosponsor.w/2);
          strokeWeight(1);

        }
      }
    }
    }
  } 
 
  // end of functions
  
}

void mousePressed(){ 
  
  x_click = mouseX;
  y_click = mouseY;
  
  boolean le_clicked = false;
  boolean nolegs = true;
  
  for (int i=0; i<legislators.size(); i++){
    
      Legislator le = (Legislator)legislators.get(i);
      
      if (x_click > le.xpos && x_click < le.xpos + le.w && y_click > le.ypos && y_click < le.ypos + le.w && !le_clicked){
        if(draw_filtered || (!draw_filtered && !le.filtered)){
        
        nolegs = false;
        le_clicked = true;


        if (le.focus){
          le.focus = false;
       //   filter_array[i] = 1;
          hideDetails();
          break;
        }
        
        else{
          le.focus = true;
        //  filter_array[i] = 0;

        }        
        
        // google news search stuff
        searchfirstname = le.title + " " + le.firstname;
        searchlastname = le.lastname; 
        OnLoad(); // google new update
        
        if (le.cosponsors_set == false){
          getCosponsors(i); // make an api call to RTC for cosponsors - JS side
        }
           
      
        getLastTweet(i); // twitter API grab - JS side
        showDetails(i); // create div w/ details - JS side
        
        
        }
      }
    
  }
  
  if (nolegs){
   javascript.hideDetails();
  }   
}


