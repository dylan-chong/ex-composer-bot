defmodule ExComposerBotTest.PartimentoChordsGenerator do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExComposerBot.{PartimentoChordsGenerator, Voice, Note, Scale, Chord.RomanChord}

  describe "generate_bass/1 creates" do
    test "a voice containing multiple notes" do
      %Voice{notes: [%Note{} | _]} =
        PartimentoChordsGenerator.generate_bass(number_of_notes: 3)
    end

    test "a list of length equal to the bass length" do
      %Voice{notes: notes} = PartimentoChordsGenerator.generate_bass(number_of_notes: 3)

      assert length(notes) == 3
    end

    test "a list where the first note is the tonic" do
      scale = Scale.c_major()

      %Voice{notes: [first_note | _]} =
        PartimentoChordsGenerator.generate_bass(number_of_notes: 3, scale: scale)

      assert first_note.pitch == hd(scale.pitches)
    end
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

    test "a list where the first chord is the tonic", %{scale: scale, bass: bass} do
      [first_chord | _] = PartimentoChordsGenerator.generate_chords(bass, scale)

      assert first_chord.root == hd(scale.pitches)
      assert first_chord.inversion == 0
    end
  end
end
