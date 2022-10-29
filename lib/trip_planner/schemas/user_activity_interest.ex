defmodule TripPlanner.Schemas.UserActivityInterest do
  use TripPlanner.Schema
  import Ecto.Changeset
  alias TripPlanner.Schemas.Activity
  alias TripPlanner.Schemas.User

  @primary_key false
  schema "user_activity_interests" do
    field(:is_interested, :boolean)
    belongs_to(:user, User, on_replace: :nilify, primary_key: true)
    belongs_to(:activity, Activity, on_replace: :nilify, primary_key: true)
    timestamps()
  end

  def changeset(params) do
    cast(%__MODULE__{}, params, [:is_interested, :user_id, :activity_id])
  end
end
