defmodule ExComposerBot.Pitch do
  @moduledoc """
  Represents a single pitch (no length, no rest).
  """

  alias ExComposerBot.Pitch, as: Pitch

  # LilyPond's default octave number
  @lily_default_octave 3

  @doc """
  * :number - The pitch number of the semitone where 0 is 'C' and 11 is 'B'.
  This includes the alteration, so a pitch number of 1 will be c# or db.
  * :octave - Middle C, and all notes up to (and including) the next B, has
  number 4.
  * :alteration - The accidental: 0 for natural, 1 for sharp, 2 for double
  sharp. Use negative numbers for flats.
  """
  @type t :: %Pitch{number: integer, octave: integer, alteration: integer}
  @enforce_keys [:number]
  defstruct [:number, octave: @lily_default_octave, alteration: 0]
  use ExStructable

  @impl true
  def validate_struct(pitch, _) do
    unless (
      pitch.number in 0..11
      and is_integer(pitch.octave)
      and pitch.alteration in -2..2
    ) do
      raise ArgumentError, "Invalid pitch: #{inspect(pitch)}"
    end
    pitch
  end

  def default_octave, do: @lily_default_octave

  @doc """
  Exports this `Pitch` to a format that can be pasted into LilyPond

  ## Examples

      iex> Pitch.to_lily_string(Pitch.new(number: 7, octave: 4))
      "g'"

      iex> Pitch.to_lily_string(Pitch.new(number: 8, alteration: 1))
      "gis"

  """
  @spec to_lily_string(t) :: String.t
  def to_lily_string(pitch = %Pitch{octave: octave}) do
    octaves = if octave == @lily_default_octave do
      ""
    else
      char = if octave < @lily_default_octave, do: ",", else: "'"
      fn -> char end
      |> Stream.repeatedly()
      |> Enum.take(abs(octave - @lily_default_octave))
      |> to_string()
    end

    "#{letter(pitch)}#{alteration_to_string(pitch)}#{octaves}"
  end

  @doc """
  ## Examples

      iex> Pitch.letter(Pitch.new(number: 0))
      "c"

      iex> Pitch.letter(Pitch.new(number: 6, alteration: -1))
      "g"

  """
  @spec letter(t) :: String.t
  def letter(%Pitch{number: number, alteration: alteration}) do
    # Add 12 to account for the possibility of negative numbers
    letter(rem(number - alteration + 12, 12))
  end

  @doc """
  Gets the letter for a given `pitch_number`.

  The alteration should have been accounted for when this method is called
  because this method only accepts natural notes. The pitch_number of `dis` will
  cause an error to be thrown, and the pitch_number of `cisis` will return `"d"`).
  """
  @spec letter(integer) :: String.t
  def letter(pitch_number) when is_integer(pitch_number) do
    case pitch_number do
      0 -> "c"
      2 -> "d"
      4 -> "e"
      5 -> "f"
      7 -> "g"
      9 -> "a"
      11 -> "b"
      _ -> raise "pitch_number #{pitch_number} is not natural"
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

  @spec c_major_numbers :: list(integer)
  def c_major_numbers do
    [0, 2, 4, 5, 7, 9, 11]
  end

  def equals_ignore_octave(pitch_a = %Pitch{}, pitch_b = %Pitch{}) do
    pitch_a.number == pitch_b.number &&
        pitch_a.alteration == pitch_b.alteration
  end

end
