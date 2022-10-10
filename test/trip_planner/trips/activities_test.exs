defmodule TripPlanner.Trips.ActivitiesTest do
  use TripPlanner.DataCase
  import TripPlanner.Factory
  alias TripPlanner.Schemas.Activity
  alias TripPlanner.Schemas.Trip
  alias TripPlanner.Schemas.User
  alias TripPlanner.Trips.Activities

  describe "create_activity" do
    @valid_attrs %{
      "name" => "activity name",
      "website" => "test website",
      "location" => "test location",
      "phone" => "test phone",
      "notes" => "test notes",
      "price_per_person" => Money.new(100, "USD"),
      "start_date" => 1_665_287_480,
      "end_date" => 1_665_287_480
    }

    test "valid attrs" do
      user = insert(:user)
      user_id = user.id
      trip = insert(:trip)
      trip_id = trip.id

      assert {:ok,
              %Activity{
                name: "activity name",
                website: "test website",
                location: "test location",
                phone: "test phone",
                notes: "test notes",
                price_per_person: %Money{amount: 100, currency: :USD},
                start_date: ~U[2022-10-09 03:51:20Z],
                end_date: ~U[2022-10-09 03:51:20Z],
                user: %User{id: ^user_id},
                trip: %Trip{id: ^trip_id}
              }} = Activities.create_activity(user, trip, @valid_attrs)
    end

    test "missing required name field" do
      user = insert(:user)
      trip = insert(:trip)
      attrs = Map.delete(@valid_attrs, "name")

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  name: {"can't be blank", [validation: :required]}
                ]
              }} = Activities.create_activity(user, trip, attrs)
    end

    test "name incorrect type" do
      user = insert(:user)
      trip = insert(:trip)
      attrs = Map.put(@valid_attrs, "name", 123)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  name: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Activities.create_activity(user, trip, attrs)
    end

    test "website incorrect type" do
      user = insert(:user)
      trip = insert(:trip)
      attrs = Map.put(@valid_attrs, "website", 123)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  website: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Activities.create_activity(user, trip, attrs)
    end

    test "location incorrect type" do
      user = insert(:user)
      trip = insert(:trip)
      attrs = Map.put(@valid_attrs, "location", 123)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  location: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Activities.create_activity(user, trip, attrs)
    end

    test "phone incorrect type" do
      user = insert(:user)
      trip = insert(:trip)
      attrs = Map.put(@valid_attrs, "phone", 123)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  phone: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Activities.create_activity(user, trip, attrs)
    end

    test "price_per_person incorrect type" do
      user = insert(:user)
      trip = insert(:trip)
      attrs = Map.put(@valid_attrs, "price_per_person", 123)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  price_per_person: {"is invalid", [type: Money.Ecto.Composite.Type, validation: :cast]}
                ]
              }} = Activities.create_activity(user, trip, attrs)
    end

    test "notes incorrect type" do
      user = insert(:user)
      trip = insert(:trip)
      attrs = Map.put(@valid_attrs, "notes", 123)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  notes: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Activities.create_activity(user, trip, attrs)
    end
  end

  describe "get_activity" do
    test "activity exists" do
      activity = insert(:activity)
      activity_id = activity.id
      assert {:ok, %Activity{id: ^activity_id, user: %User{}}} = Activities.get_activity(activity_id)
    end

    test "activity doesn't exist" do
      activity_id = Faker.UUID.v4()
      assert {:error, :not_found} = Activities.get_activity(activity_id)
    end
  end

  describe "update_activity" do
    test "valid attrs" do
      activity = insert(:activity, name: "update trip test name")

      assert {:ok,
              %Activity{
                name: "activity name",
                website: "test website",
                location: "test location",
                phone: "test phone",
                notes: "test notes",
                price_per_person: %Money{amount: 100, currency: :USD},
                start_date: ~U[2022-10-09 03:51:20Z],
                end_date: ~U[2022-10-09 03:51:20Z],
                user: %User{}
              }} = Activities.update_activity(activity, @valid_attrs)
    end

    test "invalid attrs" do
      activity = insert(:activity)
      invalid_attrs = %{"website" => 123}

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  website: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Activities.update_activity(activity, invalid_attrs)
    end

    test "activity doesn't exist" do
      activity = %Activity{id: Faker.UUID.v4()}

      assert_raise Ecto.StaleEntryError, fn ->
        Activities.update_activity(activity, @valid_attrs)
      end
    end
  end

  describe "delete_activity" do
    test "activity exists" do
      activity = insert(:activity)
      activity_id = activity.id

      assert {:ok, %Activity{id: ^activity_id}} = Activities.delete_activity(activity)
    end

    test "activity doesn't exist" do
      activity = %Activity{id: Faker.UUID.v4()}

      assert_raise Ecto.StaleEntryError, fn ->
        Activities.delete_activity(activity)
      end
    end
  end
end
