// append a new line to an exisiting text file

//import java.io.FileWriter;
//import java.io.BufferedWriter;

void setup() {

  //String[] lines = loadStrings("/../data/test.txt");
  String[] lines = loadStrings("C/Users/notch/Documents/GitHub/BLIND_SEARCH/ProcessingArduino/data/test.txt");
//C:\Users\notch\Documents\GitHub\BLIND_SEARCH
  PrintWriter output = createWriter("/data/test.txt");

  for (int i = 0; i < lines.length; i++) {
    output.println(lines[i]); 
  }

  output.println("hello");
  output.flush();
  output.close();

}
