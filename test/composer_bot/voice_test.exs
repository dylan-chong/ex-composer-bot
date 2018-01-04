defmodule ComposerBotTest.Voice do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ComposerBot.{Voice, Note, Pitch}

  describe "sequence of notes outputs correct LilyPond format" do
    # Assumes that `Note.to_lily_string` works properly

    test "for one note" do
      v = %Voice{notes: [
        Note.new(pitch: %Pitch{number: 0})
      ]}
      assert Voice.to_lily_string(v) == """
      \\absolute \\new Voice {
        c4
      }
      """
    end

    test "for two notes" do
      # Notes are in reverse order
      v = %Voice{notes: [
        Note.new(pitch: %Pitch{number: 1, alteration: 1}),
        Note.new(pitch: %Pitch{number: 0})
      ]}
      # Assume Voice.into_voice_string works properly if the "for one note"
      # test passes
      assert Voice.to_lily_string(v) == Voice.into_voice_string("c4 cis4")
    end

    test "for zero notes" do
      v = Voice.new(notes: [])
      assert Voice.to_lily_string(v) == Voice.into_voice_string("")
    end

  end
end
