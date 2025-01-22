needsPackage "RandomIdeals"

randomPureQuadraticBinomial = method(Options => {DisjointVariables => true})
randomPureQuadraticBinomial(ZZ,Ring) := opts -> (t,R) -> (
    -- Want exactly t generators
    -- TODO do we need to check prime?
    local subs;
    local l;
    local S;
    local toAdd;
    randBinomials := {};
    idealToReturn := ideal(0_R);
    if opts.DisjointVariables then (
	subs = subsets(generators R, 4);
	l = #subs;
	while #randBinomials <= t do (
	    S = subs#(random l);
	    toAdd = S#0*S#1 - S#2*S#3;
	    if ((toAdd % idealToReturn) == 0) then continue else (
		randBinomials = append(randBinomials,toAdd);
		idealToReturn = ideal(randBinomials)
		);
	    );
	)
    else (
	subs = subsets(generators R, 2);
	l = #subs;
	local mon1;
	local mon2;
	while #randBinomials <= t do (
	    S = subs#(random l);
	    mon1 = S#0 * S#1;
	    S = subs#(random l);
	    mon2 = S#0 * S#1;
	    toAdd = mon1 - mon2; -- we needn't worry if they're the same, it's fixed in next line
	    if ((toAdd % idealToReturn) == 0) then continue else (
		randBinomials = append(randBinomials,toAdd);
		idealToReturn = ideal(randBinomials)
		);
	    );
	);
    return idealToReturn
    )

-*	    
-- not actually sure what we want here...do we want square free?
RandomSquareFreePureBinomialIdeal = method(Options => {DisjointVariables => false})
RandomSquareFreePureBinomialIdeal(ZZ,ZZ,Ring) := (d,t,R) -> (d:t,R)
-- d: degree of generators
-- t: num of generators
-- R: the ring
RandomSquareFreePureBinomialIdeal(Sequence,Ring) := (S,R) -> (
    RandomSquareFreePureBinomialIdeal(toList S,R)
    )
RandomSquareFreePureBinomialIdeal(List,ZZ,Ring) := (L,R) -> (
*-

randomPureBinomialIdealDisjointVariables = method()
randomPureBinomialIdealDisjointVariables(List,Ring) := (L,R) -> (
    -- There's no way to guarantee that it's prime though...so not necessarily toric
    ideal (
	for d in L list (
	    mplus := randomMonomial(d,R);
	    I := ideal(toList(set(gens R)-support(mplus)));
	    mons := gens(I^d);
	    mminus := mons_(0,random rank source mons);
	    mplus - mminus
	    )
	)
    )
	
randomBinomialEdgeIdeal(Ring,ZZ) := (R, t) -> ( 
    	    needsPackage "EdgeIdeals";
	    needsPackage "BinomialEdgeIdeals";
    -- For now, expect R is a polynomial ring
    G := randomGraph(R, t); 
    E := apply(edges G, i -> apply(i, j -> index j+1));
    return (binomialEdgeIdeal(E), G)
    )

R = ZZ/101[x_0..x_4]
    

