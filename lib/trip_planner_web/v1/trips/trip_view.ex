defmodule TripPlannerWeb.V1.Trips.TripView do
  use TripPlannerWeb, :view
  alias TripPlanner.TypeConversions.DateTimeConverter
  alias TripPlannerWeb.V1.Trips.ActivityView
  alias TripPlannerWeb.V1.Users.UserView

  def render("trips.json", %{trips: trips}) do
    render_many(trips, __MODULE__, "trip.json", as: :trip)
  end

  def render("trip.json", %{trip: trip}) do
    %{
      id: trip.id,
      name: trip.name,
      description: trip.description,
      start_date: DateTimeConverter.to_integer(trip.start_date),
      end_date: DateTimeConverter.to_integer(trip.end_date),
      owner: render_one(trip.user, UserView, "user.json", as: :user),
      users: render_many(trip.users, UserView, "user.json", as: :user),
      activities: render_many(trip.activities, ActivityView, "activity.json", as: :activity)
    }
  end
end
