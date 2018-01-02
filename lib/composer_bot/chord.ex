defprotocol ComposerBot.Chord do
  @moduledoc """
  Something that has multiple pitches.
  """

  @doc """
  Unique `ComposerBot.Pitch`es in ascending order.
  """
  def pitches(chord)
end
