defmodule ExComposerBotTest.Note do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExComposerBot.{Note, Pitch}

  describe "to_lily_string returns correct LilyPond for a" do
    # These tests assume `Pitch.to_lily_string` works correctly

    test "crotchet c one octave below middle c" do
      n = Note.new(pitch: Pitch.new(number: 0), length: 4)
      assert Note.to_lily_string(n) == "c4"
    end

    test "crotchet middle c" do
      n = Note.new(pitch: Pitch.new(number: 0, octave: 4), length: 4)
      assert Note.to_lily_string(n) == "c'4"
    end

    test "quaver middle c" do
      n = Note.new(pitch: Pitch.new(number: 0, octave: 4), length: 8)
      assert Note.to_lily_string(n) == "c'8"
    end

    test "quaver gis above middle c" do
      n = Note.new(pitch: Pitch.new(number: 8, octave: 4, alteration: 1), length: 8)
      assert Note.to_lily_string(n) == "gis'8"
    end

    test "minim gis above middle c" do
      n = Note.new(pitch: Pitch.new(number: 8, octave: 4, alteration: 1), length: 2)
      assert Note.to_lily_string(n) == "gis'2"
    end

    test "tied note" do
      n = Note.new(pitch: Pitch.new(number: 7), tied: true)
      assert Note.to_lily_string(n) == "g~4"
    end

    test "rest" do
      n = Note.new(pitch: :is_rest)
      assert Note.to_lily_string(n) == "r4"
    end

    test "chord with 2 notes" do
      chord =
        Note.new(
          pitch: Pitch.new(number: 0),
          note_above: Note.new(pitch: Pitch.new(number: 2))
        )

      assert Note.to_lily_string(chord) == "<c d>4"
    end

    test "chord with 3 notes and an accidental" do
      top = Note.new(pitch: Pitch.new(number: 3, alteration: -1), note_above: nil)
      middle = Note.new(pitch: Pitch.new(number: 2), note_above: top)
      bottom = Note.new(pitch: Pitch.new(number: 0), note_above: middle)
      assert Note.to_lily_string(bottom) == "<c d ees>4"
    end
  end
end
