defmodule TripPlanner.Schemas.UserActivityInterestFactory do
  defmacro __using__(_opts) do
    quote do
      def user_activity_interest_factory do
        %TripPlanner.Schemas.UserActivityInterest{
          is_interested: true,
          user: build(:user),
          activity: build(:activity)
        }
      end
    end
  end
end
