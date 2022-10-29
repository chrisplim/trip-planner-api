defmodule TripPlannerWeb.V1.Trips.TripControllerTest do
  use ExUnit.Case
  use TripPlannerWeb.ConnCase

  import TripPlanner.Factory
  alias TripPlanner.TypeConversions.DateTimeConverter

  describe "index" do
    test "authenticated user, owner of trip", %{conn: conn} do
      user = insert(:user)
      user_id = user.id
      %{id: activity_id} = activity = insert(:activity)
      insert(:user_activity_interest, activity: activity, user: user, is_interested: true)
      trip = insert(:trip, user: user, users: [user], activities: [activity])
      trip_id = trip.id
      trip_name = trip.name

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_path(conn, :index))

      assert [
               %{
                 "id" => ^trip_id,
                 "name" => ^trip_name,
                 "description" => nil,
                 "start_date" => nil,
                 "end_date" => nil,
                 "owner" => %{"id" => ^user_id},
                 "users" => [%{"id" => ^user_id}],
                 "activities" => [%{"id" => ^activity_id, "user" => %{}, "is_interested" => true}]
               }
             ] = json_response(conn, 200)
    end

    test "unauthenticated user", %{conn: conn} do
      insert(:user, jwt_refresh_token: "some_token")
      conn = get(conn, Routes.trip_path(conn, :index))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end

  describe "create" do
    test "authenticated user", %{conn: conn} do
      user = insert(:user)
      user_id = user.id
      trip_params = %{name: "test_trip", description: "my test trip", start_date: 1_664_848_505}

      conn =
        conn
        |> authenticate(user)
        |> post(Routes.trip_path(conn, :create, trip_params))

      assert %{
               "id" => _,
               "name" => "test_trip",
               "description" => "my test trip",
               "start_date" => 1_664_848_505,
               "end_date" => nil,
               "owner" => %{"id" => ^user_id},
               "users" => [%{"id" => ^user_id}]
             } = json_response(conn, 200)
    end

    test "unauthenticated user", %{conn: conn} do
      insert(:user, jwt_refresh_token: "some_token")
      trip_params = %{name: "test_trip", description: "my test trip", start_date: 1_664_848_505}
      conn = post(conn, Routes.trip_path(conn, :create, trip_params))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end

  describe "show" do
    test "authenticated user, and can see the trip", %{conn: conn} do
      user = insert(:user)
      user_id = user.id
      {:ok, start_date} = DateTimeConverter.from_timestamp(1_664_848_505)

      [activity1, activity2] = activities = insert_pair(:activity)
      activity1_id = activity1.id
      activity2_id = activity2.id
      insert(:user_activity_interest, activity: activity1, user: user, is_interested: true)

      trip =
        insert(:trip,
          user: user,
          name: "test_trip",
          description: "my test trip",
          start_date: start_date,
          activities: activities
        )

      trip_id = trip.id

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_path(conn, :show, trip.id))

      assert %{
               "id" => ^trip_id,
               "name" => "test_trip",
               "description" => "my test trip",
               "start_date" => 1_664_848_505,
               "end_date" => nil,
               "owner" => %{"id" => ^user_id},
               "users" => [],
               "activities" => [
                 %{"id" => ^activity1_id, "user" => %{}, "is_interested" => true},
                 %{"id" => ^activity2_id, "user" => %{}, "is_interested" => nil}
               ]
             } = json_response(conn, 200)
    end

    @tag capture_log: true
    test "authenticated user, but cannot see the trip", %{conn: conn} do
      user = insert(:user)
      {:ok, start_date} = DateTimeConverter.from_timestamp(1_664_848_505)

      trip =
        insert(:trip,
          name: "test_trip",
          description: "my test trip",
          start_date: start_date
        )

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_path(conn, :show, trip.id))

      assert %{"error" => %{"detail" => "Forbidden"}} = json_response(conn, 403)
    end

    @tag capture_log: true
    test "authenticated user, but trip doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip_id = Faker.UUID.v4()

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_path(conn, :show, trip_id))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "unauthenticated user", %{conn: conn} do
      user = insert(:user, jwt_refresh_token: "some_token")

      {:ok, start_date} = DateTimeConverter.from_timestamp(1_664_848_505)

      trip =
        insert(:trip,
          user: user,
          name: "test_trip",
          description: "my test trip",
          start_date: start_date
        )

      conn = get(conn, Routes.trip_path(conn, :show, trip.id))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end

  describe "update" do
    test "authenticated user, and can update the trip", %{conn: conn} do
      user = insert(:user)
      user_id = user.id

      [activity1, activity2] = activities = insert_pair(:activity)
      activity1_id = activity1.id
      activity2_id = activity2.id
      insert(:user_activity_interest, activity: activity1, user: user, is_interested: true)
      insert(:user_activity_interest, activity: activity2, user: user, is_interested: false)

      trip = insert(:trip, users: [user], activities: activities)
      trip_id = trip.id

      trip_params = %{
        name: "new trip name",
        description: "new trip description",
        start_date: 1_664_848_505,
        end_date: 1_664_848_505
      }

      conn =
        conn
        |> authenticate(user)
        |> put(Routes.trip_path(conn, :update, trip.id, trip_params))

      assert %{
               "id" => ^trip_id,
               "name" => "new trip name",
               "description" => "new trip description",
               "start_date" => 1_664_848_505,
               "end_date" => 1_664_848_505,
               "owner" => %{"id" => _},
               "users" => [%{"id" => ^user_id}],
               "activities" => [
                 %{"id" => ^activity1_id, "user" => %{}, "is_interested" => true},
                 %{"id" => ^activity2_id, "user" => %{}, "is_interested" => false}
               ]
             } = json_response(conn, 200)
    end

    @tag capture_log: true
    test "authenticated user, but cannot update the trip", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip)

      trip_params = %{
        name: "new trip name",
        description: "new trip description",
        start_date: 1_664_848_505,
        end_date: 1_664_848_505
      }

      conn =
        conn
        |> authenticate(user)
        |> put(Routes.trip_path(conn, :update, trip.id, trip_params))

      assert %{"error" => %{"detail" => "Forbidden"}} = json_response(conn, 403)
    end

    @tag capture_log: true
    test "authenticated user, but trip doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip_id = Faker.UUID.v4()

      trip_params = %{
        name: "new trip name",
        description: "new trip description",
        start_date: 1_664_848_505,
        end_date: 1_664_848_505
      }

      conn =
        conn
        |> authenticate(user)
        |> put(Routes.trip_path(conn, :update, trip_id, trip_params))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "unauthenticated user", %{conn: conn} do
      trip = insert(:trip)

      trip_params = %{
        name: "new trip name",
        description: "new trip description",
        start_date: 1_664_848_505,
        end_date: 1_664_848_505
      }

      conn = put(conn, Routes.trip_path(conn, :update, trip.id, trip_params))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end

  describe "delete" do
    test "authenticated user, and can delete the trip", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip, user: user)

      conn =
        conn
        |> authenticate(user)
        |> delete(Routes.trip_path(conn, :delete, trip.id))

      assert response(conn, 204)
    end

    @tag capture_log: true
    test "authenticated user, but cannot delete the trip", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip, users: [user])

      conn =
        conn
        |> authenticate(user)
        |> delete(Routes.trip_path(conn, :delete, trip.id))

      assert %{"error" => %{"detail" => "Forbidden"}} = json_response(conn, 403)
    end

    @tag capture_log: true
    test "authenticated user, but trip doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip_id = Faker.UUID.v4()

      conn =
        conn
        |> authenticate(user)
        |> delete(Routes.trip_path(conn, :delete, trip_id))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "unauthenticated user", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip, user: user)

      conn = delete(conn, Routes.trip_path(conn, :delete, trip.id))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end
end
