defmodule TripPlanner.Schemas.ActivityFactory do
  defmacro __using__(_opts) do
    quote do
      def activity_factory do
        %TripPlanner.Schemas.Activity{
          name: Faker.String.base64(),
          user: build(:user),
          trip: build(:trip)
        }
      end
    end
  end
end
