defmodule TripPlannerWeb.CurrentUserPlug do
  def init(options), do: options

  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    Plug.Conn.assign(conn, :current_user, user)
  end
end
