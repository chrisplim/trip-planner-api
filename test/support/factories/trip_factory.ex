defmodule TripPlanner.Schemas.TripFactory do
  defmacro __using__(_opts) do
    quote do
      def trip_factory do
        %TripPlanner.Schemas.Trip{
          name: Faker.String.base64(),
          user: build(:user)
        }
      end
    end
  end
end
