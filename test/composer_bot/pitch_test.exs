defmodule ComposerBotTest.Pitch do
  use ExUnit.Case, async: true
  alias ComposerBot.Pitch, as: Pitch

  doctest ComposerBot.Pitch, import: true

  describe "to_lily_string returns correct format for LilyPond:" do
    test "octave below middle c" do
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

  describe "get_letter returns correct letter even with alterations: " do
    test "c" do
      p = %Pitch{note_num: 0}
      assert Pitch.get_letter(p) == 'c'
    end

    test "b" do
      p = %Pitch{note_num: 11}
      assert Pitch.get_letter(p) == 'b'
    end

    test "cis returns c" do
      p = %Pitch{note_num: 1, alteration: 1}
      assert Pitch.get_letter(p) == 'c'
    end

    test "bis returns b (not c)" do
      p = %Pitch{note_num: 0, alteration: 1}
      assert Pitch.get_letter(p) == 'b'
    end

    test "fis returns b" do
      p = %Pitch{note_num: 6, alteration: 1}
      assert Pitch.get_letter(p) == 'f'
    end

    test "ges returns g" do
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
