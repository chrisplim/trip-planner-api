defmodule TripPlanner.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: false)
      add(:username, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:email, :text, null: false)
      add(:phone, :string)
      add(:jwt_refresh_token, :text)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:users, [:username]))
    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:jwt_refresh_token]))
  end
end
