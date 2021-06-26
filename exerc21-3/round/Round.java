// FILENAME : Round.java
// DESCRIPTION : exerc21-3 / pl1-ntua
// AUTHOR : Theo Mper, Alex Tsaf
// COMPILE COMMAND : javac Round.java
// RUN COMMAND: java Round "input_file_path"
// TO-DO : 1)
//

import java.util.*;
import java.io.*;


public class Round {


    public Round(String[] args) {
        this.readInput(args);
    }

    // readInput()
    // some code for this method copied from
    // https://www.reddit.com/r/javaexamples/comments/344kch/reading_and_parsing_data_from_a_file/
    public void readInput(String[] args) {
        // The name of the file to open.
        File inputFile = new File(args[0]);
    }

    public void findSol() {
    }

    public static void main(String[] args) {
        Round round = new Round(args);
        round.findSol();
    }
}