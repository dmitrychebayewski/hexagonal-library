# hexagonal-library
Java Spring Boot Application To Demonstrate The Power Of Ports And Adapters Architecture

## Start Using The Code

Assuming that you have your favourite Java 11, Maven and your favourite IDE installed, type:
```
mvn clean install
``` 
then go to **launcher**
and launch LibraryApplication.java
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

The application (TinyLib) can manage a tiny library with core functions.
At some moment you want to add a method to let your library order a book by ISBN.
Given your library has yet a limited collection,  
but there is a library network (LibNet), 
and LibNet has a publically available API that provides partner libraries with books, 
how would you extend your TinyLib to communicate with LibNet and order books there, if TinyLib doesn't have any?   
