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
  private Queue<Integer> initialqueue;
  private Stack<Integer> initialstack;
  private Queue<Integer> sortedqueue;
  private StringBuilder output = new StringBuilder("");

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
      System.out.println(N);
      // we need to read a new line
      bufferedReader.read();
      // read line of numbers
      String line;
      line = bufferedReader.readLine();
      System.out.println(line);
      String[] arrOfStr = line.split(" ", 0);
      int size = arrOfStr.length;
      int[] intarray = new int[size];
      initialqueue = new LinkedList<Integer>(); 
      for (int i = 0; i < size; i++) {
        // (this.q).enqueue(a);
        //  System.out.println(a);
        intarray[i] = Integer.parseInt(arrOfStr[i]);
        // System.out.println(intarray[i]);
        initialqueue.add(intarray[i]);
      }
      Arrays.sort(intarray);
      sortedqueue = new LinkedList<Integer>(); 
      for (int a : intarray) {
        // (this.q).enqueue(a);
        // System.out.println(a);
        sortedqueue.add(a);
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
    qssort.findSol();
  }
  
  public void findSol() {
  
  
  Solver solver = new BFSolver();
  initialstack = new Stack<Integer>(); 
  State initial = new QSState(initialqueue, initialstack, sortedqueue, null, '0');
  State result = solver.solve(initial);
  if (result == null) {
    System.out.println("No solution found.");
  } 
  else {
    String check = printSolution(result);
    if (check == "") check = "empty";
    System.out.println(check);
  }
}

  // A recursive function to print the states from the initial to the final.
  private String printSolution(State s) {
    if (s.getPrevious() != null) {
      printSolution(s.getPrevious());
    }
    if (s.getPrevious() == null) return "";
    output.append(s.toString());
    return output.toString();
  }
}
    
    
    
