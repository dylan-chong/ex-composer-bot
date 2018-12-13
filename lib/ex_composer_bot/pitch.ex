defmodule ExComposerBot.Pitch do
  @moduledoc """
  Represents a single pitch (no length, no rest).
  """

  alias ExComposerBot.Pitch, as: Pitch

  # LilyPond's default octave number
  @lily_default_octave 3

  @pitch_number_to_letters [
    {0, "c"},
    {2, "d"},
    {4, "e"},
    {5, "f"},
    {7, "g"},
    {9, "a"},
    {11, "b"}
  ]

  @max_num 11

  @alterations [
    # natural
    {0, ""},
    # sharp
    {1, "is"},
    # double sharp
    {2, "isis"},
    # flat
    {-1, "es"},
    # double flat
    {-2, "eses"}
  ]

  @increase_octave "'"
  @decrease_octave ","

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
    unless pitch.number in 0..@max_num and is_integer(pitch.octave) and pitch.alteration in -2..2 do
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
  @spec to_lily_string(t) :: String.t()
  def to_lily_string(pitch = %Pitch{octave: octave}) do
    octaves =
      if octave == @lily_default_octave do
        ""
      else
        char =
          if octave < @lily_default_octave do
            @decrease_octave
          else
            @increase_octave
          end

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
  @spec letter(t) :: String.t()
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
  @spec letter(integer) :: String.t()
  def letter(pitch_number) when is_integer(pitch_number) do
    @pitch_number_to_letters
    |> Enum.find(fn {p_num, _} -> p_num == pitch_number end)
    |> case do
      {_, letter} ->
        letter

      nil ->
        raise ArgumentError,
              "pitch_number #{pitch_number} is not natural or invalid"
    end
  end

  @doc """
  Converts the alteration/accidental to LilyPond format
  """
  @spec alteration_to_string(Pitch.t()) :: String.t()
  def alteration_to_string(%Pitch{alteration: alteration}) do
    @alterations
    |> Enum.find(fn {num, _} -> num == alteration end)
    |> case do
      {_, string} ->
        string

      _ ->
        raise "Invalid alteration %{alteration}"
    end
  end

  @doc """
  See `ExComposerBotTest.Pitch` for more examples.

      iex> from_string("cis'")
      %Pitch{number: 1, alteration: 1, octave: Pitch.default_octave() + 1}

  """
  def from_string(string) when is_bitstring(string) do
    ~r/^(?<letter>[a-gA-G])(?<alteration>(?:(?:is)|(?:es)){0,2})(?<octave_shift>(?:,*|'*))$/
    |> Regex.named_captures(string)
    |> case do
      nil ->
        raise ArgumentError, "Invalid string: #{string}"

      %{
        "letter" => letter_any_case,
        "alteration" => alteration_string,
        "octave_shift" => octave_shift
      } ->
        {alteration, _} =
          Enum.find(
            @alterations,
            {0, :ignored},
            fn {_, str} -> str == alteration_string end
          )

        letter_ignoring_alteration =
          letter_any_case
          |> String.downcase()
          |> pitch_num_from_letter()

        letter =
          rem(
            letter_ignoring_alteration + alteration + @max_num + 1,
            @max_num + 1
          )

        octave =
          default_octave() +
            case String.at(octave_shift, 0) do
              nil ->
                0

              @decrease_octave ->
                -String.length(octave_shift)

              @increase_octave ->
                String.length(octave_shift)
            end

        new(
          number: letter,
          alteration: alteration,
          octave: octave
        )
    end
  end

  def pitch_num_from_letter(pitch_letter) when is_bitstring(pitch_letter) do
    @pitch_number_to_letters
    |> Enum.find(fn {_, letter} -> pitch_letter == letter end)
    |> case do
      {pitch_num, _} ->
        pitch_num

      nil ->
        raise ArgumentError, "pitch_letter #{pitch_letter} is invalid"
    end
  end

  @spec letters :: list(String.grapheme())
  def letters do
    Enum.map(@pitch_number_to_letters, fn {_, letter} -> letter end)
  end

  @spec c_major_numbers :: list(integer)
  def c_major_numbers do
    Enum.map(@pitch_number_to_letters, fn {num, _} -> num end)
  end

  def equals_ignore_octave(
        %Pitch{number: n, alteration: a},
        %Pitch{number: n, alteration: a}
      ),
      do: true

  def equals_ignore_octave(%Pitch{}, %Pitch{}), do: false
end
