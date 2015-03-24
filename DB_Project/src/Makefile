all:
	rm *.class || true
	javac -classpath ../java-json.jar:../postgresql-9.4-1201.jdbc41.jar  *.java
	java -classpath ../java-json.jar:../postgresql-9.4-1201.jdbc41.jar:. Bookface
clean:
	rm *.class || true
