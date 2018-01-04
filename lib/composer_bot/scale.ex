defmodule ComposerBot.Scale do
  @moduledoc """
  A scale is a list of pitches in ascending order. All pitches are unique
  (ignoring octave).

  This module also has methods to generate scales.
  """

  alias ComposerBot.{Scale, Pitch}

  @enforce_keys [:pitches]
  defstruct [:pitches]
  @type t :: %Scale{pitches: list(Pitch.t)}

  use ExStructable

  @impl true
  def validate_struct(scale, _) do
    unless is_list(scale.pitches) do
      raise ArgumentError, "Invalid scale: #{scale}"
    end
    scale

    # TODO validate pitches (to meet moduledoc specifications)
  end

  @doc """
  Returns a list of `Pitch` structs in ascending order
  """
  @spec type(:major, Pitch.t) :: t
  def type(:major, %Pitch{number: base_number, alteration: base_alt}) do
    if base_number != 0 || base_alt != 0 do
      # TODO SOMETIME transpose into other keys
      raise "NYI"
    end

    new(pitches: Enum.map(
      Pitch.c_major_numbers(),
      fn num -> %Pitch{number: num} end
    ))
  end

  @spec c_major() :: t
  def c_major do
    type(:major, %Pitch{number: 0})
  end

  @spec degree_above(t, Pitch.t) :: Pitch.t
  def degree_above(scale = %Scale{}, current_pitch = %Pitch{}) do
    find_pitch(scale, current_pitch, 1)
  end

  @spec degree_below(t, Pitch.t) :: Pitch.t
  def degree_below(scale = %Scale{}, current_pitch = %Pitch{}) do
    find_pitch(scale, current_pitch, -1)
  end

  @doc """
  Gets the index of the pitch in the scale.

    iex> Scale.degree_of(Scale.c_major(), %Pitch{number: 0})
    0

    iex> Scale.degree_of(Scale.c_major(), %Pitch{number: 5})
    3
  """
  @spec degree_of(t, Pitch.t) :: Pitch.t
  def degree_of(%Scale{pitches: pitches}, pitch = %Pitch{}) do
    Enum.find_index(pitches, fn current_pitch ->
      Pitch.equals_ignore_octave(pitch, current_pitch)
    end) || raise(
      ArgumentError,
      "pitch (#{inspect(pitch)}) not in scale (#{inspect(pitch)})"
    )
  end

  def at(%Scale{pitches: pitches}, index)
      when index in 0..length(pitches) - 1 do
    Enum.at(pitches, index)
  end

  def size(%Scale{pitches: pitches}) do
    length(pitches)
  end

  def steps_between(scale = %Scale{}, startp = %Pitch{}, endp = %Pitch{}) do
    octave_diff = endp.octave - startp.octave
    if octave_diff != 0 do
      octave_diff * size(scale) + steps_between(
        scale,
        %Pitch{startp | octave: startp.octave + octave_diff},
        endp
      )
    else
      degree_of(scale, endp) - degree_of(scale, startp)
    end
  end

  defp find_pitch(_scale = %Scale{}, _current_pitch = %Pitch{}, index_diff)
      when is_integer(index_diff) and abs(index_diff) >= 8 do
    raise ArgumentError, "invalid index_diff: #{index_diff}"
  end

  # index_diff: 1 to go up, -1 to go down
  defp find_pitch(scale = %Scale{}, current_pitch = %Pitch{}, index_diff)
      when is_integer(index_diff) do
    last_pitch_index = degree_of(scale, current_pitch)

    new_pitch_index = last_pitch_index + index_diff
    new_pitch_octave = current_pitch.octave + cond do
      new_pitch_index < 0 -> -1
      new_pitch_index >= Enum.count(scale.pitches) -> 1
      true -> 0
    end
    new_pitch_index = rem(new_pitch_index, size(scale))

    %{Enum.at(scale.pitches, new_pitch_index) | octave: new_pitch_octave}
  end

end
