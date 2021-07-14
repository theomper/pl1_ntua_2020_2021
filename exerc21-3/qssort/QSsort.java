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
      String line;
      line = bufferedReader.readLine();
      String[] ret = line.split(" ", 0);
      int N = Integer.parseInt(ret[0]);

      // read line of numbers
      line = bufferedReader.readLine();

      String[] arrOfStr = line.split(" ", 0);

      int[] intarray = new int[N];
      initialqueue = new LinkedList<Integer>();
      for (int i = 0; i < N; i++) {
        intarray[i] = Integer.parseInt(arrOfStr[i]);
        initialqueue.add(intarray[i]);
      }
      Arrays.sort(intarray);
      sortedqueue = new LinkedList<Integer>();
      for (int a : intarray) {
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


  BFSolver solver = new BFSolver();
  initialstack = new Stack<Integer>();
  QSState initial = new QSState(initialqueue, initialstack, sortedqueue, null, '0');
  QSState result = solver.solve(initial);
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
  private String printSolution(QSState s) {
    if (s.getPrevious() != null) {
      printSolution(s.getPrevious());
    }
    if (s.getPrevious() == null) return "";
    output.append(s.toString());
    return output.toString();
  }
}

class QSState {
  private Queue<Integer> queue;
  private Stack<Integer> stack;
  private Queue<Integer> goal;
  private char move;
  private QSState previous;


  public QSState(Queue<Integer> newqueue, Stack<Integer> newstack, Queue<Integer> permgoal, QSState prev, char newmove) {
    queue = newqueue;
    stack = newstack;
    goal = permgoal;
    previous = prev;
    move = newmove;
  }

  public boolean isFinal() {
    return queue.equals(goal);
  }


  public Collection<QSState> next() {
    Collection<QSState> states = new ArrayList<>();

    if (stack.empty()) {
      int ret = queue.remove();
      stack.push(ret);
      states.add(new QSState(queue, stack, goal, this, 'Q'));
    }
    else if (queue.peek() == null) {
      int ret = stack.pop();
      queue.add(ret);
      states.add(new QSState(queue, stack, goal, this, 'S'));
    }
    else if (queue.peek() == stack.peek()) {
      int ret = queue.remove();
      stack.push(ret);
      states.add(new QSState(queue, stack, goal, this, 'Q'));
    }
    else {
      for (int i = 0; i < 2; i++) {
        Queue<Integer> tempqueue = new LinkedList<Integer>(queue);
        Stack<Integer> tempstack = (Stack<Integer>)stack.clone();
        if (i == 0) {
          int ret = tempqueue.remove();
          tempstack.push(ret);
          states.add(new QSState(tempqueue, tempstack, goal, this, 'Q'));
        }
        else {
          int ret = tempstack.pop();
          tempqueue.add(ret);
          states.add(new QSState(tempqueue, tempstack, goal, this, 'S'));
        }
      }
    }
    return states;
  }

  public QSState getPrevious() {
    return previous;
  }

  @Override
  public String toString() {
    return Character.toString(move);
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    QSState other = (QSState) o;
    return queue.equals(other.queue) && stack.equals(other.stack) ;
  }

  @Override
  public int hashCode() {
    return Objects.hash(queue, stack);
  }
}

class BFSolver {

  public QSState solve (QSState initial) {
    Set<QSState> seen = new HashSet<>();
    Queue<QSState> remaining = new ArrayDeque<>();
    remaining.add(initial);
    seen.add(initial);
    while (!remaining.isEmpty()) {
      QSState s = remaining.remove();
      if (s.isFinal()) return s;
      for (QSState n : s.next()){
        if (!seen.contains(n)){
          remaining.add(n);
          seen.add(n);
        }
      }
    }
    return null;
  }
}
