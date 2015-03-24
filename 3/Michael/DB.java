import java.sql.*; // for standard JDBC programs
import java.util.Properties;

public class DB {

	private String url = "jdbc:postgresql://localhost/deliverable3";
	private String username = "group46";
	private String password = "root";
	private Connection c = null;

	public DB() {
		this.c = getConnection();
	}

	private Connection connect() {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException cnfe) {
			System.out.println("Could not find the JDBC driver!");
			System.exit(1);
		}
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url, username, password);
			System.out.println("Successfully Connected to Database.");
		} catch (SQLException sqle) {
			System.out.println("Could not connect");
			System.exit(1);
		}
		return conn;
	}

	private Connection getConnection() {
		if (c == null) {
			this.c = connect();
		}
		return c;
	}

	private ResultSet query(String query) {
	    // System.out.println(query);
	    Statement stmt = null;
    	ResultSet rs = null;
    	int rowCount = 0;
		try {
	      stmt = this.c.createStatement();
	      rs = stmt.executeQuery(query);
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	    return rs;
	}

	private int findLargestId(String table, String idHeader) {
		ResultSet result = query("SELECT memberid FROM member WHERE memberid = (SELECT MAX(memberid) FROM member)");
		int largestId = null;

		return largestId;	
	}

	private boolean checkMemberExist(String memberName) {
		ResultSet result = query("SELECT COUNT(*) FROM member WHERE name=" + "'" + memberName + "'");
		int rowCount = 0;
		try {
			// get the number of rows from the result set
		    result.next();
			rowCount = result.getInt(1);
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    }
		if (rowCount > 0) return true;
	    return false;
	}

	private boolean checkMemberExist(int memberId) {
	    Statement stmt = null;
    	ResultSet rs = null;
    	int rowCount = 0;
		try {
			stmt = this.c.createStatement();
			rs = stmt.executeQuery("SELECT COUNT(*) FROM member WHERE memberid=" + Integer.toString(memberId));
			// get the number of rows from the result set
			rs.next();
			rowCount = rs.getInt(1);
	    } catch (SQLException e) {
			e.printStackTrace();
	    }
	   	if (rowCount > 0) return true;
	    return false;
	}

	private void registerMember(String memberName, String email, String memberPassword) {
		// Check if member already exists
		if (checkMemberExist(memberName)) {
			System.out.println("Error, your name already exists in the database, please use a different name");
			return;	
		}
		String query = "";

		System.out.println("Member, you have been registered successfully, you can now login, welcome to bookface!");	
	}

	public void addFriend(String memberName, String friendAddedName) {
		System.out.println("Error, member not found");
		System.out.println("Friend successfully added to your friendlist");
	}

	public void removeFriend(String memberName, String friendRemovedName) {
		System.out.println("Error, friend is not on your friendlist");
		System.out.println("Friend successfully removed from your friendlist");
	}

	public void sendMessage(String memberName, String destinationMemberName, String message) {
		System.out.println("Error, destination member name does not exists");
		System.out.println("Message successfully sent to member");
	}

	public void showFriendList(String memberName) {

	}

	public static void main(String[] args) {
		DB myDB = new DB();
		myDB.registerMember("Kevin", "kevin@gmail.com", "blablabla");
	}
}