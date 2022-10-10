defmodule TripPlanner.TypeConversions.DateTimeConverter do
  @moduledoc """
  Module for converting integers to elixir DateTimes
  """
  alias TripPlanner.TypeConversions.NumberConverter

  @spec from_timestamp(any(), Keyword.t()) ::
          {:ok, DateTime.t()} | {:ok, any()} | {:error, atom()}
  def from_timestamp(timestamp, opts \\ []) do
    unit = Keyword.get(opts, :unit, :second)

    with {:ok, int_timestamp} <- NumberConverter.to_int(timestamp),
         {:ok, datetime} <- DateTime.from_unix(int_timestamp, unit) do
      {:ok, datetime}
    else
      _ ->
        case Keyword.fetch(opts, :default) do
          {:ok, default} -> {:ok, default}
          _ -> {:error, :invalid_timestamp}
        end
    end
  end

  # DateTime to integer
  def to_integer(datetime, unit \\ :second, default \\ nil)

  def to_integer(%DateTime{} = d, unit, _default) do
    DateTime.to_unix(d, unit)
  end

  def to_integer(%NaiveDateTime{} = naive_datetime, unit, _default) do
    naive_datetime |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix(unit)
  end

  def to_integer(_, _, default), do: default

  def change_precision(datetime, unit) do
    datetime
    |> DateTime.to_unix(unit)
    |> DateTime.from_unix!(unit)
  end

  def convert_date_keys_in_map(%{} = map) do
    map =
      with %{"start_date" => start_date} <- map,
           {:ok, dt} <- from_timestamp(start_date) do
        Map.put(map, "start_date", dt)
      else
        _ -> map
      end

    with %{"end_date" => end_date} <- map,
         {:ok, dt} <- from_timestamp(end_date) do
      Map.put(map, "end_date", dt)
    else
      _ -> map
    end
  end
end
