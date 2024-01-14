
let export_csv_assocs assocs =
  let path = "exam_schedule/output/assocs.csv" in
  let ff = open_out path in
  Printf.fprintf ff "Class,Room,Timeslot,Proctor\n";
  match assocs with
  | None -> ()
  | Some ass -> List.iter (fun (a,b,c,d) -> Printf.fprintf ff "%s,%s,%s,%s\n" a b c d) ass;
    close_out ff ;
    ()