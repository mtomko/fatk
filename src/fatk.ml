open Core.Std
open Extensions

let with_items file_name ~f =
  let stream_fn inc =
    let is = Fasta.fasta_stream_of_channel inc
    in Stream.iter f is
  in In_channel.with_file ~f:stream_fn file_name

let with_items_indexed file_name ~f =
  let stream_fn inc =
    let fasta_stream = Fasta.fasta_stream_of_channel inc in
    let indexed_stream = Stream.zip_with_index ~base:1 fasta_stream in
    Stream.iter f indexed_stream
  in In_channel.with_file ~f:stream_fn file_name

let with_matching_items file_name ~p ~f =
  let stream_fn inc =
    let fasta_stream = Fasta.fasta_stream_of_channel inc in
    let indexed_stream = Stream.zip_with_index ~base:1 fasta_stream in
    let matching_stream = Stream.filter ~pred:p ~stream:indexed_stream in
    Stream.iter f matching_stream
  in In_channel.with_file ~f:stream_fn file_name

let match_name name elt =
  let (item : Fasta.Item.t) = (fst elt) in item.name = name

let match_num num elt =
  let idx = (snd elt) in idx = num

let matcher seq_name seq_number =
  match seq_name, seq_number with
  | Some name, _ -> (match_name name)
  | None, Some num -> (match_num num)
  | _ -> failwith "Either sequence name or sequence number must be specified"
