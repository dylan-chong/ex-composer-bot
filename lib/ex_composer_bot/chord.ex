defprotocol ExComposerBot.Chord do
  @moduledoc """
  Something that has multiple pitches.
  """

  @doc """
  Unique `ExComposerBot.Pitch`es in ascending order.
  """
  def pitches(chord)
end
