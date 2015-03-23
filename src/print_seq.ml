open Core.Std
open Extensions

let match_name name elt =
  let (item : Fasta.Item.t) = (fst elt) in item.name = name

let match_num num elt =
  let idx = (snd elt) in idx = num

let print_seq file_name seq_name seq_number print_header =
  let p =
    match seq_name, seq_number with
    | Some name, _ -> (match_name name)
    | None, Some num -> (match_num num)
    | _ -> failwith "Either sequence name or sequence number must be specified" in
  let f =
    match print_header with
    | true -> (fun elt -> print_endline (Fasta.to_string (fst elt)))
    | false -> (fun elt ->
                  let fa = fst elt in
                    print_string fa.sequence;
                    print_newline ()) in
  Fatk.with_matching_items file_name ~p ~f

let cmd =
  Command.basic
    ~summary:"Print selected sequence in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: string)
    +> anon (maybe ("seq_name" %: string))
    +> flag "-n" (optional int) ~doc:"seq_num The sequence number to print"
    +> flag "-h" no_arg ~doc: " print sequence headers"
  )
  (fun file_name seq_name seq_number print_header () -> print_seq file_name seq_name seq_number print_header)
