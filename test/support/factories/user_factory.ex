defmodule TripPlanner.Schemas.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %TripPlanner.Schemas.User{
          first_name: Faker.Person.first_name(),
          last_name: Faker.Person.last_name(),
          email: Faker.Internet.email(),
          username: Faker.Internet.user_name(),
          password_hash: Faker.String.base64(20)
        }
      end
    end
  end
end
