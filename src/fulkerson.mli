open Graph

type path = id list

(*
  Ford-Fulkerson algorithm
  @param g : int graph
  @param source : id
  @param sink : id
  @return max flow : int and the graph with the flow : int graph
*)
val ford_fulkerson: int graph -> id -> id -> int * int graph