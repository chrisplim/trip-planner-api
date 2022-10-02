defmodule TripPlanner.Repo.Migrations.TripOwnerNotNullable do
  use Ecto.Migration

  def change do
    alter table(:trips) do
      modify :owner_id,
             references(:users, on_delete: :nilify_all),
             null: false,
             from: references(:users)
    end
  end
end
