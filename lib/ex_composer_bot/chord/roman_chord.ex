defmodule ExComposerBot.Chord.RomanChord do
  @moduledoc ""

  alias ExComposerBot.{Chord.RomanChord, Scale, Pitch}

  @doc """
  * :root - Root degree of the chord. (The root is not the base note if the
  chord is not an root position). When calling `new/2`, you can pass a scale
  degree (as a `ExComposerBot.Pitch` - the octave is ignored) provided it is in
  the given `ExComposerBot.Scale`, or degree number (`integer`) (see
  `ExComposerBot.Scale.at/2`).
  * :inversion - Root position is 0. 1st inversion is 1...
  * :scale - The `ExComposerBot.Scale` that this chord is part of.

  TODO Find a way to represent seventh chords, also suspensions
  """
  @enforce_keys [:root, :scale]
  defstruct [
    :root,
    :scale,
    inversion: 0,
  ]

  use ExStructable

  @impl true
  def validate_struct(
    chord = %RomanChord{scale: scale = %Scale{}, root: root},
    _
  ) do
    chord = %RomanChord{chord | root:
      case root do
        %Pitch{} ->
          Scale.degree_of(scale, root, fn _ ->
            raise ArgumentError,
              "Root not in scale in for chord #{inspect(chord)}"
          end)
          root
        degree when is_integer(degree) ->
          # Assume Scale.at throws on invalid degree
          Scale.at(scale, degree)
      end
    }
    chord = %RomanChord{chord | root:
      Pitch.put(chord.root, octave: Pitch.default_octave())
    }

    unless chord.inversion in 0..2 do
      raise ArgumentError, "Invalid inversion in chord, #{inspect(chord)}"
    end

    chord
  end

  @doc """

      iex> root_for(1, 0, Scale.c_major())
      1

      iex> root_for(3, 1, Scale.c_major())
      1

      iex> root_for(2, 2, Scale.c_major())
      5

      iex> root_for(0, 2, Scale.c_major())
      ** (ArgumentError) Invalid bass_degree 0

  """
  def root_for(bass_degree, inversion, scale = %Scale{})
      when is_integer(bass_degree)
      when is_integer(inversion) and inversion >= 0
  do
    unless Scale.valid_degree?(scale, bass_degree) do
      raise ArgumentError, "Invalid bass_degree #{bass_degree}"
    end
    Scale.mod_degree(scale, bass_degree - (inversion * 2))
  end

end

defimpl ExComposerBot.Chord, for: ExComposerBot.Chord.RomanChord do
  def pitches(_chord) do
    # TODO
  end
end
