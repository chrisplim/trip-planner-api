defmodule TripPlanner.TypeConversions.NumberConverter do
  @spec to_int(any(), Keyword.t()) :: {:ok, integer()} | {:error, String.t()}
  def to_int(value, opts \\ []) do
    default =
      case Keyword.fetch(opts, :default) do
        {:ok, default} -> {:ok, default}
        _ -> {:error, "can't parse value to integer"}
      end

    cond do
      is_binary(value) ->
        case Integer.parse(value) do
          {int, _} -> {:ok, int}
          _ -> default
        end

      is_integer(value) ->
        {:ok, value}

      true ->
        default
    end
  end

  def to_int!(value, opts \\ []) do
    {:ok, int} = to_int(value, opts)
    int
  end

  @spec to_float(any(), Keyword.t()) :: {:ok, float()} | {:error, String.t()}
  def to_float(value, opts \\ []) do
    default =
      case Keyword.fetch(opts, :default) do
        {:ok, default} -> {:ok, default}
        _ -> {:error, "can't parse value to float"}
      end

    cond do
      is_binary(value) ->
        case Float.parse(value) do
          {float, _} -> {:ok, float}
          _ -> default
        end

      is_integer(value) ->
        {:ok, value / 1}

      is_float(value) ->
        {:ok, value}

      true ->
        default
    end
  end

  def decimal_to_float(value, opts \\ []) do
    case value do
      %Decimal{} ->
        {:ok, Decimal.to_float(value)}

      nil ->
        case Keyword.fetch(opts, :default) do
          {:ok, default} -> {:ok, default}
          _ -> {:error, :invalid_decimal}
        end
    end
  end
end
