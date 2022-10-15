defmodule TripPlannerWeb.V1.Trips.TripViewTest do
  use ExUnit.Case
  alias TripPlanner.TypeConversions.DateTimeConverter
  alias TripPlannerWeb.V1.Trips.TripView
  import TripPlanner.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TripPlanner.Repo)
  end

  test "trips.json" do
    trips = %{trips: insert_list(3, :trip, users: [], activities: [])}
    assert [%{id: _, owner: _}, %{id: _, owner: _}, %{id: _, owner: _}] = TripView.render("trips.json", trips)
  end

  test "trip.json" do
    start_datetime = DateTime.utc_now()
    [%{id: user1_id}, %{id: user2_id}] = users = insert_pair(:user)
    [%{id: activity1_id}, %{id: activity2_id}] = activities = insert_pair(:activity)

    trip =
      insert(:trip,
        name: "test_trip",
        description: "my test trip",
        start_date: start_datetime,
        users: users,
        activities: activities
      )

    expected_start_int = DateTimeConverter.to_integer(start_datetime)

    assert %{
             id: _,
             name: "test_trip",
             description: "my test trip",
             start_date: ^expected_start_int,
             end_date: nil,
             owner: %{id: _, first_name: _, last_name: _, email: _, phone: _, username: _},
             users: [
               %{id: ^user1_id, first_name: _, last_name: _, email: _, phone: _, username: _},
               %{id: ^user2_id, first_name: _, last_name: _, email: _, phone: _, username: _}
             ],
             activities: [
               %{
                 id: ^activity1_id,
                 name: _,
                 website: _,
                 location: _,
                 price_per_person: _,
                 price_per_person_string: _,
                 notes: _,
                 start_date: _,
                 end_date: _
               },
               %{
                 id: ^activity2_id,
                 name: _,
                 website: _,
                 location: _,
                 price_per_person: _,
                 price_per_person_string: _,
                 notes: _,
                 start_date: _,
                 end_date: _
               }
             ]
           } = TripView.render("trip.json", %{trip: trip})
  end
end
