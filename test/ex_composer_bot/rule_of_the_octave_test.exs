defmodule ExComposerBotTest.RuleOfTheOctave do
  use ExUnit.Case, async: true
  alias ExComposerBot.{RuleOfTheOctave, Pitch, Scale, Chord.RomanChord}

  describe "next_chord for the bass" do
    test "c to d" do
      c = Pitch.new(number: 0)
      b = Pitch.new(number: 11)
      d = Pitch.new(number: 2)

      scale = Scale.c_major()
      expected = RomanChord.new(root: b, inversion: 1, scale: scale)
      next_chord = RuleOfTheOctave.next_chord(d, c, scale)

      assert next_chord == expected
    end

    # TODO
    #     test "f to g" do
    #       d = Pitch.new(number: 2)

    #       scale = Scale.c_major()
    #       expected = RomanChord.new(root: d, inversion: 1, scale: scale)
    #       next_chord = RuleOfTheOctave.next_chord(f, g, scale)

    #       assert next_chord == expected
    #     end
  end
end
