read_input(File, D, H, C) :-
    open(File, read, Stream),
    read_line(Stream, [D, H]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

negative(Number, OutNumber) :-
    OutNumber is -Number.

minus(Sub, Number, OutNumber) :-
    OutNumber is Number-Sub.

partial_sums(List, OutList) :-
    (List = [X|[]] -> 
        OutList = [X]
    ; List = [X,Y] -> 
        Ret is X+Y, OutList = [X,Ret]
    ; List = [X,Y|Tail] -> 
        Ret is X+Y,
        Temp = [Ret|Tail],
        partial_sums(Temp, L),
        OutList = [X|L]
    ).

prefix_sum(Hospitals, List, OutList) :-
    maplist(negative, List, L),
    maplist(minus(Hospitals), L, L1),
    partial_sums(L1, OutList).

lmin(List, OutList) :-
    (List = [X|[]] ->
        OutList = [X]
    ; List = [X,Y|Tail] ->
        Min is min(X, Y),
        lmin([Min|Tail], L),
        OutList = [X|L]
    ).

rmax(List, OutList) :-
    (List = [X|[]] ->
        OutList = [X]
    ; List = [X,Y|Tail] ->
        Max is max(X, Y),
        rmax([Max|Tail], L),
        OutList = [X|L]
    ).

checkIJ(I, J, Days) :- I >= Days; J >= Days.

checkDiff(I, J, Diff) :-
    Temp is J-I,
    Ret is max(Diff, Temp),
    Ret = Temp.

find_longest(I, J, Lmin, Rmax, Diff, Days, MaxI, MaxJ, OutDiff, OutI, OutJ) :-
    (checkIJ(I, J, Days) -> 
        OutDiff is Diff + 1, OutI = MaxI, OutJ = MaxJ
    ;   (Lmin = [HL|_TailL], Rmax = [HR|TailR], HL < HR ->
            (checkDiff(I, J, Diff) ->
                NewJ is J + 1, Ret = J - I, NewDiff is max(Diff, Ret),
                find_longest(I, NewJ, Lmin, TailR, NewDiff, Days, I, J, OutDiff, OutI, OutJ)
                ; NewJ is J + 1, Ret = J - I, NewDiff is max(Diff, Ret),
                find_longest(I, NewJ, Lmin, TailR, NewDiff, Days, MaxI, MaxJ, OutDiff, OutI, OutJ)
            )
        ; Lmin = [_HL| TailL], NewI is I+1,
        find_longest(NewI, J, TailL, Rmax, Diff, Days, MaxI, MaxJ, OutDiff, OutI, OutJ)
        )
    ).

getX(I, List, Out) :-
    (I =:= 0 ->
     nth0(0, List, Out)
     ; NewI is I - 1, nth0(NewI, List, Out)   
    ).

bypass(I, J, List, Diff, NewDiff) :-
    getX(I, List, X),
    nth0(J, List, Y),
    check_result(I, Y, X, Diff, NewDiff).
    
check_result(I, Y, X, Diff, NewDiff) :-
    (I =\= 0 , Y < X ->
        NewDiff is Diff - 1 
    ; I =:= 0, Y < 0 ->
        NewDiff is Diff - 1
    ; NewDiff is Diff
    ).

solve(File, Answer) :-
    read_input(File, Days, Hospitals, Array),
    prefix_sum(Hospitals, Array, Prefix),
    lmin(Prefix, Lmin),
    reverse(Prefix, ReversedPrefix),
    rmax(ReversedPrefix, Temp),
    reverse(Temp, Rmax),
    find_longest(0, 0, Lmin, Rmax, -1, Days, 0, 0, OutDiff, Out1, Out2),
    bypass(Out1, Out2, Prefix, OutDiff, Answer).

longest(File, Answer) :- once(solve(File, Answer)).