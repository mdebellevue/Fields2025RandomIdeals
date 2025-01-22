needsPackage "RandomIdeals"

naiveRandomSquareFreePureBinomialIdeal = method(Options => {DisjointVariables => false})
naiveRandomSquareFreePureBinomialIdeal(ZZ,Ring) := opts -> (t,R) -> (
     --t is number of 
     --Problem: duplicates aren't avoided when "take" is used
     --this gives ideals with at most t gens, rather than exactly t
     local randBinomials;
     if opts.DisjointVariables then (
	 subs := subsets(generators R, 4);
	 randQuads := take(random subs,t);
	 randBinomials = apply(randQuads, s -> (s#0)*(s#1) - (s#2)*(s#3));
	 ideal randBinomials
	 )
     else (
	 monomialPairs := subsets(subsets (generators R, 2),2);
	 randPairs := take(random monomialPairs, t);
	 randBinomials = apply(randPairs, s -> (s#0#0)*(s#0#1) - (s#1#0)*(s#1#1));
	 ideal randBinomials
     )
 )

randomPureQuadraticBinomial = method(Options => {DisjointVariables => true})
randomPureQuadraticBinomial(ZZ,Ring) := opts -> (t,R) -> (
    -- Want exactly t generators
    -- TODO do we need to check prime?
    local subs;
    local l;
    local S;
    local toAdd;
    randBinomial := {};
    idealToReturn := ideal(0_R);
    if opts.DisjointVariables then (
	subs = subsets(generators R, 4);
	l = #subs
	while #randBinomials <= t do (
	    S = subs#(random l);
	    toAdd = S#0*S#1 - S#2*S#3;
	    if ((toAdd % idealToReturn) == 0) then continue else (
		randBinomials = append(randBinomials,toAdd);
		idealToReturn = ideal(randBinomials)
		);
	    );
	return idealToReturn
	);
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
	return idealToReturn
	);
    )

	    
		
	    

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
    

