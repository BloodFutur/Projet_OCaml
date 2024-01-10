open Graph

type path = string


let read_class line counter =
  try Scanf.sscanf line "c %s %d" (fun s d -> (s, d, counter))
  with e ->
    Printf.printf "Cannot read class in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

let read_room line counter = 
  try Scanf.sscanf line "r %s %d" (fun s d -> (s, d, counter))
  with e ->
    Printf.printf "Cannot read room in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
    
let read_time line counter =
  try Scanf.sscanf line "t %s" (fun s -> (s, counter))
  with e ->
    Printf.printf "Cannot read time in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
  
let read_proctor line counter =
  try Scanf.sscanf line "p %s" (fun s -> (s, counter))
  with e ->
    Printf.printf "Cannot read proctor in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
  

let read_comment line =
  try Scanf.sscanf line " %%" ()
  with _ ->
    Printf.printf "Unknown line:\n%s\n%!" line ;
    failwith "from_file"

let print_3tuple = function
  | (a,b,c) -> Printf.printf "(%s,%d,%d)" a b c
  

let print_2tuple = function
  | (a,b) -> Printf.printf "(%s,%d)" a b


let make_graph list_class list_room list_time list_proctor = 
  Printf.printf "class list:";
  List.iter print_3tuple list_class;
  Printf.printf "room list:";
  List.iter print_3tuple list_room;
  Printf.printf "time list:";
  List.iter print_2tuple list_time;
  Printf.printf "proctor list";
  List.iter print_2tuple list_proctor;

  empty_graph
  

let from_efile path = 
  let infile = open_in path in 

  let rec loop graph counter list_class list_room list_time list_proctor =
    try 
      let line = input_line infile in
    
        if line="" then loop graph counter list_class list_room list_time list_proctor
        else match line.[0] with
        |'c' -> loop graph (counter+1) ((read_class line counter)::list_class) list_room list_time list_proctor
        |'r' -> loop graph (counter+1) list_class ((read_room line counter)::list_room) list_time list_proctor
        |'t' -> loop graph (counter+1) list_class list_room ((read_time line counter)::list_time) list_proctor
        |'p' -> loop graph (counter+1) list_class list_room list_time ((read_proctor line counter)::list_proctor)
        |_-> read_comment line; loop graph counter list_class list_room list_time list_proctor
      

      with End_of_file -> make_graph list_class list_room list_time list_proctor



      in
      let final_graph = loop empty_graph 0 [] [] [] []
    in
    close_in infile;
    final_graph
     