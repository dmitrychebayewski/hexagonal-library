# hexagonal-library
Java Spring Boot Application To Demonstrate The Power Of the Hexagonal (Ports And Adapters) Architecture.
Why is the [Hexagonal Architecture](https://en.wikipedia.org/wiki/Hexagonal_architecture_(software)) interesting?

## Hexagonal Architecture

Because the system biult on the principles of the Hexagonal Architecture will surely:
 - Avoid known structural pitfalls in object-oriented software design
 - Avoid the dependencies on the "existence of some library of feature laden software" [Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
 - Be testable
 - Provide good separation of concerns, for example: "The UI model should never pose requirements for the domain model"  [Jim Van Dam](https://stuiml.blogspot.com/2008/02/stuiml-principles.html)
 - Provide good reusability and so follow the 'strong cohesion, loose coupling' principle.

## What Could You Expect from Completion of This Workshop

 - Practical familiarity with building a Spring Boot service as "port and adapter"
 - Familiarity with deploying the Spring Boot Service in a Kubernetes (K8S) or a compatible cluster;
 - Familiarity with building the cloud - native CI/CD pipeline, following the [GitOps](https://en.wikipedia.org/wiki/DevOps#GitOps) principle

## Questions
> What Are the Alternatives To the Hexagonal Architecture?
 >> For example, [Layered Architecture, Onion Architecture and Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
 
> Is The Hexagonal Architecture intended for Spring Boot Services only, or could it be used for building a Front End as well?
 >> Yes you absolutely can bulid a Front End following the principles of The Hexagonal (or an equivalent) Architecture.
 >> There is a separate [workshop (under construction)](https://github.com/dmitrychebayewski/hexagonal-architecture-frontend) covering the aspects of anno 2025 FE

## Logical Structure
THe workshop is built as 3 modules:
- 1 "Port and adapter" as a Spring Boot Service
- 2 [Deployment in a K8S (or a compatible) cluster](./cluster/readme.md)
- 3 [CI / CD pipeline](./cluster/tekton-pipelines/readme.md)
The dependency graph is (1) -> (2) -> (3), meaning that you'll need a completion of (1) to complete (2), and a completion of (2) to complete (3)

## Start Using The Code

Assuming that your development environment meets the following prerequisites: 
- MacOs or Windows with WSL/Docker Desktop;
- Java 21 (or a later version);
- Maven;
- [Flyway](https://documentation.red-gate.com/flyway);
- IntelliJ or Visual Studio Code IDE;
- Postgres DB

and you are already familiar with Java Web or Enterprise development, it will take from 15 to 240 minutes to complete the example.

### Initialize the database

```console
flyway baseline -user=postgres -password=******** -url=jdbc:postgresql://localhost:5432/postgres -locations=filesystem:infrastructure/src/main/resources/db-migration
```

### Build the application

```console
mvn clean install
``` 
### Build the application making flyway migrate data
The command will activate Maven profile 'testrun'.
The command will activate Maven profile 'testrun'.
'testrun' profile includes the flyway dependencies, and
flyway migration will be done automatically into H2 memory DB.
```console
mvn clean install -Ptestrun
```

### Run tests making flyway migrate data
The command will activate Maven profile 'testrun'.
'testrun' profile includes the flyway dependencies, and
flyway migration will be done automatically into H2 memory DB. 
```console
mvn clean test -Ptestrun
```

### Configure the following environment variables
```
SPRING_DATASOURCE_URL
SPRING_DATASOURCE_USERNAME
SPRING_DATASOURCE_PASSWORD
```
and launch LibraryApplication.java from the [launcher](./launcher) module.
The application is served automatically after a while.

## Complete a FlyWay Migration in a separate command
```console
flyway migrate -user=postgres -password=******** -url=jdbc:postgresql://localhost:5432/postgres -locations=filesystem:infrastructure/src/main/resources/db-migration
```

## Now check the list of books 

Use this HTTP request
```http request
###
### GET a list of available books
GET http://localhost:8080/book/get
```
## Add Some Books

Submit the payload with the following HTTP request 


```http request
###
### ADD a book
POST http://localhost:8080/book/add
Content-Type: application/json

{
  "title": "Works For Organ And Piano Jan Pieterszoon Sweelinck",
  "isbn10": "0-486-24935-2",
  "description": "Werken voor orgel en clavicimbel",
  "price": 11.0
}
```
The following step is deploying the code in a K8S cluster
## Deploying The Application in K8S

[Go to ->](./cluster/readme.md)
