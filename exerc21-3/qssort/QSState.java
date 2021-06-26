  private State previous;

  public QSState(int queue, int stack) {
    queue = new Queue();
    stack = new Stack();
  }

  @Override
  public boolean isFinal() {
    return queue.issorted() && stack.isempty();
  }

  @Override
  public boolean isBad() {
    return wolf == goat && man != goat
        || goat == cabbage && man != cabbage;
  }

  @Override
  public Collection<State> next() {
    Collection<State> states = new ArrayList<>();
    states.add(new GoatState(!man, wolf, goat, cabbage, this));
    if (man == wolf)
      states.add(new GoatState(!man, !wolf, goat, cabbage, this));
    if (man == goat)
      states.add(new GoatState(!man, wolf, !goat, cabbage, this));
    if (man == cabbage)
      states.add(new GoatState(!man, wolf, goat, !cabbage, this));
    return states;
  }

  @Override
  public State getPrevious() {
    return previous;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("State: ");
    sb.append("man=").append(man ? "e" : "w");
    sb.append(", wolf=").append(wolf ? "e" : "w");
    sb.append(", goat=").append(goat ? "e" : "w");
    sb.append(", cabbage=").append(cabbage ? "e" : "w");
    return sb.toString();
  }

  // Two states are equal if all four are on the same shore.
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    GoatState other = (GoatState) o;
    return man == other.man && wolf == other.wolf && goat == other.goat
      && cabbage == other.cabbage;
  }

  // Hashing: consider only the positions of the four players.
  @Override
  public int hashCode() {
    return Objects.hash(man, wolf, goat, cabbage);
  }
}