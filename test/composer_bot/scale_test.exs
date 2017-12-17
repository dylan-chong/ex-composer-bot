defmodule ComposerBotTest.Scale do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ComposerBot.{Scale, Pitch}
  doctest Scale, import: true

  describe "major_scale starting on" do
    test "c" do
      s = Scale.c_major_scale()
      assert s == [%Pitch{note_num: 0},
                   %Pitch{note_num: 2},
                   %Pitch{note_num: 4},
                   %Pitch{note_num: 5},
                   %Pitch{note_num: 7},
                   %Pitch{note_num: 9},
                   %Pitch{note_num: 11}]
    end

    # TODO Different scales not implemented yet
    # test "g major" do
      # s = Scale.c_major_scale()
      # assert s == [%Pitch{note_num: 7},
                   # %Pitch{note_num: 9},
                   # %Pitch{note_num: 11},
                   # %Pitch{note_num: 0},
                   # %Pitch{note_num: 2},
                   # %Pitch{note_num: 4},
                   # %Pitch{note_num: 6, alteration: 1}]
    # end
  end

  describe "degree_above" do
    test "c in c_major" do
      # Assumes c_major_scale can be generated properly
      pitch_above = Scale.c_major_scale()
                    |> Scale.degree_above(%Pitch{note_num: 0})
      assert pitch_above == %Pitch{note_num: 2}
    end

    test "g in c_major" do
      pitch_above = Scale.c_major_scale()
                    |> Scale.degree_above(%Pitch{note_num: 7})
      assert pitch_above == %Pitch{note_num: 9}
    end

    test "middle c in c_major (preserves octave)" do
      pitch_above = Scale.c_major_scale()
                    |> Scale.degree_above(%Pitch{note_num: 0, octave: 4})
      assert pitch_above == %Pitch{note_num: 2, octave: 4}
    end

    test "b in c_major (increases octave)" do
      pitch_above = Scale.c_major_scale()
                    |> Scale.degree_above(%Pitch{note_num: 11, octave: 4})
      assert pitch_above == %Pitch{note_num: 0, octave: 5}
    end
  end

  describe "degree_below" do
    test "d in c_major" do
      pitch_below = Scale.c_major_scale()
                    |> Scale.degree_below(%Pitch{note_num: 2})
      assert pitch_below == %Pitch{note_num: 0}
    end

    test "a in c_major" do
      pitch_below = Scale.c_major_scale()
                    |> Scale.degree_below(%Pitch{note_num: 9})
      assert pitch_below == %Pitch{note_num: 7}
    end

    test "middle d in c_major (preserves octave)" do
      pitch_below = Scale.c_major_scale()
                    |> Scale.degree_below(%Pitch{note_num: 2, octave: 4})
      assert pitch_below == %Pitch{note_num: 0, octave: 4}
    end

    test "c in c_major (decreases octave)" do
      pitch_below = Scale.c_major_scale()
                    |> Scale.degree_below(%Pitch{note_num: 0, octave: 4})
      assert pitch_below == %Pitch{note_num: 11, octave: 3}
    end
  end

  describe "steps_between on c_major_scale is correct for" do
    test "c to c on same octave" do
      assert 0 == Scale.steps_between(
        Scale.c_major_scale(),
        Scale.c_major_scale() |> elem(0),
        Scale.c_major_scale() |> elem(0)
      )
    end

    test "c to e" do
      assert 2 == Scale.steps_between(
        Scale.c_major_scale(),
        Scale.c_major_scale() |> elem(0),
        Scale.c_major_scale() |> elem(2)
      )
    end

    test "b down to g" do
      assert -2 == Scale.steps_between(
        Scale.c_major_scale(),
        Scale.c_major_scale() |> elem(6),
        Scale.c_major_scale() |> elem(4)
      )
    end

    test "c up to b" do
      assert 6 == Scale.steps_between(
        Scale.c_major_scale(),
        Scale.c_major_scale() |> elem(0),
        Scale.c_major_scale() |> elem(6)
      )
    end

    test "c down to b" do
      assert -1 == Scale.steps_between(
        Scale.c_major_scale(),
        %Pitch{note_num: 0, octave: 3},
        %Pitch{note_num: 11, octave: 2}
      )
    end

    test "c to c down an octave" do
      assert -7 == Scale.steps_between(
        Scale.c_major_scale(),
        %Pitch{note_num: 0, octave: 4},
        %Pitch{note_num: 0, octave: 3}
      )
    end

    test "e to d on a non-default octave" do
      assert -1 == Scale.steps_between(
        Scale.c_major_scale(),
        %Pitch{note_num: 4, octave: 4},
        %Pitch{note_num: 3, octave: 3}
      )
    end

    test "note not in scale (should throw)" do
      assert_raise ArgumentError, fn -> Scale.steps_between(
        Scale.c_major_scale(),
        %Pitch{note_num: 1, octave: 4, alteration: 1}, # c sharp
        %Pitch{note_num: 3, octave: 3}
      ) end
    end
  end

end
