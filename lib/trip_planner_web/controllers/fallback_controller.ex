defmodule TripPlannerWeb.FallbackController do
  use Phoenix.Controller
  import Plug.Conn

  alias TripPlannerWeb.ErrorView

  require Logger

  def call(conn, {:error, status, message}) when is_integer(status) and is_binary(message) do
    Logger.error("[FallbackController] status: #{status}, message: #{message}")

    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", %{message: message, code: status})
  end

  def call(conn, {:error, :unauthorized}) do
    Logger.error("[FallbackController] Unauthorized")

    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
  end

  def call(conn, {:error, :forbidden}) do
    Logger.error("[FallbackController] Forbidden")

    conn
    |> put_status(:forbidden)
    |> put_view(ErrorView)
    |> render("403.json")
  end

  # For Ecto Changesets
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    Logger.error("[FallbackController] Changeset Error: #{inspect(changeset)}")

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("422.json")
  end

  def call(conn, other_error) do
    Logger.error("[FallbackController] Other Error: #{inspect(other_error)}")

    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorView)
    |> render("500.json")
  end
end
