open Graph

type path = id list

(*
  Ford-Fulkerson algorithm
  @param g : int graph
  @param source : id
  @param sink : id
  @return max_flow : int, flow_graph : int graph
*)
val ford_fulkerson: int graph -> id -> id -> int * int graph