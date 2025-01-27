loadPackage "NautyGraphs"
loadPackage "FourTiTwo"
loadPackage "Quasidegrees"

-- input: number of vertices in a graph
-- output: all possible toric ideals of graphs with these number of vertices
toricGraph = n -> (
    G = generateGraphs(n);
    G/stringToGraph;
    R = QQ[x_1..x_n];
    apply(G,g-> gens stringToEdgeIdeal(g,R));
    M = G/incidenceMatrix@@stringToGraph;
    M = apply(M, g-> toricMarkov(g));
    M = unique(M);
    I = {};
    for i from 0 to (length(M)-1) do I=append(I,mingens toBinomial(M#i,QQ[x_1..x_(rank source M#i)]));
    I = unique(I)
)

-- input: number of vertices in a graph and a degree of a generator you are looking for
-- output: pictures of graphs meeting the criteria above
toricGraphVC = (v,c) -> (
    L = toricGraph(v);
    M = {};
    for i from 0 to (length L)-1 do M=append(M,L#i#0);
    N = {};
    for i from 0 to (length L)-1 do N=append(N,L#i#1);
    L2 = apply (M, g-> flatten entries g);
    L3 = {};
    for i from 0 to (length L2)-1 do L3=append(L3, length L2#i);
    L4 = {};
    for i from 0 to (length L3)-1 do (
        degGens = {};
        for j from 0 to (L3#i)-1 do (
            if (degree L2#i#j=={c}) then degGens=append(degGens, (degree L2#i#j));
            );
        L4 = append(L4, degGens)
    );
    L5 = {};
    for i from 0 to (length L4)-1 do (
        if (L4#i=={{c}}) then L5 = append(L5,i)
    );
    L6 = {};
    for i from 0 to (length L5)-1 do L6=append(L6,stringToGraph(N#(L5#i)));
    L6
)

-- input: a list of ideals
-- output: maximum degree of a GB generator
maxDegreeStats=(L)->(
    H = for I in L list(
	S = gens gb I;
	D = for i from 0 to (numColumns(S)-1) list (degree S_i);
        max D 
	);
    tally H
)


maxDegreeStats(toricGraph(4))
Tally{{2} ⇒ 3} 

maxDegreeStats(toricGraph(5))
Tally{{2} ⇒ 11,{3} ⇒ 3} 

maxDegreeStats(toricGraph(6))
Tally{{2} ⇒ 51,{3} ⇒ 37,{4} ⇒ 5} 

maxDegreeStats(toricGraph(7))
Tally{{2} ⇒ 251,{3} ⇒ 363,{4} ⇒ 146,{5} ⇒ 13}
