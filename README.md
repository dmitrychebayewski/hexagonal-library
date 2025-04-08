# hexagonal-library
Java Spring Boot Application To Demonstrate The Power Of Ports And Adapters Architecture

## Start Using The Code

Assuming that your development environment meets the following prerequisites: 
- Java 21 (or a later version);
- Maven;
- [Flyway](https://documentation.red-gate.com/flyway);
- IntelliJ or Visual Studio Code IDE;
- Postrges DB

initialize the database:
```console
$flyway baseline -user=postgres -password=******** -url=jdbc:postgresql://localhost:5432/postgres -locations=filesystem:infrastructure/src/main/resources/db-migration
```
go to the the project root directory and type a command:

```
mvn clean install
``` 

then configure the following environment variables:
```
SPRING_DATASOURCE_URL
SPRING_DATASOURCE_USERNAME
SPRING_DATASOURCE_PASSWORD
```
and launch LibraryApplication.java from the **launcher** module.
The application is served automatically after a while.
## Now check the list of books 

Use this [List](http://localhost:8080/book/get) link
## Add Some Books

Submit the following payload with Post HTTP request by 
[Add](http://localhost:8080/book/add) 

```

{
        "title": "Works For Organ And Piano Jan Pieterszoon Sweelinck",
        "isbn10": "0-486-24935-2",
        "description": "Werken voor orgel en clavicimbel",
        "price": 11.0
}
```

## Deploying The Application in K8S

[Go to ->](./cluster/readme.md)
