import java.sql.* ;  // for standard JDBC programs

Class.forName("org.postgresql.Driver");

public void connectToAndQueryDatabase(String username, String password) {

	String url = "jdbc:postgresql://localhost/test";
	Properties props = new Properties();
	props.setProperty("user","fred");
	props.setProperty("password","secret");
	props.setProperty("ssl","true");
	Connection conn = DriverManager.getConnection(url, props);
	String url = "jdbc:postgresql://localhost/test?user=fred&password=secret&ssl=true";
	Connection conn = DriverManager.getConnection(url);

}
