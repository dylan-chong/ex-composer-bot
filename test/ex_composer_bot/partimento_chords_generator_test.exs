defmodule ExComposerBotTest.PartimentoChordsGenerator do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExComposerBot.{PartimentoChordsGenerator, Voice, Note, Scale, Chord.RomanChord}

  test "generate_bass/1 creates a voice containing multiple notes" do
    %Voice{notes: [%Note{} | _]} = PartimentoChordsGenerator.generate_bass(number_of_notes: 3)
  end

  describe "generate_chords/1 creates" do
    setup do
      scale = Scale.c_major()
      bass = PartimentoChordsGenerator.generate_bass(number_of_notes: 3, scale: scale)
      %{scale: scale, bass: bass}
    end

    test "a list of chords", %{scale: scale, bass: bass} do
      [%RomanChord{} | _] = PartimentoChordsGenerator.generate_chords(bass, scale)
    end

    test "a list of length equal to the bass length", %{scale: scale, bass: bass} do
      chords = PartimentoChordsGenerator.generate_chords(bass, scale)

      assert length(chords) == 3
    end
  end
end
