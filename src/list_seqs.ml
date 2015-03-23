open Core.Std
open Extensions

let list_seqs file_name print_lengths print_indexes =
  let item_handler (elt : (Fasta.Item.t * int)) =
    match elt with
    | (item, idx) ->
      begin if print_indexes then
        (print_int idx; print_string "\t")
      end;
      print_string item.name;
      begin if print_lengths then
        (print_string "\t"; print_int (String.length item.sequence))
      end;
      print_newline()
    in Fatk.with_items_indexed ~f:item_handler file_name


let cmd =
  Command.basic
    ~summary:"List the sequences in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: file)
    +> flag "-l" no_arg ~doc: " list sequence lengths"
    +> flag "-i" no_arg ~doc: " print sequence indexes"
  )
  (fun file_name print_lengths print_indexes () ->
    list_seqs file_name print_lengths print_indexes)
