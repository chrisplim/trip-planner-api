defmodule TripPlanner.Repo.Migrations.AddIndexesUsersTrips do
  use Ecto.Migration

  def change do
    drop table("users_trips")

    flush()

    create table(:users_trips, primary_key: false) do
      add(:user_id, references("users", on_delete: :delete_all), null: false, primary_key: true)
      add(:trip_id, references("trips", on_delete: :delete_all), null: false, primary_key: true)
    end

    # Since both user_id and trip_id are primary_keys they will be used as a composite primary key
    # and don't need another unique_index for (user_id, trip_id)
    create(index(:users_trips, :user_id))
    create(index(:users_trips, :trip_id))
  end

  def down do
  end
end
