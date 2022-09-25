defmodule TripPlanner.Trips.Trips do
  @moduledoc """
  Context file for Trips
  """
  import Ecto.Query, only: [from: 2]

  alias TripPlanner.Schemas.Trip
  alias TripPlanner.Schemas.User
  alias TripPlanner.Repo

  def create_trip(_user, attrs) do
    # TODO add user as owner
    %Trip{}
    |> Trip.changeset(attrs)
    |> Repo.insert()
  end

  def get_trip(trip_id) do
    case Repo.get(Trip, trip_id) do
      nil -> {:error, :not_found}
      trip -> {:ok, trip}
    end
  end

  def get_all_trips_including_user(%User{} = _user) do
    # TODO actually get the trips including user
    {:ok, []}
  end

  def update_trip(%Trip{} = trip, attrs) do
    trip
    |> Trip.changeset(attrs)
    |> Repo.update()
  end

  def delete_trip(%Trip{} = trip) do
    Repo.delete(trip)
  end
end
