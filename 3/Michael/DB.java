import java.sql.*; // for standard JDBC programs
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class DB {

	private String url = "jdbc:postgresql://localhost/project";
	private String username = "postgres";
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

	public JSONArray executeSelectSql(String sql) {
		Statement stmt = null;
		ResultSet rs = null;
		JSONArray result = new JSONArray();
		try {
			stmt = c.createStatement();
			rs = stmt.executeQuery(sql);
			result = convert(rs);
			stmt.close();
		} catch (Exception e) {
			errorPrinting(e);
		}
		return result;
	}

	public void executeInsertSql(String sql) {
		Statement stmt = null;
		try {
			stmt = c.createStatement();
			stmt.executeUpdate(sql);
			stmt.close();
		} catch (Exception e) {
			errorPrinting(e);
		}
	}

	private JSONArray convert(ResultSet rs) throws SQLException, JSONException {
		JSONArray json = new JSONArray();
		ResultSetMetaData rsmd = rs.getMetaData();

		while (rs.next()) {
			int numColumns = rsmd.getColumnCount();
			JSONObject obj = new JSONObject();

			for (int i = 1; i < numColumns + 1; i++) {
				String column_name = rsmd.getColumnName(i);

				if (rsmd.getColumnType(i) == java.sql.Types.ARRAY) {
					obj.put(column_name, rs.getArray(column_name));
				} else if (rsmd.getColumnType(i) == java.sql.Types.BOOLEAN) {
					obj.put(column_name, rs.getBoolean(column_name));
				} else if (rsmd.getColumnType(i) == java.sql.Types.DOUBLE) {
					obj.put(column_name, rs.getDouble(column_name));
				} else if (rsmd.getColumnType(i) == java.sql.Types.FLOAT) {
					obj.put(column_name, rs.getFloat(column_name));
				} else if (rsmd.getColumnType(i) == java.sql.Types.INTEGER) {
					obj.put(column_name, rs.getInt(column_name));
				} else if (rsmd.getColumnType(i) == java.sql.Types.VARCHAR) {
					obj.put(column_name, rs.getString(column_name));
				} else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
					obj.put(column_name, rs.getDate(column_name));
				} else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
					obj.put(column_name, rs.getTimestamp(column_name));
				} else {
					obj.put(column_name, rs.getObject(column_name));
				}
			}
			json.put(obj);
		}
		return json;
	}
	
	private void errorPrinting(Exception e) {
		System.err.println(e.getClass().getName() + ": " + e.getMessage());
		System.exit(0);
	}

	private int getLargestId(String table, String primaryIdHeader) {
		JSONArray result = executeSelectSql("SELECT " + primaryIdHeader + " FROM " + table + " WHERE " + primaryIdHeader + " = (SELECT MAX(" + primaryIdHeader + ") FROM " + table + ")");
		int largestId = 1;
		if (result.length() > 0) {
			try {
				largestId = result.getJSONObject(0).getInt(primaryIdHeader);
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		return largestId;	
	}

	private boolean checkMemberExist(String memberName) {
		JSONArray result = executeSelectSql("SELECT COUNT(*) FROM member WHERE name=" + "'" + memberName + "'");
		if (result.length() > 0) {
			for (int i = 0; i < result.length(); i++) {
				try {
					int count = result.getJSONObject(0).getInt("count");
					if (count > 0) return true;
				} catch (JSONException e) {
					errorPrinting(e);
				}
			}
		}
	    return false;
	}

	private boolean checkMemberExist(int memberId) {
		JSONArray result = executeSelectSql("SELECT COUNT(*) FROM member WHERE name=" + "'" + memberId + "'");
		if (result.length() > 0) {
			for (int i = 0; i < result.length(); i++) {
				try {
					int count = result.getJSONObject(0).getInt("count");
					if (count > 0) return true;
				} catch (JSONException e) {
					errorPrinting(e);
				}
			}
		}
	    return false;
	}

	private boolean checkInFriendList(int memberid, String friendName) {
		JSONArray friendList = getFriendList(memberid);
		for (int i = 0; i < friendList.length(); i++) {
			try {
				String friendListName = friendList.getJSONObject(i).getString("name");
				if (friendName.equals(friendListName)) return true;
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		return false;
	}

	private JSONArray getFriendList(int memberid) {
		JSONArray result = executeSelectSql("SELECT m.memberid, m.name FROM member m INNER JOIN (SELECT memberid FROM contains WHERE friendlistid = (SELECT friendlistid FROM friendlist WHERE memberid = " + memberid + ")) f ON m.memberid = f.memberid;");
		return result;
	}

	private int getMemberId(String memberName) {
		JSONArray result = executeSelectSql("SELECT memberid FROM member WHERE name = '" + memberName + "'");
		if (result.length() > 0) {
			try {
				return result.getJSONObject(0).getInt("memberid");
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		return 0;
	}

	private int getFriendListId(int memberid) {
		JSONArray result = executeSelectSql("SELECT friendlistid FROM friendlist WHERE memberid = " + memberid);
		if (result.length() > 0) {
			try {
				return result.getJSONObject(0).getInt("friendlistid");
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		return 0;
	}

	public void registerMember(String memberName, String email, String password) {
		// Check if member already exists
		if (checkMemberExist(memberName)) {
			System.out.println("Error, your name already exists in the database, please use a different name");
			return;	
		}
		int newId = getLargestId("member", "memberid") + 1;
		executeInsertSql("INSERT INTO member (memberID, name, email, password) VALUES (" + String.valueOf(newId) + ", '" + memberName + "', '" + email + "', '" + password + "')");
		System.out.println("Success, " + memberName + " have been registered, you can now login, welcome to Bookface!");	
	}

	public void addFriend(int memberid, String memberName, String friendName) {
		// Check if memberName and friendName exists
		if (!checkMemberExist(memberName)) {
			System.out.println("Error, " + memberName + " does not exist in the database");
			return;	
		} else if (!checkMemberExist(friendName)) {
			System.out.println("Error, " + friendName + " does not exist in the database");
			return;	
		} else if (checkInFriendList(memberid, friendName)) {
			System.out.println("Error, " + friendName + " is already in your friendlist!");
			return;
		}
		// Add to friendlist
		int friendId = getMemberId(friendName);
		int friendListId = getFriendListId(friendId);
		db.executeInsertSql("INSERT INTO contains (friendListID, memberID) VALUES (" + Integer.toString(friendListId) + ", " + Integer.toString(friendId) + ")");
		System.out.println(friendName + " successfully added to your friendlist");
	}

	public void removeFriend(int memberid, String memberName, String friendName) {
		// Check if memberName and friendName exists
		if (!checkMemberExist(memberName)) {
			System.out.println("Error, " + memberName + " does not exist in the database");
			return;	
		} else if (!checkMemberExist(friendName)) {
			System.out.println("Error, " + friendName + " does not exist in the database");
			return;	
		} else if (!checkInFriendList(memberid, friendName)) {
			System.out.println("Error, " + friendName + " is not in your friendlist");
			return;
		}
		// Remove from friendlist
		int friendId = getMemberId(friendName);


		System.out.println("Success, " + friendName + " successfully removed from your friendlist");
	}

	public void sendMessage(int memberid, String memberName, String destinationMemberName, String message) {
		System.out.println("Error, destination member name does not exists");
		System.out.println("Success, message sent to " + destinationMemberName);
	}

	public void showFriendList(int memberid) {
		JSONArray result = getFriendList(memberid);
		System.out.println("ID | " + "name");		
		for (int i = 0; i < result.length(); i++) {
			try {
				int friendid = result.getJSONObject(i).getInt("memberid");
				String name = result.getJSONObject(i).getString("name");
				System.out.println(friendid + " " + name);			
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
	}

	public static void main(String[] args) {
		DB db = new DB();
		db.showFriendList(44);
	}
}
