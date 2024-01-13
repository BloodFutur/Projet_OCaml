open Graph


(* 
   Convert a path list into a human readable association list
   Example: 0 4 6 8 9 1 -> MIC1 GEI15 14h Patrick
*)
val get_assocs: 'a list list -> ('a * 'b * 'c) list -> ('a * 'd * 'e) list -> ('a * 'f) list -> ('a * 'g) list -> ('b * 'd * 'f * 'g ) list

(* Apply ford-fulkerson algorithm to a given graph and return max flow, flow graph and paths list*)
val exam: int graph -> id -> id -> (int * int graph *  int list list)