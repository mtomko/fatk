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
    let indexed_stream = Stream.zip_with_index fasta_stream in
    Stream.iter f indexed_stream
  in In_channel.with_file ~f:stream_fn file_name

let with_matching_items file_name ~p ~f =
  let stream_fn inc =
    let fasta_stream = Fasta.fasta_stream_of_channel inc in
    let indexed_stream = Stream.zip_with_index fasta_stream in
    let matching_stream = Stream.filter ~pred:p ~stream:indexed_stream in
    Stream.iter f indexed_stream
  in In_channel.with_file ~f:stream_fn file_name
