defmodule ComposerBot.RuleOfTheOctave do
  @moduledoc """
  Follows the rules described here:
  http://faculty-web.at.northwestern.edu/music/gjerdingen/partimenti/aboutParti/ruleOfTheOctave.htm
  """

  alias ComposerBot.{Pitch, Scale}

  def next_chord(chord_note_pairs, next_bass = %Pitch{}, scale)
  when is_list(chord_note_pairs) and is_list(scale) do
      c = 3
    current_bass =
      chord_note_pairs
      |> List.first
      |> Keyword.fetch!(:note)
    steps = Scale.steps_between(scale, current_bass, next_bass)
    # TODO New steps to create triad with inversions
#     inversion =
#       case Scale.degree_of(next_bass) do
#         0 -> 0
#         4 -> 0
#         _ -> 1
#       end
#       # TODO write 7th chords for rule of the octave above
  end

end
