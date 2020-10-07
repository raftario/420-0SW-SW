/********************
  Énumération des directions
  possibles
  
********************/
enum Direction {
  EAST, SOUTH, WEST, NORTH
}

/********************
  Représente une carte de cellule permettant
  de trouver le chemin le plus court entre deux cellules
  
********************/
class NodeMap extends Matrix {
  Node start;
  Node end;
  
  ArrayList <Node> path;
  
  boolean debug = false;
  
  NodeMap (int nbRows, int nbColumns) {
    super (nbRows, nbColumns);
  }
  
  NodeMap (int nbRows, int nbColumns, int bpp, int width, int height) {
    super (nbRows, nbColumns, bpp, width, height);
  }
  
  void init() {
    
    cells = new ArrayList<ArrayList<Cell>>();
    
    for (int j = 0; j < rows; j++){
      // Instanciation des rangees
      cells.add (new ArrayList<Cell>());
      
      for (int i = 0; i < cols; i++) {
        Cell temp = new Node(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        
        // Position matricielle
        temp.i = i;
        temp.j = j;
        
        cells.get(j).add (temp);
      }
    }
    
    println ("rows : " + rows + " -- cols : " + cols);
  }
  
  /*
    Configure la cellule de départ
  */
  void setStartCell (int i, int j) {
    
    if (start != null) {
      start.isStart = false;
      start.setFillColor(baseColor);
    } 
    
    start = (Node)cells.get(j).get(i);
    start.isStart = true;
    
    start.setFillColor(color (127, 0, 127));
  }
  
  /*
    Configure la cellule de fin
  */
  void setEndCell (int i, int j) {
    
    if (end != null) {
      end.isEnd = false;
      end.setFillColor(baseColor);
    }
    
    end = (Node)cells.get(j).get(i);
    end.isEnd = true;
    
    end.setFillColor(color (127, 127, 0));
  }
  
  // Permet de generer les voisins de la cellule a la position indiquee
  void generateNeighbours(int i, int j) {
    Node c = (Node)getCell (i, j);
    if (debug) println ("Current cell : " + i + ", " + j);
    
    
    for (Direction d : Direction.values()) {
      Node neighbour = null;
      
      switch (d) {
        case EAST :
          if (i < cols - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i + 1, j);
          }
          break;
        case SOUTH :
          if (j < rows - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j + 1);
          }
          break;
        case WEST :
          if (i > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i - 1, j);
          }
          break;
        case NORTH :
          if (j > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j - 1);
          }
          break;
      }
      
      if (neighbour != null) {
        if (neighbour.isWalkable) {
          c.addNeighbour(neighbour);
        }
      }
    }
  }
  
  /**
    Génère les voisins de chaque Noeud
  */
  void generateNeighbourhood() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        generateNeighbours(i, j);
      }
    }
  }
  
  /*
    Permet de trouver le chemin le plus court entre
    deux cellules
  */
  void findAStarPath () {
    if (start == null || end == null) {
      println ("No start and no end defined!");
      return;
    }
    
    ArrayList<Node> openList = new ArrayList<Node>();
    ArrayList<Node> closedList = new ArrayList<Node>();
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        Node n = (Node)getCell(i, j);
        n.setH(Math.abs(end.x - n.x) + Math.abs(end.y - n.y));
        n.setG(Integer.MAX_VALUE);
      }
    }
    
    start.setG(0);
    openList.add(start);

    while (openList.size() > 0) {
      Node active = openList.get(0);
      for (int i = 1; i < openList.size(); i++) {
        Node n = openList.get(i);
        if (n.getF() < active.getF()) {
          active = n;
        }
      }

      if (active == end) {
        break;
      }

      openList.remove(active);
      closedList.add(active);
      
      for (Node n : active.neighbours) {
        if (closedList.contains(n) || !n.isWalkable) {
          continue;
        }
        
        int gPrime = active.getG() + 8;
        
        if (!openList.contains(n)) {
          openList.add(n);
        } else if (gPrime > n.getG()) {
          continue;
        }
        
        n.setParent(active);
        n.setG(gPrime);
      }
    }

    if (end.getParent() == null) {
      // oups
      return;
    }
    
    generatePath();
  }
  
  /*
    Permet de générer le chemin une fois trouvée
  */
  void generatePath () {
    Node n = end;
    while (n != null) {
      if (!n.isStart && !n.isEnd) {
        n.setFillColor(color(200, 0, 0));
      }
      n = n.getParent();
    }
  }
  
  String toStringFGH() {
    String result = "";
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        Node current = (Node)cells.get(j).get(i);
        
        result += "(" + current.getF() + ", " + current.getG() + ", " + current.getH() + ") ";
      }
      
      result += "\n";
    }
    
    return result;
  }
  
  // Permet de créer un mur à la position _i, _j avec une longueur
  // et orientation données.
  void makeWall (int _i, int _j, int _length, boolean _vertical) {
    int max;
    
    if (_vertical) {
      max = _j + _length > rows ? rows: _j + _length;  
      
      for (int j = _j; j < max; j++) {
        ((Node)cells.get(j).get(_i)).setWalkable (false, 0);
      }       
    } else {
      max = _i + _length > cols ? cols: _i + _length;  
      
      for (int i = _i; i < max; i++) {
        ((Node)cells.get(_j).get(i)).setWalkable (false, 0);
      }     
    }
  }
}
