defmodule TripPlanner.Trips.TripPolicy do
  @moduledoc """
  Module defining our Bodyguard policies for Trips
  """
  @behaviour Bodyguard.Policy
  alias TripPlanner.Schemas.Trip
  alias TripPlanner.Schemas.User
  # Only people in this trip can see + update it
  def authorize(action, %User{id: user_id}, %Trip{user: user, users: users})
      when action in [:see_trip, :update_trip] do
    user_ids = Enum.map(users, & &1.id)
    user_ids = [user.id | user_ids]

    if Enum.member?(user_ids, user_id) do
      :ok
    else
      {:error, :forbidden}
    end
  end

  # Only the owner of this trip can delete it
  def authorize(:delete_trip, %User{id: user_id}, %Trip{owner_id: user_id}), do: :ok

  # Catch-all
  def authorize(_, _, _) do
    {:error, :forbidden}
  end
end
