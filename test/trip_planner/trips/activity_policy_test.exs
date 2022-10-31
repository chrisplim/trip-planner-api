defmodule TripPlanner.Trips.ActivityPolicyTest do
  use TripPlanner.DataCase
  import TripPlanner.Factory

  alias TripPlanner.Trips.ActivityPolicy

  describe "authorize" do
    test "owners can create activities" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      assert ActivityPolicy.authorize(:create_activity, user, trip) == :ok
    end

    test "participants can create activities" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      assert ActivityPolicy.authorize(:create_activity, user, trip) == :ok
    end

    test "owners can see activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:see_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "owners cannot see activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity)
      assert ActivityPolicy.authorize(:see_activity, user, %{trip: trip, activity: activity}) == {:error, :forbidden}
    end

    test "participants can see activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:see_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "participants cannot see activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity)
      assert ActivityPolicy.authorize(:see_activity, user, %{trip: trip, activity: activity}) == {:error, :forbidden}
    end

    test "owners can update activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:update_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "owners cannot update activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity)
      assert ActivityPolicy.authorize(:update_activity, user, %{trip: trip, activity: activity}) == {:error, :forbidden}
    end

    test "participants can update activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:update_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "participants cannot update activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity)
      assert ActivityPolicy.authorize(:update_activity, user, %{trip: trip, activity: activity}) == {:error, :forbidden}
    end

    test "owners can delete activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:delete_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "owners cannot delete activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity)
      assert ActivityPolicy.authorize(:delete_activity, user, %{trip: trip, activity: activity}) == {:error, :forbidden}
    end

    test "participants can delete activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:delete_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "participants cannot delete activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity)
      assert ActivityPolicy.authorize(:delete_activity, user, %{trip: trip, activity: activity}) == {:error, :forbidden}
    end

    test "owners can vote on activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:vote_on_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "owners cannot vote on activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      activity = insert(:activity)

      assert ActivityPolicy.authorize(:vote_on_activity, user, %{trip: trip, activity: activity}) ==
               {:error, :forbidden}
    end

    test "participants can vote on activities if activity in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity, trip: trip)
      assert ActivityPolicy.authorize(:vote_on_activity, user, %{trip: trip, activity: activity}) == :ok
    end

    test "participants cannot vote on activities if activity not in trip" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      activity = insert(:activity)

      assert ActivityPolicy.authorize(:vote_on_activity, user, %{trip: trip, activity: activity}) ==
               {:error, :forbidden}
    end
  end
end
