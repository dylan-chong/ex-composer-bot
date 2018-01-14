defmodule ExComposerBot.RuleOfTheOctave do
  @moduledoc """
  Follows the rules described here:
  http://faculty-web.at.northwestern.edu/music/gjerdingen/partimenti/aboutParti/ruleOfTheOctave.htm
  """

  alias ExComposerBot.{Pitch, Scale, Chord.RomanChord}

  def next_chord(
    next_bass = %Pitch{},
    current_bass = %Pitch{},
    scale = %Scale{}
  ) do
    _current_bass_degree = Scale.degree_of(scale, current_bass)
    next_bass_degree = Scale.degree_of(scale, next_bass)
    next_inversion =
      case next_bass_degree do
        1 -> 0
        5 -> 0
        _ -> 1
      end

    RomanChord.new(
      root: RomanChord.root_for(next_bass_degree, next_inversion, scale),
      inversion: next_inversion,
      scale: scale,
    )

    # TODO return same chord if bass has same degree
    # TODO hard-code ruleOfTheOctave based on asc/desc
  end

end
