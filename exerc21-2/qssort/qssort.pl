read_input(File, N, C) :-
    open(File, read, Stream),
    read_line(Stream, N),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

states(config(Queue, Stack), config(Queue1, Stack1), File) :-
    read_input(File, _N, Queue),
    msort(Queue, Queue1),
    Stack = [],
    Stack1 = [].

move(config([H|Tail],S1), config(L2,S2), 'Q') :-
    L2 = Tail,
    S2 = [H|S1].
move(config(L1, S1), config(L2, S2), 'S') :-
    (S1 = [Elem|Tail] -> 
        % append(L1, [Elem], L2),
        L2 = [L1|Elem], 
        S2 = Tail).

append_init(Marker-Marker).
append_end(List-[E|NMarker], E, List-NMarker).
append_finish(List-[],List).

check(L1, L2, Elem) :-
    append_init(L1),
    append_end(L1, Elem, Temp1),
    append_finish(Temp1, L2).

solve(Conf, [], Final) :- Conf = Final.
solve(Conf, [Move|Moves], Final) :-
    move(Conf, Conf1, Move),
    solve(Conf1, Moves, Final).

solve(File, Answer) :-
    states(InitialConf, FinalConf, File),
    (InitialConf = FinalConf -> Moves = ['e','m','p','t','y'], atomics_to_string(Moves, Answer)
    ; length(Moves,_),
    solve(InitialConf, Moves, FinalConf),
    atomics_to_string(Moves, Answer)).

qssort(File, Answer) :-
    once(solve(File, Answer)).