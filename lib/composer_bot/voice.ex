defmodule ComposerBot.Voice do
  @moduledoc """
  Represents sequence of notes for a piece. Notes within this voice cannot
  overlap. There can also be rests.
  """

  alias ComposerBot.{Voice, Note}

  @doc """
  * :notes - A list of `Note`
  """
  @type t :: %Voice{notes: list(ComposerBot.Note.t)}
  @enforce_keys [:notes]
  defstruct [:notes]

  def to_lily_string(%Voice{notes: notes}) do
    notes
    |> Enum.map(&Note.to_lily_string/1)
    |> Enum.join(" ")
  end

end
