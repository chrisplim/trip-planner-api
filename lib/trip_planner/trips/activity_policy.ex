defmodule TripPlanner.Trips.ActivityPolicy do
  @moduledoc """
  Module defining our Bodyguard policies for Activities
  """
  @behaviour Bodyguard.Policy
  alias TripPlanner.Schemas.Activity
  alias TripPlanner.Schemas.Trip
  alias TripPlanner.Schemas.User

  # People in this trip can create activities in this trip
  def authorize(:create_activity, %User{id: user_id}, %Trip{user: user, users: users}) do
    user_ids = Enum.map(users, & &1.id)
    user_ids = [user.id | user_ids]

    if Enum.member?(user_ids, user_id) do
      :ok
    else
      {:error, :forbidden}
    end
  end

  # People in this trip can see, update, and delete activities in this trip as long as the activity is in this trip
  def authorize(action, %User{id: user_id}, %{
        trip: %Trip{id: trip_id, user: user, users: users},
        activity: %Activity{trip_id: trip_id}
      })
      when action in [:see_activity, :update_activity, :delete_activity] do
    user_ids = Enum.map(users, & &1.id)
    user_ids = [user.id | user_ids]

    if Enum.member?(user_ids, user_id) do
      :ok
    else
      {:error, :forbidden}
    end
  end

  # Catch-all
  def authorize(_, _, _) do
    {:error, :forbidden}
  end
end
