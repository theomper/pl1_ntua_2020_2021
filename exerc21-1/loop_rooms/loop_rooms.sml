(* FILENAME : loop_rooms.sml
 * DESCRIPTION : exerc21-1 / pl1-ntua
 * AUTHOR : Theo Mper, Alex Tsaf
 * HOW-TO-RUN: a) in unix shell type $ sml loop_rooms.sml and in ML interpreter type - loop_rooms "loop_rooms.in1";
 *             b) in unix shell type $ sml and in ML interpreter type - use "loop_rooms.sml"; and - loop_rooms "loop_rooms.in1";
 *             c) terminate ML interpreter with Ctrl + D
 * TO-DO : *)

(* A more efficent reverse using a helper/tail-recursive funcion *)
fun rev xs =
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
        fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        (* Open input file. *)
        val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
        val (n, m) = (readInt inStream, readInt inStream)
        val _ = TextIO.inputLine inStream

        (* fun to read a char list*)
        fun readLines acc =
            case TextIO.inputLine inStream of
                NONE => rev acc
            |   SOME  line => readLines (explode (String.substring (line, 0, m)) :: acc)

        val inputList = readLines [] : char list list
        val _ = TextIO.closeIn inStream
    in
        (n, m, inputList)
    end

(* "main" function *)
fun loop_rooms file =
    let
        val input = parse file
        val lista = #3 input
        (* val rev_days = reverse days
        val N = length days *)
    in
        Control.Print.say((Int.toString(#1 input)) ^ " " ^ (Int.toString(#2 input)) ^ "\n");
        lista
    end