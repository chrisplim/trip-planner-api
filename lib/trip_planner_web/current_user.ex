defmodule TripPlannerWeb.CurrentUser do
  @moduledoc """
  Plug to help pass the user to our controller actions as a parameter
  """
  defmacro __using__(_) do
    quote do
      def action(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _opts) do
        apply(__MODULE__, action_name(conn), [conn, conn.params, current_user])
      end

      def action(conn, _opts) do
        apply(__MODULE__, action_name(conn), [conn, conn.params, nil])
      end
    end
  end
end
