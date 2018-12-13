defmodule ExComposerBotTest.RomanChordTest do
  use ExUnit.Case
  alias ExComposerBot.{Scale, Chord.RomanChord, Pitch}
  doctest RomanChord, import: true

  describe "new" do
    def success_args do
      [
        root: 1,
        inversion: 0,
        scale: Scale.c_major()
      ]
    end

    test "successfully creates" do
      RomanChord.new(success_args())
    end

    def new_fails_validation(error \\ ArgumentError, args) do
      assert_raise(
        error,
        fn ->
          success_args()
          |> Keyword.merge(args)
          |> RomanChord.new()
        end
      )
    end

    test "fails on bad inversion" do
      new_fails_validation(inversion: -1)
    end

    test "fails on too low root" do
      new_fails_validation(FunctionClauseError, root: 0)
    end

    test "fails on too high root" do
      new_fails_validation(FunctionClauseError, root: 8)
    end

    test "fails on invalid modification" do
      new_fails_validation(ArgumentError, mods: [:invalid_mod])
    end
  end

  describe "standardises octave" do
    test "when passing a pitch as the root" do
      expected_octave = Pitch.default_octave()

      assert expected_octave ==
               [
                 root: Pitch.new(number: 0, octave: expected_octave + 3),
                 scale: Scale.c_major()
               ]
               |> RomanChord.new()
               |> Map.get(:root)
               |> Map.get(:octave)
    end

    test "when passing a degree/integer" do
      expected_octave = Pitch.default_octave()

      assert expected_octave ==
               [
                 root: 1,
                 scale: Scale.c_major()
               ]
               |> RomanChord.new()
               |> Map.get(:root)
               |> Map.get(:octave)
    end
  end

  @tag :todo
  test ":has_7th mod adds 7th degree" do
  end
end
