module MultipleDispatchKoans

struct Dog
  name::String
end

struct Cat
  name::String
end

hello() =
  "hello stranger"

hello(name) =
  "hello $(name)"

pet_talk(pet::Dog) =
  "$(pet.name): bark"

pet_talk(pet::Cat) =
  "$(pet.name): meow"

end
