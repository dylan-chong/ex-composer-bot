defmodule ComposerBot.Note do
  @moduledoc """
  A wrapper around `ComposerBot.Pitch`. A note can be a rest, and must have a
  length.
  """

  alias ComposerBot.{Note, Pitch}

  @doc """
  * :pitch - A `ComposerBot.Pitch`. Should be `nil` if this `Note` should be a
  rest (TODO LATER make rests work)
  * :length - Should be `1` for a semibrieve, `2` for a minim, `4` for a
  crotchet, etc. Notes longer than a semibrieve aren't supported for now.
  * :tied - Is this `Note` tied to the next `Note`
  """
  @type t :: %Note{pitch: Pitch.t | nil, length: integer, tied: boolean}
  @enforce_keys [:pitch]
  defstruct [:pitch, length: 4, tied: false]

  @doc """
  Exports this `Note` to a format that can be pasted into LilyPond
  """
  @spec to_lily_string(t) :: String.t
  def to_lily_string(note) do
    note_base = Pitch.to_lily_string(note.pitch)
    tied_string = if note.tied, do: "~", else: ""
    "\absolute {#{note_base}#{note.length}#{tied_string}}"
  end
end
