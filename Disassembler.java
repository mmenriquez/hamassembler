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


public class Disassembler {
	
	static BufferedReader inputStream = null;
	static PrintWriter outputStream = null;
	static String []numbers = {" "," "," "," "," "," "," "," "," "," ",};
	static int numIndex = 0;
	
	static void sysoutConverter(PrintWriter outputStream, String printStr) {
		if(printStr.contains("\"")||printStr.contains("\'")){
			for(int i = 1;i < printStr.length()-1;i++) {
				printChar(outputStream, printStr.charAt(i));
			}
			//outputStream.println("");
			//print(outputStream, "0ah");
		}else{ //pag ang printStr ay variable, e.g. number, var
			for(int i = 0; i < numbers.length; i++){//catch if value of the variable is a number
				if(numbers[i].equals(printStr)){
					StringBuilder sb = new StringBuilder(printStr);
					sb.insert(0, "str");
					printStr = sb.toString();
					break;
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
	
	static void whileConverter(PrintWriter outputStream, String loopVariable, String boolExp, int constant, ArrayList sysVar){
		String booleanExp = "";
		outputStream.println("whilelabel:");
		if(boolExp == "<"){
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jge endwhile");
			for(int i = 0;i < sysVar.size();i++) {
				sysoutConverter(outputStream, sysVar.get(i).toString());
				print(outputStream, "0ah");
			}
			outputStream.println("inc " + loopVariable); //assumed
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}else if(boolExp == "<="){
			constant++;
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jge endwhile");
			for(int i = 0;i < sysVar.size();i++) {
				sysoutConverter(outputStream, sysVar.get(i).toString());
				print(outputStream, "0ah");
			}
			outputStream.println("inc " + loopVariable); //assumed
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}else if(boolExp == ">"){
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jle endwhile");
			for(int i = 0;i < sysVar.size();i++) {
				sysoutConverter(outputStream, sysVar.get(i).toString());
				print(outputStream, "0ah");
			}
			outputStream.println("dec " + loopVariable); //assumed
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}else if(boolExp == ">="){
			constant--;
			outputStream.println("cmp " + loopVariable + ", " + constant);
			outputStream.println("jle endwhile");
			for(int i = 0;i < sysVar.size();i++) {
				sysoutConverter(outputStream, sysVar.get(i).toString());
				print(outputStream, "0ah");
			}
			outputStream.println("dec " + loopVariable); //assumed
			outputStream.println("jmp whilelabel");
			outputStream.println("endwhile:");
		}
	}
	
	static void doWhileConverter(PrintWriter outputStream, String variable, String boolExp, int constant, String sysVar){
		String booleanExp = "";
		outputStream.println("dowhilelabel:");
		if(boolExp == "<"){
			print(outputStream, "0ah");
			sysoutConverter(outputStream, sysVar);
			outputStream.println("	inc " + variable); //assumed
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jl dowhilelabel");
		}else if(boolExp == "<="){
			print(outputStream, "0ah");
			sysoutConverter(outputStream, sysVar);
			outputStream.println("	inc " + variable); //assumed
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jle dowhilelabel");
		}else if(boolExp == ">"){
			print(outputStream, "0ah");
			sysoutConverter(outputStream, sysVar);
			outputStream.println("	dec " + variable); //assumed
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jg endwhile");
		}else if(boolExp == ">="){
			print(outputStream, "0ah");
			sysoutConverter(outputStream, sysVar);
			outputStream.println("	dec " + variable); //assumed
			outputStream.println("	cmp " + variable + ", " + constant);
			outputStream.println("	jge endwhile");
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
	public static void main(String[] args) throws IOException {
		BufferedReader inputStream = null;
		PrintWriter outputStream = null;
		
		String asmFileName = null;
		int errClass = 1;
		int errMain = 1;
		int sysMode = 1;
		int ieMode = 1;
		
		Scanner scanner = new Scanner(System.in);
		System.out.println("File to open: ");
		String file_name = scanner.next();
		
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
					//INSERT IF HERE
					else if(line.contains("if")) {
						ieMode = 0;
						String sysVar = "";
						sysMode = 0;
						int start = line.indexOf('(');
						int end = line.indexOf(')');
						String condition = line.substring(start+1, end);
						//doIf(outputStream, condition);
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
						outputStream.println("jmp else_block");
						outputStream.println("if_block:");
						while((line=inputStream.readLine())!=null){
							if(line.contains("System.out.println")){
								sysVar = line.substring(line.indexOf('(')+1, line.indexOf(')'));
								sysoutConverter(outputStream, sysVar);
								print(outputStream, "0ah");
							}
							if(line.contains("}"))
								break;
						}
						outputStream.println("jmp exit");
	
					}
					else if(line.contains("else") && ieMode == 0) {
						String sysVar = "";
						sysMode = 0;
						outputStream.println("else_block:");
						while((line=inputStream.readLine())!=null){
							if(line.contains("System.out.println")){
								sysVar = line.substring(line.indexOf('(')+1, line.indexOf(')'));
								sysoutConverter(outputStream, sysVar);
								print(outputStream, "0ah");
							}
						}
					}
					
					//WHILE
					else if(line.contains("while")&&!doLoop){
						sysMode = 0;
						int startOfLoopVar = 0;
						int endOfVarLoop = 0;
						int constant = 0;
						String loopVariable = "";
						String boolExp = "";
						ArrayList<String> sysVar = new ArrayList<String>();
						
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
							}
						}
	
						whileConverter(outputStream, loopVariable, boolExp, constant, sysVar);
					}
					//FOR
					else if(line.contains("for")){
						sysMode = 0;
						int startOfLoopVar = 0;
						int endOfLoopVar = 0;
						int constant = 0;
						String loopVariable = "";
						String boolExp = "";
						ArrayList<String> sysVar = new ArrayList<String>();
						
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
							}
						}
	
						whileConverter(outputStream, loopVariable, boolExp, constant, sysVar);
					}
					//DO-WHILE
					else if(line.contains("do")){
						doLoop = true;
						sysMode = 0;
						
						int startOfLoopVar = 0;
						int endOfLoopVar = 0;
						int constant = 0;
						String loopVariable = "";
						String boolExp = "";
						String sysVar = "";
						
						while((line=inputStream.readLine())!=null){
							if(line.contains("System.out.println")){
								sysVar = line.substring(line.indexOf('(')+1, line.indexOf(')'));
								//break;
							}
						}
						while((line=inputStream.readLine())!=null){
							if(line.contains("while")&&doLoop){
								startOfLoopVar = line.charAt(line.indexOf('(')+1);

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

							}
						}
						
						doWhileConverter(outputStream, loopVariable, boolExp, constant, sysVar);
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
	}

}