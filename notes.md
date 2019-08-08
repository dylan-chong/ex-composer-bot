# Composition bot #

## TODOs ##

- Make do_generate_bass not select the tonic chord, but rather get the
  RuleOfTheOctave.next_chord to accept nil
- Finish implementing the rule of the octave
- Output the list of chords as a multiple pitch note
- Update generate.ex to use chords

- Create pitches from string
  - roman chord
  - and more

- Rename Chord to BaseChord because notes not specific
- Add more tests for Rule of the octave
- Add 7th chords in Rule of the octave

- [BIG] PartimentoChordsGenerator
  - RomanChord impl
  - Finish PartimentoChordsGenerator next_chord
  - Then try randomised stepping bass notes
  - Look at schemas on openmusictheory
- Data export
- Cadences
- Rests
- Remove parallels

- Make the non composing stuff its own module/library

## Composition Process ##

- Modular composition process
  - Need more information here?
    - Try writing chorales and finding a good process
    - Look up composition processes
  - Context/Intent (for high level description of comp)
    - Summary: a word / few words to sum up piece
      - E.g. “Exciting, or blissful”
    - |> High level countour
      - Look up?: alternative, abstract, representations of notation for
      ideas
    - |> Musical Form
    - |> Phrasing?
    - |> Collect to Intent (returned)
  - |> Bass line (plain) out of nowhere (or from intent)
    - ¿Maybe merge with block chords?
  - |> Bass line (plain) => Figured bass symbols
    - See Partimento Realisation
      - Insanguine PDF
        - Rule of the Octave
        - Cadences
        - Preparing dissonances
        - Tied basses / bass suspensions
        - Change Key / modulations
        - Intervallic moves / counterpoint dissonances
    - Free Counterpoint guidelines
  - |> Block chords => Melody
    - Both Soprano and Bass at the same time
      - because they interact
  - |> Are more steps needed?

## Other Notes ##

- Types of piecs to make
  - Do chorales first
  - Mozart minuets

