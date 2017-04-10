defmodule ComposerBot.FileExport do
  alias ComposerBot.{FileExport, Voice}

  @spec to_lily_string(list(Voice.t)) :: String.t

  def to_lily_string(voices = []) do
    into_lily_file_string("")
  end

  def to_lily_string(voices = [top, bottom]) do
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

  defp into_lily_file_string(voices_string) do
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
