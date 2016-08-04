open Core_kernel.Std
open Extensions
open Re2

module Item = struct
  type t = {
    name : string;
    sequence : string;
  }
end

(* regex for the header line of a FASTA file *)
let sequence_name_re = Regex.create_exn "^>(.*)$"

(* helper function to pull the capturing group from a match *)
let extract_re_exn re = Regex.find_first_exn ~sub:(`Index 1) re

(* predicate matching lines that aren't FASTA headers *)
let not_header l = not (Regex.matches sequence_name_re l)

(* Creates a FASTA item stream from the input channel *)
let fasta_stream_of_channel channel =
  let line_stream =
    Stream.from (fun _ -> In_channel.input_line channel) in
  let fasta_stream_fn _ =
    try
      let header = Stream.next line_stream in
      let name = extract_re_exn sequence_name_re header in
      if Regex.matches sequence_name_re header then
        let lines = Stream.take_while ~pred:not_header ~stream:line_stream in
        let data = String.concat lines in
        Some { Item.name ; sequence = data }
      else None
    with Stream.Failure -> None in
  Stream.from fasta_stream_fn

let list_partition_n l n =
  let rec loop ls acc =
    match ls with
    | [] -> List.rev acc
    | _ -> let (l1, l2) = List.split_n ls n in
           loop l2 (l1 :: acc) in
  loop l []

let string_split_n s n =
  let l : char list = String.to_list s in
  let ls : char list list = list_partition_n l n in
  List.map ~f:(fun l -> String.of_char_list l) ls

let to_string ?width t =
  let width = match width with None -> 60 | Some w -> w in
  let header = String.concat [">"; t.Item.name] in
  let sequence =  t.Item.sequence in
  let sequence_blocks = string_split_n sequence width in
  let sequence_blocked = String.concat ~sep:"\n" sequence_blocks in
  String.concat ~sep:"\n" [header; sequence_blocked]

let get_sequence t = t.Item.sequence
