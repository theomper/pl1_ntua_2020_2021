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
move(config(L1, [Elem|Tail]), config(L2, S2), 'S') :-
        ((L1 = [H|_] , \+ H = Elem) ->
        append(L1, [Elem], L2),
        S2 = Tail).

% solve(Conf, [], Final) :- Conf = Final.
% solve(Conf, [Move|Moves], Final) :-
%     move(Conf, Conf1, Move),
%     solve(Conf1, Moves, Final).

solve(Conf, [], Final, _,_) :- Conf = Final.
solve(Conf, [Move|Moves], Final, Qcounter, Length) :-
    (Check is Length/2 , Qcounter =< Check ->
        move(Conf, Conf1, Move),
        (Move = 'Q' -> NewCounter is Qcounter + 1 ; NewCounter is Qcounter),
        solve(Conf1, Moves, Final, NewCounter, Length)).

solve(File, Answer) :-
    states(InitialConf, FinalConf, File),
    (InitialConf = FinalConf -> Moves = ['e','m','p','t','y'], atomics_to_string(Moves, Answer)
    ; length(Moves,_),
    length(Moves,X),
    0 is X rem 2,
    solve(InitialConf, Moves, FinalConf, 0, X),
    atomics_to_string(Moves, Answer)).

qssort(File, Answer) :-
    once(solve(File, Answer)).