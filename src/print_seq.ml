open Core.Std
open Extensions

let print_seq file_name seq_name print_header =
  Fatk.with_items
    (fun stream ->
     let matching_seqs =
       Stream.filter (fun (fa: Fasta.item) -> fa.name = seq_name) stream in
     let handler =
       match print_header with
       | true -> (fun (fa : Fasta.item) ->
                  print_newline fa.name;
                  print_newline fa.sequence)
       | false -> (fun (fa : Fasta.item) ->
                   print_newline fa.sequence) in
     Stream.iter handler matching_seqs) file_name

let cmd =
  Command.basic
    ~summary:"Print selected sequence in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: file)
    +> flag "-n" string ~doc: " sequence name"
    +> flag "-h" no_arg ~doc: " print sequence headers"
  )
  (fun file_name seq_name print_header () -> print_seq file_name seq_name print_header)
                                    
  
