open Graph
open Tools

type path = id list

(* From a given graph, returns Some path if a path was found between s and t*)
let find_path gr s t =
  (* Depth-first search algorithm to determine a path from s to t in gr *)
  let rec path_dfs (visited: id list) (acc: path) (s: id) =
    (* Print visited node*)
    (* Printf.printf "node visited: %d \n" s; *)
    if s=t then 
      List.rev(s::acc) (* if s=t, then we found a path from s to t, we return it *)
    else
      let rec loop = function
        |[]->[]
        (* we go deeper*)
        |a::rest -> if (not (List.mem a.tgt visited)) && (a.lbl>0) (* if the node has not been visited we go deeper *)
          then (match (path_dfs (s::visited) (a.src::acc) a.tgt) with
              |[]-> loop rest (* if we did not find a path, we go to the next arc*)
              |p -> p) (* if we found a path, we return it *)
          else loop rest  (* we go to the next arc*)
      in
      loop (out_arcs gr s) 
  in
  (* Transform into option type*)
  match path_dfs [] [] s with
  |[] -> None
  |p -> Some p


(* gets minimal flow from path (id list)*)
let min_flow gr p = 
  List.fold_left (fun acu a -> min acu a.lbl) max_int (arcs_from_nodes gr p)


(* Add flow alongside a path in a given flow graph *)
let update_flows grf path flow = 
  List.fold_left (fun acu a -> add_arc acu a.src a.tgt flow) grf (arcs_from_nodes grf path)

(* match path with
   |[] -> grf
   |_::[] -> grf
   |node1::(node2::rest) -> 
   let graph1 = add_arc grf node1 node2 flow in
   update_flows graph1 (node2::rest) flow *)

(* Returns sum of outarcs flow for a given node *)
let max_flow_node node1 gr =
  List.fold_left (fun acu a -> acu+a.lbl) 0 (out_arcs gr node1)
