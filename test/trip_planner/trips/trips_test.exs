defmodule TripPlanner.Trips.TripsTest do
  use TripPlanner.DataCase
  import TripPlanner.Factory
  alias TripPlanner.Trips.Trips
  alias TripPlanner.Schemas.Activity
  alias TripPlanner.Schemas.Trip
  alias TripPlanner.Schemas.User

  describe "create_trip" do
    @valid_attrs %{
      "name" => "trip name",
      "description" => "trip description",
      "start_date" => DateTime.utc_now(),
      "end_date" => DateTime.utc_now()
    }

    @invalid_attrs %{"name" => 123, "description" => 123}

    test "valid attrs; no dates" do
      user = insert(:user)
      user_id = user.id
      attrs = @valid_attrs |> Map.delete("start_date") |> Map.delete("end_date")

      assert {:ok,
              %Trip{
                name: "trip name",
                description: "trip description",
                start_date: nil,
                end_date: nil,
                owner_id: ^user_id,
                user: %User{id: ^user_id},
                users: [%User{id: ^user_id}],
                activities: []
              }} = Trips.create_trip(user, attrs)
    end

    test "valid attrs; with dates" do
      user = insert(:user)
      user_id = user.id
      time_integer = 1_664_939_105
      attrs = @valid_attrs |> Map.put("start_date", time_integer) |> Map.put("end_date", time_integer)

      expected_datetime = DateTime.from_unix!(time_integer)

      assert {:ok,
              %Trip{
                name: "trip name",
                description: "trip description",
                start_date: ^expected_datetime,
                end_date: ^expected_datetime,
                owner_id: ^user_id,
                user: %User{id: ^user_id},
                users: [%User{id: ^user_id}]
              }} = Trips.create_trip(user, attrs)
    end

    test "invalid attrs" do
      user = insert(:user)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  name: {"is invalid", [type: :string, validation: :cast]},
                  description: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Trips.create_trip(user, @invalid_attrs)
    end
  end

  describe "get_trip_with_activities_preloads" do
    test "trip exists" do
      user = insert(:user)
      start_date = DateTime.utc_now()

      [%{id: activity1_id} = activity1, %{id: activity2_id}, %{id: activity3_id}, %{id: activity4_id}] =
        activities = [
          insert(:activity, start_date: start_date, name: "c"),
          insert(:activity, start_date: start_date, name: "d"),
          insert(:activity, start_date: nil, name: "a"),
          insert(:activity, start_date: nil, name: "b")
        ]

      insert(:user_activity_interest, activity: activity1, user: user, is_interested: true)
      trip = insert(:trip, activities: activities)
      trip_id = trip.id

      assert {:ok,
              %Trip{
                id: ^trip_id,
                users: [],
                user: %User{},
                activities: [
                  %Activity{id: ^activity1_id, user: %User{}, is_interested: true},
                  %Activity{id: ^activity2_id, user: %User{}, is_interested: nil},
                  %Activity{id: ^activity3_id, user: %User{}, is_interested: nil},
                  %Activity{id: ^activity4_id, user: %User{}, is_interested: nil}
                ]
              }} = Trips.get_trip_with_activities_preloads(user, trip_id)
    end

    test "trip doesn't exist" do
      user = insert(:user)
      trip_id = Faker.UUID.v4()
      assert {:error, :not_found} = Trips.get_trip_with_activities_preloads(user, trip_id)
    end
  end

  describe "get_trip" do
    test "trip exists" do
      activities = insert_pair(:activity)
      trip = insert(:trip, activities: activities)
      trip_id = trip.id

      assert {:ok, %Trip{id: ^trip_id, users: [], user: %User{}}} = Trips.get_trip(trip_id)
    end

    test "trip doesn't exist" do
      trip_id = Faker.UUID.v4()
      assert {:error, :not_found} = Trips.get_trip(trip_id)
    end
  end

  describe "get_all_trips_including_user" do
    test "user has no associated trips" do
      user = insert(:user)
      assert {:ok, []} = Trips.get_all_trips_including_user(user)
    end

    test "user is the owner of a trip" do
      user = insert(:user)
      activities = insert_pair(:activity)
      trip = insert(:trip, user: user, activities: activities)
      trip_id = trip.id
      assert {:ok, [%Trip{id: ^trip_id, activities: [_, _]}]} = Trips.get_all_trips_including_user(user)
    end

    test "user is the participant of a trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      trip_id = trip.id
      assert {:ok, [%Trip{id: ^trip_id}]} = Trips.get_all_trips_including_user(user)
    end

    test "user is the owner and participant of a few different trips" do
      user = insert(:user)
      second_user = insert(:user)

      start_date = DateTime.utc_now()
      inserted_at = DateTime.utc_now()

      %{id: trip1_id} =
        insert(:trip, user: user, users: [second_user], start_date: start_date, name: "b", inserted_at: inserted_at)

      %{id: trip2_id} = insert(:trip, users: [user, second_user], name: "a")

      [%{id: activity1_id} = activity1, %{id: activity2_id}, %{id: activity3_id}] =
        activities = [
          insert(:activity, start_date: nil, name: "1"),
          insert(:activity, start_date: nil, name: "2"),
          insert(:activity, start_date: start_date, name: "3")
        ]

      insert(:user_activity_interest, activity: activity1, user: user, is_interested: true)

      %{id: trip3_id} =
        insert(:trip,
          users: [user, second_user],
          start_date: start_date,
          name: "b",
          inserted_at: DateTime.add(inserted_at, 1),
          activities: activities
        )

      # User isn't in trip4
      _trip4 = insert(:trip, users: [second_user])

      assert {:ok,
              [
                %Trip{id: ^trip1_id},
                %Trip{
                  id: ^trip3_id,
                  activities: [
                    %Activity{id: ^activity3_id, is_interested: nil},
                    %Activity{id: ^activity1_id, is_interested: true},
                    %Activity{id: ^activity2_id, is_interested: nil}
                  ]
                },
                %Trip{id: ^trip2_id}
              ]} = Trips.get_all_trips_including_user(user)
    end
  end

  describe "update_trip" do
    test "valid attrs; no dates" do
      user = insert(:user)
      activities = insert_pair(:activity)

      trip =
        insert(:trip, activities: activities, name: "update trip test name", description: "update trip test description")

      attrs = @valid_attrs |> Map.delete("start_date") |> Map.delete("end_date")

      assert {:ok,
              %Trip{
                name: "trip name",
                description: "trip description",
                start_date: nil,
                end_date: nil,
                owner_id: _,
                user: %User{},
                users: [],
                activities: [%Activity{user: %User{}, is_interested: nil}, _]
              }} = Trips.update_trip(user, trip, attrs)
    end

    test "valid attrs; with dates" do
      user = insert(:user)
      trip = insert(:trip, name: "update trip test name", description: "update trip test description")
      time_integer = 1_664_939_105
      attrs = @valid_attrs |> Map.put("start_date", time_integer) |> Map.put("end_date", time_integer)

      expected_datetime = DateTime.from_unix!(time_integer)

      assert {:ok,
              %Trip{
                name: "trip name",
                description: "trip description",
                start_date: ^expected_datetime,
                end_date: ^expected_datetime,
                owner_id: _,
                user: %User{},
                users: []
              }} = Trips.update_trip(user, trip, attrs)
    end

    test "invalid attrs" do
      user = insert(:user)
      trip = insert(:trip, name: "update trip test name", description: "update trip test description")

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  name: {"is invalid", [type: :string, validation: :cast]},
                  description: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Trips.update_trip(user, trip, @invalid_attrs)
    end

    test "trip doesn't exist" do
      user = insert(:user)
      trip = %Trip{id: Faker.UUID.v4()}

      assert_raise Ecto.StaleEntryError, fn ->
        Trips.update_trip(user, trip, @valid_attrs)
      end
    end
  end

  describe "delete_trip" do
    test "trip exists" do
      trip = insert(:trip)
      trip_id = trip.id

      assert {:ok, %Trip{id: ^trip_id}} = Trips.delete_trip(trip)
    end

    test "trip doesn't exist" do
      trip = %Trip{id: Faker.UUID.v4()}

      assert_raise Ecto.StaleEntryError, fn ->
        Trips.delete_trip(trip)
      end
    end
  end
end
