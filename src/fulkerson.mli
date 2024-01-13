open Graph

type path = id list

(*
  Ford-Fulkerson algorithm
  @param g : int graph
  @param source : id
  @param sink : id
  @return max flow : int 
*)
val ford_fulkerson: int graph -> id -> id -> int

(* Ford-Fulkerson algorithm, the same as ford_fulkerson but returns the graph with the flow *)
val eford_fulkerson: int graph -> id -> id -> int *  int graph