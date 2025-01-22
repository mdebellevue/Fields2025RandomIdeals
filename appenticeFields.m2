-- ULTIMATE GOAL OF THIS FILE: 
-- input: list of integer matrices, or list of binomial ideals 
-- output: degree statistics for mingens and GBs (of the corresponding toric ideals) 


-- enumerating graphs on n nodes can be done using this package: 
loadPackage "NautyGraphs"
G = generateGraphs(5, le=4, ue=10)
G/stringToGraph;
R = QQ[x_1..x_5]; apply(G,g-> gens stringToEdgeIdeal(g,R))
G/incidenceMatrix@@stringToGraph 

-* 
loadPackage "RandomMonomialIdeals"  -- do not re-run more than once in a session!! 

-- the following function is from the package RandomMonomialIdeals.m2 : 
statistics = method(TypicalValue => HashTable)
statistics (Sample, Function) := HashTable => (s,f) -> (
    fData := apply(s.Data,f);
    mean := (sum fData)/s.SampleSize; -- <- should the mean be returned as RR? 
    new HashTable from {Mean=>mean,
     StdDev=>sqrt(sum apply(fData, x-> (mean-x)^2)/s.SampleSize),
     Histogram=>tally fData}
)
*- 

statistics (List, Function) := HashTable => (s,f) -> (
    fData := apply(s,f);
    mean := (sum fData)/#s; -- <- should the mean be returned as RR? 
    new HashTable from {Mean=>mean,
     StdDev=>sqrt(sum apply(fData, x-> (mean-x)^2)/#s),
     Histogram=>tally fData}    
    )



-- this function gives you all the degrees of GB elements for I_A
-- input: toric matrix A or ideal I 
-- output: list of gb degrees
gbDegs = method()
gbDegs Matrix := A -> (
    b = toricGroebner A;
    if b==0 then return {0};
    myrows = apply(numrows b, r-> b^{r});
    apply(myrows, onerow-> (
	 mybinomial = partition(i->i>0, flatten entries onerow);  -- b = b^+-b^- binomial
    	 max(sum mybinomial#true,sum mybinomial#false)
	 )
    )
)
gbDegs Ideal := I -> (
    b = flatten entries gens gb I;
    apply(b, onebinomial-> (
	 e = exponents onebinomial; -- e = {positive exponents, negagive expoennts}
    	 max(sum e_0,sum e_1)
	 )
    )
)

-- for a list of matrices: 
myList = G/incidenceMatrix@@stringToGraph;
statistics (myList,max@@gbDegs) -- <<<<<<=======

--- for a list of ideals: 
R = QQ[x_1..x_7];
myList = {ideal(x_1*x_3-x_4*x_6, x_6^2-x_7*x_1), ideal(x_1*x_3-x_2*x_6, x_3^2-x_7*x_1)}
statistics (myList,max@@gbDegs) -- <<<<<<=======


-* 
-- input: list of data, such as toric matrices A, or ideals or whatever;
-- output: an object of type Sample whose data is this list! 
sampleFromList = method(TypicalValue => Sample)
sampleFromList (List) := Sample => (myListOfData) -> (
--sampleFromList List := myListOfData -> (
    new Sample from {ModelName => SonjaApprentice, 
            Parameters => "n=5 etc - will figure out later", 
            SampleSize => # myListOfData, 
            Data => myListOfData}
)
-- why? because now we can do this: 

mySample = sampleFromList(G/incidenceMatrix@@stringToGraph )
statistics(mySample,numcols) -- this will tell you how many columns (variables) there are in the data set! 

-- not exactly working yet. 

statistics(mySample,max@@gbDegs) -- this will tell you max GB degre for a sample of toric matrices
maxGBdegree = method()
maxGBdegree Matrix := A -> (
    max gbDegs A
    )
statistics(mySample,maxGBdegree) -- this will tell you max GB degre for a sample of toric matrices
*- 


-*
b = toricGroebner A
myrows = apply(numrows b, r-> b^{r})
mybinomial = partition(i->i>0, flatten entries b^{r})  -- b = b^+-b^- binomial
mydeg = max(sum mybinomial#true,sum mybinomial#false)
-- this will give the degree of the gens encoded as exponents. 
apply(myrows,  .... 
*- 

-- oh, by the way:
peek mySample
mySample.Data

--idealSample = sampleFromList(....)
--statistics(idealSample,degrees@@ideal@@leadTerm)

loadPackage "FourTiTwo"  -- do not re-run more than once in a session!! 
gbStats = method()
gbStats List := matricesA -> (
    tbl := new MutableHashTable;
    apply(matricesA, A-> (
	    n := numcols A;
	    x := symbol x;
    	    R = QQ[x_1..x_n];
	    I := toricGroebner(A,R);
--    	    print "Here are the GB degree statistics: mean, variance, and the tally of all GB degrees:"; 
--	    if I!=0 then degStats({monomialIdeal leadTerm I},ShowTally=>true) else 0 
	    );
	);
    return ideals
    )
gbStats (G/incidenceMatrix@@stringToGraph)




