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


	private static void displayMenu(){
			
		System.out.println("Welcome to BookFace Java App!");
		System.out.println("1. admin only: Post an existant IDEA, PICTURE, VIDEO or EVENT created by a member to one of his/her circles");
		System.out.println("2. DO SOMETHING");
		System.out.println("3. DO SOMETHING");
		System.out.println("4. DO SOMETHING");
		System.out.println("5. DO SOMETHING");
		System.out.println("6. EXIT");
	}

	// connects user with user name and password
	//returns true if successful, false if not
	private static boolean userConnected(){

		user = db.login("Joshua", "DMe2t7eyL");
		
		if (user == null) {
			System.out.println("Unable to login, please try again with a correct name and password combination");
			return false;
		} else {
			System.out.println("Login successful! Welcome back " + user.getName());
			return true;

		}

	}

	//keeps on asking user for input until user inputs an int
	private static int getUserInput(String promptMessage){

		while (true)
		{
			System.out.println(promptMessage);

			Scanner userIn = new Scanner(System.in);

			int userChoice;

			try
			{
				userChoice = Integer.parseInt(userIn.next());
			}
			catch (Exception e)
			{
				System.out.println("choice entered not an int, please try again");
				System.out.println("______________________________________");
				continue;
			}

			return userChoice;
		}
	}


	//validate menu choice (has to be between 1 and 6)
	private static boolean isValidMenuChoice(int choice)
	{
		if(choice > 6 || choice < 1)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	//input:
	// - name of table you want to insert into
	// - name of primary key
	//output:
	// - returns (the maximum ID that exist in the table currently incremented by 1)
	private static int generateUniqueID(String tableName, String pkName)
	{
		int uniqueID=-1;
		try{

			 uniqueID = db.executeSelectSql("select " +pkName+  " from " + tableName + " where " + pkName + "=(select max(" + pkName + ") from " + tableName +")").getJSONObject(0).getInt(pkName) + 1;

			
			
		}
		catch(JSONException e)
		{
			db.errorPrinting(e);
		}
		finally
		{
			return uniqueID;
		}
		

	}

	//checks if the id choosen can be found inside the jsonarray under attribute pkName
	private static boolean isValidIdChoice(JSONArray arr, int id, String pkName)
	{

		boolean result=false;

		for(int i=0; i<arr.length();i++)
		{
			try{

				if (arr.getJSONObject(i).getInt(pkName)==id)
				{
					result = true;
				}
			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}
		}

		return result;

	}



	private static void displayChoiceMessage(String msg)
	{
		System.out.println("=======================================================================");
		System.out.println(msg);
	}

	//prints out each row of the array and strips out the useless info
	private static JSONArray stripAndPrintAttributes(JSONArray inputArray, String pkName, String additionalMessage)
	{
		JSONArray outputArray = new JSONArray();

		for(int i = 0; i<inputArray.length(); i++)
		{
			try{
				
				System.out.println(pkName+"="+inputArray.getJSONObject(i).getInt(pkName) +"\t"+ additionalMessage);
				JSONObject obj = new JSONObject();
				obj.put(pkName,inputArray.getJSONObject(i).getInt(pkName));
				outputArray.put(obj);


			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}
		}

		return outputArray;
	}

	//ask for user to input a valid id choice until the inputed choice is valid, i.e it exists in the jsonarray
	private static int getIdChoice(JSONArray inputArray, String pkName)
	{	
		int chosenID;

		chosenID = getUserInput("enter " + pkName +":");
		while(!isValidIdChoice(inputArray, chosenID, pkName))
		{
			System.out.println("invalid " + pkName + " choice, try again:");
			chosenID= getUserInput("enter "+ pkName +":");
		}

		return chosenID;
	}

	//concatenates 2 JSON arrays
	private static JSONArray concatJSONArrays(JSONArray a1, JSONArray a2)
	{
		try
		{
			for(int i = 0; i<a1.length(); i++)
			{
				a2.put(a1.getJSONObject(i));
			}
		}
		catch (JSONException e)
		{
			db.errorPrinting(e);
		}
		

		return a2;
	}

	public static void choice1(){

		

		int serviceID;

		int postID;

		int circleID;

		int memberID;



		//choose a member-----------------------------------------------------------------
		
		displayChoiceMessage("Choose a member with content available to post from the list:");

		String sql = ("SELECT DISTINCT memberID FROM (SELECT memberID FROM idea union SELECT memberID FROM picture union SELECT memberID from event union SELECT memberID from video) as res1;");

		JSONArray membersWithContent = db.executeSelectSql(sql);

		membersWithContent = stripAndPrintAttributes(membersWithContent, "memberid", "");
		

		memberID = getIdChoice(membersWithContent, "memberid");
		

		

		// choose a service-----------------------------------------------------------------




		displayChoiceMessage("Choose a service to post:");

		
		sql = ("SELECT serviceID FROM idea WHERE memberID="+memberID+";");


		JSONArray availableIdeas = db.executeSelectSql(sql);

		availableIdeas = stripAndPrintAttributes(availableIdeas, "serviceid", "\t type=idea");
		




		sql = ("SELECT serviceID FROM picture WHERE memberID="+memberID+";");


		JSONArray availablePictures = db.executeSelectSql(sql);

		availablePictures = stripAndPrintAttributes(availablePictures, "serviceid", "\t type = picture");

		



		sql = ("SELECT serviceID FROM event WHERE memberID="+memberID+";");


		JSONArray availableEvents = db.executeSelectSql(sql);

		availableEvents = stripAndPrintAttributes(availableEvents, "serviceid", "\t type=event");

		

		

		sql = ("SELECT serviceID FROM video WHERE memberID="+memberID+";");


		JSONArray availableVideos = db.executeSelectSql(sql);

		availableVideos = stripAndPrintAttributes(availableVideos, "serviceid", "\t type=video");




		//concatenate all 4 JSON Arrays
		JSONArray accArray = new JSONArray();

		accArray = concatJSONArrays(availableIdeas,availablePictures);

		accArray = concatJSONArrays(accArray, availableEvents);

		accArray = concatJSONArrays(accArray, availableVideos);



		// get serviceID from user
		serviceID = getIdChoice(accArray, "serviceid");

		

		//choose a circle ------------------------------------------------------------------------------------

		displayChoiceMessage("Choose a circle to post into:");

		
		sql = ("select * FROM friendgroup INNER JOIN partof ON friendgroup.groupID = partof.groupID WHERE memberID=" + memberID);


		JSONArray availableGroups = db.executeSelectSql(sql);

		availableGroups = stripAndPrintAttributes(availableGroups, "circleid", "\t type=group");

		

		

		sql = ("SELECT circleID FROM friendlist where memberID=" + memberID);


		JSONArray availableLists = db.executeSelectSql(sql);

		availableLists = stripAndPrintAttributes(availableLists, "circleid", "\t type=friendlist");

		
		//concatenate all 2 json arrays
		accArray = new JSONArray();

		accArray = concatJSONArrays(availableGroups, availableLists);


		//get circleID from user
		circleID = getIdChoice(accArray, "circleid");



		//get postID-----------------------------------------------------------

		postID = generateUniqueID("post", "postid");

		




		//make post ------------------------------------------------------------

		sql = ("INSERT INTO POST (postid, circleid, memberid, serviceid) VALUES("+postID+ ","+circleID+","+memberID+","+serviceID +");");

		db.executeInsertSql(sql);


		System.out.println("\n++++++++++++++++++++++++\npost added successfully\n++++++++++++++++++++++++");

	}

	public static void choice2(){
		;
	}

	public static void choice3(){
		;
	}

	public static void choice4(){
		;
	}

	public static void choice5(){
		;
	}



	private static void startInterface(){


		while(true)
		{
			
			
			Bookface.displayMenu();

			int userChoice;

			userChoice = Bookface.getUserInput("Enter choice number:");


			
			
			// if choice not between 1 and 6, ask display menu again
			if(!isValidMenuChoice(userChoice))
			{
				System.out.println("choice does not exist, please try again\n\n");
				System.out.println("______________________________________");
				continue;
			}

			// if choice is exit, then exit
			if(userChoice == 6)
			{
				System.out.println("Bye!\n");
				break;
			}

			// choice is either between 1 to 5, so do something
			switch (userChoice)
			{
				case 1:	choice1();
						break;

				case 2:	choice2();
						break;

				case 3: choice3();
						break;

				case 4: choice4();
						break;

				case 5: choice5();
						break;
			}

			System.out.println("\n______________________________________");


		}




	}

	
	public static void main(String[] args) {
		

		if (Bookface.userConnected())
		{
			Bookface.startInterface();
		}
	}
}
