module MultipleDispatchKoans

struct Dog
    name::String
end

struct Cat
    name::String
end

function hello()
end

function hello(name)
end

function pet_talk(pet::Dog)
end

function pet_talk(pet::Cat)
end

end
