defmodule ComposerBotTest.Pitch do
  use ExUnit.Case, async: true
  alias ComposerBot.Pitch, as: Pitch

  doctest Pitch, import: true

  describe "to_lily_string returns LilyPond format for a note" do
    test "an octave below middle c" do
      p = %Pitch{note_num: 0, octave: 3}
      # The '\' is literal
      assert Pitch.to_lily_string(p) ==  "\absolute {c}"
    end

    test "with above middle c" do
      p = %Pitch{note_num: 7, octave: 4}
      assert Pitch.to_lily_string(p) ==  "\absolute {g'}"
    end

    test "roughly 2 octaves below middle c" do
      p = %Pitch{note_num: 4, octave: 2}
      assert Pitch.to_lily_string(p) ==  "\absolute {e,}"
    end

    test "with a sharp" do
      p = %Pitch{note_num: 8, alteration: 1}
      assert Pitch.to_lily_string(p) ==  "\absolute {gis}"
    end

    test "with a flat" do
      p = %Pitch{note_num: 10, alteration: -1}
      assert Pitch.to_lily_string(p) ==  "\absolute {bes}"
    end

    test "with a flat, 2 octaves below middle c" do
      p = %Pitch{note_num: 10, alteration: -1, octave: 4}
      assert Pitch.to_lily_string(p) ==  "\absolute {bes'}"
    end

    test "2 octaves above middle c" do
      p = %Pitch{note_num: 0, octave: 5}
      assert Pitch.to_lily_string(p) ==  "\absolute {c''}"
    end
  end

  describe "get_letter returns base letter for note" do
    test "c" do
      p = %Pitch{note_num: 0}
      assert Pitch.get_letter(p) == 'c'
    end

    test "b" do
      p = %Pitch{note_num: 11}
      assert Pitch.get_letter(p) == 'b'
    end

    test "cis" do
      p = %Pitch{note_num: 1, alteration: 1}
      assert Pitch.get_letter(p) == 'c'
    end

    test "bis (returns b, not c)" do
      p = %Pitch{note_num: 0, alteration: 1}
      assert Pitch.get_letter(p) == 'b'
    end

    test "fis" do
      p = %Pitch{note_num: 6, alteration: 1}
      assert Pitch.get_letter(p) == 'f'
    end

    test "ges" do
      p = %Pitch{note_num: 6, alteration: -1}
      assert Pitch.get_letter(p) == 'g'
    end

    test "cisis returns g" do
      p = %Pitch{note_num: 2, alteration: 2}
      assert Pitch.get_letter(p) == 'c'
    end

    test "beses returns b" do
      p = %Pitch{note_num: 9, alteration: -2}
      assert Pitch.get_letter(p) == 'b'
    end
  end

end
