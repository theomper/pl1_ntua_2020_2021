import java.util.*;

public class GoatState implements State{
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
    return ((queue == goal) && stack.empty());
  }
  
  // @Override
  // public boolean isBad() {
    //   return wolf == goat && man != goat
    //       || goat == cabbage && man != cabbage;
    // }
    
  @Override
  public Collection<State> next() {
    Collection<State> states = new ArrayList<>();
    if (stack.empty()) {
      int ret = queue.remove();
      stack.push(ret);
      move = 'Q';
      states.add(new QSState(queue, stack, goal, this, move));    
    }
    else if (queue.peek() == null) {
      int ret = stack.pop();
      queue.add(ret);
      move = 'S';
      states.add(new QSState(queue, stack, goal, this, move));    
    }
    else {
      for (int i = 0; i < 2; i++) {
        if (i == 1) {
          int ret = queue.remove();
          stack.push(ret);
          move = 'Q';
          states.add(new QSState(queue, stack, goal, this, move));        
        }
        else {
          int ret = stack.pop();
          queue.add(ret);
          move = 'S';
          states.add(new QSState(queue, stack, goal, this, move));
        }
      }
    }
    return states;
  }
  
  @Override
  public State getPrevious() {
    return previous;
  }
  
  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("");
    if (move == 'Q') sb.append("Q");
    else if (move == 'S') sb.append("S");
    return sb.toString();
  }
  
  // Two states are equal if all four are on the same shore.
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    QSState other = (QSState) o;
    return queue == other.queue && stack == other.stack && move == other.move
    && previous == other.previous;
  }
  
  // Hashing: consider only the positions of the four players.
  @Override
  public int hashCode() {
    return Objects.hash(queue, stack);
  }
}