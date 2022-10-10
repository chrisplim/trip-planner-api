defmodule TripPlanner.Schemas.Trip do
  use TripPlanner.Schema
  import Ecto.Changeset
  alias TripPlanner.Schemas.User

  schema "trips" do
    field(:name, :string)
    field(:description, :string)
    field(:start_date, :utc_datetime)
    field(:end_date, :utc_datetime)
    belongs_to(:user, User, foreign_key: :owner_id, on_replace: :nilify)

    many_to_many(:users, User,
      join_through: "users_trips",
      on_replace: :delete
    )

    timestamps(type: :utc_datetime)
  end

  def create_changeset(trip, params, user) do
    trip
    |> cast(params, [:name, :description, :start_date, :end_date])
    |> validate_required([:name])
    # |> foreign_key_constraint(:owner_id)
    |> unique_constraint([:owner_id, :name], name: :unique_trip_name_per_owner)
    |> put_assoc(:user, user)
    |> put_assoc(:users, [user])
  end

  def update_changeset(trip, params) do
    trip
    |> cast(params, [:name, :description, :start_date, :end_date, :owner_id])
    |> foreign_key_constraint(:owner_id)
    |> unique_constraint([:owner_id, :name], name: :unique_trip_name_per_owner)
  end
end
