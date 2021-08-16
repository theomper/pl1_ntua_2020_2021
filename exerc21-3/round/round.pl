read_input(File, C, V, Initial) :-
    open(File, read, Stream),
    read_line(Stream, [C, V]),
    read_line(Stream, Initial).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

round(File, Sum, Index):-
    read_input(File, Cities, Vehicles, Start),
    msort(Start, SortedStart),
    citylist(Cities, 0, 0, SortedStart, CityList),
    firstsum(Cities, 0, CityList, Sum1),
    CityList = [_|CutList],
    solve(Cities, Vehicles, CityList, 1, 1, CutList, Sum1, Sum1, 0, Sum, Index),
    !.


citylist(Cities, Index, N, [], OutList):-
    (Index = Cities -> 
        OutList = [N]
    ;NewIndex is Index + 1,
    citylist(Cities, NewIndex, 0, [], Temp),
    OutList = [N|Temp]
    ).
citylist(Cities, Index, N, [Head|Tail], OutList):-
    (Index < Head ->
        NewIndex is Index + 1,
        citylist(Cities, NewIndex, 0, [Head|Tail], Temp),
        OutList = [N|Temp]
    ;Index = Head ->
        NewN is N + 1,
        citylist(Cities, Index, NewN, Tail, OutList)
    ).

firstsum(_, _, [], Sum):-
    Sum is 0.
firstsum(Cities, Index, [Head|Tail], Sum):-
    NewIndex is Index + 1,
    (Index is 0 -> Ret is 0; Ret is Cities - Index),
    firstsum(Cities, NewIndex, Tail, Temp),
    Sum is Temp + Head*Ret.

solve(Cities, _, _, I, _, _, _, CurrMin, CurrIndex, Sum, Index):-
    I =:= Cities,
    Sum is CurrMin,
    Index is CurrIndex.
solve(Cities, Vehicles, CList, I, MaxI, [Head|Tail], CurrSum, CurrMin, CurrIndex, Sum, Index):-
    (I >= MaxI ->
        findmax(Cities, CList, Tail, I, NewMax)
        ; NewMax is MaxI),
    (I < NewMax ->
    Diff is Cities + I - NewMax
    ; Diff is I - NewMax),
    NewSum is CurrSum + Vehicles - Cities*Head,
    Check is NewSum - Diff + 1,
    NewI is I + 1,
 ((Diff =< Check, (NewSum < CurrMin; CurrMin = -1)) -> 
         solve(Cities, Vehicles, CList, NewI, NewMax, Tail, NewSum, NewSum, I, Sum, Index)
        ;solve(Cities, Vehicles, CList, NewI, NewMax, Tail, NewSum, CurrMin, CurrIndex, Sum, Index)
    ).


findmax(Cities, CList, CreList, Index, OutMax):-
    (Index is Cities - 1 ->
        Max is 0,
        CList = [Head|Tail]
    ;Max is Index + 1,
    CreList = [Head|Tail]
    ),
    (Head > 0 ->
        OutMax is Max
        ;findmax(Cities, CList, Tail, Max, OutMax)
    ).

