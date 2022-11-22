# Rest API Sample - Spring Boot - Java SDK 

This project consists in a Spring Boot application that implements a REST API whose the served data are collected from a Relational AI (RAI) project hosted in the [RAI platform](https://console.relationalai.com/), and the communication with RAI is implemented using the [RAI SDK for Java](https://github.com/RelationalAI/rai-sdk-java).

## How to run

### System requirements

To run this project you need have installed in or operating system:
- Java JDK 15 (or higher) installed (to check it, run `java --version`)

To change Java version required locate file `pom.xml` and change property `<java.version>xx</java.version>` appropriately.

### Setup the RAI client

Once this application uses the RAI SDK for Java, you need have the following data from your RAI account before start:
- Client ID
- Client Secret
- Database name
- Engine name

For more details about the client credentials, check [this](https://github.com/RelationalAI/rai-sdk-java#create-a-configuration-file).

Now you need inform paste your data properly in the following file:
- Client ID and Client Secret are defined in the file: `src/main/resources/rai/config`
- Database name and Engine name are defined in the properties `rai.database` and `rai.database` in the file `src/main/resources/application.properties`

### Run the application

**Development mode**

In the project root (same directory where the `pom.xml` file is located), run:
```shell
./mvnw spring-boot:run
```
Check the terminal output, if the application has started, access http://localhost:8080/api/database in the browser. If your credentials have the appropriate permission, the metadata of all the databases of your account should be shown in JSON format.
