defmodule TripPlannerWeb.V1.Trips.ActivityControllerTest do
  use ExUnit.Case
  use TripPlannerWeb.ConnCase

  import TripPlanner.Factory
  alias TripPlanner.TypeConversions.DateTimeConverter

  describe "create" do
    test "authenticated user", %{conn: conn} do
      user = insert(:user)
      user_id = user.id
      trip = insert(:trip, user: user)
      trip_id = trip.id

      params = %{
        name: "test activity",
        website: "test website",
        location: "test location",
        phone: "test phone",
        price_per_person: %{"amount" => 100, "currency" => "USD"},
        notes: "test notes",
        start_date: 1_664_848_505,
        end_date: 1_664_848_505
      }

      conn =
        conn
        |> authenticate(user)
        |> post(Routes.trip_activity_path(conn, :create, trip_id, params))

      assert %{
               "id" => _,
               "name" => "test activity",
               "website" => "test website",
               "location" => "test location",
               "phone" => "test phone",
               "price_per_person" => %{"amount" => 100, "currency" => "USD"},
               "price_per_person_string" => "$1.00",
               "notes" => "test notes",
               "start_date" => 1_664_848_505,
               "end_date" => 1_664_848_505,
               "user" => %{"id" => ^user_id},
               "trip_id" => ^trip_id
             } = json_response(conn, 200)
    end

    @tag capture_log: true
    test "authenticated user; trip doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip_id = Faker.UUID.v4()
      params = %{name: "test activity", start_date: 1_664_848_505}

      conn =
        conn
        |> authenticate(user)
        |> post(Routes.trip_activity_path(conn, :create, trip_id, params))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "unauthenticated user", %{conn: conn} do
      user = insert(:user, jwt_refresh_token: "some_token")
      trip = insert(:trip, user: user)
      trip_id = trip.id
      params = %{name: "test activity", start_date: 1_664_848_505}
      conn = post(conn, Routes.trip_activity_path(conn, :create, trip_id, params))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end

  describe "show" do
    test "authenticated user, and can see the activity; trip exists; activity exists", %{conn: conn} do
      user = insert(:user)
      user_id = user.id
      trip = insert(:trip, user: user)
      trip_id = trip.id
      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          user: user,
          trip: trip
        )

      activity_id = activity.id

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_activity_path(conn, :show, trip.id, activity.id))

      assert %{
               "id" => ^activity_id,
               "name" => "test activity name",
               "website" => "test website",
               "location" => "test location",
               "phone" => "test phone",
               "price_per_person" => %{"amount" => 100, "currency" => "USD"},
               "price_per_person_string" => "$1.00",
               "notes" => "test notes",
               "start_date" => 1_664_848_505,
               "end_date" => 1_664_848_505,
               "user" => %{"id" => ^user_id},
               "trip_id" => ^trip_id
             } = json_response(conn, 200)
    end

    @tag capture_log: true
    test "authenticated user, and can see the activity; trip doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip_id = Faker.UUID.v4()
      activity_id = Faker.UUID.v4()

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_activity_path(conn, :show, trip_id, activity_id))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    @tag capture_log: true
    test "authenticated user, and can see the activity; activity doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip, user: user)
      trip_id = trip.id
      activity_id = Faker.UUID.v4()

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_activity_path(conn, :show, trip_id, activity_id))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    @tag capture_log: true
    test "authenticated user, but cannot see the activity", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip)
      trip_id = trip.id

      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          user: user,
          trip: trip
        )

      activity_id = activity.id

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.trip_activity_path(conn, :show, trip_id, activity_id))

      assert %{"error" => %{"detail" => "Forbidden"}} = json_response(conn, 403)
    end

    test "unauthenticated user", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip)

      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          user: user,
          trip: trip
        )

      conn = get(conn, Routes.trip_activity_path(conn, :show, trip.id, activity.id))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end

  describe "update" do
    test "authenticated user, and can update the activity; trip exists; activity exists", %{conn: conn} do
      user = insert(:user)
      user_id = user.id
      trip = insert(:trip, user: user)
      trip_id = trip.id
      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          user: user,
          trip: trip
        )

      activity_id = activity.id

      params = %{price_per_person: %{amount: 435}}

      conn =
        conn
        |> authenticate(user)
        |> patch(Routes.trip_activity_path(conn, :update, trip.id, activity.id, params))

      assert %{
               "id" => ^activity_id,
               "name" => "test activity name",
               "website" => "test website",
               "location" => "test location",
               "phone" => "test phone",
               "price_per_person" => %{"amount" => 435, "currency" => "USD"},
               "price_per_person_string" => "$4.35",
               "notes" => "test notes",
               "start_date" => 1_664_848_505,
               "end_date" => 1_664_848_505,
               "user" => %{"id" => ^user_id},
               "trip_id" => ^trip_id
             } = json_response(conn, 200)
    end

    @tag capture_log: true
    test "authenticated user, and can update the activity; trip doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip_id = Faker.UUID.v4()
      activity_id = Faker.UUID.v4()
      params = %{price_per_person: %{amount: 435}}

      conn =
        conn
        |> authenticate(user)
        |> patch(Routes.trip_activity_path(conn, :update, trip_id, activity_id, params))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    @tag capture_log: true
    test "authenticated user, and can update the activity; activity doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip, user: user)
      trip_id = trip.id
      activity_id = Faker.UUID.v4()
      params = %{price_per_person: %{amount: 435}}

      conn =
        conn
        |> authenticate(user)
        |> patch(Routes.trip_activity_path(conn, :update, trip_id, activity_id, params))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    @tag capture_log: true
    test "authenticated user, but cannot update the activity", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip)
      trip_id = trip.id

      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          user: user,
          trip: trip
        )

      activity_id = activity.id
      params = %{price_per_person: %{amount: 435}}

      conn =
        conn
        |> authenticate(user)
        |> patch(Routes.trip_activity_path(conn, :update, trip_id, activity_id, params))

      assert %{"error" => %{"detail" => "Forbidden"}} = json_response(conn, 403)
    end

    test "unauthenticated user", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip)

      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          user: user,
          trip: trip
        )

      params = %{price_per_person: %{amount: 435}}
      conn = patch(conn, Routes.trip_activity_path(conn, :update, trip.id, activity.id, params))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end

  describe "delete" do
    test "authenticated user, and can delete the activity; trip exists; activity exists", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip, user: user)
      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          user: user,
          trip: trip
        )

      conn =
        conn
        |> authenticate(user)
        |> delete(Routes.trip_activity_path(conn, :delete, trip.id, activity.id))

      assert response(conn, 204)
    end

    @tag capture_log: true
    test "authenticated user, and can delete the activity; trip doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip_id = Faker.UUID.v4()
      activity_id = Faker.UUID.v4()

      conn =
        conn
        |> authenticate(user)
        |> delete(Routes.trip_activity_path(conn, :delete, trip_id, activity_id))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    @tag capture_log: true
    test "authenticated user, and can delete the activity; activity doesn't exist", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip, user: user)
      trip_id = trip.id
      activity_id = Faker.UUID.v4()

      conn =
        conn
        |> authenticate(user)
        |> delete(Routes.trip_activity_path(conn, :delete, trip_id, activity_id))

      assert %{"error" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    @tag capture_log: true
    test "authenticated user, but cannot delete the activity", %{conn: conn} do
      user = insert(:user)
      trip = insert(:trip)
      trip_id = trip.id

      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          trip: trip
        )

      activity_id = activity.id

      conn =
        conn
        |> authenticate(user)
        |> delete(Routes.trip_activity_path(conn, :delete, trip_id, activity_id))

      assert %{"error" => %{"detail" => "Forbidden"}} = json_response(conn, 403)
    end

    test "unauthenticated user", %{conn: conn} do
      trip = insert(:trip)

      {:ok, dt} = DateTimeConverter.from_timestamp(1_664_848_505)

      activity =
        insert(:activity,
          name: "test activity name",
          website: "test website",
          location: "test location",
          phone: "test phone",
          price_per_person: Money.new(100, :USD),
          notes: "test notes",
          start_date: dt,
          end_date: dt,
          trip: trip
        )

      conn = delete(conn, Routes.trip_activity_path(conn, :delete, trip.id, activity.id))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end
end
