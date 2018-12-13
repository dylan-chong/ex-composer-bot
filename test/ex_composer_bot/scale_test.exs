defmodule ExComposerBotTest.Scale do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExComposerBot.{Scale, Pitch}
  doctest Scale, import: true

  describe "validate_struct fails" do
    test "when non-pitch is passed" do
      assert_raise(
        ArgumentError,
        ~r"Invalid scale.*",
        fn ->
          Scale.new(
            pitches: [
              Pitch.new(number: 0),
              :not_a_pitch
            ]
          )
        end
      )
    end

    test "when pitch with incorrect octave is passed" do
      assert_raise(
        ArgumentError,
        ~r"Invalid scale.*",
        fn ->
          Scale.new(
            pitches: [
              Pitch.new(number: 0, octave: 1),
              Pitch.new(number: 0, octave: 2)
            ]
          )
        end
      )
    end
  end

  describe "major_scale starting on" do
    test "c" do
      s = Scale.c_major()

      assert s.pitches == [
               Pitch.new(number: 0),
               Pitch.new(number: 2),
               Pitch.new(number: 4),
               Pitch.new(number: 5),
               Pitch.new(number: 7),
               Pitch.new(number: 9),
               Pitch.new(number: 11)
             ]
    end

    # TODO Different scales not implemented yet
    @tag :todo
    test "g major" do
      s = Scale.type(:major, Pitch.new(number: 7))

      assert s.pitches == [
               Pitch.new(number: 7),
               Pitch.new(number: 9),
               Pitch.new(number: 11),
               Pitch.new(number: 0),
               Pitch.new(number: 2),
               Pitch.new(number: 4),
               Pitch.new(number: 6, alteration: 1)
             ]
    end
  end

  describe "degree_above" do
    test "c in c_major" do
      # Assumes c_major can be generated properly
      pitch_above =
        Scale.c_major()
        |> Scale.degree_above(Pitch.new(number: 0))

      assert pitch_above == Pitch.new(number: 2)
    end

    test "g in c_major" do
      pitch_above =
        Scale.c_major()
        |> Scale.degree_above(Pitch.new(number: 7))

      assert pitch_above == Pitch.new(number: 9)
    end

    test "middle c in c_major (preserves octave)" do
      pitch_above =
        Scale.c_major()
        |> Scale.degree_above(Pitch.new(number: 0, octave: 4))

      assert pitch_above == Pitch.new(number: 2, octave: 4)
    end

    test "b in c_major (increases octave)" do
      pitch_above =
        Scale.c_major()
        |> Scale.degree_above(Pitch.new(number: 11, octave: 4))

      assert pitch_above == Pitch.new(number: 0, octave: 5)
    end
  end

  describe "degree_below" do
    test "d in c_major" do
      pitch_below =
        Scale.c_major()
        |> Scale.degree_below(Pitch.new(number: 2))

      assert pitch_below == Pitch.new(number: 0)
    end

    test "a in c_major" do
      pitch_below =
        Scale.c_major()
        |> Scale.degree_below(Pitch.new(number: 9))

      assert pitch_below == Pitch.new(number: 7)
    end

    test "middle d in c_major (preserves octave)" do
      pitch_below =
        Scale.c_major()
        |> Scale.degree_below(Pitch.new(number: 2, octave: 4))

      assert pitch_below == Pitch.new(number: 0, octave: 4)
    end

    test "c in c_major (decreases octave)" do
      pitch_below =
        Scale.c_major()
        |> Scale.degree_below(Pitch.new(number: 0, octave: 4))

      assert pitch_below == Pitch.new(number: 11, octave: 3)
    end
  end

  describe "steps_between on c_major_scale is correct for" do
    test "c to c on same octave" do
      assert 0 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Scale.c_major() |> Scale.at(1),
                 Scale.c_major() |> Scale.at(1)
               )
    end

    test "c to e" do
      assert 2 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Scale.c_major() |> Scale.at(1),
                 Scale.c_major() |> Scale.at(3)
               )
    end

    test "b down to g" do
      assert -2 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Scale.c_major() |> Scale.at(7),
                 Scale.c_major() |> Scale.at(5)
               )
    end

    test "c up to b" do
      assert 6 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Scale.c_major() |> Scale.at(1),
                 Scale.c_major() |> Scale.at(7)
               )
    end

    test "c down to b" do
      assert -1 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Pitch.new(number: 0, octave: 3),
                 Pitch.new(number: 11, octave: 2)
               )
    end

    test "c to c down an octave" do
      assert -7 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Pitch.new(number: 0, octave: 4),
                 Pitch.new(number: 0, octave: 3)
               )
    end

    test "e to d on a non-default octave" do
      assert -1 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Pitch.new(number: 4, octave: 4),
                 Pitch.new(number: 2, octave: 4)
               )
    end

    test "c down a 9th to b" do
      assert -8 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Pitch.new(number: 0, octave: 3),
                 Pitch.new(number: 11, octave: 1)
               )
    end

    test "c up a 9th to d" do
      assert 8 ==
               Scale.steps_between(
                 Scale.c_major(),
                 Pitch.new(number: 0, octave: 3),
                 Pitch.new(number: 2, octave: 4)
               )
    end

    test "note not in scale (should throw)" do
      assert_raise(
        ArgumentError,
        ~r"pitch.*not in scale.*",
        fn ->
          Scale.steps_between(
            Scale.c_major(),
            # c sharp
            Pitch.new(number: 1, octave: 4, alteration: 1),
            Pitch.new(number: 3, octave: 3)
          )
        end
      )
    end
  end

  describe "contains" do
    test "returns true for pitch in the scale" do
      assert Scale.contains(Scale.c_major(), Pitch.new(number: 0, octave: 99))
    end

    test "returns false for pitch in the scale" do
      refute Scale.contains(Scale.c_major(), Pitch.new(number: 1, octave: 99))
    end
  end
end
