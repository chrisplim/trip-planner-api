defmodule TripPlanner.TypeConversions.MoneyConverter do
  alias TripPlanner.TypeConversions.NumberConverter

  def parse_price_per_person(map) do
    case Map.get(map, "price_per_person") do
      %{"amount" => amount, "currency" => _} ->
        # Make sure amount is an integer
        put_in(map, ["price_per_person", "amount"], NumberConverter.to_int!(amount))

      %{"amount" => amount} ->
        # Make sure amount is an integer
        # Also, assume currency is the default currency
        Map.put(map, "price_per_person", %{
          "amount" => NumberConverter.to_int!(amount),
          "currency" => Application.get_env(:money, :default_currency)
        })

      _ ->
        # Otherwise, do nothing
        map
    end
  end
end
