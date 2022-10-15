defmodule TripPlannerWeb.V1.Trips.ActivityView do
  use TripPlannerWeb, :view
  alias TripPlanner.TypeConversions.DateTimeConverter
  alias TripPlannerWeb.V1.Users.UserView

  def render("activity.json", %{activity: activity}) do
    price_per_person_string =
      if activity.price_per_person do
        Money.to_string(activity.price_per_person)
      else
        nil
      end

    %{
      id: activity.id,
      name: activity.name,
      website: activity.website,
      location: activity.location,
      phone: activity.phone,
      price_per_person: activity.price_per_person,
      price_per_person_string: price_per_person_string,
      notes: activity.notes,
      start_date: DateTimeConverter.to_integer(activity.start_date),
      end_date: DateTimeConverter.to_integer(activity.end_date),
      user: render_one(activity.user, UserView, "user.json", as: :user),
      trip_id: activity.trip_id
    }
  end
end
