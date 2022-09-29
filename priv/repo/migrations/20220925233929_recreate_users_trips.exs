defmodule TripPlanner.Repo.Migrations.AddIndexesUsersTrips do
  use Ecto.Migration

  def change do
    drop table("users_trips")

    flush()

    create table(:users_trips, primary_key: false) do
      add(:user_id, references("users"), null: false, primary_key: true, on_delete: :delete_all)
      add(:trip_id, references("trips"), null: false, primary_key: true, on_delete: :delete_all)
    end

    create(index(:users_trips, :user_id))
    create(index(:users_trips, :trip_id))
  end
end
