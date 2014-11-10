//package mp;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;
import java.util.StringTokenizer;


public class Disassembler {
	
	static BufferedReader inputStream = null;
	static PrintWriter outputStream = null;
	
	static void sysoutConverter(PrintWriter outputStream, String printStr) {
		if(printStr.contains("\"")) { //pag ang printStr at ay parang "Hello world"
			for(int i = 1;i < printStr.length()-1;i++) {
				printChar(outputStream, printStr.charAt(i));
			}
		}
		else { //pag ang printStr ay variable, e.g. number, var
			outputStream.println("lea dx," +printStr);
			outputStream.println("mov ah, 09h");
			outputStream.println("int 21h");
		}
	}
	
	static String getValue(String variable) { //gets the value in a variable. eg: number = 5 will return 5 
		int start = variable.indexOf('=') + 2;
		int end = variable.length()-1;
		if(start == end) {
			char c = variable.charAt(start);
			return c + "";
			
		}
		return variable.substring(start, end);
	}
	
	static String changeVar(String variable) {
		StringTokenizer st = new StringTokenizer(variable, " ");
		String terms[] = new String[3];
		for(int i = 0;i < 3;i++) {
			terms[i] = st.nextToken();
		}
		terms[2] = "\"" + terms[2] + "$\"";
		return terms[0] + " " + terms[1] + " " + terms[2];
	}
	
	static void variableConverter(PrintWriter outputStream, String variable){
		if(variable.contains("\"")) {
			variable += ",\"$\"";
		} 
		else 
			variable = changeVar(variable);

		String var = variable.replace("=", "db");
		outputStream.println("	" + var);
	}
	
	static void specialvariableConverter(PrintWriter outputStream, String variable) {
		String var = variable.replace("=", "db");
		outputStream.println("	" + var);
	}
	
	static void printChar(PrintWriter outputStream, char toprint) {
		String toOutput = "'" + toprint + "'";
		outputStream.println("mov dl, " + toOutput);
		outputStream.println("mov ah, 02h");
		outputStream.println("int 21h");
	}
	
	static void print(PrintWriter outputStream, String reg) {
		if(reg.contains("=")) {
			reg = getValue(reg);
			reg = "'" + reg + "'";
		}
		outputStream.println("mov dl, " + reg);
		outputStream.println("mov ah, 02h");
		outputStream.println("int 21h");
	}
	
	static String getComparator(String condition) {
		StringTokenizer st = new StringTokenizer(condition, " ");
		String temp = "";
		for(int i = 1;i <= 3;i++) {
			temp = st.nextToken();
			if(temp.equals("=") || temp.equals("<")|| temp.equals(">") || temp.equals("<=") || temp.equals(">=") || temp.equals("!="))
				return temp;
		}
		return "";
	}
	
	static String getFirstTerm(String condition) {
		StringTokenizer st = new StringTokenizer(condition, " ");
		return st.nextToken();
	}
	static String getLastTerm(String condition) {
		StringTokenizer st = new StringTokenizer(condition, " ");
		String temp = "";
		for(int i = 1;i <= 3;i++) {
			temp = st.nextToken();
		}
		return temp;
	}
	static void doIf(PrintWriter outputStream, String condition) {
		String comparator = getComparator(condition);
		String firstTerm = getFirstTerm(condition);
		String secondTerm = getLastTerm(condition);
		String temp = "";
		if(comparator.equals("="))
			temp = "je";
		else if(comparator.equals(">")) 
			temp = "jg";
		else if(comparator.equals("<")) 
			temp = "jl";
		else if(comparator.equals("<=")) 
			temp = "jle";
		else if(comparator.equals(">=")) 
			temp = "jge";
		else if(comparator.equals("!="))
			temp = "jne";
		outputStream.println("cmp "+ firstTerm + "," + secondTerm);
		outputStream.println(temp + " if_block");
		outputStream.println("if_block:");
	}
	
