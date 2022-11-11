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

  describe "change_precision" do
    test "microseconds to seconds" do
      dt = DateTime.utc_now()
      assert DateTimeConverter.change_precision(dt, :second) == DateTime.truncate(dt, :second)
    end

    test "microseconds to microseconds" do
      dt = DateTime.utc_now()
      assert DateTimeConverter.change_precision(dt, :microsecond) == dt
    end
  end

  describe "convert_date_keys_in_map" do
    test "start_date and end_date are convertible" do
      start_ts = 1_668_135_674
      end_ts = 1_668_135_688
      expected_start = DateTime.from_unix!(start_ts)
      expected_end = DateTime.from_unix!(end_ts)

      map = %{"start_date" => start_ts, "end_date" => end_ts, "other_key" => "other val"}

      assert DateTimeConverter.convert_date_keys_in_map(map) == %{
               "start_date" => expected_start,
               "end_date" => expected_end,
               "other_key" => "other val"
             }
    end

    test "start_date is convertible; end_date is not" do
      start_ts = 1_668_135_674
      end_ts = "bad value"
      expected_start = DateTime.from_unix!(start_ts)

      map = %{"start_date" => start_ts, "end_date" => end_ts, "other_key" => "other val"}

      assert DateTimeConverter.convert_date_keys_in_map(map) == %{
               "start_date" => expected_start,
               "end_date" => "bad value",
               "other_key" => "other val"
             }
    end

    test "start_date is convertible; end_date is missing" do
      start_ts = 1_668_135_674
      expected_start = DateTime.from_unix!(start_ts)

      map = %{"start_date" => start_ts, "other_key" => "other val"}

      assert DateTimeConverter.convert_date_keys_in_map(map) == %{
               "start_date" => expected_start,
               "other_key" => "other val"
             }
    end

    test "start_date is missing; end_date is convertible;" do
      end_ts = 1_668_135_674
      expected_end = DateTime.from_unix!(end_ts)

      map = %{"end_date" => end_ts, "other_key" => "other val"}

      assert DateTimeConverter.convert_date_keys_in_map(map) == %{
               "end_date" => expected_end,
               "other_key" => "other val"
             }
    end

    test "both start_date and end_date are missing" do
      map = %{"other_key" => "other val"}

      assert DateTimeConverter.convert_date_keys_in_map(map) == %{
               "other_key" => "other val"
             }
    end
  end
end
