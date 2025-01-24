needsPackage "Python"
pm = import "pymongo" 
defaultUri = "mongodb://localhost:27017/"
MongoCollection = new Type of PythonObject
-- Should change print for it I guess

mongoCollection = method()
-- If a collection does not already exist, it is created!
mongoCollection(String,String,String):= (uri,db,col) -> (
    client := pm@@MongoClient(uri);
    database := client_db;
    collection := database_col;
    new MongoCollection from collection
    )

mongoCollection(String,String):= (db,col) -> (
    client := pm@@MongoClient(defaultUri);
    database := client_db;
    collection := database_col;
    new MongoCollection from collection
    )

find = method()
find (HashTable,MongoCollection):= (t,C) -> iterator(C@@find(t))
-- TODO should be able to enter a python dict
-- To discuss: should it be unpacked into a list, instead of left as an iterator?
-- (the user is unlikely to be familiar with iterators)
findOne = method()
findOne(MongoCollection) := C -> C@@"find_one"()
findOne(HashTable,MongoCollection) := (H,C) -> C@@"find_one"(H)

insert(HashTable,MongoCollection) := (H,C) -> C@@"insert_one"(H)
insert(List,MongoCollection) := (L,C) -> C@@"insert_many"(L)

delete(HashTable,MongoCollection) := (H,C) -> C@@"delete_one"(H)

countDocuments = method()
countDocuments(MongoCollection) := C -> (nullHash := HashTable{}; C@@count_documents(nullHash))
countDocuments(HashTable,MongoCollection) := (H,C) -> C@@count_documents(H)

updateOne = method()
updateOne(HashTable,HashTable,MongoCollection) := (Query,Update,C) -> C@@"update_one"(Query,Update)
updateMany = method()
updateMany(HashTable,HashTable,MongoCollection) := (Query,Update,C) -> C@@"update_many"(Query,Update)
-- TODO change printing
-- To discuss: how should data be normalized for passing to mongo??
-- Should everything be ultimately converted to a string?
-- Maybe as a fallback if toPython doesn't have anything else to do?
