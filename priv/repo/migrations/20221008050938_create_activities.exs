defmodule TripPlanner.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE public.money_with_currency AS (amount integer, currency varchar(3))
    """

    flush()

    create table(:activities) do
      add(:name, :string, null: false)
      add(:website, :text)
      add(:location, :string)
      add(:phone, :string)
      add(:price_per_person, :money_with_currency)
      add(:start_date, :utc_datetime)
      add(:end_date, :utc_datetime)
      add(:notes, :text)
      add(:user_id, references("users"))
      add(:trip_id, references("trips"))

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:activities, [:trip_id, :name]))
  end

  def down do
    drop table(:activities)

    flush()

    execute """
    DROP TYPE public.money_with_currency
    """
  end
end
