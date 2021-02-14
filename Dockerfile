# JDK 8 + Maven 3.3.9 
FROM openjdk:11-alpine

# Prepare the folder
RUN mkdir -p /app
COPY . /app
WORKDIR /app
# Generates the package
# RUN mvn install

# Http port
ENV PORT 9090
EXPOSE  $PORT

# Executes spring boot's jar
CMD ["java", "-jar", "vulnerablejavawebapp-0.0.1-SNAPSHOT.jar"]
