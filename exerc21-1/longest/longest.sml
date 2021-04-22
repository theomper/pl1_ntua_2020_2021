(* FILENAME : longest.sml
 * DESCRIPTION : exerc21-1 / pl1-ntua
 * AUTHOR : Theo Mper, Alex Tsaf
 * HOW-TO-RUN: a) in unix shell type $ sml longest.sml and in ML interpreter type - longest "longest.in1";
 *             b) in unix shell type $ sml and in ML interpreter type - use "longest.sml"; and - longest "longest.in1";
 *             c) terminate ML interpreter with Ctrl + D
 * TO-DO : *)

(* A more efficent reverse using a helper/tail-recursive funcion *)
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

(* "main" function *)
fun longest file =
    let
        val input = parse file
        val number_of_days = #1 input
        val hospitals = #2 input
        val rev_days = reverse (#3 input)
        val rev_days = map (fn x => ~x) rev_days
        val rev_days = map (fn x => x - hospitals) rev_days
        fun prefixsums xs =
            let
                fun prefix (nil, pr, z) = z
                  | prefix (ys, pr, nil) = prefix (ys, pr, pr::[])
                  | prefix (y::ys, pr, z) = prefix (ys, pr + y, (pr + y)::z)
            in
                prefix (tl xs, hd xs, nil)
            end
        val rev_days = prefixsums rev_days
        val rev_days = reverse rev_days
        fun lmin xs =
            let
                fun lm (nil, pr, z) = z
                  | lm (ys, pr, nil) = lm (ys, pr, pr::[])
                  | lm (y::ys, pr, z) = lm (ys, if (length ys <> 0) then hd ys else 0, (min y (hd z))::z)
            in
                lm (tl xs, hd xs, nil)
            end
        val lmins = lmin rev_days
        val lmins = reverse lmins
    in
        Control.Print.say((Int.toString(number_of_days)) ^ " " ^ (Int.toString(hospitals)) ^ "\n");
        rev_days
    end