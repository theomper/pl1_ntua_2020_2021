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

fun printGridChar i N M grid =
  if (i >= N) then ()
  else
    (
      let
        fun printRow j M =
          if (j >= M) then ()
          else (print (Char.toString(Array2.sub(grid, i, j))); printRow (j+1) M)
      in
        printRow 0 M;
        print "\n";
        printGridChar (i + 1) N M grid
      end
    )

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

fun tryingToCount i N M grid metr =
  if (i >= N) then ( metr )
  else
  (
    let
      fun countRow j M metr =
        if (j >= M) then ()
        else ( if (Array2.sub(grid, i, j) = 0) then (countRow (j+1) M (metr + 1)) else (countRow (j+1) M metr); countRow (j+1) M metr)
    in
      countRow 0 M metr;
      tryingToCount (i + 1) N M grid metr
    end
  )

fun fairbox ix jx rows columns rooms_array visited_array fairness_array =
(
    if ((Array2.sub(visited_array, ix, jx) = 1) andalso (Array2.sub(fairness_array, ix, jx) = ~1))
    then Array2.update(fairness_array, ix, jx, 0)
    else (
        if (Array2.sub(fairness_array, ix, jx) <> ~1)
        then ()
        else (
            if (   ((ix = 0) andalso (Array2.sub(rooms_array, ix, jx) = #"U" ))
            orelse ((ix = rows - 1) andalso (Array2.sub(rooms_array, ix, jx) = #"D" ))
            orelse ((jx = 0) andalso (Array2.sub(rooms_array, ix, jx) = #"L" ))
            orelse ((jx = columns - 1) andalso (Array2.sub(rooms_array, ix, jx) = #"R" ))
            ) then (Array2.update(visited_array, ix, jx, 1);
                    Array2.update(fairness_array, ix, jx, 1))
            else (
                case (Array2.sub(rooms_array, ix, jx)) of
                    #"U" => (Array2.update(visited_array, ix, jx, 1);
                            fairbox (ix - 1) jx rows columns rooms_array visited_array fairness_array;
                            Array2.update(fairness_array, ix , jx, Array2.sub(fairness_array, ix - 1, jx))
                            )
                |   #"D" => (Array2.update(visited_array, ix, jx, 1);
                            fairbox (ix + 1) jx rows columns rooms_array visited_array fairness_array;
                            Array2.update(fairness_array, ix , jx, Array2.sub(fairness_array, ix + 1, jx))
                            )
                |   #"L" => (Array2.update(visited_array, ix, jx, 1);
                            fairbox ix (jx - 1) rows columns rooms_array visited_array fairness_array;
                            Array2.update(fairness_array, ix , jx, Array2.sub(fairness_array, ix, jx - 1))
                            )
                |   #"R" => (Array2.update(visited_array, ix, jx, 1);
                            fairbox ix (jx + 1) rows columns rooms_array visited_array fairness_array;
                            Array2.update(fairness_array, ix , jx, Array2.sub(fairness_array, ix, jx + 1))
                            )
                |     _  => ()
            )
        )
    )
)

(* "main" function *)
fun loop_rooms file =
  let
    val input = parse file
    val rows = #1 input
    val columns = #2 input
    val rooms = #3 input
    val rooms_array = Array2.fromList rooms
    val visited_array = Array2.array(rows, columns, 0)
    val fairness_array = Array2.array(rows, columns, ~1)
    fun loopa i j rows columns = (
      if ((i = rows - 1) andalso (j = columns - 1))
      then ( fairbox i j rows columns rooms_array visited_array fairness_array)
      else (
        if (j = columns - 1)
        then (  fairbox i j rows columns rooms_array visited_array fairness_array;
                loopa (i + 1) 0 rows columns)
        else (
          fairbox i j rows columns rooms_array visited_array fairness_array;
          loopa i (j + 1) rows columns
        )
      )
    )
    fun counting counter i j rows columns = (
      if ((i = rows))
      then ( counter )
      else (
          if (j = columns - 1)
          then (if (Array2.sub(fairness_array, i, j) = 0) 
              then (counting (counter + 1) (i + 1) 0 rows columns)
              else (counting counter (i + 1) 0 rows columns))
          else (if (Array2.sub(fairness_array, i, j) = 0) 
              then (counting (counter + 1) i (j + 1) rows columns)
              else (counting counter i (j + 1) rows columns))
        )
    )
  in
    loopa 0 0 rows columns;
    print (Int.toString(counting 0 0 0 rows columns) ^ "\n")
  end