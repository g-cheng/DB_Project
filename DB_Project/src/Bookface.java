
public class Bookface {

	static DB db = new DB();
	
	static User user = null;
	
	public static void main(String[] args) {
		
		user = db.login("Jerry", "R3yUz1Q");
		
		if(user == null)
			System.out.println("Unable to login, please try again with a correct name and password combination.");
		
			
	}
}
