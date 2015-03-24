
public class User {

	private int memberID;
	private String name;
	private String email;
	
	public User(int memberID, String name, String email) {
		this.memberID = memberID;
		this.name = name;
		this.email = email;
	}
	
	public int getID() {
		return this.memberID;
	}
	
	public String getName() {
		return this.name;
	}
	
	public String getEmail() {
		return this.email;
	}
}
