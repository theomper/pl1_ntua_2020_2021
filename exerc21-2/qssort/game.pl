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
        append(L1, [Elem], L2),
        S2 = Tail).

%NEW THINGS START HERE

addindex(Index , Number, Result) :-
    Result is (2*Index) + Number.

createlist(Index, List) :-
    maplist(addindex(Index), [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], List).

index(Elem, [Elem|_], 0) :- !.
index(Elem, [_|Tail], Position):-
    index(Elem, Tail, NewPosition),
    Position is 1 + NewPosition.

minimum(List, Index) :-
    min_list(List, Min),
    index(Min, List, Index).

%NEW THINGS END HERE

solve(Conf, [], Final) :- Conf = Final.
solve(Conf, [Move|Moves], Final) :-
    move(Conf, Conf1, Move),
    solve(Conf1, Moves, Final).

solve(File, Answer) :-
    states(InitialConf, FinalConf, File),
    (InitialConf = FinalConf -> Moves = ['e','m','p','t','y'], atomics_to_string(Moves, Answer)
    ; InitialConf = config(InitQueue, _) ->
    minimum(InitQueue, Index),
    writeln(Index),
    createlist(Index, LengthList),
    writeln(LengthList),
    member(Length, LengthList),
    writeln(Length),
    length(Moves, 28),
    solve(InitialConf, Moves, FinalConf),
    atomics_to_string(Moves, Answer)).

qssort(File, Answer) :-
    once(solve(File, Answer)).

test(File, Answer) :-
    qssort(File, Answer), writeln(Answer), fail.