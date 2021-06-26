// FILENAME : QSsort.java
// DESCRIPTION : exerc21-3 / pl1-ntua
// AUTHOR : Theo Mper, Alex Tsaf
// COMPILE COMMAND : javac QSsort.java
// RUN COMMAND: java QSsort "input_file_path"
// TO-DO : 1)
//

import java.util.*;
import java.io.*;




public class QSsort {
  
  
  public QSsort(String[] args) {
    this.readInput(args);
  
  
    // The name of the file to open.
    File inputFile = new File(args[0]);
  }

  public static void main(String[] args) {
    QSsort qssort = new QSsort(args);
    qssort.findSol();
  }
    
  public void findSol() {
  }
  
  Solver solver = new BFSolver();
  State initial = new GoatState(false, false, false, false, null);
  State result = solver.solve(initial);
  if (result == null) {
    System.out.println("No solution found.");
  } else {
    printSolution(result);
  }
  
  
  // A recursive function to print the states from the initial to the final.
  private static void printSolution(State s) {
    if (s.getPrevious() != null) {
      printSolution(s.getPrevious());
    }
    System.out.println(s);
  }
  
}



