import org.json.JSONObject;

public class Bookface {

	static DB db = new DB();
	
	static User user = null;
	
	public static void main(String[] args) {
		
		login("Jerry", "R3yUz1Q");	
//		joinGroup("Livefish");
	}
	
	public static void joinGroup(String groupName) {
		JSONObject group = db.getGroup(groupName);
		if(group == null) {
			System.out.println("Group does not exist. Please try again.");
		}
		else {
			int groupID = db.getGroupID(group);
			db.addGroup(groupID, user.getID());
		}
	}
	
	public static void login(String name, String password) {
		user = db.login(name, password);
		if(user == null)
			System.out.println("Unable to login, please try again with a correct name and password combination.");
	}
}
