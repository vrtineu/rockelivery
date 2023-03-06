# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rockelivery.Repo.insert!(%Rockelivery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rockelivery.{Repo, User, Item, Order}

IO.puts("Seeding database...")

user = %User{
  age: 25,
  address: "Rua das Flores, 123",
  cpf: "12345678901",
  cep: "12345678",
  city: "São Paulo",
  email: "john@doe.com",
  name: "John Doe",
  password: "123456",
  uf: "SP"
}

%User{id: user_id} = Repo.insert!(user)

IO.puts("User created!")

item1 = %Item{
  category: :food,
  description: "Pizza",
  price: Decimal.new("39.90"),
  photo: "/priv/photos/pizza.jpg"
}

item2 = %Item{
  category: :food,
  description: "Hamburguer",
  price: Decimal.new("19.90"),
  photo: "/priv/photos/hamburguer.jpg"
}

item3 = %Item{
  category: :drink,
  description: "Coca-cola",
  price: Decimal.new("5.90"),
  photo: "/priv/photos/coca-cola.jpg"
}

Repo.insert!(item1)
Repo.insert!(item2)
Repo.insert!(item3)

IO.puts("Items created!")

order = %Order{
  user_id: user_id,
  items: [item1, item2, item3],
  address: "Rua das Flores, 123",
  comments: "Pode deixar na portaria",
  payment_method: :credit_card
}

Repo.insert!(order)
IO.puts("Order created!")
IO.puts("Database seeded!")
