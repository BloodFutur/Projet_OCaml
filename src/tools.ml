open Graph

type path = id list

let clone_nodes (gr: 'a graph) = n_fold gr new_node empty_graph

(* It folds over edges of the given graph and applies the function f, from an arc-empty copy*)
let gmap (gr: 'a graph) (f: 'a -> 'b) = e_fold gr (fun g e -> new_arc g {e with lbl=(f e.lbl)}) (clone_nodes gr)


(* Add n to the value fo the arc betwen id1 and id2. If the arc does not exist, it is created*)
let add_arc (gr: 'a graph) (id1: id) (id2: id) (n: int) =  match (find_arc gr id1 id2) with
  |None -> new_arc gr {src=id1 ; tgt=id2 ; lbl=n}
  |Some arc -> new_arc gr {arc with lbl=(arc.lbl + n)}

let rec print_list = function 
[] -> ()
| e::l -> print_int e ; print_string " " ; print_list l


(* From a given graph, returns Some path if a path was found between s and t*)
let find_path gr visited s t =
  (* Deep-first search algorithm to determine a path from s to t in gr *)
  let rec path_dfs (gr: 'a graph) (visited: id list) (acc: path) (s: id) (t: id) =
    if s=t then 
      List.rev(s::acc)
  (* else List.map (fun a-> (path_dfs gr (List.append visited [s]) ((a.src)::acc) a.tgt t) else acc) (out_arcs gr s) *)
    else
      let rec loop = function
      |[]->[]
      |a::rest -> if not (List.mem a.tgt visited) then (match (path_dfs gr (s::visited) (a.src::acc) a.tgt t) with
                                                          |[]-> loop rest
                                                          |_-> path_dfs gr (s::visited) (a.src::acc) a.tgt t)
                  else loop rest 
    in
    loop (out_arcs gr s)
  in
  match path_dfs gr visited [] s t with
  |[] -> None
  |p -> Some p


(* gets minimal flow from path (id list)*)
let rec min_flow gr acu p = 
  match p with
  |[] -> acu
  |_::[] -> acu
  |node1::(node2::rest) -> 
    match find_arc gr node1 node2 with
    |None -> failwith("Edge not found")
    |Some arc -> if (acu<arc.lbl) then min_flow gr acu rest else min_flow gr arc.lbl rest


(*
let ford_fulkerson (gr: 'a graph) (s: id) (t: id) =
  (* initialize an identical graph with 0 flow on all arcs *)
  let gr_f0 = e_fold gr (fun acc a -> new_arc acc {src=a.src ;  tgt=a.tgt ;  lbl=0}) (clone_nodes gr)
  in 
  (* loop on possible paths from s to t*)
  let rec loop = match path_dfs gr visited acc s t with
    |[] -> gr_f0 (* termination condition ??*)
    |node1::(node2::rest) ->  
      match (find_arc gr node1 node2) with
      |Some a when a.lbl>0 -> let min_arc = min_list 
      |_ ->

*)
     


