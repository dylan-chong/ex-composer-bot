defmodule ExComposerBot.PartimentoChordsGenerator do
  @moduledoc """
  Generates the chords and basic bassline for a Partimento.
  """

  alias ExComposerBot.{Scale, Note, Voice, Pitch, RuleOfTheOctave, Chord.RomanChord}

  @doc """
  Generates a voice containing a list of bass notes.
  """
  def generate_bass(options \\ []) do
    %{number_of_notes: number_of_notes, scale: scale} =
      Enum.into(
        options,
        %{
          # 4 bars of 4/4 + end note
          number_of_notes: 4 * 4 + 1,
          scale: Scale.c_major()
        }
      )

    first_note = Note.new(pitch: Scale.at(scale, 1))
    bass = do_generate_bass([first_note], scale, number_of_notes - 1)
    Voice.new(notes: Enum.reverse(bass))
  end

  defp do_generate_bass(notes, _scale = %Scale{}, 0) when is_list(notes) do
    notes
  end

  # scale - An ascending list of pitches of a diatonic scale
  # notes_left - Number of notes to add
  defp do_generate_bass(
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
    |> do_generate_bass(scale, notes_left - 1)
  end

  @doc """
  Generates a list of chords, to suit the given bassline
  """
  def generate_chords(%Voice{notes: bass_notes}, scale = %Scale{}) do
    tonic_note = List.first(bass_notes)
    tonic_pitch = tonic_note.pitch

    unless Scale.degree_of(scale, tonic_pitch) == 1 do
      raise "Starting on a non-tonic chord is not supported yet"
    end

    tonic_chord = RomanChord.new(root: tonic_pitch, scale: scale)
    chords = do_generate_chords(bass_notes, scale, [tonic_chord])
    Enum.reverse(chords)
  end

  defp do_generate_chords([_], _, chords), do: chords

  defp do_generate_chords(
         [current_bass | future_bass = [next_bass | _]],
         scale = %Scale{},
         chords
       ) do
    next_chord =
      RuleOfTheOctave.next_chord(
        next_bass.pitch,
        current_bass.pitch,
        scale
      )

    do_generate_chords(future_bass, scale, [next_chord | chords])
  end
end
