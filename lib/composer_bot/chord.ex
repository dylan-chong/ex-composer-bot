defprotocol ComposerBot.Chord do
  def pitches(chord)
end

defmodule ComposerBot.RomanChord do
  @moduledoc """
  TODO NEXT move this into a new file
  """

  alias ComposerBot.{Chord, Pitch, Scale}

  @doc """
  * :root_degree - Number starting from 0.
  * :inversion - Root position is 0. 1st inversion is 1.
  * :scale - The ComposerBot.Scale that this chord is part of.
  TODO Find a way to represent seventh chords, also suspensions
  """
  @enforce_keys [:root_pitch]
  defstruct [
    :root_degree,
    :inversion,
    :scale,
  ]

  def new(
      root \\ 0,
      inversion \\ 0,
      scale
  ) when is_integer(root)
      and 0 <= root and root < length(scale)
      and is_integer(inversion)
      and 0 <= inversion and inversion < 3 # TODO Don't hardcode three for seventh chords
      and is_list(scale)
  do
    struct(__MODULE__, [
      root: root,
      inversion: inversion,
      scale: scale,
    ])
  end

  def pitches(chord) do
    # TODO
  end

end
