defmodule ComposerBot.Chord do
  @moduledoc false

  alias ComposerBot.{Chord, Pitch, Scale}

  @doc """
  TODO
  """
  @enforce_keys [:root_pitch]
  defstruct [
    :root_pitch,
    inversion: 0,
    type: :triad,
    scale: Scale.c_major_scale()
  ]

  def pitches(chord) do
    # TODO
  end

  # TODO other types (eg 7th, suspensions)

end
