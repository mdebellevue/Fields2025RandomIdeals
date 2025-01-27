restart
needsPackage "RandomIdeals"

-- fix 5 variables
R=QQ[x_1..x_5, MonomialOrder=>Lex]


-- function: generate a binomial ideal as a difference of two monomials
-- input: i number of generators of the ideal, j maximum degree of a generator
-- output: binomial ideal with i generators up to degree j
differenceMonomial = (i,j) -> (
     A=i;
     B=2*A;
     -- list of random degrees
     D = {};
     for i from 1 to B do D=append(D,random(j)+1);
     -- list of random monomials in random degrees
     M = {};
     for i from 1 to B do M=append(M,randomMonomial(D#(i-1),R));
     -- list of binomials as difference of above monomials
     N = {};
     for i from 1 to A do N=append(N,M#(i-1)-M#i);
     -- random binomial ideal
     I = ideal(N);
     I
     );

-- function: compute number of mingens of Grobner basis of random binomial ideals
-- input: i ideals, j generators up to degree k
gbNumGens = (j,k) -> (
    rank source mingens gb differenceMonomial(j,k)
    );

-- function: compute highest degree of mingens of Grobner basis of random binomial ideals
-- input: i ideals, j generators up to degree k
gbGenMaxDeg = (j,k) -> (
    L = flatten entries mingens gb differenceMonomial(j,k);
    M = {};
    for x from 1 to (length(L)-1) do M=append(M,degree L#x);
    max flatten M
    );

M = for i from 1 to 1000 list gbGenMaxDeg(10,30);
tally M
