defmodule TripPlannerWeb.TripView do
  use TripPlannerWeb, :view

  def render("trips.json", %{trips: trips}) do
    render_many(trips, __MODULE__, "trip.json", as: :trip)
  end

  def render("trip.json", %{trip: trip}) do
    %{
      id: trip.id,
      name: trip.name,
      description: trip.description,
      start_date: trip.start_date,
      end_date: trip.end_date,
      owner: render_one(trip.user, TripPlannerWeb.UserView, "user.json", as: :user)
    }
  end
end
