defmodule TripPlanner.Trips.Trips do
  @moduledoc """
  Context file for Trips
  """
  import Ecto.Query, only: [from: 2]

  alias TripPlanner.Repo
  alias TripPlanner.Schemas.Trip
  alias TripPlanner.Schemas.User
  alias TripPlanner.TypeConversions.DateTimeConverter

  def create_trip(user, attrs) do
    attrs =
      attrs
      |> Map.put("owner_id", user.id)
      |> DateTimeConverter.convert_date_keys_in_map()

    result =
      %Trip{}
      |> Trip.create_changeset(attrs, user)
      |> Repo.insert()

    case result do
      {:ok, trip} -> {:ok, Repo.preload(trip, [:user, :users])}
      error -> error
    end
  end

  def get_trip(trip_id) do
    query =
      from(trip in Trip,
        where: trip.id == type(^trip_id, :binary_id),
        preload: [:user, :users]
      )

    case Repo.one(query) do
      nil -> {:error, :not_found}
      trip -> {:ok, trip}
    end
  end

  def get_all_trips_including_user(%User{} = user) do
    query =
      from(trip in Trip,
        left_join: user in assoc(trip, :user),
        left_join: participant in assoc(trip, :users),
        where: participant.id == ^user.id or user.id == ^user.id,
        group_by: [trip.id],
        preload: [:user]
      )

    {:ok, Repo.all(query)}
  end

  def update_trip(%Trip{} = trip, attrs) do
    attrs = DateTimeConverter.convert_date_keys_in_map(attrs)

    result =
      trip
      |> Trip.update_changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, trip} -> {:ok, Repo.preload(trip, [:user, :users])}
      error -> error
    end
  end

  def delete_trip(%Trip{} = trip) do
    Repo.delete(trip)
  end
end
