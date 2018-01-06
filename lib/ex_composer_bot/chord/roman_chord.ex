defmodule ExComposerBot.Chord.RomanChord do
  @moduledoc ""

  alias ExComposerBot.{Chord.RomanChord, Scale, Pitch}

  @doc """
  * :root - Root degree. A number starting from 0.
  * :inversion - Root position is 0. 1st inversion is 1.
  * :scale - The ExComposerBot.Scale that this chord is part of.

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
    chord = %RomanChord{chord | root: case root do
      %Pitch{} ->
        Scale.degree_of(scale, root, fn _ ->
          raise ArgumentError,
            "Root not in scale in for chord #{inspect(chord)}"
        end)
        root
      degree when is_integer(degree) ->
        Scale.at(scale, degree)
    end}

    unless chord.inversion in 0..2 do
      raise ArgumentError, "Invalid inversion in chord, #{inspect(chord)}"
    end

    chord
  end
end

defimpl ExComposerBot.Chord, for: ExComposerBot.Chord.RomanChord do
  def pitches(_chord) do
    # TODO
  end
end
