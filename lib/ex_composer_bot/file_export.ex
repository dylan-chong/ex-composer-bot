defmodule ExComposerBot.FileExport do
  @moduledoc "Exports voices to LilyPond format."

  alias ExComposerBot.{Voice}

  @spec to_lily_string(list(Voice.t())) :: String.t()
  def to_lily_string(_voices = []) do
    into_lily_file_string("")
  end

  def to_lily_string([top = %Voice{}, bottom = %Voice{}]) do
    """
    \\new Staff <<
      \\key c \\major
      \\clef treble
      #{Voice.to_lily_string(top)}
    >>

    \\new Staff <<
      \\key c \\major
      \\clef bass
      #{Voice.to_lily_string(bottom)}
    >>
    """
    |> into_lily_file_string()
  end

  def write_to(lily_string, path) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, lily_string)
  end

  defp into_lily_file_string(voices_string)
       when is_bitstring(voices_string) do
    """
    \\score {

      \\absolute <<
        \\time 4/4
        #{voices_string}
      >>

      \\layout{}
      \\midi{}
    }
    """
  end
end
