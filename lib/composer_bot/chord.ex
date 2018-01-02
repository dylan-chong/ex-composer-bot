defprotocol ComposerBot.Chord do
  def pitches(chord)
end

defmodule ComposerBot.RomanChord do
  @moduledoc """
  TODO NEXT move this into a new file
  """

  alias ComposerBot.{Chord, Pitch, Scale}

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
  def validate_struct(chord, _) do
    unless (
      chord.root in 0..(length(chord.scale) - 1)
      and chord.inversion in 0..2
      and is_list(chord.scale)
    ) do
      raise ArgumentError, "Invalid chord, #{inspect(chord)}"
    end
    chord
  end

  def pitches(chord) do
    # TODO
  end

end
