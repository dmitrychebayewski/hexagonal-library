FROM openjdk:21-jdk
LABEL authors="rotterdam-minsk"
COPY launcher/target/launcher-1.0-SNAPSHOT.jar launcher-1.0-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/launcher-1.0-SNAPSHOT.jar"]