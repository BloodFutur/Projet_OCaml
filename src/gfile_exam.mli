open Graph

type path = string

(*val read_class:*)

val make_graph: (int * string * int) list -> (int * string * int) list -> (int * string) list -> (int * string) list -> int graph

val from_efile: path -> (int * string * int) list * (int * string * int) list * (int * string) list * (int * string) list