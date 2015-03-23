open Core.Std

(** Applies a function f to each element in a stream of Fasta.Item.t derived from the provided
    file; closes the file when done. *)
val with_items : string -> f:(Fasta.Item.t -> unit) -> unit

(** Applies the function f: (Fasta.Item.t * int) -> ()) to a stream of items from the
    provided input file *)
val with_items_indexed : string -> f:(Fasta.Item.t * int -> unit) -> unit

val with_matching_items : string -> p:(Fasta.Item.t * int -> bool) -> f:(Fasta.Item.t * int -> unit) -> unit
