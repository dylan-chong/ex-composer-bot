defmodule ExComposerBotTest.PartimentoChordsGenerator do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExComposerBot.{PartimentoChordsGenerator, Voice, Note, Scale, Chord.RomanChord}

  test "generate_bass/1 creates a voice containing multiple notes" do
    %Voice{notes: [%Note{} | _]} = PartimentoChordsGenerator.generate_bass(number_of_notes: 3)
  end

  test "generate_chords/1 creates a list of chords" do
    scale = Scale.c_major()
    bass = PartimentoChordsGenerator.generate_bass(number_of_notes: 3, scale: scale)

    [%RomanChord{} | _] = PartimentoChordsGenerator.generate_chords(bass, scale)
  end
end
