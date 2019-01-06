defmodule ExComposerBotTest.FileExport do
  use ExUnit.Case, async: true
  alias ExComposerBot.FileExport

  describe "to_lily_string converts to LilyPond format for " do
    test "no voices" do
      text = FileExport.to_lily_string([])

      expected = """
      \\version "2.18.2"

      \\score {
        \\absolute <<
          \\time 4/4
        >>
        \\layout{}
        \\midi{}
      }
      """

      assert string_tokens(text) == string_tokens(expected)
    end
  end

  defp string_tokens(string) do
    String.split(string, ~r{\s}, trim: true)
  end
end
