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
				System.out.println("choice entered not an int, please try again\n\n");
				System.out.println("______________________________________");
				continue;
			}

			return userChoice;
		}
	}


	//validate menu choice
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



	public static void choice1(){

		

		int serviceID;

		int postID;

		int circleID;

		int memberID;

		//choose a member
		System.out.println("=======================================================================");
		System.out.println("Choose a member with content available to post from the list:");

		String sql = ("SELECT DISTINCT memberID FROM (SELECT memberID FROM idea union SELECT memberID FROM picture union SELECT memberID from event union SELECT memberID from video) as res1;");

		JSONArray membersWithContent = db.executeSelectSql(sql);


		for(int i = 0; i<membersWithContent.length(); i++)
		{
			try{
				
				System.out.println(membersWithContent.getJSONObject(i).getInt("memberid"));

			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}
		}

		

		memberID = getUserInput("enter memberID:");
		
		while(!isValidIdChoice(membersWithContent, memberID, "memberid"))
		{
			System.out.println("invalid member choice, try again:");
			memberID = getUserInput("enter memberID:");
		}

		

		// choose a service

		JSONArray accArray = new JSONArray();





		System.out.println("=======================================================================");

		System.out.println("Choose a service to post:");

		
		sql = ("SELECT serviceID FROM idea WHERE memberID="+memberID+";");


		JSONArray availableIdeas = db.executeSelectSql(sql);

		for(int i = 0; i<availableIdeas.length(); i++)
		{
			

			try{

				System.out.println("serviceID=" + availableIdeas.getJSONObject(i).getInt("serviceid") + "\t" + "type=idea");

				JSONObject obj = new JSONObject();
				obj.put("serviceID",availableIdeas.getJSONObject(i).getInt("serviceid"));
				accArray.put(obj);
			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}
			

		}

		

		sql = ("SELECT serviceID FROM picture WHERE memberID="+memberID+";");


		JSONArray availablePictures = db.executeSelectSql(sql);

		for(int i = 0; i<availablePictures.length(); i++)
		{


			try{

				System.out.println("serviceID=" + availablePictures.getJSONObject(i).getInt("serviceid") + "\t" + "type=picture");

				JSONObject obj = new JSONObject();
				obj.put("serviceID",availablePictures.getJSONObject(i).getInt("serviceid"));
				accArray.put(obj);
			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}
			
		}



		sql = ("SELECT serviceID FROM event WHERE memberID="+memberID+";");


		JSONArray availableEvents = db.executeSelectSql(sql);

		for(int i = 0; i<availableEvents.length(); i++)
		{


			try{
				
				System.out.println("serviceID=" + availableEvents.getJSONObject(i).getInt("serviceid") + "\t" + "type=event");
				JSONObject obj = new JSONObject();
				obj.put("serviceID", availableEvents.getJSONObject(i).getInt("serviceid"));
				accArray.put(obj);			
			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}

		}

		
		sql = ("SELECT serviceID FROM video WHERE memberID="+memberID+";");


		JSONArray availableVideos = db.executeSelectSql(sql);

		for(int i = 0; i<availableVideos.length(); i++)
		{
			

			try{

				System.out.println("serviceID=" + availableVideos.getJSONObject(i).getInt("serviceid") + "\t" + "type=video");


				JSONObject obj = new JSONObject();
				obj.put("serviceID", availableVideos.getJSONObject(i).getInt("serviceid"));
				accArray.put(obj);
			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}

		}





		serviceID = getUserInput("enter serviceID:");


		while(!isValidIdChoice(accArray, serviceID, "serviceID"))
		{
			System.out.println("invalid service choice, try again:");
			serviceID = getUserInput("enter serviceID:");
		}


		//choose a circle


		accArray = new JSONArray();





		System.out.println("=======================================================================");

		System.out.println("Choose a circle to post to:");

		
		sql = ("select * FROM friendgroup INNER JOIN partof ON friendgroup.groupID = partof.groupID WHERE memberID=" + memberID);


		JSONArray availableGroups = db.executeSelectSql(sql);

		for(int i = 0; i<availableGroups.length(); i++)
		{
			

			try{

				System.out.println("circleID=" + availableGroups.getJSONObject(i).getInt("circleid") + "\t" + "type=group" +"\t" + "groupName=" + availableGroups.getJSONObject(i).getString("name"));

				JSONObject obj = new JSONObject();
				obj.put("circleID",availableGroups.getJSONObject(i).getInt("circleid"));
				accArray.put(obj);
			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}


		}

		

		sql = ("SELECT circleID FROM friendlist where memberID=" + memberID);


		JSONArray availableLists = db.executeSelectSql(sql);

		for(int i = 0; i<availableLists.length(); i++)
		{
			
			try{

				System.out.println("circleID=" + availableLists.getJSONObject(i).getInt("circleid") + "\t" + "type=friendlist");

				JSONObject obj = new JSONObject();

				obj.put("circleID",availableLists.getJSONObject(i).getInt("circleid"));
				accArray.put(obj);

			}
			catch(JSONException e)
			{
				db.errorPrinting(e);
			}

		}



		circleID = getUserInput("enter circleID:");


		while(!isValidIdChoice(accArray, circleID, "circleID"))
		{
			System.out.println("invalid circle choice, try again:");
			circleID = getUserInput("enter circleID:");
		}

		//get postID

		postID = generateUniqueID("post", "postid");

		//post it

		sql = ("INSERT INTO POST (postid, circleid, memberid, serviceid) VALUES("+postID+ ","+circleID+","+memberID+","+serviceID +");");

		db.executeInsertSql(sql);

		System.out.println("post added successfully");

		


		



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
				System.out.println("Bye!\n\n\n");
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

			System.out.println("\n\n______________________________________");


		}




	}

	
	public static void main(String[] args) {
		

		if (Bookface.userConnected())
		{
			Bookface.startInterface();
		}
	}
}
