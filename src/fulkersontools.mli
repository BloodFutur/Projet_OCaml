open Graph

type path = id list

(* Return list of all paths from s to t, depth-first search *)
val find_path: int graph -> id list -> id -> id -> path option

(* Return flow graph with updated flows on a specified path*)
val update_flows: int graph -> path -> int -> int graph

(* Return flow graph with updated capacities on a specified path*)
val update_capacities: int graph -> path -> int -> int graph

(* Return the minimum flow on a specified path*)
val min_flow: int graph -> path -> int 

(* Return the maximum flow of outer arcs of a node*)
val max_flow_node:  id -> int graph -> int