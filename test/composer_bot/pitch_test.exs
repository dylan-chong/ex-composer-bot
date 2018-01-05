defmodule ExComposerBotTest.Pitch do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExComposerBot.Pitch, as: Pitch

  doctest Pitch, import: true

  describe "to_lily_string returns correct format for a pitch" do
    test "an octave below middle c" do
      p = Pitch.new(number: 0, octave: 3)
      assert Pitch.to_lily_string(p) ==  "c"
    end

    test "with above middle c" do
      p = Pitch.new(number: 7, octave: 4)
      assert Pitch.to_lily_string(p) ==  "g'"
    end

    test "roughly 2 octaves below middle c" do
      p = Pitch.new(number: 4, octave: 2)
      assert Pitch.to_lily_string(p) ==  "e,"
    end

    test "with a sharp" do
      p = Pitch.new(number: 8, alteration: 1)
      assert Pitch.to_lily_string(p) ==  "gis"
    end

    test "with a flat" do
      p = Pitch.new(number: 10, alteration: -1)
      assert Pitch.to_lily_string(p) ==  "bes"
    end

    test "with a flat, 2 octaves below middle c" do
      p = Pitch.new(number: 10, alteration: -1, octave: 4)
      assert Pitch.to_lily_string(p) ==  "bes'"
    end

    test "2 octaves above middle c" do
      p = Pitch.new(number: 0, octave: 5)
      assert Pitch.to_lily_string(p) ==  "c''"
    end
  end

  describe "letter returns base letter for pitch" do
    test "c" do
      p = Pitch.new(number: 0)
      assert Pitch.letter(p) == 'c'
    end

    test "b" do
      p = Pitch.new(number: 11)
      assert Pitch.letter(p) == 'b'
    end

    test "cis" do
      p = Pitch.new(number: 1, alteration: 1)
      assert Pitch.letter(p) == 'c'
    end

    test "bis (returns b, not c)" do
      p = Pitch.new(number: 0, alteration: 1)
      assert Pitch.letter(p) == 'b'
    end

    test "fis" do
      p = Pitch.new(number: 6, alteration: 1)
      assert Pitch.letter(p) == 'f'
    end

    test "ges" do
      p = Pitch.new(number: 6, alteration: -1)
      assert Pitch.letter(p) == 'g'
    end

    test "cisis returns g" do
      p = Pitch.new(number: 2, alteration: 2)
      assert Pitch.letter(p) == 'c'
    end

    test "beses returns b" do
      p = Pitch.new(number: 9, alteration: -2)
      assert Pitch.letter(p) == 'b'
    end
  end

end
