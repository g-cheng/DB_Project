all:
	rm *.class || true
	javac -classpath postgresql DB.java
	java -classpath postgresql.jar:. DB