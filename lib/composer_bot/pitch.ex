defmodule ComposerBot.Pitch do
  @moduledoc """
  Represents a single note
  """

  @doc "LilyPond's default octave number"
  @lily_default_octave 3

  @doc """
  * :note_num The number of the semitone where 0 is 'C' and 11 is 'B'. This includes
              the alteration, so 1 will be c# or db
  * :octave Middle C, and all notes up to (and including) the next B, has number 4
  * :alteration The accidental - 0 for natural, -1 for flat, and 1 for sharp
  """
  @enforce_keys [:note_num]
  defstruct [:note_num, octave: @lily_default_octave, alteration: 0]

  @doc """
  Exports this pitch to a format that can be pasted into LilyPond

  ## Examples

    iex> Pitch.to_lily_string(%Pitch{note_num: 7, octave: 4})
    "\\absolute {g'}"

    iex> Pitch.to_lily_string(%Pitch{note_num: 8, alteration: 1})
    "\\absolute {gis}"

  """
  @lint {Credo.Check.Refactor.PipeChainStart, false}
  def to_lily_string(pitch) do
    octaves = if pitch.octave == @lily_default_octave do
      ""
    else
      char = if pitch.octave < @lily_default_octave, do: ',', else: '\''
      Stream.repeatedly(fn -> char end)
      |> Enum.take(abs(pitch.octave - @lily_default_octave))
      |> to_string()
    end

    # The '\' is literal for some reason
    "\absolute {#{get_letter(pitch)}#{alteration_to_string(pitch)}#{octaves}}"
  end

  @doc """
  ## Examples

    iex> Pitch.get_letter(%Pitch{note_num: 0})
    'c'

    iex> Pitch.get_letter(%Pitch{note_num: 6, alteration: -1})
    'g'

  """
  def get_letter(%{note_num: note_num, alteration: alteration}) do
    case rem(note_num - alteration + 12, 12) do
      0 -> 'c'
      2 -> 'd'
      4 -> 'e'
      5 -> 'f'
      7 -> 'g'
      9 -> 'a'
      11 -> 'b'
      _ -> raise "Alteration #{alteration} is impossible for note #{note_num}"
    end
  end

  @doc """
  Converts the alteration/accidental to LilyPond format
  """
  def alteration_to_string(%{alteration: alteration}) do
    case alteration do
      0 -> "" # natural
      1 -> "is" # sharp
      2 -> "isis" # double sharp
      -1 -> "es" # flat
      -2 -> "eses" # double flat
      _ -> raise "Invalid alteration %{alteration}"
    end
  end

end
