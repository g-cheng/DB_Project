import java.sql.*; // for standard JDBC programs
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;

import com.bethecoder.ascii_table.impl.CollectionASCIITableAware;
import com.bethecoder.ascii_table.impl.JDBCASCIITableAware;
import com.bethecoder.ascii_table.spec.IASCIITableAware;
import com.bethecoder.ascii_table.ASCIITable;
import com.bethecoder.ascii_table.ASCIITableHeader;

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

	public void closeConnection() {
		try {
			c.close();
		} catch (SQLException e) {
			errorPrinting(e);
		}
	}

	public User login(String name, String password) {
		String query = "Select * From Member where name='" + name + "'"
				+ "AND password='" + password + "'";
		JSONArray result = executeSelectSql(query);
		User currentUser = null;
		if (result.length() > 0) {
			try {
				JSONObject entry = result.getJSONObject(0);
				int memberID = entry.getInt("memberid");
				String email = entry.getString("email");
				currentUser = new User(memberID, name, email);
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		return currentUser;
	}

	public JSONObject getGroup(String groupName) {
		JSONObject result = null;
		String query = "Select * from friendgroup where name='''" + groupName
				+ "'''";
		JSONArray entries = executeSelectSql(query);
		try {
			if (entries.length() > 0)
				result = entries.getJSONObject(0);
		} catch (JSONException e) {
			errorPrinting(e);
		}
		return result;
	}

	public int getGroupID(JSONObject groupEntry) {
		int groupID = -1;
		try {
			groupID = groupEntry.getInt("groupid");
		} catch (JSONException e) {
			errorPrinting(e);
		}
		return groupID;
	}

	public void addGroup(int groupID, int memberID) {
		String query = "Insert into partof (groupid, memberid) values ("
				+ groupID + "," + memberID + ")";
		System.out.println(query);
		executeInsertSql(query);
	}

	// Michael ==========================================>

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

	public boolean checkMemberExist(String memberName) {
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

	public boolean checkMemberExist(int memberId) {
		JSONArray result = executeSelectSql("SELECT COUNT(*) FROM member WHERE memberid=" + "'" + memberId + "'");
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

	private JSONArray getMsgSentList(int memberid) {
		JSONArray result = executeSelectSql("SELECT mem.name, mem.email, m.memberid, m.messageid, m.content, m.sentat FROM member mem INNER JOIN (SELECT rcv.memberid, msg.messageid, msg.content, msg.sentat FROM receive rcv INNER JOIN (SELECT messageid, content, sentat, senderid FROM message WHERE senderid=" + memberid + ") msg ON msg.messageid = rcv.messageid) m ON m.memberid=mem.memberid");
		return result;
	}

	private JSONArray getMsgReceivedList(int memberid) {
		JSONArray result = executeSelectSql("SELECT f.name, l.senderid, l.memberid, l.messageid, l.content, l.sentat, l.receivedat FROM member f INNER JOIN (SELECT m.messageid, r.memberid, m.senderid, m.content, m.sentat, m.receivedat FROM message m INNER JOIN (SELECT * FROM receive WHERE memberid=" + memberid + ") r ON m.messageid=r.messageid) l ON l.senderid=f.memberid;");
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

	private int createCircle() {
		int newId = getLargestId("circle", "circleid") + 1;
		executeInsertSql("INSERT INTO circle (circleID) VALUES ("+ newId+");");
		return newId;
	}

	private void createUserFriendList(int memberid) {
		int circleId = createCircle();
		int newId = getLargestId("friendlist", "friendlistid") + 1;
		executeInsertSql("INSERT INTO friendlist (circleID, friendListID, memberID) VALUES(" + circleId +"," + newId +"," +memberid+");");
	}

	public void registerMember(String memberName, String email, String password) {
		// Check if member already exists
		if (checkMemberExist(memberName)) {
			System.out.println("\n>.< Error, your name already exists in the database, please use a different name");
			return;	
		}
		int newId = getLargestId("member", "memberid") + 1;
		executeInsertSql("INSERT INTO member (memberID, name, email, password) VALUES (" + String.valueOf(newId) + ", '" + memberName + "', '" + email + "', '" + password + "')");
		createUserFriendList(newId);
		System.out.println("\n:D Success, " + memberName + " have been registered. Welcome to Bookface! You can now login");	
	}

	public void addFriend(int memberid, String memberName, String friendName) {
		// Check if memberName and friendName exists
		if (!checkMemberExist(memberid)) {
			System.out.println("\n>.< Error, " + memberName + " does not exist in the database");
			return;	
		} else if (!checkMemberExist(friendName)) {
			System.out.println("\n>.< Error, " + friendName + " does not exist in the database");
			return;	
		} else if (checkInFriendList(memberid, friendName)) {
			System.out.println("\n>.< Error, " + friendName + " is already in your friendlist!");
			return;
		}
		// Add to friendlist
		int friendId = getMemberId(friendName);
		int friendListId = getFriendListId(memberid);
		executeInsertSql("INSERT INTO contains (friendListID, memberID) VALUES (" + friendListId + ", " + friendId + ")");
		System.out.println("\n:D Success, " + friendName + " added to your friendlist");
	}

	public void removeFriend(int memberid, String memberName, String friendName) {
		// Check if memberName and friendName exists
		if (!checkMemberExist(memberid)) {
			System.out.println("\n>.< Error, " + memberName + " does not exist in the database");
			return;	
		} else if (!checkMemberExist(friendName)) {
			System.out.println("\n>.< Error, " + friendName + " does not exist in the database");
			return;	
		} else if (!checkInFriendList(memberid, friendName)) {
			System.out.println("\n>.< Error, " + friendName + " is not in your friendlist");
			return;
		}
		// Remove from friendlist
		int friendId = getMemberId(friendName);
		int friendListId = getFriendListId(memberid);
		executeInsertSql("DELETE FROM contains WHERE memberid=" + friendId + " AND friendlistid=" + friendListId); // ORDER MATTERS ?!!?!?
		System.out.println("\n:D Success, " + friendName + " successfully removed from your friendlist");
	}

	public void sendMessage(int memberid, String memberName, String destName, String message) {
		// Check if memberName and destName exists
		if (!checkMemberExist(memberid)) {
			System.out.println("\n>.< Error, " + memberName + " does not exist in the database");
			return;	
		} else if (!checkMemberExist(destName)) {
			System.out.println("\n>.< Error, " + destName + " does not exist in the database");
			return;	
		} 
		int destId = getMemberId(destName);
		int newMsgId = getLargestId("message", "messageid") + 1;
		executeInsertSql("INSERT INTO message (messageID, senderID, content) VALUES (" + newMsgId + ", " + memberid + ", '"+ message +"')");
		executeInsertSql("INSERT INTO receive (messageID, memberID) VALUES (" + newMsgId + ", " + destId + ")");
		System.out.println("\n:D Success, message sent to " + destName);
	}

	public void showFriendList(int memberid) {
		JSONArray result = getFriendList(memberid);
		if (result.length() == 0) {
			System.out.println("\n>.< Error, you have no friends yet");
			return;
		}
		ASCIITableHeader[] header = {
    		new ASCIITableHeader("ID", ASCIITable.ALIGN_LEFT),
    		new ASCIITableHeader("Name", ASCIITable.ALIGN_LEFT)
	    };
		String[][] table = new String[result.length()][];
		for (int i = 0; i < result.length(); i++) {
			try {
				int friendid = result.getJSONObject(i).getInt("memberid");
				String name = result.getJSONObject(i).getString("name");
				table[i] = new String[] { Integer.toString(friendid), name };		
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		ASCIITable.getInstance().printTable(header, table);
	}

	public void showMsgSent(int memberid) {
		JSONArray result = getMsgSentList(memberid);
		if (result.length() == 0) {
			System.out.println("\n>.< Error, you have not sent any messages yet");
			return;
		}
	    ASCIITableHeader[] header = {
	    		new ASCIITableHeader("To", ASCIITable.ALIGN_LEFT),
	    		// new ASCIITableHeader("E-mail", ASCIITable.ALIGN_LEFT),
	    		new ASCIITableHeader("Content", ASCIITable.ALIGN_LEFT),
	    		new ASCIITableHeader("Sent at", ASCIITable.ALIGN_LEFT)
	    };
		String[][] table = new String[result.length()][];
		for (int i = 0; i < result.length(); i++) {
			try {
				String name = result.getJSONObject(i).getString("name");
				// String email = result.getJSONObject(i).getString("email");
				String sentat = result.getJSONObject(i).get("sentat").toString();
				String content = result.getJSONObject(i).getString("content");
				table[i] = new String[] { name, content, sentat };
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		ASCIITable.getInstance().printTable(header, table);
	}

	public void showMsgReceived(int memberid) {
		JSONArray result = getMsgReceivedList(memberid);
		if (result.length() == 0) {
			System.out.println("\n>.< Error, you have not received any messages yet");
			return;
		}
	    ASCIITableHeader[] header = {
	    		new ASCIITableHeader("From", ASCIITable.ALIGN_LEFT),
	    		new ASCIITableHeader("Content", ASCIITable.ALIGN_LEFT),
	    		new ASCIITableHeader("Received at", ASCIITable.ALIGN_LEFT)
	    };
		String[][] table = new String[result.length()][];
		for (int i = 0; i < result.length(); i++) {
			try {
				String name = result.getJSONObject(i).getString("name");
				String receivedat = result.getJSONObject(i).get("receivedat").toString();
				String content = result.getJSONObject(i).getString("content");
				table[i] = new String[] { name, content, receivedat };
			} catch (JSONException e) {
				errorPrinting(e);
			}
		}
		ASCIITable.getInstance().printTable(header, table);
	}

	// <==========================================

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
	
	public void errorPrinting(Exception e) {
		System.err.println(e.getClass().getName() + ": " + e.getMessage());
		System.exit(0);
	}
}
