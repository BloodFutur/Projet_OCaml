open Graph

let clone_nodes (gr: 'a graph) = n_fold gr new_node empty_graph

(* It folds over edges of the given graph and applies the function f, from an arc-empty copy*)
let gmap (gr: 'a graph) (f: 'a -> 'b) = e_fold gr (fun g e -> new_arc g {e with lbl=(f e.lbl)}) (clone_nodes gr)


(* Add n to the value fo the arc betwen id1 and id2. If the arc does not exist, it is created*)
let add_arc (gr: 'a graph) (id1: id) (id2: id) (n: int) =  match (find_arc gr id1 id2) with
  |None -> new_arc gr {src=id1 ; tgt=id2 ; lbl=n}
  |Some arc -> new_arc gr {arc with lbl=(arc.lbl + n)}

let rec print_list = function 
  | [] -> ()
  | e::l -> print_int e ; print_string " " ; print_list l


let arcs_from_nodes gr nlist =
  let rec loop alist = function
    | [] -> alist
    | _::[] -> alist
    | n1::n2::tl -> 
      match find_arc gr n1 n2 with
      | None -> loop ({src=n1;tgt=n2;lbl=0}::alist) (n2::tl) (* If the arc does not exist, we create it with a weight of 0 *)
      | Some arc -> loop (arc::alist) (n2::tl)
  in loop [] nlist