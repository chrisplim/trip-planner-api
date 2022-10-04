defmodule TripPlanner.TypeConversions.DateTimeConverterTest do
  use ExUnit.Case
  alias TripPlanner.TypeConversions.DateTimeConverter

  describe "from_timestamp" do
    test "pass in timestamp string that isn't parseable to int" do
      assert DateTimeConverter.from_timestamp("asdf") == {:error, :invalid_timestamp}
    end

    test "pass in timestamp string that isn't parseable to int; with default" do
      assert DateTimeConverter.from_timestamp("asdf", unit: :second, default: "default") == {:ok, "default"}
    end

    test "pass in timestamp string that isn't parseable to DateTime" do
      assert DateTimeConverter.from_timestamp("11111111111111111111", default: nil) == {:ok, nil}
    end

    test "pass in timestamp string that isn't parseable to DateTime; with default" do
      assert DateTimeConverter.from_timestamp("11111111111111111111", unit: :second, default: "default") ==
               {:ok, "default"}
    end

    test "pass in timestamp int that isn't parseable to DateTime" do
      assert DateTimeConverter.from_timestamp(11_111_111_111_111_111, default: nil) == {:ok, nil}
    end

    test "pass in timestamp int that isn't parseable to DateTime with default" do
      assert DateTimeConverter.from_timestamp(11_111_111_111_111_111, unit: :second, default: "default") ==
               {:ok, "default"}
    end

    test "pass in timestamp int that is able to be parsed default second unit" do
      assert DateTimeConverter.from_timestamp(1_633_081_287) == {:ok, ~U[2021-10-01 09:41:27Z]}
    end

    test "pass in timestamp int that is able to be parsed millisecond unit" do
      assert DateTimeConverter.from_timestamp(1_633_081_287_000, unit: :millisecond) ==
               {:ok, ~U[2021-10-01 09:41:27.000Z]}
    end

    test "pass in junk" do
      assert DateTimeConverter.from_timestamp([]) == {:error, :invalid_timestamp}
    end
  end

  describe "to_integer" do
    test "pass in DateTime; with default unit :second" do
      dt = DateTime.new!(~D[2016-05-24], ~T[13:26:08.003123], "Etc/UTC")
      assert DateTimeConverter.to_integer(dt, :second) == 1_464_096_368
    end

    test "pass in DateTime; with millisecond unit" do
      dt = DateTime.new!(~D[2016-05-24], ~T[13:26:08.003123], "Etc/UTC")
      assert DateTimeConverter.to_integer(dt, :millisecond) == 1_464_096_368_003
    end

    test "pass in NaiveDateTime; default unit" do
      dt = NaiveDateTime.new!(~D[2016-05-24], ~T[13:26:08.003123])
      assert DateTimeConverter.to_integer(dt) == 1_464_096_368
    end

    test "pass in non-datetime" do
      assert DateTimeConverter.to_integer("asdf", :millisecond) == nil
    end
  end
end
