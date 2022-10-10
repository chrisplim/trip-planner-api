defmodule TripPlanner.Factory do
  @moduledoc """
  ExMachina Factory useful for creating objects for unit tests
  """
  use ExMachina.Ecto, repo: TripPlanner.Repo

  use TripPlanner.Schemas.ActivityFactory
  use TripPlanner.Schemas.TripFactory
  use TripPlanner.Schemas.UserFactory
end
