open Graph

type path = id list

(* Return a new graph having the same nodes than gr, but not arc*)
val clone_nodes: 'a graph -> 'b graph

(* Map all arcs of gr by function f*)
val gmap: 'a graph -> ('a -> 'b) -> 'b graph

(* Add n to the value fo the arc betwen id1 and id2. If the arc does not exist, it is created*)
val add_arc: int graph -> id -> id -> int -> int graph

val print_list: int list -> unit 

(* Return list of all paths from s to t, depth-first search *)
val find_path: int graph -> id list -> id -> id -> path option

val min_flow: int graph -> path -> int 

val ford_fulkerson: int graph -> id -> id -> int