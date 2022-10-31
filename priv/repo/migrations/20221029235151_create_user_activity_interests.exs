defmodule TripPlanner.Repo.Migrations.CreateUserActivityInterests do
  use Ecto.Migration

  def change do
    create table(:user_activity_interests, primary_key: false) do
      add(:user_id, references("users", on_delete: :delete_all), null: false, primary_key: true)

      add(:activity_id, references("activities", on_delete: :delete_all),
        null: false,
        primary_key: true
      )

      add(:is_interested, :boolean)

      timestamps()
    end

    # Since both user_id and activity_id are primary_keys they will be used as a composite primary key
    # and don't need another unique_index for (user_id, activity_id)
    create(index(:user_activity_interests, :user_id))
    create(index(:user_activity_interests, :activity_id))
  end
end
