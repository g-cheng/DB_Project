public class Index {

	static DB db = new DB();

	static final String queryMember = "SELECT * FROM member INNER JOIN (SELECT memberID, COUNT (memberID) "
			+ "FROM contains GROUP BY memberID) c ON (member.memberID = c.memberID) WHERE COUNT=(SELECT MAX(count) "
			+ "FROM (SELECT * FROM member INNER JOIN (SELECT memberID, COUNT (memberID) "
			+ "FROM contains GROUP BY memberID) c ON (member.memberID = c.memberID)) max)";
	
	static final String queryGroup =  "select memberid from partOf where partOf.groupid "
			+ "in (select groupid from friendgroup where name='''Linkbridge''')";
	
	public static void main(String[] args) {
		System.out.println("Query on Which members has the most friends?");
		System.out.println("	Time spend on query without the index on name: "
				+ withoutMemberNameIndex());
		System.out.println("	Time spend on query with the index on name: "
				+ withMemberNameIndex());

		System.out.println("===============================================");

		System.out.println("	Which members are part of Linkbridge group? ");
		System.out.println("	Time spend on query without the index on name: "
				+ withoutGroupNameIndex());
		 System.out.println("	Time spend on query with the index on name: "
		 + withGroupNameIndex());
	}

	public static long withoutMemberNameIndex() {
		
		long before = System.currentTimeMillis();

		db.executeSelect(queryMember);

		long after = System.currentTimeMillis();

		long difference = after - before;
		return difference;
	}

	public static long withMemberNameIndex() {
		createMemberIndex();

		long before = System.currentTimeMillis();

		db.executeSelect(queryMember);

		long after = System.currentTimeMillis();

		long difference = after - before;
		System.out.println("cleaning up by dropping the index");
		dropMemberIndex();
		return difference;
	}

	public static long withoutGroupNameIndex() {

		long before = System.currentTimeMillis();

		db.executeSelect(queryGroup);

		long after = System.currentTimeMillis();

		long difference = after - before;
		return difference;
	}

	public static long withGroupNameIndex() {
		createGroupIndex();

		long before = System.currentTimeMillis();

		db.executeSelect(queryGroup);

		long after = System.currentTimeMillis();

		long difference = after - before;
		System.out.println("cleaning up by dropping the index");
		dropGroupIndex();
		return difference;
	}

	public static void createMemberIndex() {
		String query = "Create index memberName on member(name)";
		db.createIndex(query);
	}

	public static void dropMemberIndex() {
		db.dropIndex("memberName");
	}

	public static void createGroupIndex() {
		String query = "Create index groupName on friendGroup(name)";
		db.createIndex(query);
	}

	public static void dropGroupIndex() {
		db.dropIndex("groupName");
	}

}
