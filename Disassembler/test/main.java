
public class main {

	/**
	 * @param args
	 */
	static int num = 0;
	static int number = 0;
	
	public static void main(String[] args) {
		System.out.println("before clause");
		while(num < 7){
			System.out.println(num);
			num++;
		}
		do{
			 System.out.println(num);
			 num--;
			 number += 2;
			 System.out.println(number);
		}while(num > 3);
		if(num < 8){
			System.out.println("ifelse");
			num += 2;
			System.out.println(num);
		}
		else{
			System.out.println(num);
		}
		System.out.println("after clause");
	}

}
