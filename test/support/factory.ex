defmodule TripPlanner.Factory do
  use ExMachina.Ecto, repo: TripPlanner.Repo

  use TripPlanner.Schemas.UserFactory
end
