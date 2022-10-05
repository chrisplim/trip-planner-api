defmodule TripPlanner.TypeConversions.NumberConverterTest do
  use ExUnit.Case
  alias TripPlanner.TypeConversions.NumberConverter

  describe "to_int" do
    test "pass in string that's parseable to int" do
      assert NumberConverter.to_int("1") == {:ok, 1}
    end

    test "pass in string that's NOT parseable to int" do
      assert NumberConverter.to_int("asdf") == {:error, "can't parse value to integer"}
    end

    test "pass in string that's NOT parseable to int; with a default" do
      assert NumberConverter.to_int("adsf", default: "some default") == {:ok, "some default"}
    end

    test "pass in int" do
      assert NumberConverter.to_int(1) == {:ok, 1}
    end

    test "pass in non-int/non-string" do
      assert NumberConverter.to_int([]) == {:error, "can't parse value to integer"}
    end
  end

  describe "to_float" do
    test "pass in string that's parseable to int" do
      assert NumberConverter.to_float("1") == {:ok, 1.0}
    end

    test "pass in string that's NOT parseable to int" do
      assert NumberConverter.to_float("asdf") == {:error, "can't parse value to float"}
    end

    test "pass in string that's NOT parseable to int; with a default" do
      assert NumberConverter.to_float("adsf", default: "some default") == {:ok, "some default"}
    end

    test "pass in int" do
      assert NumberConverter.to_float(1) == {:ok, 1.0}
    end

    test "pass in float" do
      assert NumberConverter.to_float(1.0) == {:ok, 1.0}
    end

    test "pass in non-int/non-string" do
      assert NumberConverter.to_float([]) == {:error, "can't parse value to float"}
    end
  end

  describe "decimal_to_float" do
    test "nil should return error if no default" do
      assert NumberConverter.decimal_to_float(nil) == {:error, :invalid_decimal}
    end

    test "default is returned if default specified" do
      assert NumberConverter.decimal_to_float(nil, default: "hi") == {:ok, "hi"}
    end

    test "Decimal returns float" do
      decimal = Decimal.from_float(0.02)
      assert NumberConverter.decimal_to_float(decimal) == {:ok, 0.02}
    end
  end
end
