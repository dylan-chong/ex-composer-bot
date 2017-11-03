defmodule ComposerBotTest.FileExport do
  use ExUnit.Case
  alias ComposerBot.FileExport

  describe "to_lily_string converts to LilyPond format for " do
    test "no voices" do
      text = FileExport.to_lily_string([])
      expected = """
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

    test "temp" do
      alias ComposerBot.{PartimentoChordsGenerator}
      bass = PartimentoChordsGenerator.generate_bass
      s = FileExport.to_lily_string [bass, bass]
      IO.puts "\n\n\n#{s}\n\n\n"
      require IEx
      IEx.pry
    end
  end

  defp string_tokens(string) do
    String.split(string, ~r{\s}, [trim: true])
  end

end
