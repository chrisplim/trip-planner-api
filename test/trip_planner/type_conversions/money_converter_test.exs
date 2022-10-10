defmodule TripPlanner.TypeConversions.MoneyConverterTest do
  use ExUnit.Case
  alias TripPlanner.TypeConversions.MoneyConverter

  describe "parse_price_per_person" do
    test "map has no price_per_person key" do
      map = %{}
      assert MoneyConverter.parse_price_per_person(map) == map
    end

    test "map has price_per_person key, with neither amount nor currency" do
      map = %{"price_per_person" => %{}}
      assert MoneyConverter.parse_price_per_person(map) == map
    end

    test "map has price_per_person key, with just currency" do
      map = %{"price_per_person" => %{"currency" => "USD"}}
      assert MoneyConverter.parse_price_per_person(map) == map
    end

    test "map has price_per_person key, with just amount" do
      map = %{"price_per_person" => %{"amount" => "100"}}

      assert MoneyConverter.parse_price_per_person(map) == %{
               "price_per_person" => %{"amount" => 100, "currency" => :USD}
             }
    end

    test "map has price_per_person key, with both amount and currency" do
      map = %{"price_per_person" => %{"amount" => "100", "currency" => "JPY"}}

      assert MoneyConverter.parse_price_per_person(map) == %{
               "price_per_person" => %{"amount" => 100, "currency" => "JPY"}
             }
    end
  end
end
