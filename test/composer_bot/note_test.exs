defmodule ComposerBotTest.Note do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ComposerBot.{Note, Pitch}

  describe "to_lily_string returns correct LilyPond for a" do
    # These tests assume `Pitch.to_lily_string` works correctly

    test "crotchet c one octave below middle c" do
      n = %Note{pitch: %Pitch{note_num: 0}, length: 4}
      # The '\' is literal
      assert Note.to_lily_string(n) == "c4"
    end

    test "crotchet middle c" do
      n = %Note{pitch: %Pitch{note_num: 0, octave: 4}, length: 4}
      assert Note.to_lily_string(n) == "c'4"
    end

    test "quaver middle c" do
      n = %Note{pitch: %Pitch{note_num: 0, octave: 4}, length: 8}
      assert Note.to_lily_string(n) == "c'8"
    end

    test "quaver gis above middle c" do
      n = %Note{pitch: %Pitch{note_num: 8, octave: 4, alteration: 1}, length: 8}
      assert Note.to_lily_string(n) == "gis'8"
    end

    test "minim gis above middle c" do
      n = %Note{pitch: %Pitch{note_num: 8, octave: 4, alteration: 1}, length: 2}
      assert Note.to_lily_string(n) == "gis'2"
    end

    test "tied note" do
      n = %Note{pitch: %Pitch{note_num: 7}, tied: true}
      assert Note.to_lily_string(n) == "g4~"
    end

    test "rest" do
      n = %Note{pitch: nil}
      assert Note.to_lily_string(n) == "r4"
    end

  end
end
