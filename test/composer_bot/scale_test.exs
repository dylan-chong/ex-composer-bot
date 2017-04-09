defmodule ComposerBotTest.Scale do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ComposerBot.{Scale, Pitch}

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

end
