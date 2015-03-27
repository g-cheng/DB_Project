import java.util.Scanner;
import java.util.Properties;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Bookface {

	static DB db = new DB();
	static User user = null;

	// connects user with user name and password
	// returns true if successful, false if not
	private static boolean isUserConnected() {
		return (user != null) ? true : false;
	}

	// keeps on asking user for input until user inputs an int
	private static int promptUserChoice(String promptMessage) {
		while (true) {
			System.out.print(promptMessage);
			Scanner userIn = new Scanner(System.in);
			int userChoice;
			try {
				userChoice = Integer.parseInt(userIn.next());
			} catch (Exception e) {
				System.out
						.println("Choice entered not a number, please try again");
				System.out.println("______________________________________");
				continue;
			}
			return userChoice;
		}
	}

	private static String promptUserInput(String promptMessage) {
		System.out.print(promptMessage);
		Scanner userIn = new Scanner(System.in);
		String userInput = null;
		try {
			userInput = userIn.next();
		} catch (Exception e) {
			db.errorPrinting(e);
		}
		return userInput;
	}

	// validate menu choice (has to be between 1 and 8)
	private static boolean isValidMenuChoice(int choice) {
		if (choice > 11 || choice < 1)
			return false;
		return true;
	}

	// input:
	// - name of table you want to insert into
	// - name of primary key
	// output:
	// - returns (the maximum ID that exist in the table currently incremented
	// by 1)
	private static int generateUniqueID(String tableName, String pkName) {
		int uniqueID = -1;
		try {
			uniqueID = db
					.executeSelectSql(
							"select " + pkName + " from " + tableName
									+ " where " + pkName + "=(select max("
									+ pkName + ") from " + tableName + ")")
					.getJSONObject(0).getInt(pkName) + 1;
		} catch (JSONException e) {
			db.errorPrinting(e);
		} finally {
			return uniqueID;
		}
	}

	// checks if the id choosen can be found inside the jsonarray under
	// attribute pkName
	private static boolean isValidIdChoice(JSONArray arr, int id, String pkName) {
		boolean result = false;
		for (int i = 0; i < arr.length(); i++) {
			try {
				if (arr.getJSONObject(i).getInt(pkName) == id) {
					result = true;
				}
			} catch (JSONException e) {
				db.errorPrinting(e);
			}
		}
		return result;
	}

	private static void displayChoiceMessage(String msg) {
		System.out
				.println("=======================================================================");
		System.out.println(msg);
	}

	// prints out each row of the array and strips out the useless info
	private static JSONArray stripAndPrintAttributes(JSONArray inputArray,
			String pkName, String additionalMessage) {
		JSONArray outputArray = new JSONArray();
		for (int i = 0; i < inputArray.length(); i++) {
			try {
				System.out.println(pkName + "="
						+ inputArray.getJSONObject(i).getInt(pkName) + "\t"
						+ additionalMessage);
				JSONObject obj = new JSONObject();
				obj.put(pkName, inputArray.getJSONObject(i).getInt(pkName));
				outputArray.put(obj);
			} catch (JSONException e) {
				db.errorPrinting(e);
			}
		}
		return outputArray;
	}

	// ask for user to input a valid id choice until the inputed choice is
	// valid, i.e it exists in the jsonarray
	private static int getIdChoice(JSONArray inputArray, String pkName) {
		int chosenID;
		chosenID = promptUserChoice("enter " + pkName + ":");
		while (!isValidIdChoice(inputArray, chosenID, pkName)) {
			System.out.println("invalid " + pkName + " choice, try again:");
			chosenID = promptUserChoice("enter " + pkName + ":");
		}
		return chosenID;
	}

	// concatenates 2 JSON arrays
	private static JSONArray concatJSONArrays(JSONArray a1, JSONArray a2) {
		try {
			for (int i = 0; i < a1.length(); i++) {
				a2.put(a1.getJSONObject(i));
			}
		} catch (JSONException e) {
			db.errorPrinting(e);
		}
		return a2;
	}

	// LOGIN
	public static void choice1() {
		String username = promptUserInput("Username: ");
		String password = promptUserInput("Password: ");
		user = db.login(username, password);
		// user = db.login("George", "fkQWGTswL");
		if (user == null) {
			System.out.println("\n>.< Error, unable to login, please try again with a correct name and password combination");
		} else {
			System.out.println("\n:D Login successful! Welcome " + user.getName());
		}
	}

	// REGISTER
	public static void choice2() {
		String username = promptUserInput("Enter username: ");
		String email = promptUserInput("Enter email: ");
		String password = promptUserInput("Enter password: ");
		String password2 = promptUserInput("Enter password again: ");
		if (db.checkMemberExist(username)) {
			System.out.println("\n>.< Error, username already taken");
			return;
		} else if (!password.equals(password2)) {
			System.out.println("\n>.< Error, password does not match");
			return;
		}
		db.registerMember(username, email, password);
	}

	// POST
	public static void choice3() {
		int serviceID;
		int postID;
		int circleID;
		int memberID;

		// choose a
		// member-----------------------------------------------------------------
		displayChoiceMessage("Choose a member with content available to post from the list: ");
		String sql = ("SELECT DISTINCT memberID FROM (SELECT memberID FROM idea union SELECT memberID FROM picture union SELECT memberID from event union SELECT memberID from video) as res1;");
		JSONArray membersWithContent = db.executeSelectSql(sql);
		membersWithContent = stripAndPrintAttributes(membersWithContent,
				"memberid", "");
		memberID = getIdChoice(membersWithContent, "memberid");

		// choose a
		// service-----------------------------------------------------------------

		displayChoiceMessage("Choose a service to post: ");
		sql = ("SELECT serviceID FROM idea WHERE memberID=" + memberID + ";");
		JSONArray availableIdeas = db.executeSelectSql(sql);
		availableIdeas = stripAndPrintAttributes(availableIdeas, "serviceid",
				"\t type=idea");
		sql = ("SELECT serviceID FROM picture WHERE memberID=" + memberID + ";");
		JSONArray availablePictures = db.executeSelectSql(sql);
		availablePictures = stripAndPrintAttributes(availablePictures,
				"serviceid", "\t type = picture");
		sql = ("SELECT serviceID FROM event WHERE memberID=" + memberID + ";");
		JSONArray availableEvents = db.executeSelectSql(sql);
		availableEvents = stripAndPrintAttributes(availableEvents, "serviceid",
				"\t type=event");
		sql = ("SELECT serviceID FROM video WHERE memberID=" + memberID + ";");
		JSONArray availableVideos = db.executeSelectSql(sql);
		availableVideos = stripAndPrintAttributes(availableVideos, "serviceid",
				"\t type=video");

		// concatenate all 4 JSON Arrays
		JSONArray accArray = new JSONArray();
		accArray = concatJSONArrays(availableIdeas, availablePictures);
		accArray = concatJSONArrays(accArray, availableEvents);
		accArray = concatJSONArrays(accArray, availableVideos);

		// get serviceID from user
		serviceID = getIdChoice(accArray, "serviceid");

		// choose a circle
		// ------------------------------------------------------------------------------------
		displayChoiceMessage("Choose a circle to post into: ");
		sql = ("select * FROM friendgroup INNER JOIN partof ON friendgroup.groupID = partof.groupID WHERE memberID=" + memberID);
		JSONArray availableGroups = db.executeSelectSql(sql);
		availableGroups = stripAndPrintAttributes(availableGroups, "circleid",
				"\t type=group");
		sql = ("SELECT circleID FROM friendlist where memberID=" + memberID);
		JSONArray availableLists = db.executeSelectSql(sql);
		availableLists = stripAndPrintAttributes(availableLists, "circleid",
				"\t type=friendlist");

		// concatenate all 2 json arrays
		accArray = new JSONArray();
		accArray = concatJSONArrays(availableGroups, availableLists);

		// get circleID from user
		circleID = getIdChoice(accArray, "circleid");

		// get postID-----------------------------------------------------------
		postID = generateUniqueID("post", "postid");

		// make post
		// ------------------------------------------------------------
		sql = ("INSERT INTO POST (postid, circleid, memberid, serviceid) VALUES("
				+ postID + "," + circleID + "," + memberID + "," + serviceID + ");");
		db.executeInsertSql(sql);

		System.out
				.println("\n++++++++++++++++++++++++\npost added successfully\n++++++++++++++++++++++++");
	}

	// MESSAGE
	public static void choice4() {
		String destName = promptUserInput("Enter destination username: ");
		String message = promptUserInput("Enter message content: ");
		db.sendMessage(user.getID(), user.getName(), destName, message);
	}

	// JOIN GROUP
	public static void choice5() {
		String groupName = promptUserInput("Please enter the group name: ");
		JSONObject group = db.getGroup(groupName);
		if (group == null) {
			System.out.println("Group cannot be found. Please try again.");
			choice5();
		} else {
			int groupID = db.getGroupID(group);
			int memberID = user.getID();
			db.addGroup(groupID, memberID);
			System.out
					.println("\n++++++++++++++++++++++++\ngroup added successfully\n++++++++++++++++++++++++");
		}
	}

	// LIST FRIENDS
	public static void choice6() {
		db.showFriendList(user.getID());
	}

	// ADD FRIEND
	public static void choice7() {
		String friendName = promptUserInput("Enter username of friend to add: ");
		db.addFriend(user.getID(), user.getName(), friendName);
	}

	// REMOVE FRIEND
	public static void choice8() {
		String friendName = promptUserInput("Enter username of friend to remove: ");
		db.removeFriend(user.getID(), user.getName(), friendName);
	}

	// SHOW ALL MESSAGES SENT
	public static void choice9() {
		db.showMsgSent(user.getID());
	}

	// SHOW ALL MESSAGES RECEIVED
	public static void choice10() {
		db.showMsgReceived(user.getID());
	}

	private static void displayMenu() {
		System.out.println("Welcome to the BookFace native app!");
		System.out.println("1. LOGIN");
		System.out.println("2. REGISTER");
		System.out
				.println("3. POST an existant IDEA, PICTURE, VIDEO or EVENT created by a member to one of his/her circles");
		System.out.println("4. MESSAGE another member");
		System.out.println("5. JOIN a group");
		System.out.println("6. LIST my friends");
		System.out.println("7. ADD a friend");
		System.out.println("8. REMOVE a friend");
		System.out.println("9. SHOW all messages sent");
		System.out.println("10. SHOW all messages received");
		System.out.println("11. EXIT");
	}

	private static void startInterface() {
		while (true) {
			Bookface.displayMenu();
			int userChoice;
			userChoice = Bookface.promptUserChoice("Enter choice number: ");
			System.out.println("______________________________________\n\n");
			if (!isValidMenuChoice(userChoice)) {
				System.out.println("Choice is invalid, please try again\n");
				System.out.println("______________________________________");
				continue;
			} else if (userChoice == 11) {
				db.closeConnection();
				System.out.println("Bye!");
				break;
			} else if (userChoice > 2 && !isUserConnected()) {
				System.out.println("Please login before using this option\n");
				System.out.println("______________________________________");
				continue;
			}
			switch (userChoice) {
			case 1:
				choice1();
				break;
			case 2:
				choice2();
				break;
			case 3:
				choice3();
				break;
			case 4:
				choice4();
				break;
			case 5:
				choice5();
				break;
			case 6:
				choice6();
				break;
			case 7:
				choice7();
				break;
			case 8:
				choice8();
				break;
			case 9:
				choice9();
				break;
			case 10:
				choice10();
				break;
			}
			System.out.println("\n\n______________________________________");
		}
	}

	public static void main(String[] args) {
		Bookface.startInterface();
	}
}
