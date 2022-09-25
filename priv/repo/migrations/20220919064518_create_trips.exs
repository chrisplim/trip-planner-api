defmodule TripPlanner.Repo.Migrations.CreateTrips do
  use Ecto.Migration

  def change do
    create table(:trips) do
      add(:name, :string, null: false)
      add(:description, :text)
      add(:start_date, :utc_datetime)
      add(:end_date, :utc_datetime)
      add(:owner_id, references("users"))

      timestamps(type: :utc_datetime)
    end

    create(index(:trips, [:owner_id]))
    create(unique_index(:trips, [:owner_id, :name]))
  end
end
