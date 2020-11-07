open QCheck.Gen
open TOF

module type MFantasy = sig
  val elf_arbitrary : Elf.t QCheck.arbitrary

  val elf_high_arbitrary : Elf.t QCheck.arbitrary

  val troll_arbitrary : Troll.t QCheck.arbitrary

  val troll_elf_arbitrary : (Troll.t * Elf.t) QCheck.arbitrary

  val troll_elf_int_arbitrary : (Troll.t * Elf.t * int) QCheck.arbitrary

  val troll_two_elves_arbitrary : (Troll.t * Elf.t * Elf.t) QCheck.arbitrary
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
    |> QCheck.Print.string


  let elf_arbitrary = QCheck.make ~print:elf_print elf_gen

  let elf_high_arbitrary = QCheck.make ~print:elf_print elf_high_gen

  let name_gen = string ~gen:QCheck.Gen.printable

  let kill_gen =
    pair elf_gen nat
    >|= fun pair ->
    let key, value = pair in
    Troll.ElvesMap.update
      key
      (Troll.optional_add (Some value [@explicit_arity]))
      Troll.ElvesMap.empty


  let killed_merger acc v =
    Troll.ElvesMap.merge
      (fun k x y ->
        match (x, y) with
        | Some xo, Some yo -> Some (xo + yo)
        | None, Some _ -> y
        | Some _, None -> x
        | _ -> None)
      acc
      v


  let list_killed_to_map_killed kills =
    List.fold_left killed_merger Troll.ElvesMap.empty kills


  let troll_gen =
    pair name_gen (QCheck.Gen.list kill_gen)
    >|= fun (name, kills) ->
    let open Troll in
    { name; kills = list_killed_to_map_killed kills }


  let troll_print troll = Troll.show troll |> QCheck.Print.string

  let troll_arbitrary = QCheck.make ~print:troll_print troll_gen

  let troll_elf_arbitrary = QCheck.pair troll_arbitrary elf_arbitrary

  let troll_elf_int_arbitrary =
    QCheck.triple troll_arbitrary elf_arbitrary QCheck.small_nat


  let troll_two_elves_arbitrary =
    QCheck.triple troll_arbitrary elf_arbitrary elf_arbitrary
end
