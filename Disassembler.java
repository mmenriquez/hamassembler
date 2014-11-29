//package mp;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.StringTokenizer;

import javax.swing.JOptionPane;


public class Disassembler {
	
	static BufferedReader inputStream = null;
	static PrintWriter outputStream = null;
	static String []numbers = {" "," "," "," "," "," "," "," "," "," ",};
	static int numIndex = 0;
	
	static String var1 = "";
	static String var2 = "";
	static int ifelse = 0;
	static int elsetemp = 0;
	static int loop = 0;
	static String loopstr = "";
	
	static void sysoutConverter(PrintWriter outputStream, String printStr) {
		if(printStr.contains("\"")||printStr.contains("\'")){
			for(int i = 1;i < printStr.length()-1;i++) {
				printChar(outputStream, printStr.charAt(i));
			}
		}else{ 
			for(int i = 0; i < numbers.length; i++){//catch if value of the variable is a number
				if(numbers[i].equals(printStr)){
					outputStream.println("add " +printStr+", 48");
					outputStream.println("mov dl," +printStr);
					outputStream.println("mov ah, 02h");
					outputStream.println("int 21h");
					outputStream.println("sub " +printStr+", 48");
					outputStream.println("");
					return;
				}
			}
			outputStream.println("lea dx," +printStr);
			outputStream.println("mov ah, 09h");
			outputStream.println("int 21h");
			outputStream.println("");
		}
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
	
	static void variableConverter(PrintWriter outputStream, String variable, String type){
		if(variable.contains("\"")) {
			variable += ",\"$\"";
		}else if(variable.contains("\'")){
			variable += ",\'$\'";
		}else if((variable.contains("0")||variable.contains("1")||variable.contains("2")||variable.contains("3")||variable.contains("4")||variable.contains("5")||variable.contains("6")||variable.contains("7")||variable.contains("8")||variable.contains("9"))&&(type.equals("int")||type.equals("double")||type.equals("float"))){
			String varStr = variable;
			StringBuilder sb = new StringBuilder(varStr);
			sb.insert(0, "str");
			varStr = sb.toString();
			varStr = changeVar(varStr);
			varStr = varStr.replace("=","db");
			outputStream.println("	" + varStr);
		}
		String var = variable.replace("=", "db");
		outputStream.println("	" + var);
	}
	
	static void printChar(PrintWriter outputStream, char toprint) {
		String toOutput = "'" + toprint + "'";
		outputStream.println("mov dl, " + toOutput);
		outputStream.println("mov ah, 02h");
		outputStream.println("int 21h");
		outputStream.println("");
	}
	
	static void print(PrintWriter outputStream, String reg) {
		if(reg.contains("=")) {
			reg = getValue(reg);
			reg = "'" + reg + "'";
		}
		outputStream.println("mov dl, " + reg);
		outputStream.println("mov ah, 02h");
		outputStream.println("int 21h");
		outputStream.println("");
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
	
	static void arithmeticHandler(PrintWriter outputStream, String result, String operation, String foperator, String soperator){
		if(operation.equals("+")){
			outputStream.println("mov al,"+foperator);
			outputStream.println("mov cl,"+soperator);
			outputStream.println("add al,cl");
			outputStream.println("mov "+result+",al");
		}else if(operation.equals("-")){
			outputStream.println("mov al,"+foperator);
			outputStream.println("mov cl,"+soperator);
			outputStream.println("sub al,cl");
			outputStream.println("mov "+result+",al");
		}
	}
	
	static void forConverter(PrintWriter outputStream, String loopVariable, String boolExp, int constant,ArrayList<String> sequence, ArrayList<String> sysVar, ArrayList<String> result, ArrayList<String> operation, ArrayList<String> foperator, ArrayList<String> soperator){
		String booleanExp = "";
		int isysVar = 0;
		int iresult = 0;
		int ioperation = 0;
		int ifoperator = 0;
		int isoperator = 0;
		
		outputStream.println("forlabel:");
		if(boolExp == "<"){
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jge endfor");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("inc "+loopVariable);
			outputStream.println("jmp forlabel");
			outputStream.println("endfor:");
		}else if(boolExp == "<="){
			constant++;
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jge endwhile");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("inc "+loopVariable);
			outputStream.println("jmp forlabel");
			outputStream.println("endfor:");
		}else if(boolExp == ">"){
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jle endwhile");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("dec "+loopVariable);
			outputStream.println("jmp forlabel");
			outputStream.println("endfor:");
		}else if(boolExp == ">="){
			constant--;
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jle endwhile");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("dec "+loopVariable);
			outputStream.println("jmp forlabel");
			outputStream.println("endfor:");
		}
	}
	
	static void whileConverter(PrintWriter outputStream, String loopVariable, String boolExp, int constant,ArrayList<String> sequence, ArrayList<String> sysVar, ArrayList<String> result, ArrayList<String> operation, ArrayList<String> foperator, ArrayList<String> soperator){
		String booleanExp = "";
		int isysVar = 0;
		int iresult = 0;
		int ioperation = 0;
		int ifoperator = 0;
		int isoperator = 0;
		
		outputStream.println("whilelabel:");
		if(boolExp == "<"){
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jge endwhile");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}else if(boolExp == "<="){
			constant++;
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jge endwhile");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}else if(boolExp == ">"){
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jle endwhile");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}else if(boolExp == ">="){
			constant--;
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jle endwhile");
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}
	}
	
	static void doWhileConverter(PrintWriter outputStream, String variable, String boolExp, int constant,ArrayList<String> sequence, ArrayList<String> sysVar, ArrayList<String> result, ArrayList<String> operation, ArrayList<String> foperator, ArrayList<String> soperator){
		String booleanExp = "";
		int isysVar = 0;
		int iresult = 0;
		int ioperation = 0;
		int ifoperator = 0;
		int isoperator = 0;
		outputStream.println("dowhilelabel:");
		if(boolExp == "<"){
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jl dowhilelabel");
		}else if(boolExp == "<="){
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jle dowhilelabel");
		}else if(boolExp == ">"){
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jg dowhilelabel");
		}else if(boolExp == ">="){
			for(int i = 0; i < sequence.size(); i++){
				if(sequence.get(i).equals("print")){
					sysoutConverter(outputStream, sysVar.get(isysVar).toString());
					print(outputStream, "0ah");
					isysVar++;
				}else if(sequence.get(i).equals("arithmetic")){
					arithmeticHandler(outputStream, result.get(iresult), operation.get(ioperation), foperator.get(ifoperator), soperator.get(isoperator));
					iresult++;
					ioperation++;
					ifoperator++;
					isoperator++;
				}
			}
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jge dowhilelabel");
		}
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
	
	// ASSEMBLY TO JAVA FUNCTIONS
	public static String removeChr(String str, char x){
		StringBuilder strBuilder = new StringBuilder();
	    char[] rmString = str.toCharArray();
	    for(int i=0; i<rmString.length; i++) {
	    	if(rmString[i] == x) {
	    		
	    	} else {
	                strBuilder.append(rmString[i]);
	        }
	    }
	    return strBuilder.toString();
	}
	
	public static String removeLastChar(String str) {
        return str.substring(0,str.length()-1);
    }
	
	public static void printOutputs(PrintWriter outputStream, String line) {
		if(line.contains("lea dx")) {
			String vartoprint = line.substring(line.indexOf("lea dx")+7);
			vartoprint = removeChr(vartoprint, ' ');
			outputStream.println("\tSystem.out.print(" +vartoprint+ ");");
		}
		else if(line.contains("mov dx, offset") || line.contains("mov dx,offset")) {
			String vartoprint = line.substring(line.indexOf("mov dx")+14);
			vartoprint = removeChr(vartoprint, ' ');
			outputStream.println("\tSystem.out.print(" +vartoprint+ ");");
		}
		else if(line.contains("mov dl") && !line.contains("\'")) {
			String vartoprint = line.substring(line.indexOf("mov dl")+7);
			vartoprint = removeChr(vartoprint, ' ');
			if(vartoprint.equals("0ah") || vartoprint.equals(" 0ah")) {
				outputStream.println("\tSystem.out.print(" + "\"\\n\"" +");");
			}
			else {
				outputStream.println("\tSystem.out.print(" +vartoprint+ ");");
			}
		}
		else if(line.contains("mov dl") && line.contains("\'")) {
			String vartoprint = line.substring(line.indexOf("mov dl")+7);
			vartoprint = removeChr(vartoprint, '\'');
			vartoprint = removeChr(vartoprint, ' ');
			outputStream.println("\tSystem.out.print(\"" +vartoprint+ "\"" + ");");
		}
	}
	
	
	public static void main(String[] args) throws IOException {
		BufferedReader inputStream = null;
		PrintWriter outputStream = null;
		Scanner scanner;
		String file_name = "";

		String option = JOptionPane.showInputDialog("\tHAMssembler\n[1] Java->Assembly\n[2] Assembly->Java");
		switch (option){
		case "1": String asmFileName = null;
					int errClass = 1;
					int errMain = 1;
					int sysMode = 1;
					int ieMode = 1;
					
					scanner = new Scanner(System.in);
					System.out.println("File to open: ");
					file_name = scanner.next();
					
					try {
						inputStream = new BufferedReader(new FileReader(file_name));
						String line = "";
						//CHECK FOR CLASS AND MAIN FXN
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
						//END
						if(errClass == 0 && errMain == 0){ //proper class and main function
							inputStream = new BufferedReader(new FileReader(file_name));
							outputStream = new PrintWriter(new FileOutputStream(asmFileName));
							String variable = "";
							boolean doLoop = false;
							line = "";
							
							outputStream.println(".model small");
							outputStream.println(".data");
							
							// DECLARATION OF VARIABLES
							while((line = inputStream.readLine()) != null){
								if(line.contains("int ")) {
									int startOfVariable = line.indexOf("int") + 4;
									int endOfVar = line.indexOf('=')-1;
									int endOfVariable = line.indexOf(';');
									variable = line.substring(startOfVariable, endOfVariable);
									variableConverter(outputStream, variable, "int");
									String var = line.substring(startOfVariable,endOfVar);
									numbers[numIndex] = var;
									numIndex++;
								}
								if(line.contains("double ")) {
									int startOfVariable = line.indexOf("double") + 7;
									int endOfVar = line.indexOf('=')-1;
									int endOfVariable = line.indexOf(';');
									variable = line.substring(startOfVariable, endOfVariable);
									variableConverter(outputStream, variable, "double");
									String var = line.substring(startOfVariable,endOfVar);
									numbers[numIndex] = var;
									numIndex++;
								}
								if(line.contains("float ")) {
									int startOfVariable = line.indexOf("float") + 6;
									int endOfVar = line.indexOf('=')-1;
									int endOfVariable = line.indexOf(';');
									variable = line.substring(startOfVariable, endOfVariable);
									variableConverter(outputStream, variable, "float");
									String var = line.substring(startOfVariable,endOfVar);
									numbers[numIndex] = var;
									numIndex++;
								}
								if(line.contains("char ")) {
									int startOfVariable = line.indexOf("char") + 5;
									int endOfVariable = line.indexOf(';');
									variable = line.substring(startOfVariable, endOfVariable);
									variableConverter(outputStream, variable, "char");
								}
								if(line.contains("String ")) {
									int startOfVariable = line.indexOf("String")  + 7;
									int endOfVariable = line.indexOf(';');
									variable = line.substring(startOfVariable, endOfVariable);
									variableConverter(outputStream, variable, "String");					
								}
								if(line.contains("boolean ")) {
									int startOfVariable = line.indexOf("boolean") + 7;
									int endOfVariable = line.indexOf(';');
									variable = line.substring(startOfVariable, endOfVariable);
									variableConverter(outputStream, variable, "boolean");
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
							
							inputStream = new BufferedReader(new FileReader(file_name));
							
							while((line=inputStream.readLine()) != null){
								//PRINTING
								if(line.contains("System.out")&&sysMode>0) {
									int startOfPrint = line.indexOf('(');
									int endOfPrint = line.indexOf(')');
									String print = line.substring(startOfPrint+1, endOfPrint);
									sysoutConverter(outputStream, print);
									print(outputStream, "0ah");
								}
								//IF-ELSE
								else if(line.contains("if")) {
									System.out.println("if");
									ieMode = 0;
									String sysVar = "";
									//sysMode = 0;
									int start = line.indexOf('(');
									int end = line.indexOf(')');
									String condition = line.substring(start+1, end);
									//doIf(outputStream, condition);
									String comparator = getComparator(condition);
									String firstTerm = getFirstTerm(condition);
									String secondTerm = getLastTerm(condition);
									String temp = "";
									
									String result = "";
									String operation = "";
									String foperator = "";
									String soperator = "";
									
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
									outputStream.println("jmp else_block");
									outputStream.println("if_block:");
									while((line=inputStream.readLine())!=null){
										if(line.contains("System.out.println")){
											sysVar = line.substring(line.indexOf('(')+1, line.indexOf(')'));
											sysoutConverter(outputStream, sysVar);
											print(outputStream, "0ah");
										}else if((line.contains("++")||line.contains("--"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("++")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("++")));
												operation = "+";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("++")));
												soperator = "1";
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}else if(line.contains("--")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("--")));
												operation = "-";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("--")));
												soperator = "1";
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}
										}else if(line.contains("+=")||line.contains("-=")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("+=")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("+=")));
												operation = "+";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("+=")));
												soperator = line.substring((line.indexOf("=")+1), line.indexOf(";"));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}else if(line.contains("--")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("-=")));
												operation = "-";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("-=")));
												soperator = line.substring((line.indexOf("=")+1), line.indexOf(";"));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}
										}else if((line.contains("+")||line.contains("-"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])&&(line.indexOf(numbers[i])<line.indexOf("="))){
													lhs = numbers[i];
													break;
												}
											}
											result = line.substring(line.indexOf(lhs), (line.indexOf("=")-1));
											if(line.contains("+")){
												operation = "+";
												foperator = line.substring((line.indexOf("=")+2), (line.indexOf("+")-1));
												soperator = line.substring((line.indexOf("+")+2), (line.indexOf(";")));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}else if(line.contains("-")){
												operation = "-";
												foperator = line.substring((line.indexOf("=")+2), (line.indexOf("-")-1));
												soperator = line.substring((line.indexOf("-")+2), (line.indexOf(";")));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}
										}
										else if(line.contains("}"))
											break;
									}
									outputStream.println("jmp exit");
								}
								else if(line.contains("else") && ieMode == 0) {
									System.out.println("else");
									String sysVar = "";
									//sysMode = 0;
									String result = "";
									String operation = "";
									String foperator = "";
									String soperator = "";
									
									outputStream.println("else_block:");
									while((line=inputStream.readLine())!=null){
										if(line.contains("System.out.println")){
											sysVar = line.substring(line.indexOf('(')+1, line.indexOf(')'));
											sysoutConverter(outputStream, sysVar);
											print(outputStream, "0ah");
										}else if((line.contains("++")||line.contains("--"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("++")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("++")));
												operation = "+";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("++")));
												soperator = "1";
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}else if(line.contains("--")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("--")));
												operation = "-";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("--")));
												soperator = "1";
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}
										}else if(line.contains("+=")||line.contains("-=")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("+=")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("+=")));
												operation = "+";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("+=")));
												soperator = line.substring((line.indexOf("=")+1), line.indexOf(";"));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}else if(line.contains("--")){
												result = line.substring(line.indexOf(lhs), (line.indexOf("-=")));
												operation = "-";
												foperator = line.substring(line.indexOf(lhs), (line.indexOf("-=")));
												soperator = line.substring((line.indexOf("=")+1), line.indexOf(";"));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}
										}else if((line.contains("+")||line.contains("-"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])&&(line.indexOf(numbers[i])<line.indexOf("="))){
													lhs = numbers[i];
													break;
												}
											}
											result = line.substring(line.indexOf(lhs), (line.indexOf("=")-1));
											if(line.contains("+")){
												operation = "+";
												foperator = line.substring((line.indexOf("=")+2), (line.indexOf("+")-1));
												soperator = line.substring((line.indexOf("+")+2), (line.indexOf(";")));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}else if(line.contains("-")){
												operation = "-";
												foperator = line.substring((line.indexOf("=")+2), (line.indexOf("-")-1));
												soperator = line.substring((line.indexOf("-")+2), (line.indexOf(";")));
												arithmeticHandler(outputStream, result, operation, foperator, soperator);
											}
										}
										if(line.contains("}"))
											break;
									}
								}
								//WHILE
								else if(line.contains("while")&&!doLoop){
									//sysMode = 0;
									int startOfLoopVar = 0;
									int endOfVarLoop = 0;
									int constant = 0;
									String loopVariable = "";
									String boolExp = "";
									ArrayList<String> sequence = new ArrayList<String>();
									ArrayList<String> sysVar = new ArrayList<String>();
									
									ArrayList<String> result = new ArrayList<String>();
									ArrayList<String> foperator = new ArrayList<String>();
									ArrayList<String> soperator = new ArrayList<String>();
									ArrayList<String> operation = new ArrayList<String>();
									
									startOfLoopVar = line.indexOf('(')+1;
									if(line.contains("<")){
										endOfVarLoop = line.indexOf("<")-1;
										if(line.charAt(line.indexOf("<")+1) == '='){
											boolExp = "<=";
										}else{
											boolExp = "<";
										}
									}else if(line.contains(">")){
										endOfVarLoop = line.indexOf(">")-1;
										if(line.charAt(line.indexOf(">")+1) == '='){
											boolExp = ">=";
										}else{
											boolExp = ">";
										}
									}
									loopVariable = line.substring(startOfLoopVar, endOfVarLoop);
									constant = line.charAt(line.indexOf(')')-1);
									constant -= 48;
									
									while((line=inputStream.readLine())!=null){
										if(line.contains("System.out.println")){
											sysVar.add(line.substring(line.indexOf('(')+1, line.indexOf(')')));
											sequence.add("print");
										}else if((line.contains("++")||line.contains("--")) && !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("++")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("++"))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("++"))));
												soperator.add("1");
												sequence.add("arithmetic");
											}else if(line.contains("--")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("--"))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("--"))));
												soperator.add("1");
												sequence.add("arithmetic");
											}
										}else if(line.contains("+=")||line.contains("-=")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("+=")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("+="))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("+="))));
												soperator.add(line.substring((line.indexOf("=")+1), line.indexOf(";")));
												sequence.add("arithmetic");
											}else if(line.contains("-=")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("-="))));
												operation.add("-");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("-="))));
												soperator.add(line.substring((line.indexOf("=")+1), line.indexOf(";")));
												sequence.add("arithmetic");
											}
										}else if((line.contains("+")||line.contains("-")) && !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])&&(line.indexOf(numbers[i])<line.indexOf("="))){
													lhs = numbers[i];
													break;
												}
											}
											result.add(line.substring(line.indexOf(lhs), (line.indexOf("=")-1)));
											if(line.contains("+")){
												operation.add("+");
												foperator.add(line.substring((line.indexOf("=")+2), (line.indexOf("+")-1)));
												soperator.add(line.substring((line.indexOf("+")+2), (line.indexOf(";"))));
												sequence.add("arithmetic");
											}else if(line.contains("-")){
												operation.add("-");
												foperator.add(line.substring((line.indexOf("=")+2), (line.indexOf("-")-1)));
												soperator.add(line.substring((line.indexOf("-")+2), (line.indexOf(";"))));
												sequence.add("arithmetic");
											}
										}
										if(line.contains("}"))
											break;
									}
									whileConverter(outputStream, loopVariable, boolExp, constant, sequence, sysVar, result, operation, foperator,soperator);
								}
								//FOR
								else if(line.contains("for")){
									//sysMode = 0;
									int startOfLoopVar = 0;
									int endOfLoopVar = 0;
									int constant = 0;
									String loopVariable = "";
									String boolExp = "";
									ArrayList<String> sequence = new ArrayList<String>();
									ArrayList<String> sysVar = new ArrayList<String>();
									
									ArrayList<String> result = new ArrayList<String>();
									ArrayList<String> foperator = new ArrayList<String>();
									ArrayList<String> soperator = new ArrayList<String>();
									ArrayList<String> operation = new ArrayList<String>();
									
									startOfLoopVar = line.indexOf('(')+1;
									endOfLoopVar = line.indexOf('=')-1;
									
									if(line.contains("<")){
										if(line.charAt(line.indexOf("<")+1) == '='){
											boolExp = "<=";
											constant = line.charAt(line.indexOf('<')+3);
										}else{
											boolExp = "<";
											constant = line.charAt(line.indexOf('<')+2);
										}
									}else if(line.contains(">")){
										if(line.charAt(line.indexOf(">")+1) == '='){
											boolExp = ">=";
											constant = line.charAt(line.indexOf('>')+3);
										}else{
											boolExp = ">";
											constant = line.charAt(line.indexOf('>')+2);
										}
									}
									
									loopVariable = line.substring(startOfLoopVar, endOfLoopVar);
									constant -= 48;
									
									while((line=inputStream.readLine())!=null){
										if(line.contains("System.out.println")){
											sysVar.add(line.substring(line.indexOf('(')+1, line.indexOf(')')));
											sequence.add("print");
										}else if((line.contains("++")||line.contains("--"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("++")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("++"))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("++"))));
												soperator.add("1");
												sequence.add("arithmetic");
											}else if(line.contains("--")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("--"))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("--"))));
												soperator.add("1");
												sequence.add("arithmetic");
											}
										}else if(line.contains("+=")||line.contains("-=")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("+=")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("+="))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("+="))));
												soperator.add(line.substring((line.indexOf("=")+1), line.indexOf(";")));
												sequence.add("arithmetic");
											}else if(line.contains("-=")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("-="))));
												operation.add("-");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("-="))));
												soperator.add(line.substring((line.indexOf("=")+1), line.indexOf(";")));
												sequence.add("arithmetic");
											}
										}else if((line.contains("+")||line.contains("-"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])&&(line.indexOf(numbers[i])<line.indexOf("="))){
													lhs = numbers[i];
													break;
												}
											}
											result.add(line.substring(line.indexOf(lhs), (line.indexOf("=")-1)));
											if(line.contains("+")){
												operation.add("+");
												foperator.add(line.substring((line.indexOf("=")+2), (line.indexOf("+")-1)));
												soperator.add(line.substring((line.indexOf("+")+2), (line.indexOf(";"))));
												sequence.add("arithmetic");
											}else if(line.contains("-")){
												operation.add("-");
												foperator.add(line.substring((line.indexOf("=")+2), (line.indexOf("-")-1)));
												soperator.add(line.substring((line.indexOf("-")+2), (line.indexOf(";"))));
												sequence.add("arithmetic");
											}
										}
										if(line.contains("}"))
											break;
									}
									forConverter(outputStream, loopVariable, boolExp, constant, sequence, sysVar, result, operation, foperator,soperator);
								}
								//DO-WHILE
								else if(line.contains("do")){
									doLoop = true;
									//sysMode = 0;
									
									int startOfLoopVar = 0;
									int endOfLoopVar = 0;
									int constant = 0;
									String loopVariable = "";
									String boolExp = "";
									ArrayList<String> sequence = new ArrayList<String>();
									ArrayList<String> sysVar = new ArrayList<String>();
									
									ArrayList<String> result = new ArrayList<String>();
									ArrayList<String> foperator = new ArrayList<String>();
									ArrayList<String> soperator = new ArrayList<String>();
									ArrayList<String> operation = new ArrayList<String>();
									
									while((line=inputStream.readLine())!=null){
										if(line.contains("System.out.println")){
											sysVar.add(line.substring(line.indexOf('(')+1, line.indexOf(')')));
											sequence.add("print");
										}else if(line.contains("while")&&doLoop){
											startOfLoopVar = line.indexOf('(')+1;
		
											if(line.contains("<")){
												endOfLoopVar = line.indexOf('<')-1;
												if(line.charAt(line.indexOf("<")+1) == '='){
													boolExp = "<=";
												}else{
													boolExp = "<";
												}
											}else if(line.contains(">")){
												endOfLoopVar = line.indexOf('>')-1;
												if(line.charAt(line.indexOf(">")+1) == '='){
													boolExp = ">=";
												}else{
													boolExp = ">";
												}
											}
											loopVariable = line.substring(startOfLoopVar, endOfLoopVar);
											constant = line.charAt(line.indexOf(')')-1);
											constant -= 48;
										}else if((line.contains("++")||line.contains("--"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("++")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("++"))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("++"))));
												soperator.add("1");
												sequence.add("arithmetic");
											}else if(line.contains("--")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("--"))));
												operation.add("-");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("--"))));
												soperator.add("1");
												sequence.add("arithmetic");
											}
										}else if(line.contains("+=")||line.contains("-=")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])){
													lhs = numbers[i];
													break;
												}
											}
											if(line.contains("+=")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("+="))));
												operation.add("+");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("+="))));
												soperator.add(line.substring((line.indexOf("=")+1), line.indexOf(";")));
												sequence.add("arithmetic");
											}else if(line.contains("-=")){
												result.add(line.substring(line.indexOf(lhs), (line.indexOf("-="))));
												operation.add("-");
												foperator.add(line.substring(line.indexOf(lhs), (line.indexOf("-="))));
												soperator.add(line.substring((line.indexOf("=")+1), line.indexOf(";")));
												sequence.add("arithmetic");
											}
										}else if((line.contains("+")||line.contains("-"))&& !line.contains("for")){
											String lhs = "";
											for(int i = 0; i < numbers.length; i++){
												if(line.contains(numbers[i])&&(line.indexOf(numbers[i])<line.indexOf("="))){
													lhs = numbers[i];
													break;
												}
											}
											result.add(line.substring(line.indexOf(lhs), (line.indexOf("=")-1)));
											if(line.contains("+")){
												operation.add("+");
												foperator.add(line.substring((line.indexOf("=")+2), (line.indexOf("+")-1)));
												soperator.add(line.substring((line.indexOf("+")+2), (line.indexOf(";"))));
												sequence.add("arithmetic");
											}else if(line.contains("-")){
												operation.add("-");
												foperator.add(line.substring((line.indexOf("=")+2), (line.indexOf("-")-1)));
												soperator.add(line.substring((line.indexOf("-")+2), (line.indexOf(";"))));
												sequence.add("arithmetic");
											}
										}
										if(line.contains("}"))
											break;
									}
									doWhileConverter(outputStream, loopVariable, boolExp, constant, sequence, sysVar, result, operation, foperator, soperator);
								}
							}
							inputStream.close();
							//END OF OUTPUTS
							outputStream.println("exit:");
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
					break;
		
		case "2":   scanner = new Scanner(System.in);
					System.out.println("File to open: ");
					file_name = scanner.next();
					String javafilename = file_name.substring(0, file_name.indexOf(".")) + ".java";
					try {
						inputStream = new BufferedReader(new FileReader(file_name));
						outputStream = new PrintWriter(new FileOutputStream(javafilename));
						outputStream.println("public class "+file_name.substring(0, file_name.indexOf(".")) + " {\n");
						String line = "";
						outputStream.println("\t\npublic static void main(String[] args) {");
						while((line=inputStream.readLine()) != null) {
							//DECLARATION OF VARIABLES
							if(line.contains("db")) {
								if(line.contains("$")) { //String
									line = removeChr(line, '\'');
									line = removeChr(line, ',');
									line = removeChr(line, '$');
									String var = line.substring(0, line.indexOf("db"));
									String varstr = line.substring(line.indexOf("db")+3);
									String last = varstr.substring(varstr.length() - 1); 
									if(last.equals(" ")) {
										varstr = removeLastChar(varstr);
									}
									outputStream.println("\tString" +var+ "= \"" + varstr +"\"" + ";");
								}
								else if(line.contains("\'") && !line.contains("$")) { //char
									String var = line.substring(0, line.indexOf("db"));
									String varstr = line.substring(line.indexOf("db")+3);
									String last = varstr.substring(varstr.length() - 1); 
									if(last.equals(" ")) {
										varstr = removeLastChar(varstr);
									}
									outputStream.println("\tchar" +var+ "= " + varstr + ";");
								}
								else { //integer
									String var = line.substring(0, line.indexOf("db"));
									String varstr = line.substring(line.indexOf("db")+3);
									String last = varstr.substring(varstr.length() - 1); 
									if(last.equals(" ")) {
										varstr = removeLastChar(varstr);
									}
									outputStream.println("\tint" +var+ "= " + varstr + ";");
								}
							}
							//PRINTING OF OUTPUTS
							if(ifelse == 0) {
								printOutputs(outputStream, line);
							}
							
							//IF ELSE
							if(line.contains("mov al")) {
								var1 = line.substring(line.indexOf("mov al")+7);
								var1 = removeChr(var1, ' ');
							}
							if(line.contains("cmp al")) {
								var2 = line.substring(line.indexOf("cmp al")+7);
								var2 = removeChr(var2, ' ');
							}
							String comparator = "";
							if(line.contains("je iflabel")) {
								comparator = "==";
							}
							else if(line.contains("jl iflabel")) {
								comparator = "<";
							}
							else if(line.contains("jg iflabel")) {
								comparator = ">";			
							}
							else if(line.contains("jle iflabel")) {
								comparator = "<=";
							}
							else if(line.contains("jge iflabel")) {
								comparator = ">=";
							}
							if(line.contains("jmp elselabel")) {
								elsetemp = 1;
							}
							if(line.contains("iflabel") && !line.contains(":")) {
								outputStream.println("\tif(" + var1 + comparator + var2 +") {");
							}
							if(line.contains("iflabel") && line.contains(":")) {
								ifelse = 1;
							}
							if(line.contains("jmp endiflabe")) {
								outputStream.println("\t}");
								ifelse = 0;
							} //end if
							if(ifelse == 1) {
								printOutputs(outputStream, line);
							}
							if(line.contains("elselabel") && elsetemp == 1 && line.contains(":")) {
								outputStream.println("\telse {");
								printOutputs(outputStream, line);
								elsetemp = -1;
							}
							if(line.contains("jmp endelselabe")) {
								outputStream.println("\t}");
								elsetemp = 0;
							}
							
							//LOOP
							if(line.contains("looplabel") && line.contains(":")) {
								outputStream.println("\tdo {");
								printOutputs(outputStream, line);
								loop = -1;
							}
							if(line.contains("mov bl")) {
								var1 = line.substring(line.indexOf("mov bl")+7);
								var1 = removeChr(var1, ' ');
							}
							if(line.contains("cmp bl")) {
								var2 = line.substring(line.indexOf("cmp bl")+7);
								var2 = removeChr(var2, ' ');
							}
							if(line.contains("add")) {
								outputStream.println("\t" + var1 + "++;");
							}
							if(line.contains("je looplabel")) {
								loopstr = "while(" + var1 + "==" + var2 + "+1);";
							}
							if(line.contains("jl looplabel")) {
								loopstr = "while(" + var1 + "<" + var2 + "+1);";
							}
							if(line.contains("jg looplabel")) {
								loopstr = "while(" + var1 + ">" + var2 + "+1);";
							}
							if(line.contains("jle looplabel")) {
								loopstr = "while(" + var1 + "<=" + var2 + "+1);";
							}
							if(line.contains("jge looplabel")) {
								loopstr = "while(" + var1 + ">=" + var2 + "+1);";
							}
							if(line.contains("jmp endlooplabe")) {
								outputStream.println("\t}" + loopstr);
								loop = 0;
							}
		
						}
						outputStream.println("\t}\n"); //end main
						outputStream.println("}"); //end class
						
						inputStream.close();
						outputStream.close();
						
					}catch(FileNotFoundException e){
						System.out.println("Error occured.");
					}catch(IOException e){
						System.out.println("Error occured.");
					}
					break;

		}
		
	}

}