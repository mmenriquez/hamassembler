import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

public class Disassembler2 {
	
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
		
		
		Scanner scanner = new Scanner(System.in);
		System.out.println("File to open: ");
		String file_name = scanner.next();
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
				if(line.contains("iflabel:")) {
					ifelse = 1;
				}
				if(line.contains("jmp endiflabe")) {
					outputStream.println("\t}");
					ifelse = 0;
				} //end if
				if(ifelse == 1) {
					printOutputs(outputStream, line);
				}
				if(line.contains("elselabel:") && elsetemp == 1) {
					outputStream.println("\telse {");
					printOutputs(outputStream, line);
					elsetemp = -1;
				}
				if(line.contains("jmp endelselabe")) {
					outputStream.println("\t}");
					elsetemp = 0;
				}
				
				//LOOP
				if(line.contains("looplabel:")) {
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
	}

}