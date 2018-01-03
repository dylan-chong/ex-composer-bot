defmodule ComposerBot.Note do
  @moduledoc """
  A wrapper around `ComposerBot.Pitch`. A note can be a rest, and must have a
  length.
  """

  alias ComposerBot.{Note, Pitch}

  @doc """
  * :pitch - A `Pitch`. Should be `nil` if this `Note` should be a rest
  * :length - Should be `1` for a semibrieve, `2` for a minim, `4` for a
  crotchet, etc. Notes longer than a semibrieve aren't supported for now.
  * :tied - Is this `Note` tied to the next `Note`
  * :note_above - nil, or another `Note` that should have the same length as
  this `Note`, and has a pitch that is higher than this. It can have it's own
  properties (`pitch`, `tied`, or another `note_above`), although the lengths
  of all notes above ignored.
  """
  @type t :: %Note{
    pitch: Pitch.t | nil,
    length: integer,
    tied: boolean,
    note_above: Note.t
  }
  @enforce_keys [:pitch]
  defstruct [:pitch, length: 4, tied: false, note_above: nil]

  @doc """
  Exports this `Note` to a format that can be pasted into LilyPond
  """
  @spec to_lily_string(t) :: String.t
  def to_lily_string(%Note{pitch: nil, length: length}) do
    "r#{length}"
  end

  def to_lily_string(note = %Note{length: length, note_above: nil}) do
    "#{to_string_with_tie(note)}#{length}"
  end

  def to_lily_string(note = %Note{length: length}) do
    # note_above is non-nil
    "<#{to_lily_string_simple(note)}>#{length}"
  end

  defp to_string_with_tie(%Note{pitch: pitch, tied: tied}) do
    note_base = Pitch.to_lily_string(pitch)
    tied_string = if tied, do: "~", else: ""
    "#{note_base}#{tied_string}"
  end

  # Converting chords to string
  defp to_lily_string_simple(note = %Note{note_above: nil}) do
    "#{to_string_with_tie(note)}"
  end

  defp to_lily_string_simple(note = %Note{note_above: note_above}) do
    "#{to_string_with_tie(note)} #{to_lily_string_simple(note_above)}"
  end

end
