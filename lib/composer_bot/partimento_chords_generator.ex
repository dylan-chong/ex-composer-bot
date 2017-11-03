defmodule ComposerBot.PartimentoChordsGenerator do
  @moduledoc """
  Generates the chords and basic bassline for a Partimento.
  """

  alias ComposerBot.{Scale, Note, Voice}

  @spec generate_bass :: Voice.t
  def generate_bass do
    scale = Scale.c_major_scale()
    first_note = %Note{pitch: Enum.at(scale, 0)}
    %Voice{notes: generate_bass([first_note], scale, 7)}
  end

  defp generate_bass(notes, _scale, 0), do: notes

  # scale - An ascending list of pitches of a diatonic scale
  # notes_left - Number of notes to add
  defp generate_bass(notes = [last_note | _], scale, notes_left) do
    new_pitch = scale |> Scale.degree_above(last_note.pitch)
    new_note = %{last_note | pitch: new_pitch}

    [new_note | notes]
    |> generate_bass(scale, notes_left - 1)
  end

end
