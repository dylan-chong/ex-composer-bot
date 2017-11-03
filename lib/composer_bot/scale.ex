defmodule ComposerBot.Scale do
  @moduledoc """
  Methods to generate lists of `Pitch` structs.
  A scale type ignores octaves
  """

  alias ComposerBot.{Scale, Pitch}

  @type t :: list(Pitch.t)

  @doc """
  Returns a list of `Pitch` structs in ascending order
  """
  @spec major_scale(Pitch.t) :: t
  def major_scale(%Pitch{note_num: base_note_num, alteration: base_alt}) do
    if base_note_num != 0 || base_alt != 0 do
      raise "NYI"
    end

    Pitch.c_major_note_nums()
    # TODO SOMETIME transpose into other keys
    |> Enum.map(fn num -> %Pitch{note_num: num} end)
  end

  @spec c_major_scale() :: t
  def c_major_scale() do
    Scale.major_scale(%Pitch{note_num: 0})
  end

  @spec degree_above(t, Pitch.t) :: Pitch.t
  def degree_above(scale, current_pitch) do
    find_degree(scale, current_pitch, 1)
  end

  @spec degree_below(t, Pitch.t) :: Pitch.t
  def degree_below(scale, current_pitch) do
    find_degree(scale, current_pitch, -1)
  end

  @doc """
  Gets the index of the pitch in the scale.

    iex> Scale.degree_of(Scale.c_major_scale(), %Pitch{note_num: 0})
    0

    iex> Scale.degree_of(Scale.c_major_scale(), %Pitch{note_num: 5})
    3
  """
  @spec degree_of(t, Pitch.t) :: Pitch.t
  def degree_of(scale, pitch) do
    Enum.find_index(scale, fn current_pitch ->
      Pitch.equals_ignore_octave(pitch, current_pitch)
    end) || raise ArgumentError
  end

  defp find_degree(scale, current_pitch, index_difference)
      when abs(index_difference) >= 8 do
    find_degree(scale, current_pitch, rem(index_difference, 8))
  end

  # index_difference - 1 to go up, -1 to go down
  defp find_degree(scale, current_pitch, index_difference) do
    last_pitch_index = degree_of(scale, current_pitch)

    new_pitch_index = last_pitch_index + index_difference
    new_pitch_octave = current_pitch.octave + cond do
      new_pitch_index < 0 -> -1
      new_pitch_index >= Enum.count(scale) -> 1
      true -> 0
    end
    new_pitch_index = rem(new_pitch_index, Enum.count(scale))

    %{Enum.at(scale, new_pitch_index) | octave: new_pitch_octave}
  end

end
