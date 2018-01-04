defmodule ComposerBot.Voice do
  @moduledoc """
  Represents sequence of notes for a piece. Notes within this voice cannot
  overlap with each other.
  """

  alias ComposerBot.{Voice, Note}

  @doc """
  * :notes - A list of `Note`, starting with the last note (reverse order)
  """
  @type t :: %Voice{notes: list(Note.t)}
  @enforce_keys [:notes]
  defstruct [:notes]
  use ExStructable

  @spec to_lily_string(Voice.t) :: String.t
  def to_lily_string(%Voice{notes: notes}) do
    notes
    |> Enum.reverse()
    |> Enum.map(&Note.to_lily_string/1)
    |> Enum.join(" ")
    |> into_voice_string()
  end

  @spec into_voice_string(String.t) :: String.t
  def into_voice_string(notes_string) when is_bitstring(notes_string) do
    """
    \\absolute \\new Voice {
      #{notes_string}
    }
    """
  end

end
