defmodule ComposerBot.Chord.RomanChord do
  @moduledoc ""

  alias ComposerBot.{Chord.RomanChord, Scale}

  @doc """
  * :root - Root degree. A number starting from 0.
  * :inversion - Root position is 0. 1st inversion is 1.
  * :scale - The ComposerBot.Scale that this chord is part of.

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
  def validate_struct(chord = %RomanChord{scale: %Scale{}}, _) do
    unless (
      chord.root in 0..(Scale.size(chord.scale) - 1)
      and chord.inversion in 0..2
    ) do
      raise ArgumentError, "Invalid chord, #{inspect(chord)}"
    end
    # TODO accept root as pitch
    chord
  end

end

defimpl ComposerBot.Chord, for: ComposerBot.Chord.RomanChord do
  def pitches(_chord) do
    # TODO
  end
end
