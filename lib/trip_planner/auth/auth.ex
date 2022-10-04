defmodule TripPlanner.Auth.Auth do
  import Ecto.Query, only: [from: 2]
  alias TripPlanner.Repo
  alias TripPlanner.Schemas.User
  alias TripPlannerWeb.Guardian

  def authenticate_user(username, plain_text_password) do
    query = from(u in User, where: u.username == ^username)

    case Repo.one(query) do
      nil ->
        Argon2.no_user_verify()
        {:error, :unauthorized}

      user ->
        if Argon2.verify_pass(plain_text_password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end

  def create_tokens_for_user(%User{} = user) do
    with {:ok, access_token, _claims} <- Guardian.encode_and_sign(user),
         {:ok, refresh_token, _claims} <-
           Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {2, :weeks}) do
      {:ok, %{access_token: access_token, refresh_token: refresh_token}}
    end
  end
end
