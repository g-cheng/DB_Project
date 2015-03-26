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
