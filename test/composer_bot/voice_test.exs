defmodule ComposerBotTest.Voice do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ComposerBot.{Voice, Note, Pitch}

  describe "sequence of notes outputs correct LilyPond format" do
    # Assumes that `Note.to_lily_string` works properly

    test "for one note" do
      v = %Voice{notes: [
        %Note{pitch: %Pitch{note_num: 0}}
      ]}
      # The '\' is literal
      assert Voice.to_lily_string(v) == "\absolute {c4}"
    end

    test "for two notes" do
      v = %Voice{notes: [
        %Note{pitch: %Pitch{note_num: 1, alteration: 1}},
        %Note{pitch: %Pitch{note_num: 0}}
      ]}
      assert Voice.to_lily_string(v) == "\absolute {c4} \absolute {cis4}"
    end

  end
end
