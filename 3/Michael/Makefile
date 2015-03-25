all:
	rm *.class || true
	javac -classpath postgresql:java-json.jar DB.java
	java -classpath postgresql.jar:java-json.jar:. DB