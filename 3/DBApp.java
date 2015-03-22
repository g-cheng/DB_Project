import java.sql.*;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;


public class DBApp
{
	private String dbURL;
	private String dbUser;
	private String dbPass;
	private Scanner userIn;
	private Connection dbConn;
	private Statement statement;
	private ResultSet sqlResult;
	private String sql;
	private int choice;



	//constructor

	public DBApp(String dbUser, String dbPass)
	{
		this.dbURL = "jdbc:postgresql://localhost/bookface";
		this.dbUser = dbUser;
		this.dbPass = dbPass;
		this.userIn = new Scanner(System.in);

		try
		{
			Class.forName("org.postgresql.Driver");
			dbConn = DriverManager.getConnection(dbURL, dbUser, dbPass);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			
		}
	}

	//validate menu choice
	private static boolean isValidChoice(int choice)
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

	//menu choices
	private void choice1()
	{
		while(true)
		{
			try
			{
				
				//variables required to add posts

				int memberID;

				int serviceID;

				int postID;

				int circleID;


				//create a sql statement to database
				statement = dbConn.createStatement();
				

				//MEMBER CHOICE ---------------------------------------------------------------------------
				sql = ("SELECT DISTINCT memberID FROM (SELECT memberID FROM idea union SELECT memberID FROM picture union SELECT memberID from event union SELECT memberID from video) as res1;");

				sqlResult = statement.executeQuery(sql);


				System.out.println("=======================================================================");
				System.out.println("Choose a member with content available to post from the list:");


				List<Integer> dataSet = new ArrayList<Integer>();


				while(sqlResult.next())
				{
					System.out.println(sqlResult.getInt("memberID"));
					dataSet.add(sqlResult.getInt("memberID"));

				}


				//ask for user to choose member
				System.out.println("Enter memberID: ");

				try
				{
					choice = Integer.parseInt(userIn.next());
				}
				catch(Exception e)
				{
					System.out.println("Error: choice entered is not a number. Try again");

					continue;
				}

			
				//check if user choice is valid
				boolean hasId=false;

				for (int i = 0; i < dataSet.size(); i++) 
				{
            		if(dataSet.get(i)==choice)
					{
						hasId=true;
					}
        		}

				//if not valid, ask for user choice again
				if (!hasId)
				{
					System.out.println("Error: invalid member choice: try again");
					continue;
				}

				memberID=choice;


				//SERVICE CHOICE-----------------------------------------------------------------------------------------------------
				System.out.println("=======================================================================");

				System.out.println("Choose a service to post:");

				//display ideas
				sql = ("SELECT serviceID FROM idea WHERE memberID="+memberID+";");

				sqlResult = statement.executeQuery(sql);

				dataSet = new ArrayList<Integer>();

				while(sqlResult.next())
				{
					System.out.println("serviceID=" + sqlResult.getInt("serviceID") + "\t" + "type=idea");
					dataSet.add(sqlResult.getInt("serviceID"));

				}

				//display pictures
				sql = ("SELECT serviceID, pictureID, fileSize FROM picture WHERE memberID="+memberID+";");

				sqlResult = statement.executeQuery(sql);

				while(sqlResult.next())
				{
					System.out.println("serviceID=" + sqlResult.getInt("serviceID") + "\t" + "type=picture" +"\t" + "pictureID=" + sqlResult.getInt("pictureID") + "\t" + "fileSize=" + sqlResult.getInt("fileSize"));
					dataSet.add(sqlResult.getInt("serviceID"));
				}

				//display events

				sql = ("SELECT serviceID, name FROM event WHERE memberID="+memberID+";");

				sqlResult = statement.executeQuery(sql);

				while(sqlResult.next())
				{
					System.out.println("serviceID=" + sqlResult.getInt("serviceID") + "\t" + "type=event" +"\t" + "eventName=" + sqlResult.getString("name"));
					dataSet.add(sqlResult.getInt("serviceID"));
				}

				//display videos

				sql = ("SELECT serviceID, format FROM video WHERE memberID="+memberID+";");

				sqlResult = statement.executeQuery(sql);

				while(sqlResult.next())
				{
					System.out.println("serviceID=" + sqlResult.getInt("serviceID") + "\t" + "type=video" +"\t" + "videoFormat=" + sqlResult.getString("format"));
					dataSet.add(sqlResult.getInt("serviceID"));
				}

				
				//ask user for choice

				while (true)
				{
					System.out.println("Enter serviceID: ");

					try
					{
						choice = Integer.parseInt(userIn.next());
					}
					catch(Exception e)
					{
						System.out.println("Error: choice entered is not a number. Try again");

						continue;
					}

					//check if user choice is valid
					hasId=false;

					for (int i = 0; i < dataSet.size(); i++) 
					{
	            		if(dataSet.get(i)==choice)
						{
							hasId=true;
						}
	        		}

					//if not valid, ask for user choice again
					if (!hasId)
					{
						System.out.println("Error: invalid service choice: try again");
						continue;
					}
					else
					{
						serviceID=choice;
						break;
					}

				}


				//CIRCLE CHOICE -------------------------------------------------------------------------------------

				System.out.println("=======================================================================");

				System.out.println("Choose a circle to post in:");


				dataSet = new ArrayList<Integer>();

				//display circles

				sql = ("select * FROM friendgroup INNER JOIN partof ON friendgroup.groupID = partof.groupID WHERE memberID=" + memberID);

				sqlResult = statement.executeQuery(sql);

				while(sqlResult.next())
				{
					System.out.println("circleID=" + sqlResult.getInt("circleID") + "\t" + "type=group" +"\t" + "groupName=" + sqlResult.getString("name"));
					dataSet.add(sqlResult.getInt("circleID"));
				}

				//display friendlist

				sql = ("SELECT circleID FROM friendlist where memberID=" + memberID);

				sqlResult = statement.executeQuery(sql);

				while(sqlResult.next())
				{
					System.out.println("circleID=" + sqlResult.getInt("circleID") + "\t" + "type=friendlist");
					dataSet.add(sqlResult.getInt("circleID"));
				}
				
				
				//ask for circle choice


				while (true)
				{
					System.out.println("Enter circleID: ");

					try
					{
						choice = Integer.parseInt(userIn.next());
					}
					catch(Exception e)
					{
						System.out.println("Error: choice entered is not a number. Try again");

						continue;
					}

					//check if user choice is valid
					hasId=false;

					for (int i = 0; i < dataSet.size(); i++) 
					{
	            		if(dataSet.get(i)==choice)
						{
							hasId=true;
						}
	        		}

					//if not valid, ask for user choice again
					if (!hasId)
					{
						System.out.println("Error: invalid circle choice: try again");
						continue;
					}
					else
					{
						circleID=choice;
						break;
					}

				}

				//POSTID --------------------------------------------------------------------------------------

				dataSet= new ArrayList<Integer>();


				sql = ("SELECT postID FROM post");

				sqlResult = statement.executeQuery(sql);

				while(sqlResult.next())
				{
					dataSet.add(sqlResult.getInt("postID"));
				}

				Collections.sort(dataSet);

				postID = dataSet.get(dataSet.size()-1)+1;


				//add post


				sql = ("INSERT INTO POST (postid, circleid, memberid, serviceid) VALUES("+postID+ ","+circleID+","+memberID+","+serviceID +");");

				statement.executeUpdate(sql);

				statement.close();

				break;
			}
			catch(Exception e)
			{
				e.printStackTrace();
				break;
			}


		}
		
		

	}

