defmodule TripPlanner.Users.Users do
  @moduledoc """
  Context file for Users
  """
  import Ecto.Query, only: [from: 2]

  alias TripPlanner.Repo
  alias TripPlanner.Schemas.User

  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def get_user(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_logged_in_user(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      %User{jwt_refresh_token: nil} -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def update_refresh_token(user, refresh_token) do
    user
    |> User.refresh_token_changeset(%{jwt_refresh_token: refresh_token})
    |> Repo.update()
  end

  def get_user_profile(user_id) do
    query =
      from(user in User,
        where: user.id == ^user_id
      )

    case Repo.one(query) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
