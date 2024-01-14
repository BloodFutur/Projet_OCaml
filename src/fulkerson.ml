open Graph
open Tools
open Fulkersontools

type path = id list

(*
  Ford-Fulkerson algorithm
  Input: a graph gr, a source node s and a sink node t
  Output: the maximum flow from s to t and flow graph *)
let ford_fulkerson (gr_cp: 'a graph) (s: id) (t: id) =
  (* initialize an identical graph with 0 flow on all arcs *)
  let gr_flow = e_fold gr_cp (fun acc a -> new_arc acc {src=a.src ;  tgt=a.tgt ;  lbl=0}) (clone_nodes gr_cp)
  in 
  (* loop on possible paths from s to t*)
  let rec loop_paths grc grf = match find_path grc s t with
    |None -> (max_flow_node s grf, grf) (* termination condition: return flow + flow graph *)
    |Some p -> 
      (* find the minimum possible flow on a given path *)
      let capacity = min_flow grc p in

      (* print chosen path and its capacity*)
      (* Printf.printf "path: ";
         print_list p;
         Printf.printf "capacity: %d \n" capacity; *)

      (* update flow and capacities graphs *)
      let grf_update = update_flows grf p capacity in
      let grc_update1 = update_flows grc p (-capacity) in
      let grc_update2 = update_flows grc_update1 (List.rev p) capacity in
      loop_paths grc_update2 grf_update
  in
  loop_paths gr_cp gr_flow
