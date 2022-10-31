require Protocol
Protocol.derive(Jason.Encoder, Money)

defmodule TripPlanner.Schemas.Activity do
  use TripPlanner.Schema
  import Ecto.Changeset
  alias TripPlanner.Schemas.Trip
  alias TripPlanner.Schemas.User

  schema "activities" do
    field(:name, :string)
    field(:website, :string)
    field(:location, :string)
    field(:phone, :string)
    field(:price_per_person, Money.Ecto.Composite.Type)
    field(:notes, :string)
    field(:start_date, :utc_datetime)
    field(:end_date, :utc_datetime)
    belongs_to(:user, User, on_replace: :nilify)
    belongs_to(:trip, Trip, on_replace: :nilify)

    field(:is_interested, :boolean, virtual: true)

    timestamps(type: :utc_datetime)
  end

  def create_changeset(activity, params, user, trip) do
    activity
    |> cast(params, [:name, :website, :location, :phone, :price_per_person, :notes, :start_date, :end_date])
    |> validate_required([:name])
    # |> foreign_key_constraint(:user_id)
    # |> foreign_key_constraint(:trip_id)
    |> unique_constraint([:trip_id, :name], name: :unique_activity_name_per_trip)
    |> put_assoc(:user, user)
    |> put_assoc(:trip, trip)
  end

  def update_changeset(trip, params) do
    trip
    |> cast(params, [:name, :website, :location, :phone, :price_per_person, :notes, :start_date, :end_date])
    |> unique_constraint([:trip_id, :name], name: :unique_activity_name_per_trip)
  end
end
