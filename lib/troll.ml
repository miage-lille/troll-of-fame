type score = int

type kill = int

module ElvesMap = Map.Make (Elf)

module Killed = struct
  let kills_to_string : kill ElvesMap.t -> string =
   fun ks ->
    ElvesMap.fold (fun k v accum -> Elf.show k ^ " : " ^ string_of_int v) ks ""


  type t =
    (kill ElvesMap.t
    [@printer fun fmt k -> Format.pp_print_string fmt (kills_to_string k)])
  [@@deriving show]
end

type t =
  { name : string
  ; kills : Killed.t
  }
[@@deriving show]

let scoring : t -> score =
 fun troll -> ElvesMap.fold (fun k v accum -> Elf.value k * v) troll.kills 0


let update_elves_killed : (kill option -> kill option) -> Elf.t -> t -> t =
 fun modifier elf troll ->
  { name = troll.name; kills = ElvesMap.update elf modifier troll.kills }


let optional_add : kill option -> kill option -> kill option =
 fun a b ->
  let sum =
    match (a, b) with
    | Some x, None -> x
    | Some x, Some y -> x + y
    | None, Some y -> y
    | None, None -> 0
  in
  if sum > 0 then Some sum else None


let i_got num = update_elves_killed (optional_add (Some num))

let i_got_one : Elf.t -> t -> t = i_got 1

let oops_he_survived : Elf.t -> t -> t = i_got (-1)

let all_elves_of_a_kind_resurrected : Elf.t -> t -> t =
 fun elf troll ->
  let without_resurected = ElvesMap.remove elf troll.kills in
  { name = troll.name; kills = without_resurected }


let all_elves_resurrected : t -> t =
 fun troll -> { name = troll.name; kills = ElvesMap.empty }
