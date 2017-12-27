defmodule ComposerBotTest.RomanChordTest do
  use ExUnit.Case
  alias ComposerBot.{RomanChord, Pitch, Scale, Chord}
  doctest RomanChord, import: true

  describe "new" do
    test "successfully creates" do
      RomanChord.new(
        root: 0,
        inversion: 0,
        scale: Scale.c_major_scale()
      )
    end

    test "fails on bad inversion root" do
      assert_raise(
        ArgumentError,
        fn -> RomanChord.new(
          root: -1,
          inversion: 0,
          scale: Scale.c_major_scale()
        ) end
      )
    end

    test "fails on bad root" do
      assert_raise(
        ArgumentError,
        fn -> RomanChord.new(
          root: 0,
          inversion: -1,
          scale: Scale.c_major_scale()
        ) end
      )
    end
  end

end
