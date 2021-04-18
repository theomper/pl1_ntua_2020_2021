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
        (* val rev_days = reverse days
        val N = length days *)
    in
        Control.Print.say((Int.toString(#1 input)) ^ " " ^ (Int.toString(#2 input)) ^ "\n")
    end