all:
	rm *.class || true
	javac -classpath postgresql:java-json.jar:btc-ascii-table-1.0.jar DB.java
	java -classpath postgresql.jar:java-json.jar:btc-ascii-table-1.0.jar:. DB