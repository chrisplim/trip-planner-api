defmodule TripPlannerWeb.Plugs.DateParamsParserPlug do
  import Plug.Conn

  alias TripPlanner.TypeConversions.DateTimeConverter

  def init(_params) do
  end

  @keys ["start_date", "end_date"]

  def call(%{params: params} = conn, _opts) do
    conn = assign(conn, :dates, %{})

    Enum.reduce(@keys, conn, fn key, conn_acc ->
      value = Map.get(params, key)
      parse_param_and_assign(conn_acc, key, value)
    end)
  end

  def parse_param_and_assign(conn, "start_date", value) do
    {:ok, start_date} = DateTimeConverter.from_timestamp(value, default: nil)
    conn_assign(conn, %{start_date: start_date})
  end

  def parse_param_and_assign(conn, "end_date", value) do
    {:ok, end_date} = DateTimeConverter.from_timestamp(value, default: nil)
    conn_assign(conn, %{end_date: end_date})
  end

  defp conn_assign(%{assigns: %{dates: dates}} = conn, map) do
    assign(conn, :dates, Map.merge(dates, map))
  end
end
