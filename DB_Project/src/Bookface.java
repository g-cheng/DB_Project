
public class Bookface {

	static DB db = new DB();
	
	static User user = null;
	
	public static void main(String[] args) {
		
		user = db.login("Jerry", "R3yUz1Q");
		
			
	}
}
