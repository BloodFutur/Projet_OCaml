open Gfile
open Tools
open Gfile_exam
open Exam
    
let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

(*
  let graph = from_file infile in
  let path = find_path_bfs (gmap graph int_of_string) _source _sink in
  match path with
  |None -> Printf.printf "oups"
  |Some p -> print_list p;
 *)

  (* Open file *)
  let graph = from_efile infile in
  let f,g = exam graph _source _sink in 
    Printf.printf "max flow: %d" f;
    export outfile (gmap g string_of_int);
  (*
  Printf.printf "\nPrint graph nodes:";
  n_iter graph (fun id -> Printf.printf "%d " id);
  let mqxfloz = ford_fulkerson graph _source _sink in
  match mqxfloz with
  | f -> Printf.printf "max flow: %d" f;

  *)
  (* Test 1: *)
  (* let test1 = clone_nodes graph in *)

  (* Test 2: *)
  (* let test2 = gmap graph (fun a -> a ^ "coucou") in *)

  (* Test 3: to test with graph1 *)
  
(*   let test3 = gmap (add_arc (gmap graph int_of_string) 1 3 69) string_of_int in
 *)
  (*let test_path = find_path (gmap graph int_of_string) [] 0 12 in
  match test_path with 
  |Some a -> print_list a; Printf.printf "flow: %d" (min_flow (gmap graph int_of_string) max_int a)
  |None -> Printf.printf "non"
  *)
  (*
 let testff = ford_fulkerson (gmap graph int_of_string) _source _sink in
  match testff with
  |x ->  Printf.printf "ff: %d" x ;
 
*)
  (* Rewrite the graph that has been read. *)
  (*
  let () = export outfile (gmap graph string_of_int) in

  () 
  *)
