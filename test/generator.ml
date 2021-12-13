open QCheck2.Gen
open TOF

module type MFantasy = sig
  val elf_gen : Elf.t t

  val elf_high_gen : Elf.t t

  val elf_print : Elf.t -> string

  val troll_gen : Troll.t t

  val troll_elf_gen : (Troll.t * Elf.t) t

  val troll_elf_int_gen : (Troll.t * Elf.t * int) t

  val troll_two_elves_gen : (Troll.t * Elf.t * Elf.t) t

  val troll_print : Troll.t -> string
end

module Fantasy : MFantasy = struct
  let elf_gen =
    let open Elf in
    pair
      (oneofl Role.[ Swordsman; Archer; Warlock; Priest ])
      (oneofl Race.[ High_Elf; Dark_Elf ])
    >|= fun pair -> from_pair pair


  let elf_high_gen =
    let open Elf in
    pair
      (oneofl Role.[ Swordsman; Archer; Warlock; Priest ])
      (pure Race.High_Elf)
    >|= fun pair -> from_pair pair


  let elf_print elf =
    Elf.show elf ^ " = " ^ (Elf.value elf |> string_of_int)
    |> QCheck2.Print.string


  let name_gen = string_printable

  let kill_gen =
    pair elf_gen nat
    >|= fun pair ->
    let key, value = pair in
    Troll.ElvesMap.update
      key
      (Troll.optional_add (Some value))
      Troll.ElvesMap.empty


  let killed_merger acc v =
    Troll.ElvesMap.merge
      (fun k x y ->
        match (x, y) with
        | Some xo, Some yo -> Some (xo + yo)
        | None, Some _ -> y
        | Some _, None -> x
        | _ -> None )
      acc
      v


  let list_killed_to_map_killed kills =
    List.fold_left killed_merger Troll.ElvesMap.empty kills


  let troll_gen =
    pair name_gen (list kill_gen)
    >|= fun (name, kills) ->
    let open Troll in
    { name; kills = list_killed_to_map_killed kills }


  let troll_print troll = Troll.show troll |> QCheck2.Print.string

  let troll_elf_gen = pair troll_gen elf_gen

  let troll_elf_int_gen = triple troll_gen elf_gen small_nat

  let troll_two_elves_gen = triple troll_gen elf_gen elf_gen
end
