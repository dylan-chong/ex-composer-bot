defmodule ExComposerBotTest.RomanChordTest do
  use ExUnit.Case
  alias ExComposerBot.{Scale, Chord.RomanChord}
  doctest RomanChord, import: true

  describe "new" do
    def success_args do
      [
        root: 0,
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
      new_fails_validation(FunctionClauseError, root: -1)
    end

    test "fails on too high root" do
      new_fails_validation(FunctionClauseError, root: 7)
    end
  end

end
