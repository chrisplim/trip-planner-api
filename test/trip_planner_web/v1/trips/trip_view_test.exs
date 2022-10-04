defmodule TripPlannerWeb.V1.Trips.TripViewTest do
  use ExUnit.Case
  alias TripPlanner.TypeConversions.DateTimeConverter
  alias TripPlannerWeb.V1.Trips.TripView
  import TripPlanner.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TripPlanner.Repo)
  end

  test "trips.json" do
    trips = %{trips: insert_list(3, :trip)}
    assert [%{id: _, owner: _}, %{id: _, owner: _}, %{id: _, owner: _}] = TripView.render("trips.json", trips)
  end

  test "trip.json" do
    start_datetime = DateTime.utc_now()
    trip = insert(:trip, name: "test_trip", description: "my test trip", start_date: start_datetime)
    expected_start_int = DateTimeConverter.to_integer(start_datetime)

    assert %{
             id: _,
             name: "test_trip",
             description: "my test trip",
             start_date: ^expected_start_int,
             end_date: nil,
             owner: %{id: _, first_name: _, last_name: _, email: _, phone: _, username: _}
           } = TripView.render("trip.json", %{trip: trip})
  end
end
