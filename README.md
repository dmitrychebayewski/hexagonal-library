# hexagonal-library
Java Spring Boot Application To Demonstrate The Power Of Ports And Adapters Architecture

## Start Using The Code

Assuming that you have Java 11 (or a later version), Maven and your favourite IDE installed, 
go to the the project root directory and type a command:
```
mvn clean install
``` 
then  launch LibraryApplication.java from the **launcher** module.
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

## Build A LibNet Broker

De applicatie (TinyLib) kan een beperkte bibliotheek met kernfuncties beheren. 
Op een gegeven moment wil je een feature toevoegen om je bibliotheek een boek op ISBN te laten bestellen. 
Aangezien uw bibliotheek nog maar een beperkte collectie heeft, maar er is een bibliotheeknetwerk (LibNet), 
en LibNet heeft een open API die partnerbibliotheken van boeken voorziet, 
hoe zou je je TinyLib uitbreiden om met LibNet te communiceren en daar boeken te bestellen, 
als je TinyLib een of meerdere boeken nog niet heeft?

The application (TinyLib) can manage a limited library with core features. 
At some point, you want to add a feature to let your library order a book by ISBN. 
Since your library still has a limited collection, but there is a library network (LibNet), 
and LibNet has an open API that provides partner libraries with books, 
how would you extend your TinyLib to communicate with LibNet and order books there, 
if your TinyLib doesn't have one or more books yet?
