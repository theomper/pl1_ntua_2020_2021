
read_input(File, N, C) :-
    open(File, read, Stream),
    read_line(Stream, N),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

initial(config(Queue, Stack), File) :-
    read_input(File, _N, Queue),
    Stack = [].

final(config(Queue, Stack), File) :-
    read_input(File, _N, Temp),
    msort(Temp, Queue),
    Stack = [].


move(config([H|Tail],S1),config(L2,S2), 'Q') :-
    L2 = Tail,
    S2 = [H|S1].
move(config(L1,[Elem|[]]), config(L2, S2), 'S') :-
    append(L1, [Elem], L2),
    S2 = [].
move(config(L1, S1), config(L2, S2), 'S') :-
    (S1 = [Elem|_] -> 
        append(L1, [Elem], L2),
        append([Elem], S2, S1)).

% move(L1, S1, L2, S2) :-
%     (L1 = [] -> false
%     ; L1 =[H|Tail]-> L2 = Tail, S2 = [H|S1]).

% move(L1, S1, L2, S2) :-
%     (S1 = []-> false
%      ; S1 = [Elem|[]] -> L2 = [L1|Elem], S2 = []
%      ; S1 = [Elem|_] -> L2 = [L1|Elem], pop(Elem, S1, S2)).

pop(E, [E|Es], Es).
push(E, Es, [E|Es]).

solve(Conf, [], Final) :- Conf = Final.
solve(Conf, [Move|Moves], Final) :-
    move(Conf, Conf1, Move),
    solve(Conf1, Moves, Final).

solve(File, Answer) :-
    initial(InitialConf, File),
    final(FinalConf, File),
    (InitialConf = FinalConf -> Moves = ['e','m','p','t','y'], atomics_to_string(Moves, Answer)
    ; length(Moves,_),
    solve(InitialConf, Moves, FinalConf),
    atomics_to_string(Moves, Answer)).

longest(File, Answer) :-
    once(solve(File, Answer)).