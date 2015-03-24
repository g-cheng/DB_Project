import java.sql.*; // for standard JDBC programs
import java.util.Properties;

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

	public void executeSelect(String query) {
		Statement stmt = null;
		try {
			stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			stmt.close();
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}
	}
	
	public void createIndex(String index) {
		Statement stmt = null;
		try {
			System.out.println("Executing: " + index);
			stmt = c.createStatement();
			stmt.executeUpdate(index);
			System.out.println("Index is successfully created.");
			stmt.close();
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}
	}
	
	public void dropIndex(String indexName) {
		Statement stmt = null;
		String toExecute = "drop index " + indexName;
		
		try {
			System.out.println("Executing: " + toExecute);
			stmt = c.createStatement();
			stmt.executeUpdate(toExecute);
			System.out.println("Index is successfully dropped.");
			stmt.close();
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}
		
	}
}
