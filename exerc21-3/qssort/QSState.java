import java.util.*;

public class QSState implements State{
  private Queue<Integer> queue;
  private Stack<Integer> stack;
  private Queue<Integer> goal;
  private char move;
  private State previous;
  
  
  public QSState(Queue<Integer> newqueue, Stack<Integer> newstack, Queue<Integer> permgoal, State prev, char newmove) {
    queue = newqueue;
    stack = newstack;
    goal = permgoal;
    previous = prev;
    move = newmove;
  }
  
  @Override
  public boolean isFinal() {
    int size = goal.size();
    if (size != queue.size()) return false;
    Iterator<Integer> i1 = queue.iterator();
    Iterator<Integer> i2 = goal.iterator();
    while (i1.hasNext() && i2.hasNext()) {
      if (i1.next() != i2.next()) return false; 
    }
    return true;
  }
  
  @Override
  public boolean isBad() {
      return false;
    }
    
  @Override
  public Collection<State> next() {
    Collection<State> states = new ArrayList<>();
    Queue<Integer> tempqueue = new LinkedList<Integer>(queue);
    Stack<Integer> tempstack = (Stack<Integer>)stack.clone();

    if (stack.empty()) {
      int ret = tempqueue.remove();
      tempstack.push(ret);
      states.add(new QSState(tempqueue, tempstack, goal, this, 'Q'));    
    }
    else if (queue.peek() == null) {
      int ret = tempstack.pop();
      tempqueue.add(ret);
      states.add(new QSState(tempqueue, tempstack, goal, this, 'S'));    
    }
    else if (queue.peek() == stack.peek()) {
      int ret = tempqueue.remove();
      tempstack.push(ret);
      states.add(new QSState(tempqueue, tempstack, goal, this, 'Q'));
    }
    else {
      for (int i = 0; i < 2; i++) {
        tempqueue = new LinkedList<Integer>(queue);
        tempstack = (Stack<Integer>)stack.clone();
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
  
  @Override
  public State getPrevious() {
    return previous;
  }
  
  // @Override
  // public String toString() {
  //   StringBuilder sb = new StringBuilder("Queue: ");
  //   for (int a : queue){
  //     sb.append(Integer.toString(a));
  //     sb.append(",");
  //   }
  //   sb.append(" Stack: ");
  //   for (int a : stack){
  //     sb.append(Integer.toString(a));
  //     sb.append(",");
  //   }
  //   sb.append(Character.toString(move));
  //   return sb.toString();
  // }

  @Override
  public String toString() {
    return Character.toString(move);
  }
  // Two states are equal if all four are on the same shore.
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    QSState other = (QSState) o;
    // System.out.println(this.toString());
    // System.out.println("Checking equality with");
    // System.out.println(o.toString());
    return queue == other.queue && previous == other.previous && move == other.move;
  }
  
  // Hashing: consider only the positions of the four players.
  @Override
  public int hashCode() {
    return Objects.hash(queue, stack, previous);
  }
}