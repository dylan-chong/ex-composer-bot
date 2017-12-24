# Composition bot #

## TODOs ##
- Finish PartimentoChordsGenerator next_chord
  - Requires representing chord as roman numeral - **TODO NEXT make Chord a protocol**
- Create pitches from string
- Make scale a struct (for future maintainability)

- PartimentoChordsGenerator
  - Rule of the octave
    - Then try randomised stepping bass notes
  - Look at schemas on openmusictheory
- Data export
- Cadences
- Rests
- Remove parallels

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

- Do chorales first

- Make the non composing stuff its own library
