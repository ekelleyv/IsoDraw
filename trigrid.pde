// 2D Array of objects
ArrayList grid;
float tri_side = 50.0;
float tri_width = 25*sqrt(3);
int width = 600;
int height = 400;
int rows = ceil(height/tri_side)+1;
int cols = ceil(width/tri_width)+1;
int index = 0;



void setup() {

  size(width + 300, height);
  grid = new ArrayList();

  //Each triangle has a side length of 50 and width of 25*sqrt(3)
  //Initialize triangles
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {

      //ul is the upper left corner of the rhombus
      if (i%2 == 0) {
        float ul_x = i*tri_width;
        float ul_y = j*tri_side;
        //Add upper triangle
        grid.add(new Triangle(ul_x, ul_y, ul_x + tri_width, ul_y-tri_side/2.0, ul_x+tri_width, ul_y+tri_side/2.0));

        //Add lower triangle
        grid.add(new Triangle(ul_x, ul_y, ul_x+tri_width, ul_y + tri_side/2.0, ul_x, ul_y + tri_side));

      }
      else {
        float ur_x = (i+1)*tri_width;
        float ur_y = j*tri_side;

        grid.add(new Triangle(ur_x, ur_y, ur_x - tri_width, ur_y-tri_side/2.0, ur_x-tri_width, ur_y+tri_side/2.0));

        //Add lower triangle
        grid.add(new Triangle(ur_x, ur_y, ur_x - tri_width, ur_y + tri_side/2.0, ur_x, ur_y + tri_side));
      }
    }
  }

  //Initialize Color Selection
}

void draw() {
  background(247);
  for (Triangle tri : grid) {
    tri.display();
  } 
}

void mouseClicked() {
  int col = floor(mouseX/tri_width);
  int col_rem = mouseX%tri_width;
  int start_index = rows*col*2;

  // for (int i = start_index; i < (start_index + rows*2); i++) {
  //   grid.get(start_index + i).change_type();
  // }
  int row = floor(mouseY/(.5*tri_side));
  int row_rem = mouseY%(.5*tri_side);

  println("Row " + row);
  println("Col " + col);

  //If in box with top left to bottom right line
  if (col%2 == 0) {
    if (row%2 == 0) {
      //Below line
      if (row_rem > 1/sqrt(3)*col_rem) {
        grid.get(start_index+row+1).change_type();
      }
      //Above line
      else {
        grid.get(start_index+row).change_type();
      }
    }
    else {
      //Below line
      if (row_rem > ((-1/sqrt(3))*col_rem + tri_width/2)) {
        grid.get(start_index+row+1).change_type();
      }
      //Above line
      else {
        grid.get(start_index+row).change_type();
      }
    }
  }
  else {
    if (row%2 == 1) {
      //Below line
      if (row_rem > 1/sqrt(3)*col_rem) {
        grid.get(start_index+row+1).change_type();
      }
      //Above line
      else {
        grid.get(start_index+row).change_type();
      }
    }
    else {
      //Below line
      if (row_rem > ((-1/sqrt(3))*col_rem + tri_width/2)) {
        grid.get(start_index+row+1).change_type();
      }
      //Above line
      else {
        grid.get(start_index+row).change_type();
      }
    }
  }
}

  

class Triangle {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x0;
  float y0;
  float x1;
  float y1;
  float x2;
  float y2;

  int type;


  // Cell Constructor
  Triangle(float x0, float y0, float x1, float y1, float x2, float y2) {
    this.x0 = x0;
    this.y0 = y0;
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    type = 0; //Empty
  } 
  
  void change_type() {
    type = (type+1)%4;
  }

  void display() {

    if (type == 0) {
      stroke(230);
      fill(255);
    }
    else if (type == 1) {
      stroke(200);
      fill(200);
    }
    else if (type == 2) {
      stroke(180);
      fill(180);
    }
    else {
      stroke(140);
      fill(140);
    }

    triangle(x0, y0, x1, y1, x2, y2);
  }
}