(* FILENAME : round.sml
 * DESCRIPTION : exerc21-1 / pl1-ntua
 * AUTHOR : Theo Mper, Alex Tsaf
 * HOW-TO-RUN: a) in unix shell type $ sml round.sml and in ML interpreter type - round "round.in1";
 *             b) in unix shell type $ sml and in ML interpreter type - use "round.sml"; and - round "round.in1";
 *             c) terminate ML interpreter with Ctrl + D
 * TO-DO : *)

 local 

    fun compare a b =
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


    fun citylist (i, j, cities, vehicles, array, sum, maxmoves, list) = (
        if (i = cities)
        then (list)
        else ( 
            if (j = vehicles)
            then (
                citylist(i+1, 0, cities, vehicles, array, 0, 0, (sum, maxmoves, i)::list) 
            )
            else (
                if (i >= Array.sub(array, j))
                then (
                    citylist(i, j+1, cities, vehicles, array, (sum + i - Array.sub(array, j)), (compare (maxmoves) (i - Array.sub(array, j))), list)
                )
                else (
                    citylist(i, j+1, cities, vehicles, array, (sum + cities + i - Array.sub(array, j)), (compare (maxmoves) (cities + i - Array.sub(array, j))), list)
                )
            )
        )
    )

    fun best ([], sum, index) = (sum, index)
        | best ((x, y, z)::list, sum, index) = (
            if (((x < sum) andalso (2*y - x <= 1)) orelse ((x = sum) andalso (2*y - x <= 1) andalso (z < index)))
            then (best(list, x, z))
            else (best(list, sum, index))
        )   

(* "main" function *)
in
    fun round file =
        let
            val input = parse file
            val cities = #1 input
            val vehicles = #2 input
            val positions = reverse (#3 input)
            val pos_array = Array.fromList(positions)
            val city_array = citylist(0, 0, cities, vehicles, pos_array, 0, 0, [])
            val int = valOf Int.maxInt
            val (sum, index) = best(city_array, int, int) 
        in
            Control.Print.say((Int.toString(sum)) ^ " " ^ (Int.toString(index)) ^ "\n")
        end
end  