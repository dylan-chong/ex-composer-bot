defmodule ComposerBot.Pitch do
  @moduledoc """
  Represents a single pitch (no length, no rest).
  """

  alias ComposerBot.Pitch, as: Pitch

  # LilyPond's default octave number"
  @lily_default_octave 3

  @doc """
  * :note_num - The number of the semitone where 0 is 'C' and 11 is 'B'. This
  includes the alteration, so 1 will be c# or db. (This should really be
  called `:pitch_num`.)
  * :octave - Middle C, and all notes up to (and including) the next B, has
  number 4
  * :alteration - The accidental - 0 for natural, -1 for flat, and 1 for sharp
  """
  @type t :: %Pitch{note_num: integer, octave: integer, alteration: integer}
  @enforce_keys [:note_num]
  defstruct [:note_num, octave: @lily_default_octave, alteration: 0]

  @doc """
  Exports this `Pitch` to a format that can be pasted into LilyPond

  ## Examples

    iex> Pitch.to_lily_string(%Pitch{note_num: 7, octave: 4})
    "g'"

    iex> Pitch.to_lily_string(%Pitch{note_num: 8, alteration: 1})
    "gis"

  """
  @spec to_lily_string(t) :: String.t
  def to_lily_string(pitch) do
    octaves = if pitch.octave == @lily_default_octave do
      ""
    else
      char = if pitch.octave < @lily_default_octave, do: ',', else: '\''
      fn -> char end
      |> Stream.repeatedly()
      |> Enum.take(abs(pitch.octave - @lily_default_octave))
      |> to_string()
    end

    "#{letter(pitch)}#{alteration_to_string(pitch)}#{octaves}"
  end

  @doc """
  ## Examples

    iex> Pitch.letter(%Pitch{note_num: 0})
    'c'

    iex> Pitch.letter(%Pitch{note_num: 6, alteration: -1})
    'g'

  """
  @spec letter(t) :: charlist
  def letter(%Pitch{note_num: note_num, alteration: alteration}) do
    # Add 12 to account for the possibility of negative numbers
    letter(rem(note_num - alteration + 12, 12))
  end

  @doc """
  Gets the letter for a given `note_num`.

  The alteration should have been accounted for when this method is called
  because this method only accepts natural notes. The note_num of `dis` will
  cause an error to be thrown, and the note_num of `cisis` will return `'d'`).
  """
  @spec letter(integer) :: charlist
  def letter(note_num) when is_integer(note_num) do
    case note_num do
      0 -> 'c'
      2 -> 'd'
      4 -> 'e'
      5 -> 'f'
      7 -> 'g'
      9 -> 'a'
      11 -> 'b'
      _ -> raise "note_num #{note_num} is not natural"
    end
  end

  @doc """
  Converts the alteration/accidental to LilyPond format
  """
  @spec alteration_to_string(Pitch.t) :: String.t
  def alteration_to_string(%Pitch{alteration: alteration}) do
    case alteration do
      0 -> "" # natural
      1 -> "is" # sharp
      2 -> "isis" # double sharp
      -1 -> "es" # flat
      -2 -> "eses" # double flat
      _ -> raise "Invalid alteration %{alteration}"
    end
  end

  @spec letters :: list(String.grapheme)
  def letters do
    String.graphemes("cdefgab")
  end

  @spec c_major_note_nums :: list(integer)
  def c_major_note_nums do
    [0, 2, 4, 5, 7, 9, 11]
  end

  def equals_ignore_octave(pitch_a, pitch_b) do
    pitch_a.note_num == pitch_b.note_num &&
    pitch_a.alteration == pitch_b.alteration
  end

end
