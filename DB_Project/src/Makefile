all:
	rm *.class || true
	javac -classpath ../java-json.jar:../postgresql-9.4-1201.jdbc41.jar  *.java
	java -classpath ../java-json.jar:../postgresql-9.4-1201.jdbc41.jar:. Bookface

91:
	rm *.class || true
	javac -classpath ../java-json.jar:/usr/local/pgsql/share/java/postgresql-9.1-903.jdbc4.jar  *.java
	java -classpath ../java-json.jar:/usr/local/pgsql/share/java/postgresql-9.1-903.jdbc4.jar:. Bookface


clean:
	rm *.class || true

