defmodule TripPlannerWeb.V1.Trips.ActivityViewTest do
  use ExUnit.Case
  alias TripPlanner.TypeConversions.DateTimeConverter
  alias TripPlannerWeb.V1.Trips.ActivityView
  import TripPlanner.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TripPlanner.Repo)
  end

  test "activity.json" do
    datetime = DateTime.utc_now()
    expected_datetime_int = DateTimeConverter.to_integer(datetime)

    activity =
      insert(:activity,
        name: "test_trip",
        website: "test website",
        location: "test location",
        phone: "test phone",
        price_per_person: Money.new(100, "USD"),
        notes: "test notes",
        start_date: datetime,
        end_date: datetime
      )

    user_id = activity.user.id

    assert %{
             id: _,
             name: "test_trip",
             website: "test website",
             location: "test location",
             phone: "test phone",
             price_per_person: %Money{amount: 100, currency: :USD},
             price_per_person_string: "$1.00",
             notes: "test notes",
             start_date: ^expected_datetime_int,
             end_date: ^expected_datetime_int,
             is_interested: nil,
             user: %{id: ^user_id, first_name: _, last_name: _, email: _, phone: _, username: _}
           } = ActivityView.render("activity.json", %{activity: activity})
  end

  test "activity.json with nil price_per_person" do
    datetime = DateTime.utc_now()
    expected_datetime_int = DateTimeConverter.to_integer(datetime)

    activity =
      insert(:activity,
        name: "test_trip",
        website: "test website",
        location: "test location",
        phone: "test phone",
        price_per_person: nil,
        notes: "test notes",
        start_date: datetime,
        end_date: datetime,
        is_interested: true
      )

    user_id = activity.user.id

    assert %{
             id: _,
             name: "test_trip",
             website: "test website",
             location: "test location",
             phone: "test phone",
             price_per_person: nil,
             price_per_person_string: nil,
             notes: "test notes",
             start_date: ^expected_datetime_int,
             end_date: ^expected_datetime_int,
             is_interested: true,
             user: %{id: ^user_id, first_name: _, last_name: _, email: _, phone: _, username: _}
           } = ActivityView.render("activity.json", %{activity: activity})
  end
end