	private void choice2()
	{
		;
	}


	private void choice3()
	{
		;
	}


	private void choice4()
	{
		;
	}


	private void choice5()
	{
		;
	}


	private void displayMenu()
	{
		System.out.println("Welcome to BookFace Java App!");
		System.out.println("1. Post an existant IDEA, PICTURE, VIDEO or EVENT created by a member to one of his/her circles");
		System.out.println("2. DO SOMETHING");
		System.out.println("3. DO SOMETHING");
		System.out.println("4. DO SOMETHING");
		System.out.println("5. DO SOMETHING");
		System.out.println("6. EXIT");
		System.out.println("Enter choice number:");
	}


	public void startCmdInterface()
	{

		

		while(true)
		{
			
			
			this.displayMenu();


			//get user input for choice
			try
			{
				choice = Integer.parseInt(userIn.next());
			}
			catch (Exception e)
			{
				System.out.println("choice entered not an int, please try again\n\n");
				System.out.println("______________________________________");
				continue;
			}

			
			// if choice not between 1 and 6, ask display menu again
			if(!isValidChoice(choice))
			{
				System.out.println("choice does not exist, please try again\n\n");
				System.out.println("______________________________________");
				continue;
			}

			// if choice is exit, then exit
			if(choice == 6)
			{
				System.out.println("Bye!\n\n\n");
				break;
			}

			// choice is either between 1 to 5, so do something
			switch (choice)
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


	//ENTRY POINT
	//USAGE: java DBApp <dbUsername> <dbPassword>
	public static void main(String[] args)
	{
		try
		{
			(new DBApp(args[0], args[1])).startCmdInterface();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
}