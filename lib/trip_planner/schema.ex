defmodule TripPlanner.Schema do
  @moduledoc """
  Defines a macro for the schemas in our app.
  We default to generating binary_ids instead of bigints
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
