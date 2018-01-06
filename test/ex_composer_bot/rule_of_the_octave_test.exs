defmodule ExComposerBotTest.RuleOfTheOctave do
  use ExUnit.Case
  alias ExComposerBot.{RuleOfTheOctave, Pitch, Scale, Chord.RomanChord}

  describe "next_chord for the bass ascending from" do
    @tag :todo
    test "c to d" do
      c = Pitch.new(number: 0)
      b = Pitch.new(number: 11)
      d = Pitch.new(number: 2)

      scale = Scale.c_major()
      chord_vii_dim_6 = RomanChord.new(root: b, inversion: 1, scale: scale)
      next_chord = RuleOfTheOctave.next_chord(d, c, scale)

      assert next_chord == chord_vii_dim_6
    end
  end

end
