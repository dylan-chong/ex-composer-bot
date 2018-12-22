defmodule ExComposerBot.PartimentoChordsGenerator do
  @moduledoc """
  Generates the chords and basic bassline for a Partimento.
  """

  alias ExComposerBot.{Scale, Note, Voice}

  def generate_bass(options \\ []) do
    [number_of_notes: number_of_notes, scale: scale] =
      Enum.into(
        options,
        # 4 bars of 4/4 + end note
        number_of_notes: 4 * 4 + 1,
        scale: Scale.c_major()
      )

    first_note = Note.new(pitch: Scale.at(scale, 1))
    bass = generate_bass([first_note], scale, number_of_notes)
    Voice.new(notes: bass)
  end

  def generate_chords(bass = %Voice{}) do
    raise "TODO: Make sure rule of the octave is implemented"
  end

  defp generate_bass(notes, _scale = %Scale{}, 0) when is_list(notes) do
    notes
  end

  # scale - An ascending list of pitches of a diatonic scale
  # notes_left - Number of notes to add
  defp generate_bass(
         notes = [last_note = %Note{} | _],
         scale = %Scale{},
         notes_left
       )
       when is_integer(notes_left) and notes_left > 0 do
    new_pitch =
      if Enum.random(0..1) == 0 do
        scale |> Scale.degree_below(last_note.pitch)
      else
        scale |> Scale.degree_above(last_note.pitch)
      end

    new_note = last_note |> Note.put(pitch: new_pitch)

    [new_note | notes]
    |> generate_bass(scale, notes_left - 1)
  end
end
