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
  }
  
  // readInput()
  // some code for this method copied from
  // https://www.reddit.com/r/javaexamples/comments/344kch/reading_and_parsing_data_from_a_file/
  public void readInput(String[] args) {
    // The name of the file to open.
    File inputFile = new File(args[0]);
    
    try {
      // FileReader reads text files in the default encoding.
      FileReader fileReader = new FileReader(inputFile);
      
      // Always wrap FileReader in BufferedReader.
      BufferedReader bufferedReader = new BufferedReader(fileReader);
      
      // String line;
      // while ((line = bufferedReader.readLine()) != null) {
      //   System.out.println(line);
      // }
      
      // int c;
      // while ((c = fileReader.read()) != -1) {
      //   if((char) c == '\r')
      //     continue;
      //   else if((char) c == '\n')
      //     continue;
      //   else if((char) c == ' ')
      //     continue;
      //   System.out.print((char) c);
      // }
      int N;
      N = bufferedReader.read();
      // we need to read a new line
      bufferedReader.read();
      // read line of numbers
      String line;
      line = bufferedReader.readLine();
      String[] arrOfStr = line.split(" ", 0);
      int size = arrOfStr.length;
      int[] intarray = new int[size];
      Queue<Integer> initialqueue = new LinkedList<Integer>(); 
      for (int i = 0; i < size; i++) {
        // (this.q).enqueue(a);
        //  System.out.println(a);
        intarray[i] = Integer.parseInt(arrOfStr[i]);
        // System.out.println(intarray[i]);
        initialqueue.add(intarray[i]);
      }
      Arrays.sort(intarray);
      for (int a : intarray) {
        // (this.q).enqueue(a);
        // System.out.println(a);
        initialqueue.add(a);
      }
      bufferedReader.close();
    }
    catch (FileNotFoundException ex) {
      // insert code to run when exception occurs
      ex.printStackTrace();
    }
    catch(IOException e) {
      e.printStackTrace();
    }
    
    return;
  }
  
  public static void main(String[] args) {
    QSsort qssort = new QSsort(args);
    //qssort.findSol();
  }
  
  // public void findSol() {
  // }
  
  // Solver solver = new BFSolver();
  // Stack<Integer> initialstack = new Stack<Integer>;
  // Queue<Integer> finalqueue = 
  // State initial = new QSState(initialqueue, false, false, false, null);
  // State result = solver.solve(initial);
  // if (result == null) {
  //   System.out.println("No solution found.");
  // } else {
  //   printSolution(result);
  // }
  
  // // A recursive function to print the states from the initial to the final.
  // private static void printSolution(State s) {
  //   if (s.getPrevious() != null) {
  //     printSolution(s.getPrevious());
  //   }
    
  //   System.out.println(s);
  // }
  // Stack<Integer> initialstack = new Stack<Integer>;
  // Queue<Integer> finalqueue = 
  // State initial = new QSState(initialqueue, false, false, false, null);
  // State result = solver.solve(initial);
  // if (result == null) {
  //   System.out.println("No solution found.");
  // } else {
  //   printSolution(result);
  // }
  
  // // A recursive function to print the states from the initial to the final.
  // private static void printSolution(State s) {
  //   if (s.getPrevious() != null) {
  //     printSolution(s.getPrevious());
  //   }
    
  //   System.out.println(s);
  // }
}
    
    
    
