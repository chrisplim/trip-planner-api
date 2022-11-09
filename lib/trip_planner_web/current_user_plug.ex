defmodule TripPlannerWeb.CurrentUserPlug do
  import Plug.Conn
  def init(options), do: options

  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      nil -> conn |> send_resp(401, []) |> halt()
      user -> assign(conn, :current_user, user)
    end
  end
end
