# Use an official OpenJDK runtime as a parent image
FROM apachedirectory/maven-build:jdk-17

# Set the working directory in the container
WORKDIR /app

# Copy all files
COPY . /app

# Make port 9090 available to the world outside this container
EXPOSE 9090

# Run the .jar file
ENTRYPOINT ["java", "-jar", "/app/target/nicefc-0.0.1-SNAPSHOT.jar"]