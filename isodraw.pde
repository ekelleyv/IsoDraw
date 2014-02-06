// 2D Array of objects
ArrayList grid;
ArrayList schemes;
float tri_side = 50.0;
float tri_width = 25*sqrt(3);
int width = 600;
int height = 400;
int sidebar = 300;
int rows = ceil(height/tri_side)+1;
int cols = ceil(width/tri_width)+1;
int index = 0;
int scheme_index = 0;


void setupTriangles() {
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
}

void setupSchemes() {
  //Greyscale
  Arraylist greyscale = new ArrayList();
  greyscale.add(new Color(200, 200, 200));
  greyscale.add(new Color(180, 180, 180));
  greyscale.add(new Color(140, 140, 140));

  schemes.add(new Scheme(schemes.size(), greyscale, width+100, 30 + schemes.size(), 50));

  //BluePurp
  Arraylist bluepurp = new ArrayList();
  bluepurp.add(new Color(121, 120, 115));
  bluepurp.add(new Color(55, 82, 108));
  bluepurp.add(new Color(69, 47, 70));

  schemes.add(new Scheme(schemes.size(), bluepurp, width+100, 30 + schemes.size()*100, 50));

  //Candy
  Arraylist candy = new ArrayList();
  candy.add(new Color(165, 232, 238));
  candy.add(new Color(255, 179, 203));
  candy.add(new Color(219, 148, 204));


  schemes.add(new Scheme(schemes.size(), candy, width+100, 30 + schemes.size()*100, 50));

  //Grn
  Arraylist grn = new ArrayList();
  grn.add(new Color(177, 244, 69));
  grn.add(new Color(123, 223, 73));
  grn.add(new Color(36, 103, 60));
  schemes.add(new Scheme(schemes.size(), grn, width+100, 30 + schemes.size()*100, 50));
}



void setup() {

  size(width + sidebar, height);
  grid = new ArrayList();
  schemes = new ArrayList();

  //Each triangle has a side length of 50 and width of 25*sqrt(3)
  //Initialize triangles
  setupTriangles();
  setupSchemes();

  //Initialize Color Selection
}

void draw() {
  background(247);
  for (Triangle tri : grid) {
    tri.display();
  }
  for (Scheme s : schemes) {
    s.display();
  } 
}

void updateTriangles() {
  int col = floor(mouseX/tri_width);
  int col_rem = mouseX%tri_width;
  int start_index = rows*col*2;

  // for (int i = start_index; i < (start_index + rows*2); i++) {
  //   grid.get(start_index + i).change_type();
  // }
  int row = floor(mouseY/(.5*tri_side));
  int row_rem = mouseY%(.5*tri_side);

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

void updateScheme() {
  for (int i = 0; i < schemes.size(); i++) {
    Scheme cur_scheme = schemes.get(i);
    if (cur_scheme.click_inside()) {
      scheme_index = i;
    }
  }
}


void mouseClicked() {
  if (mouseX < cols*tri_width) {
    updateTriangles();
  }
  else if (mouseX > cols*tri_width) {
    updateScheme();
  }
}


class Color {
  int r;
  int g;
  int b;

  Color (int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

class Scheme {
  ArrayList colors;
  int scheme_id;
  int x_loc;
  int y_loc;
  int color_width; //Width of an individual color patch

  Scheme(int scheme_id, ArrayList colors, int x_loc, int y_loc, int color_width) {
    this.scheme_id = scheme_id;
    this.colors = new ArrayList();
    this.colors = colors;
    this.x_loc = x_loc;
    this.y_loc = y_loc;
    this.color_width = color_width;
  }

  boolean click_inside() {
    if (mouseX >= x_loc && mouseX <= x_loc+color_width*colors.size() && mouseY >= y_loc && mouseY <= y_loc+color_width) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    for (int i = 0; i < colors.size(); i++) {
      Scheme cur_scheme = schemes.get(scheme_id);
      Color cur_color = cur_scheme.colors.get(i);

      stroke(cur_color.r, cur_color.g, cur_color.b);
      fill(cur_color.r, cur_color.g, cur_color.b);
      rect(x_loc + color_width*i, y_loc, color_width, color_width);

      if (scheme_id == scheme_index) {
        int tri_size = 10;
        int offset = 10;
        stroke(150, 150, 150);
        fill(150, 150, 150);
        triangle(x_loc-offset-tri_size*sqrt(3), y_loc+(color_width/2)-tri_size, x_loc - offset, y_loc+(color_width/2), x_loc-offset-tri_size*sqrt(3), y_loc+(color_width/2)+tri_size); 
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
    Scheme cur_scheme = schemes.get(scheme_index);
    //Empty
    if (type == 0) {
      stroke(245);
      fill(255);
    }
    else {
      Color cur_color = cur_scheme.colors.get(type-1);
      stroke(cur_color.r, cur_color.g, cur_color.b);
      fill(cur_color.r, cur_color.g, cur_color.b);
    }

    triangle(x0, y0, x1, y1, x2, y2);
  }
}