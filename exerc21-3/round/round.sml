(* FILENAME : round.sml
 * DESCRIPTION : exerc21-1 / pl1-ntua
 * AUTHOR : Theo Mper, Alex Tsaf
 * HOW-TO-RUN: a) in unix shell type $ sml round.sml and in ML interpreter type - round "round.in1";
 *             b) in unix shell type $ sml and in ML interpreter type - use "round.sml"; and - round "round.in1";
 *             c) terminate ML interpreter with Ctrl + D
 * TO-DO : *)

 local 

    fun max a b =
        if a > b then a else b;

    fun printGridInt i N M grid =
    if (i >= N) then ()
    else
    (
        let
        fun printRow j M =
            if (j >= M) then ()
            else (print (Int.toString(Array2.sub(grid, i, j))); printRow (j+1) M)
        in
        printRow 0 M;
        print "\n";
        printGridInt (i + 1) N M grid
        end
    )

    fun reverse xs =
            let 
                fun rev (nil, z) = z
                | rev (y::ys, z) = rev (ys, y::z)
            in
                rev (xs, nil)
            end

    (* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
    fun parse file =
        let
            
            fun readInt input = 
            Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

            (* Open input file. *)
            val inStream = TextIO.openIn file

            (* Read integers (number of cities and vehicles) and consume newline. *)
            val N = readInt inStream
            val K = readInt inStream
            val _ = TextIO.inputLine inStream

            (* A function to read N integers from the open file. *)
            fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
            | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
        in
            (N, K, readInts K [])
        end
    fun printarray l =  
        let 
            val listarray = map Int.toString l
            val output = foldl (fn (x, acc) => acc ^ ", " ^ x) (hd listarray) (tl listarray)
        in
            print(output)
        end

    fun compute i j rows columns grid list sum linemax= (
        if (i = rows)
            then (grid)
        else (
            if (j = columns) then (Array2.update(grid, i, j, sum);
                                Array2.update(grid, i, j + 1, linemax);
                                compute (i+1) (0) (rows) (columns) (grid) (list) (0) (0)
                            )
            else (
                if (i > Array.sub(list, j))
                    then (Array2.update(grid, i, j, (i - Array.sub(list, j)));
                        compute (i) (j+1) (rows) (columns) (grid) (list) (sum + i - Array.sub(list, j)) (max (linemax) (Array2.sub(grid, i, j)))
                    )
                else (Array2.update(grid, i, j, (columns + i - Array.sub(list, j)));
                    compute i (j+1) (rows) (columns) (grid) (list) (sum + columns + i - Array.sub(list, j)) (max (linemax) (Array2.sub(grid, i, j)))
                )
            )
        )
    )

    (* fun max i j rows columns grid = 
        let 
            fun row_max i j sum = 
                if (j = columns)  *)


(* "main" function *)
in
    fun round file =
        let
            val input = parse file
            val cities = #1 input
            val vehicles = #2 input
            val positions = reverse (#3 input)
            val pos_array = Array.fromList(positions)
            val city_array = Array2.array(cities, vehicles + 2, 0)
            val city_moves = compute 0 0 cities vehicles city_array pos_array 0 0 

        in
            (* Control.Print.say((Int.toString(number_of_days)) ^ " " ^ (Int.toString(hospitals)) ^ "\n"); *)
            printGridInt 0 cities (vehicles + 2) city_moves
        end
end  