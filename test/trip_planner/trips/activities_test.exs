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
                is_interested: nil,
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
      assert {:ok, %Activity{id: ^activity_id}} = Activities.get_activity(activity_id)
    end

    test "activity doesn't exist" do
      activity_id = Faker.UUID.v4()
      assert {:error, :not_found} = Activities.get_activity(activity_id)
    end
  end

  describe "get_activity_with_interest" do
    test "activity exists" do
      user = insert(:user)
      activity = insert(:activity)
      activity_id = activity.id

      assert {:ok, %Activity{id: ^activity_id, user: %User{}, is_interested: nil}} =
               Activities.get_activity_with_interest(user, activity_id)
    end

    test "activity doesn't exist" do
      user = insert(:user)
      activity_id = Faker.UUID.v4()
      assert {:error, :not_found} = Activities.get_activity_with_interest(user, activity_id)
    end

    test "user is not interested in the activity" do
      user = insert(:user)
      activity = insert(:activity)
      activity_id = activity.id
      insert(:user_activity_interest, is_interested: false, activity: activity, user: user)

      assert {:ok, %Activity{id: ^activity_id, user: %User{}, is_interested: false}} =
               Activities.get_activity_with_interest(user, activity_id)
    end

    test "user is interested in the activity" do
      user = insert(:user)
      activity = insert(:activity)
      activity_id = activity.id
      insert(:user_activity_interest, is_interested: true, activity: activity, user: user)

      assert {:ok, %Activity{id: ^activity_id, user: %User{}, is_interested: true}} =
               Activities.get_activity_with_interest(user, activity_id)
    end
  end

  describe "update_activity" do
    test "valid attrs" do
      user = insert(:user)
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
                is_interested: nil,
                user: %User{}
              }} = Activities.update_activity(user, activity, @valid_attrs)
    end

    test "invalid attrs" do
      user = insert(:user)
      activity = insert(:activity)
      invalid_attrs = %{"website" => 123}

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  website: {"is invalid", [type: :string, validation: :cast]}
                ]
              }} = Activities.update_activity(user, activity, invalid_attrs)
    end

    test "activity doesn't exist" do
      user = insert(:user)
      activity = %Activity{id: Faker.UUID.v4()}

      assert_raise Ecto.StaleEntryError, fn ->
        Activities.update_activity(user, activity, @valid_attrs)
      end
    end

    test "user has interest in activity" do
      user = insert(:user)
      activity = insert(:activity, name: "update trip test name")
      insert(:user_activity_interest, is_interested: true, activity: activity, user: user)

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
                is_interested: true,
                user: %User{}
              }} = Activities.update_activity(user, activity, @valid_attrs)
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

  # def vote_on_activity(user, %Activity{} = activity, is_interested) do
  describe "vote_on_activity" do
    test "activity exists; user did not have previous interest setting" do
      user = insert(:user)
      activity = insert(:activity)
      activity_id = activity.id

      assert activity.is_interested == nil

      assert {:ok, %Activity{id: ^activity_id, user: %User{}, is_interested: false}} =
               Activities.vote_on_activity(user, activity, false)
    end

    test "activity exists; before is_interested=true, after is_interested=true" do
      user = insert(:user)
      activity = insert(:activity)
      activity_id = activity.id
      insert(:user_activity_interest, is_interested: true, activity: activity, user: user)

      assert {:ok, %Activity{id: ^activity_id, user: %User{}, is_interested: true}} =
               Activities.vote_on_activity(user, activity, true)
    end

    test "activity exists; before is_interested=true, after is_interested=false" do
      user = insert(:user)
      activity = insert(:activity)
      activity_id = activity.id
      insert(:user_activity_interest, is_interested: true, activity: activity, user: user)

      assert {:ok, %Activity{id: ^activity_id, user: %User{}, is_interested: false}} =
               Activities.vote_on_activity(user, activity, false)
    end

    test "activity exists; before is_interested=true, after is_interested=nil" do
      user = insert(:user)
      activity = insert(:activity)
      activity_id = activity.id
      insert(:user_activity_interest, is_interested: true, activity: activity, user: user)

      assert {:ok, %Activity{id: ^activity_id, user: %User{}, is_interested: nil}} =
               Activities.vote_on_activity(user, activity, nil)
    end

    test "activity exists; incorrect is_interested type" do
      user = insert(:user)
      activity = insert(:activity)
      insert(:user_activity_interest, is_interested: true, activity: activity, user: user)

      assert {:error, %Ecto.Changeset{errors: [is_interested: {"is invalid", [type: :boolean, validation: :cast]}]}} =
               Activities.vote_on_activity(user, activity, "123")
    end

    test "activity doesn't exist" do
      activity = %Activity{id: Faker.UUID.v4()}

      assert_raise Ecto.StaleEntryError, fn ->
        Activities.delete_activity(activity)
      end
    end
  end
end
