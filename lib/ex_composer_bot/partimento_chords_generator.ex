defmodule ExComposerBot.PartimentoChordsGenerator do
  @moduledoc """
  Generates the chords and basic bassline for a Partimento.
  """

  alias ExComposerBot.{Scale, Note, Voice}

  @spec generate_bass :: Voice.t
  def generate_bass do
    scale = Scale.c_major()
    first_note = %Note{pitch: Scale.at(scale, 0)}
    %Voice{notes: generate_bass([first_note], scale, 7)}
  end

  @spec generate_bass(list(Note.t), Scale.t, non_neg_integer) :: list(Note.t)
  defp generate_bass(notes, _scale = %Scale{}, 0) when is_list(notes)do
    notes
  end

  # scale - An ascending list of pitches of a diatonic scale
  # notes_left - Number of notes to add
  defp generate_bass(
    notes = [last_note = %Note{} | _],
    scale = %Scale{},
    notes_left
  ) when is_integer(notes_left) and notes_left > 0 do
    new_pitch = scale |> Scale.degree_above(last_note.pitch)
    new_note = %Note{last_note | pitch: new_pitch}

    [new_note | notes]
    |> generate_bass(scale, notes_left - 1)
  end

end
