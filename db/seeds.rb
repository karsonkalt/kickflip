#Helper methods
# def generate_random_user
#     random_user = rand(User.maximum(:id))
#     User.find_by(id: random_user) ? random_user : generate_random_user
# end

# def generate_random_park
#     random_park = rand(Park.maximum(:id))
#     Park.find_by(id: random_park) ? random_park : generate_random_park
# end

# 100.times do
#     username = Faker::Internet.username(specifier: 5..11)
#     attribute_hash = {username: username}
#     User.create(attribute_hash)
# end

# Activate to create Random Skate Parks, not valid with geocoder gem.
# 30.times do
#     faker = Faker::Address.full_address
#     address = faker.split(", ")
#     address[2] = address[2].split(" ")[0]
#     attribute_hash = {name: address[1] + " Skate Park", street: address[0], city:address[1], state: address[2]}
#     Park.create(attribute_hash)
# end

# 300.times do
#     attribute_hash = {user_id: generate_random_user, park_id: generate_random_park}
#     SkateSession.create(attribute_hash)
# end

#PowerUsers
# 5.times do
#     attribute_hash = {user_id: generate_random_user, park_id: generate_random_park}
#     58.times do
#         SkateSession.create(attribute_hash)
#     end
# end

# User.all.each do |user|
#     Trick.all.each do |trick|
#         if rand(2) == 1
#             UserTrick.create(user_id: user.id, trick_id: trick.id)
#         end
#     end
# end