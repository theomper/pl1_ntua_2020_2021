(* FILENAME : longest.sml
 * DESCRIPTION : exerc21-1 / pl1-ntua
 * AUTHOR : Theo Mper, Alex Tsaf
 * HOW-TO-RUN: a) in unix shell type $ sml longest.sml and in ML interpreter type - longest "longest.in1";
 *             b) in unix shell type $ sml and in ML interpreter type - use "longest.sml"; and - longest "longest.in1";
 *             c) terminate ML interpreter with Ctrl + D
 * TO-DO : *)

(* A more efficent reverse using a helper/tail-recursive funcion *)
local
    fun reverse xs =
        let 
            fun rev (nil, z) = z
            | rev (y::ys, z) = rev (ys, y::z)
        in
            rev (xs, nil)
        end

    fun max a b =
        if a > b then a else b;

    fun min a b =
        if a < b then a else b;

    (* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
    fun parse file =
        let
            (* A function to read an integer from specified input. *)
            fun readInt input = 
            Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

            (* Open input file. *)
            val inStream = TextIO.openIn file

            (* Read an integer (number of countries) and consume newline. *)
            val n = readInt inStream
            val hospitals = readInt inStream
            val _ = TextIO.inputLine inStream

            (* A function to read N integers from the open file. *)
            fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
            | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
        in
            (n, hospitals, readInts n [])
        end

    fun prefixsums [] = []
        | prefixsums (x::[]) = []
        | prefixsums (x::y::[]) = [x,x+y]
        | prefixsums (x::y::l) = (x::(prefixsums ((x+y)::l)))

    fun lmin [] = []
        | lmin (x::[]) = [x]
        | lmin (x::y::l) = x::lmin ((min x y)::l)

    fun rmax [] = []
        | rmax (x::[]) = [x]
        | rmax (x::y::l) = x::rmax ((max x y)::l)


    fun find_longest (i, j, lm, rm, diff, days, maxi, maxj) =
            if ((i >= days) orelse (j >= days)) then ((diff + 1), maxi, maxj) 
            else (
                if ((hd lm) < (hd rm)) 
                then (
                    if ((max diff (j-i)) = (j-i)) 
                        then (
                            find_longest (i, (j+1), lm, (tl rm), (max diff (j-i)), days, i, j)
                        )
                    else (
                        find_longest (i, (j+1), lm, (tl rm), (max diff (j-i)), days, maxi, maxj)
                    )
                )
                else (
                    find_longest ((i+1), j,(tl lm), rm, diff, days, maxi, maxj)
                )
            )   

    fun bypass (minl, maxr, n, prefix) =
        let 
         val (a,b,c) = find_longest (0, 0, minl, maxr, ~1, n, 0, 0)
         val prefix_sum = Array.fromList(prefix)
         val x = if (b = 0) then Array.sub(prefix_sum,b) else Array.sub(prefix_sum,b-1)
         val y = Array.sub(prefix_sum,c)
         in
         if (((b <> 0) andalso (y < x)) orelse (b = 0) andalso (y < 0)) 
            then (
                a-1
            )
        else (
            a
        )
        end

            
            

           

(* "main" function *)
in
    fun longest file =
        let
            val input = parse file
            val number_of_days = #1 input
            val hospitals = #2 input
            val rev_days = reverse (#3 input)
            val rev_days = map (fn x => ~x) rev_days
            val rev_days = map (fn x => x - hospitals) rev_days
            val rev_days = prefixsums rev_days
            val LMin = lmin rev_days
            val rev_days = reverse rev_days
            val RMax = rmax rev_days
            val rev_days = reverse rev_days
            val RMax = reverse RMax 
            val result = bypass (LMin, RMax, number_of_days, rev_days)
        in
            (* Control.Print.say((Int.toString(number_of_days)) ^ " " ^ (Int.toString(hospitals)) ^ "\n"); *)
            print(Int.toString(result)^"\n")
        end
end