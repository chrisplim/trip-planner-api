defmodule TripPlanner.Repo.Migrations.CreateUsersTrips do
  use Ecto.Migration

  def change do
    create table(:users_trips, primary_key: false) do
      add(:user_id, references("users"))
      add(:trip_id, references("trips"))
    end

    create(unique_index(:users_trips, [:user_id, :trip_id]))
  end
end
