load "PyMongoInterface.m2"

-- Connect to polydb
polydb = mongoClient("mongodb://db.polymake.org", port => 27017, username =>"polymake", password => "database", directConnection => true, tls => true)
-- Select the smooth reflexive polytope collection
SmoothReflexive =  mongoCollection(polydb, "polydb", "Polytopes.Lattice.SmoothReflexive")
-- Polytope with fewer than 10 vertices, greater than 7 vertices, and dimension 7
poly10 = findOne(hashTable{"N_VERTICES" => hashTable{ "$lt" => 10, "$gt" => 7}, "DIM" => hashTable{ "$gt" => 7}},SmoothReflexive)
-- here we ask for a polytope which has either 5 or 7 facets, and whose dim is 3
poly57 = findOne(hashTable{"$or" => {hashTable{"N_FACETS" => 5},hashTable{"N_FACETS" => 7}}, "DIM" => 3},SmoothReflexive)

-- "Find" returns "generator" object rather than a list
-- Here we get all polytopes with 7 facets
polys = find(hashTable{"N_FACETS" => 7},SmoothReflexive)
-- We can step through the it one at a time
next(polys)
-- or we can list out the whole thing
polyList = for pol in polys list pol;
