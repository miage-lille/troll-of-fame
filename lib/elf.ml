module Race = struct
  type t =
    | Dark_Elf [@value 1]
    | High_Elf [@value 2]
  [@@deriving show, enum, eq, ord]
end

module Role = struct
  type t =
    | Swordsman [@value 1]
    | Archer [@value 2]
    | Priest [@value 5]
    | Warlock [@value 4]
  [@@deriving show, enum, eq, ord]
end

type t =
  { role : Role.t
  ; race : Race.t
  }
[@@deriving show, eq, ord]

let value elf = Role.to_enum elf.role + Race.to_enum elf.race

let from_pair (role, race) = { race; role }
