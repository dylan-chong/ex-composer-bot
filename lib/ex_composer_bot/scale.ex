defmodule ExComposerBot.Scale do
  @moduledoc """
  A scale is a list of pitches in ascending order. All pitches are unique
  (ignoring octave).

  This module also has methods to generate scales.
  """

  alias ExComposerBot.{Scale, Pitch}

  @type t :: %Scale{pitches: list(Pitch.t())}
  @enforce_keys [:pitches]
  defstruct [:pitches]
  use ExStructable

  @impl true
  def validate_struct(
        scale = %Scale{pitches: pitches = [%Pitch{octave: octave} | _]},
        _
      ) do
    Enum.each(pitches, fn
      %Pitch{octave: ^octave} ->
        # TODO all octaves should not be the same if not c_major
        :ok

      invalid_item ->
        raise ArgumentError,
              "Invalid scale #{inspect(scale)} " <> "pitch is invalid #{inspect(invalid_item)}"
    end)

    if length(pitches) < 1 do
      raise ArgumentError,
            "Invalid scale #{inspect(scale)} " <> "because not enough pitches"
    end

    scale
  end

  @doc """
  Returns a list of `Pitch` structs in ascending order
  """
  @spec type(:major, Pitch.t()) :: t
  def type(:major, %Pitch{number: base_number, alteration: base_alt}) do
    if base_number != 0 || base_alt != 0 do
      # TODO SOMETIME transpose into other keys
      raise "NYI"
    end

    new(
      pitches:
        Enum.map(
          Pitch.c_major_numbers(),
          fn num -> Pitch.new(number: num) end
        )
    )
  end

  @spec c_major() :: t
  def c_major do
    type(:major, Pitch.new(number: 0))
  end

  @spec degree_above(t, Pitch.t()) :: Pitch.t()
  def degree_above(scale = %Scale{}, current_pitch = %Pitch{}) do
    find_pitch(scale, current_pitch, 1)
  end

  @spec degree_below(t, Pitch.t()) :: Pitch.t()
  def degree_below(scale = %Scale{}, current_pitch = %Pitch{}) do
    find_pitch(scale, current_pitch, -1)
  end

  @doc """
  Gets the degree (1-based) of the pitch in the scale.

      iex> Scale.degree_of(Scale.c_major(), Pitch.new(number: 0))
      1

      iex> Scale.degree_of(Scale.c_major(), Pitch.new(number: 5))
      4

      iex> Scale.degree_of(Scale.c_major(), Pitch.new(number: 11))
      7

  """
  @spec degree_of(t, Pitch.t()) :: non_neg_integer
  def degree_of(
        %Scale{pitches: pitches},
        pitch = %Pitch{},
        default_fun \\ fn pitch ->
          raise(
            ArgumentError,
            "pitch (#{inspect(pitch)}) not in scale (#{inspect(pitch)})"
          )
        end
      ) do
    pitches
    |> Enum.find_index(fn current_pitch ->
      Pitch.equals_ignore_octave(pitch, current_pitch)
    end)
    |> case do
      nil ->
        default_fun.(pitch)

      index ->
        index + 1
    end
  end

  @doc """
  Returns true if the given pitch is inside this scale (ignoring octaves).
  """
  def contains(scale = %Scale{}, pitch = %Pitch{}) do
    degree_of(scale, pitch, fn _ -> :not_found end) != :not_found
  end

  @doc """
  Get scale using 1-based-degree.

      iex> at(c_major(), 1) |> Pitch.letter()
      "c"

  """
  def at(%Scale{pitches: pitches}, degree)
      when degree in 1..length(pitches) do
    Enum.at(pitches, degree - 1)
  end

  def size(%Scale{pitches: pitches}) do
    length(pitches)
  end

  @doc """
  Wrap the given degree so it is not out of bounds.

      iex> mod_degree(c_major(), 0)
      7

      iex> mod_degree(c_major(), 1)
      1

      iex> mod_degree(c_major(), 8)
      1

      iex> mod_degree(c_major(), -3)
      4

  """
  def mod_degree(scale = %Scale{}, degree) when is_integer(degree) do
    s_size = size(scale)

    case rem(s_size + degree, s_size) do
      0 -> s_size
      d -> d
    end
  end

  @doc """
  Wrap the given degree so it is not out of bounds.

      iex> valid_degree?(c_major(), 1)
      true

      iex> valid_degree?(c_major(), 7)
      true

      iex> valid_degree?(c_major(), 0)
      false

      iex> valid_degree?(c_major(), 8)
      false

  """
  def valid_degree?(scale = %Scale{}, degree) when is_integer(degree) do
    mod_degree(scale, degree) == degree
  end

  def steps_between(scale = %Scale{}, startp = %Pitch{}, endp = %Pitch{}) do
    octave_diff = endp.octave - startp.octave

    if octave_diff != 0 do
      octave_diff * size(scale) +
        steps_between(
          scale,
          Pitch.put(startp, octave: startp.octave + octave_diff),
          endp
        )
    else
      degree_of(scale, endp) - degree_of(scale, startp)
    end
  end

  # degree_diff: 1 to go up, -1 to go down
  defp find_pitch(scale = %Scale{}, current_pitch = %Pitch{}, degree_diff)
       when is_integer(degree_diff) and abs(degree_diff) < 8 do
    current_pitch_index = degree_of(scale, current_pitch) - 1

    new_pitch_index = current_pitch_index + degree_diff

    new_pitch_octave =
      current_pitch.octave +
        cond do
          new_pitch_index < 0 -> -1
          new_pitch_index >= size(scale) -> 1
          true -> 0
        end

    new_pitch_index = rem(new_pitch_index + size(scale), size(scale))

    scale
    # + 1 to go from 0-based-index to 1-based-degree
    |> at(new_pitch_index + 1)
    |> Pitch.put(octave: new_pitch_octave)
  end
end
