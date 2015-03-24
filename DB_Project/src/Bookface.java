
public class Bookface {

	static DB db = new DB();
	
	static User user = null;
	
	public static void main(String[] args) {
		
		user = db.login("Joshua", "DMe2t7eyL");
		
		if (user == null) {
			System.out.println("Unable to login, please try again with a correct name and password combination");
		} else {
			System.out.println("Login successful! Welcome back " + user.getName());
		}
		
	}
}
