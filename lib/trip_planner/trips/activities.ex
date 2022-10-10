defmodule TripPlanner.Trips.Activities do
  @moduledoc """
  Context file for Trips
  """
  import Ecto.Query, only: [from: 2]

  alias TripPlanner.Repo
  alias TripPlanner.Schemas.Activity
  alias TripPlanner.TypeConversions.DateTimeConverter
  alias TripPlanner.TypeConversions.MoneyConverter

  def create_activity(user, trip, attrs) do
    attrs =
      attrs
      |> DateTimeConverter.convert_date_keys_in_map()
      |> MoneyConverter.parse_price_per_person()

    result =
      %Activity{}
      |> Activity.create_changeset(attrs, user, trip)
      |> Repo.insert()

    case result do
      {:ok, activity} -> {:ok, Repo.preload(activity, [:user])}
      error -> error
    end
  end

  def get_activity(activity_id) do
    query =
      from(activity in Activity,
        where: activity.id == type(^activity_id, :binary_id),
        preload: [:user]
      )

    case Repo.one(query) do
      nil -> {:error, :not_found}
      activity -> {:ok, activity}
    end
  end

  def update_activity(%Activity{} = activity, attrs) do
    attrs =
      attrs
      |> DateTimeConverter.convert_date_keys_in_map()
      |> MoneyConverter.parse_price_per_person()

    result =
      activity
      |> Activity.update_changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, activity} -> {:ok, Repo.preload(activity, [:user])}
      error -> error
    end
  end

  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end
end
