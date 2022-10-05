defmodule TripPlanner.Trips.TripPolicyTest do
  use TripPlanner.DataCase
  import TripPlanner.Factory

  alias TripPlanner.Trips.TripPolicy

  describe "authorize" do
    test "participants can see trips" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      assert TripPolicy.authorize(:see_trip, user, trip) == :ok
    end

    test "owners can see trips" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      assert TripPolicy.authorize(:see_trip, user, trip) == :ok
    end

    test "other users cannot see trips" do
      user = insert(:user)
      trip = insert(:trip, users: [])
      assert TripPolicy.authorize(:see_trip, user, trip) == {:error, :forbidden}
    end

    test "participants can update trips" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      assert TripPolicy.authorize(:update_trip, user, trip) == :ok
    end

    test "owners can update trips" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      assert TripPolicy.authorize(:update_trip, user, trip) == :ok
    end

    test "other users cannot update trips" do
      user = insert(:user)
      trip = insert(:trip, users: [])
      assert TripPolicy.authorize(:update_trip, user, trip) == {:error, :forbidden}
    end

    test "only owners can delete trips" do
      user = insert(:user)
      trip = insert(:trip, user: user, users: [])
      assert TripPolicy.authorize(:delete_trip, user, trip) == :ok
    end

    test "participants cannot delete trips" do
      user = insert(:user)
      trip = insert(:trip, users: [user])
      assert TripPolicy.authorize(:delete_trip, user, trip) == {:error, :forbidden}
    end

    test "other users cannot delete trips" do
      user = insert(:user)
      trip = insert(:trip, users: [])
      assert TripPolicy.authorize(:delete_trip, user, trip) == {:error, :forbidden}
    end
  end
end
