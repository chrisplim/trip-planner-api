defmodule TripPlanner.Trips.Activities do
  @moduledoc """
  Context file for Trips
  """
  import Ecto.Query, only: [from: 2]

  alias TripPlanner.Repo
  alias TripPlanner.Schemas.Activity
  alias TripPlanner.Schemas.UserActivityInterest
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
      {:ok, activity} -> {:ok, %{Repo.preload(activity, [:user]) | is_interested: nil}}
      error -> error
    end
  end

  def get_activity_with_interest(user, activity_id) do
    query =
      from(activity in Activity,
        left_join: user_activity_interest in UserActivityInterest,
        on: user_activity_interest.activity_id == activity.id and user_activity_interest.user_id == ^user.id,
        where: activity.id == type(^activity_id, :binary_id),
        preload: [:user],
        select: %{activity | is_interested: user_activity_interest.is_interested}
      )

    case Repo.one(query) do
      nil -> {:error, :not_found}
      activity -> {:ok, activity}
    end
  end

  def get_activity(activity_id) do
    query = from(activity in Activity, where: activity.id == type(^activity_id, :binary_id))

    case Repo.one(query) do
      nil -> {:error, :not_found}
      activity -> {:ok, activity}
    end
  end

  def update_activity(user, %Activity{} = activity, attrs) do
    attrs =
      attrs
      |> DateTimeConverter.convert_date_keys_in_map()
      |> MoneyConverter.parse_price_per_person()

    result =
      activity
      |> Activity.update_changeset(attrs)
      |> Repo.update()

    is_interested =
      Repo.one(
        from(user_activity_interest in UserActivityInterest,
          where: user_activity_interest.user_id == ^user.id and user_activity_interest.activity_id == ^activity.id,
          select: user_activity_interest.is_interested
        )
      )

    case result do
      {:ok, activity} -> {:ok, %{Repo.preload(activity, [:user]) | is_interested: is_interested}}
      error -> error
    end
  end

  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  def vote_on_activity(user, %Activity{} = activity, is_interested) do
    result =
      %{user_id: user.id, activity_id: activity.id, is_interested: is_interested}
      |> UserActivityInterest.changeset()
      |> Repo.insert(
        on_conflict: {:replace, [:is_interested]},
        conflict_target: [:user_id, :activity_id],
        returning: true
      )

    case result do
      {:ok, _} -> {:ok, %{Repo.preload(activity, [:user]) | is_interested: is_interested}}
      error -> error
    end
  end
end
