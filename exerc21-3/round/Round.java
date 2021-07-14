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
    private int cities;
    private int vehicles;
    private int[] initial;
    
    
    public Round(String[] args) {
        this.readInput(args);
    }
    
    // readInput()
    // some code for this method copied from
    // https://www.reddit.com/r/javaexamples/comments/344kch/reading_and_parsing_data_from_a_file/
    public void readInput(String[] args) {
        // The name of the file to open.
        File inputFile = new File(args[0]);
        
        try {
            // FileReader reads text files in the default encoding.
            FileReader fileReader = new FileReader(inputFile);
            
            // Always wrap FileReader in BufferedReader.
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            
            String line;
            line = bufferedReader.readLine();
            String[] first = line.split(" ", 0);
            cities = Integer.parseInt(first[0]);
            vehicles = Integer.parseInt(first[1]);
            
            // read next line of numbers
            
            line = bufferedReader.readLine();
            String[] arrOfStr = line.split(" ", 0);
            
            initial = new int[vehicles];
            
            for (int i = 0; i < vehicles; i++) {
                
                initial[i] = Integer.parseInt(arrOfStr[i]);
            }
            
            bufferedReader.close();
        }
        catch (FileNotFoundException ex) {
            // insert code to run when exception occurs
            ex.printStackTrace();
        }
        catch(IOException e) {
            e.printStackTrace();
        }
        
        return;
    }
    
    public static void main(String[] args) {
        Round Round = new Round(args);
        Round.findSol();
    }
    
    public void findSol() {
        City[] city_array = new City[cities];
        
        
        for (int i = 0; i < cities; i++) { 
            City ret = new City(initial, i, vehicles, cities);
            city_array[i] = ret;
        }
        City best = new City(Integer.MAX_VALUE, 0, 0);
        for (City C : city_array) {
            if (!best.isBetter(C)) best = C;
        }
        System.out.println(best);
    }
    
}


class City {
    private int sum;
    private int index;
    private int maxtravel;
    
    public City(int s, int i, int m) {
        sum = s;
        index = i;
        maxtravel = m;
    }
    
    public City(int[] initial, int pos, int k, int c) {
        sum = 0;
        index = pos;
        maxtravel = -1;
        int ret;
        for (int i = 0; i < k; i++) {
            ret = pos - initial[i];
            if (ret < 0) ret += c;
            sum += ret;
            maxtravel = Math.max(ret, maxtravel);
        }
    }
    
    public int getsum() {
        return sum;
    }
    
    public int getindex() {
        return index;
    }
    
    public int getmax() {
        return maxtravel;
    }
    
    public boolean isBetter(City other) {
        if ((other.getsum() < sum) && (2*other.getmax() - other.getsum()) <= 1) {
            return false;
        }
        else return true;
    }
    
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("");
        sb.append(Integer.toString(sum) + " " + Integer.toString(index));
        return sb.toString();
    }
}
