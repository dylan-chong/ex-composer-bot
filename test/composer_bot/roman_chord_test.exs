defmodule ComposerBotTest.RomanChordTest do
  use ExUnit.Case
  alias ComposerBot.{RomanChord, Pitch, Scale, Chord}
  doctest RomanChord, import: true

  describe "new" do
    test "successfully creates" do
      RomanChord.new(0, 0, Scale.c_major_scale())
    end

    test "new fails on bad inversion root" do
      assert_raise(
        FunctionClauseError,
        fn -> RomanChord.new(-1, 0, Scale.c_major_scale()) end
      )
    end

    test "new fails on bad root" do
      assert_raise(
        FunctionClauseError,
        fn -> RomanChord.new(0, -1, Scale.c_major_scale()) end
      )
    end
  end

end