	public static void main(String[] args) throws IOException {
		BufferedReader inputStream = null;
		PrintWriter outputStream = null;
		
		String asmFileName = null;
		int errClass = 1;
		int errMain = 1;
		
		Scanner scanner = new Scanner(System.in);
		System.out.println("File to open: ");
		String file_name = scanner.next();
		
		try {
			inputStream = new BufferedReader(new FileReader(file_name));
			String line = "";
			while((line=inputStream.readLine()) != null) {
				if(line.contains("class")) {
					errClass = 0;
					StringTokenizer tokenizer = new StringTokenizer(line);
					while(tokenizer.hasMoreTokens()) {
						if(tokenizer.nextToken().equals("class")){
							asmFileName = tokenizer.nextToken();
							asmFileName += ".asm";
						}
					}
				}
				if(line.contains("void main")){
					errMain = 0;
				}
			}inputStream.close();
			
			if(errClass == 0 && errMain == 0) { //proper class and main function
				line = "";
				inputStream = new BufferedReader(new FileReader(file_name));
				outputStream = new PrintWriter(new FileOutputStream(asmFileName));
				String variable = "";
				
				outputStream.println(".model small");
				outputStream.println(".data");
				// DECLARATION OF VARIABLES
				while((line = inputStream.readLine()) != null){
					if(line.contains("int ")) {
						int startOfVariable = line.indexOf('i') + 4;
						int endOfVariable = line.indexOf(';');
						variable = line.substring(startOfVariable, endOfVariable);
						specialvariableConverter(outputStream, variable);
					}
					if(line.contains("char ")) {
						int startOfVariable = line.indexOf('c') + 5;
						int endOfVariable = line.indexOf(';');
						variable = line.substring(startOfVariable, endOfVariable);
						variableConverter(outputStream, variable);
					}
					if(line.contains("float ")) {
						int startOfVariable = line.indexOf('f') + 6;
						int endOfVariable = line.indexOf(';');
						variable = line.substring(startOfVariable, endOfVariable);
						variableConverter(outputStream, variable);
					}
					if(line.contains("String ")) {
						int startOfVariable = line.indexOf('S')  + 7;
						int endOfVariable = line.indexOf(';');
						variable = line.substring(startOfVariable, endOfVariable);
						variableConverter(outputStream, variable);					
					}
					if(line.contains("double ")) {
						int startOfVariable = line.indexOf('d') + 7;
						int endOfVariable = line.indexOf(';');
						variable = line.substring(startOfVariable, endOfVariable);
						variableConverter(outputStream, variable);
					}
					if(line.contains("boolean ")) {
						int startOfVariable = line.indexOf('b') + 7;
						int endOfVariable = line.indexOf(';');
						variable = line.substring(startOfVariable, endOfVariable);
						variableConverter(outputStream, variable);
					}
				}inputStream.close();
				outputStream.println(".stack 100h");
				outputStream.println(".code");
				outputStream.println("");
				
				outputStream.println("main proc");
				outputStream.println("");
				outputStream.println("mov ax, @data");
				outputStream.println("mov ds, ax");
				outputStream.println("");
				
				
				//MAUNA DAPAT NA HANAPIN ANG IF ELSE THEN PUT A COUNTER
				//PRINTING OF OUTPUTS
				inputStream = new BufferedReader(new FileReader(file_name));
				
				while((line=inputStream.readLine()) != null){
					if(line.contains("System.out")) {
						int startOfPrint = line.indexOf('(');
						int endOfPrint = line.indexOf(')');
						String print = line.substring(startOfPrint+1, endOfPrint);
						sysoutConverter(outputStream, print);
						print(outputStream, "0ah");
					}
				}
				inputStream.close();
				
				//IF ELSE
				String ifblk = "";
				String ifstmt = "";
				inputStream = new BufferedReader(new FileReader(file_name));
				while((line=inputStream.readLine()) != null) {
					ifstmt = ifstmt + "\n" + line;
				}
				StringTokenizer st = new StringTokenizer(ifstmt, "\n");
				int i = 0;
				int numOfTokens = st.countTokens();
				String[] token = new String[numOfTokens];
				while(st.hasMoreTokens()) {
					token[i] = st.nextToken();
					if(token[i].contains("if")) {
						int start = token[i].indexOf('(');
						int end = token[i].indexOf(')');
						String condition = token[i].substring(start+1, end);
						doIf(outputStream, condition);
						print(outputStream, "0ah");
					}
					i++;
				}
				
				inputStream.close();
				
				outputStream.println("mov ax, 4c00h");
				outputStream.println("int 21h");
				outputStream.println("");
				outputStream.println("main endp");
				outputStream.println("end main");
				
				inputStream.close();
				outputStream.close();
			}else{
				System.out.println("Error in the java file has been found.");
				
			}
			
		}catch(FileNotFoundException e){
			System.out.println("Error occured.");
		}catch(IOException e){
			System.out.println("Error occured.");
		}
	}

}
