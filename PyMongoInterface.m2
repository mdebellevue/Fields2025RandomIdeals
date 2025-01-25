needsPackage "Python"
pm = import "pymongo" 
defaultUri = "mongodb://localhost:27017/"

MongoClient = new Type of PythonObject
-- I think a more user-friendly way of handling this:
-- create a global variable for storing the mongo client
-- (like "if client == nothing, make it and demand from the user that they give necessary info.  Otherwise use existing."
-- Or, store the associated DB/Client of a collection as an attribute of the MongoCollection type,
-- and then have a switchCollection function which takes the current collection, gets the associated db/client

MongoCollection = new Type of PythonObject
-- Should change print for these I guess
mongoClientOpts = {
    -- global options for all mongo client calls
    username => null,
    password => null,
    tls=>false, -- whether to use transport layer security
    directConnection=>false, -- true connects to single node, false allows replicas (see mongo documentation for details)
    port=>27017
    }

mongoClientFun = toFunction pm@@MongoClient

mongoClient = method(Options => mongoClientOpts)
mongoClient(String) := opts -> uri -> (
    new MongoClient from mongoClientFun(uri,
	"username"         => opts.username,
	"password"	   => opts.password,
	"tls"		   => opts.tls,
	"directConnection" => opts.directConnection,
	"port"             => opts.port)
    )
	
mongoCollection = method(Options => mongoClientOpts)
-- If a collection does not already exist, it is created!
-- note that the "traditional pymongo pipeline" is still available
-- (i.e., one can run client = mongoClient(uri), and then call db = client_"db-name", col = db_"collection-name")
-- However, you need to turn the result into a MongoCollection for the rest of the functions to work
mongoCollection(String,String,String):= opts -> (uri,db,col) -> (
    -- I'm assuming here that M2 folks won't want separate mongo client, db, and collection
    -- rather, just a collection (keep it simple)
    -- I suppose this has the distinct disadvantage of requiring that all the optional args of pymongo.MongoClient be added as opts to mongoCollection
    -- It shouldn't be too hard to either add all these options though (most aren't needed in 99% of cases)
    -- or there should be a more compact way to do the below
    client := mongoClientFun(uri,
	"username"         => opts.username,
	"password"	   => opts.password,
	"tls"		   => opts.tls,
	"directConnection" => opts.directConnection,
	"port"             => opts.port);
    -- TODO surely optional args/kwargs can be passed to python more easily than this...
    database := client_db;
    collection := database_col;
    new MongoCollection from collection
    )
mongoCollection(String,String) := opts -> (db,col) -> (
    -- For the user that configures the network defaults once and never wants to enter them again
    -- (configures them by changing mongoClientOpts, above)
    client := mongoClientFun(defaultUri,
	"username"         => opts.username,
	"password"	   => opts.password,
	"tls"		   => opts.tls,
	"directConnection" => opts.directConnection,
	"port"             => opts.port);
    database := client_db;
    collection := database_col;
    new MongoCollection from collection
    )
mongoCollection(MongoClient,String,String) := opts -> (client,db,col) -> (
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
