defmodule ComposerBotTest.Scale do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ComposerBot.{Scale, Pitch}
  doctest Scale, import: true

  describe "major_scale starting on" do
    test "c" do
      s = Scale.c_major()
      assert s.pitches == [
        %Pitch{number: 0},
        %Pitch{number: 2},
        %Pitch{number: 4},
        %Pitch{number: 5},
        %Pitch{number: 7},
        %Pitch{number: 9},
        %Pitch{number: 11}
      ]
    end

    @tag :todo # TODO Different scales not implemented yet
    test "g major" do
      s = Scale.type(:major, %Pitch{number: 7})
      assert s.pitches == [
        %Pitch{number: 7},
        %Pitch{number: 9},
        %Pitch{number: 11},
        %Pitch{number: 0},
        %Pitch{number: 2},
        %Pitch{number: 4},
        %Pitch{number: 6, alteration: 1}
      ]
    end
  end

  describe "degree_above" do
    test "c in c_major" do
      # Assumes c_major can be generated properly
      pitch_above = Scale.c_major()
                    |> Scale.degree_above(%Pitch{number: 0})
      assert pitch_above == %Pitch{number: 2}
    end

    test "g in c_major" do
      pitch_above = Scale.c_major()
                    |> Scale.degree_above(%Pitch{number: 7})
      assert pitch_above == %Pitch{number: 9}
    end

    test "middle c in c_major (preserves octave)" do
      pitch_above = Scale.c_major()
                    |> Scale.degree_above(%Pitch{number: 0, octave: 4})
      assert pitch_above == %Pitch{number: 2, octave: 4}
    end

    test "b in c_major (increases octave)" do
      pitch_above = Scale.c_major()
                    |> Scale.degree_above(%Pitch{number: 11, octave: 4})
      assert pitch_above == %Pitch{number: 0, octave: 5}
    end
  end

  describe "degree_below" do
    test "d in c_major" do
      pitch_below = Scale.c_major()
                    |> Scale.degree_below(%Pitch{number: 2})
      assert pitch_below == %Pitch{number: 0}
    end

    test "a in c_major" do
      pitch_below = Scale.c_major()
                    |> Scale.degree_below(%Pitch{number: 9})
      assert pitch_below == %Pitch{number: 7}
    end

    test "middle d in c_major (preserves octave)" do
      pitch_below = Scale.c_major()
                    |> Scale.degree_below(%Pitch{number: 2, octave: 4})
      assert pitch_below == %Pitch{number: 0, octave: 4}
    end

    test "c in c_major (decreases octave)" do
      pitch_below = Scale.c_major()
                    |> Scale.degree_below(%Pitch{number: 0, octave: 4})
      assert pitch_below == %Pitch{number: 11, octave: 3}
    end
  end

  describe "steps_between on c_major_scale is correct for" do
    test "c to c on same octave" do
      assert 0 == Scale.steps_between(
        Scale.c_major(),
        Scale.c_major() |> Scale.at(0),
        Scale.c_major() |> Scale.at(0)
      )
    end

    test "c to e" do
      assert 2 == Scale.steps_between(
        Scale.c_major(),
        Scale.c_major() |> Scale.at(0),
        Scale.c_major() |> Scale.at(2)
      )
    end

    test "b down to g" do
      assert -2 == Scale.steps_between(
        Scale.c_major(),
        Scale.c_major() |> Scale.at(6),
        Scale.c_major() |> Scale.at(4)
      )
    end

    test "c up to b" do
      assert 6 == Scale.steps_between(
        Scale.c_major(),
        Scale.c_major() |> Scale.at(0),
        Scale.c_major() |> Scale.at(6)
      )
    end

    test "c down to b" do
      assert -1 == Scale.steps_between(
        Scale.c_major(),
        %Pitch{number: 0, octave: 3},
        %Pitch{number: 11, octave: 2}
      )
    end

    test "c to c down an octave" do
      assert -7 == Scale.steps_between(
        Scale.c_major(),
        %Pitch{number: 0, octave: 4},
        %Pitch{number: 0, octave: 3}
      )
    end

    test "e to d on a non-default octave" do
      assert -1 == Scale.steps_between(
        Scale.c_major(),
        %Pitch{number: 4, octave: 4},
        %Pitch{number: 2, octave: 4}
      )
    end

    test "c down a 9th to b" do
      assert -8 == Scale.steps_between(
        Scale.c_major(),
        %Pitch{number: 0, octave: 3},
        %Pitch{number: 11, octave: 1}
      )
    end

    test "c up a 9th to d" do
      assert 8 == Scale.steps_between(
        Scale.c_major(),
        %Pitch{number: 0, octave: 3},
        %Pitch{number: 2, octave: 4}
      )
    end

    test "note not in scale (should throw)" do
      assert_raise(
        ArgumentError,
        ~r"pitch.*not in scale.*",
        fn -> Scale.steps_between(
          Scale.c_major(),
          %Pitch{number: 1, octave: 4, alteration: 1}, # c sharp
          %Pitch{number: 3, octave: 3}
        ) end
      )
    end

  end

end
