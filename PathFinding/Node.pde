class Node extends Cell {

  // Variables pour le pathfinding
  private int G;
  private int H;
  private int movementCost;
  
  Node parent; // Cellule parent
  ArrayList<Node> neighbours; // Cellules voisins
  
  
  boolean isStart = false; // Definit si la cellule est une la case départ
  boolean isEnd = false; // Definit si la cellule est une la case fin
  boolean selected = false; // Definit si la cellule est sélectionnée pour le chemin
  
  boolean isWalkable = true; // Definit si la cellule est marchable  
  
  Node (int _x, int _y) {
    super (_x, _y);
    
    G = 0;
    H = 0;
  }
  
  Node (int _x, int _y, int _w, int _h) {
    super (_x, _y, _w, _h);
    
    movementCost = 10;
  }
  
  int getF() {
    return G + H;
  }
  
  int getH() {
    return H;
  }
  
  int getG() {
    return G;
  }
  
  void setH (int h) {
    this.H = h;
  }
  
  void setG(int g) {
    this.G = g;
  }
  
  // Permet d'ajouter des voisins à la liste
  void addNeighbour (Node neighbour) {
   
    if (neighbours == null) {
      neighbours = new ArrayList<Node>();
    }
    
    neighbours.add(neighbour);
  }
  
  
  void setMovementCost (int cost) {
    movementCost = cost;
  }
  
  Node getParent () {
    return this.parent;
  }    
  
  void setParent (Node parent) {
    this.parent = parent;
  }
  
  String toString() {
    return "( " + getF() + ", " + getG() + ", " + getH() + ")"; 
  }
  
  
  void setWalkable (boolean value, int bgColor) {
    isWalkable =false;
    fillColor = bgColor;
  }

}
