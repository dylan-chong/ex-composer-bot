defmodule ExComposerBotTest.Pitch do
  @moduledoc false

  use ExUnit.Case, async: true
  use ExUnit.Parameterized
  alias ExComposerBot.Pitch

  doctest Pitch, import: true

  describe "validate_struct" do
    test "passes for valid pitch" do
      Pitch.new(number: 0, octave: 3, alteration: 2)
    end

    test "fails for pitch with too low pitch number" do
      assert_raise(
        ArgumentError,
        ~r"Invalid pitch.*",
        fn -> Pitch.new(number: -1, octave: 3, alteration: 2) end
      )
    end

    test "fails for pitch with too high pitch number" do
      assert_raise(
        ArgumentError,
        ~r"Invalid pitch.*",
        fn -> Pitch.new(number: 12, octave: 3, alteration: 2) end
      )
    end
  end

  describe "to_lily_string returns correct format for a pitch" do
    test "an octave below middle c" do
      p = Pitch.new(number: 0, octave: 3)
      assert Pitch.to_lily_string(p) == "c"
    end

    test "above middle c" do
      p = Pitch.new(number: 7, octave: 4)
      assert Pitch.to_lily_string(p) == "g'"
    end

    test "roughly 2 octaves below middle c" do
      p = Pitch.new(number: 4, octave: 2)
      assert Pitch.to_lily_string(p) == "e,"
    end

    test "with a sharp" do
      p = Pitch.new(number: 8, alteration: 1)
      assert Pitch.to_lily_string(p) == "gis"
    end

    test "with a flat" do
      p = Pitch.new(number: 10, alteration: -1)
      assert Pitch.to_lily_string(p) == "bes"
    end

    test "with a flat, below middle c" do
      p = Pitch.new(number: 10, alteration: -1, octave: 4)
      assert Pitch.to_lily_string(p) == "bes'"
    end

    test "with a sharp, 2 octaves below middle c" do
      p = Pitch.new(number: 0, alteration: 1, octave: 2)
      assert Pitch.to_lily_string(p) == "bis,"
    end

    test "2 octaves above middle c" do
      p = Pitch.new(number: 0, octave: 5)
      assert Pitch.to_lily_string(p) == "c''"
    end

    test "bis which shouldn't overflow the octave in terms of ' or , symbols" do
      p = Pitch.new(number: 0, alteration: 1)
      assert Pitch.to_lily_string(p) == "bis"
    end

    test "ces which shouldn't overflow the octave in terms of ' or , symbols" do
      p = Pitch.new(number: 11, alteration: -1)
      assert Pitch.to_lily_string(p) == "ces"
    end
  end

  describe "letter returns base letter for pitch" do
    test "c" do
      p = Pitch.new(number: 0)
      assert Pitch.letter(p) == "c"
    end

    test "b" do
      p = Pitch.new(number: 11)
      assert Pitch.letter(p) == "b"
    end

    test "cis" do
      p = Pitch.new(number: 1, alteration: 1)
      assert Pitch.letter(p) == "c"
    end

    test "bis (returns b, not c)" do
      p = Pitch.new(number: 0, alteration: 1)
      assert Pitch.letter(p) == "b"
    end

    test "fis" do
      p = Pitch.new(number: 6, alteration: 1)
      assert Pitch.letter(p) == "f"
    end

    test "ges" do
      p = Pitch.new(number: 6, alteration: -1)
      assert Pitch.letter(p) == "g"
    end

    test "cisis returns g" do
      p = Pitch.new(number: 2, alteration: 2)
      assert Pitch.letter(p) == "c"
    end

    test "beses returns b" do
      p = Pitch.new(number: 9, alteration: -2)
      assert Pitch.letter(p) == "b"
    end
  end

  test_with_params "from_string returns correct value for",
                   fn string, pitch_args ->
                     assert Pitch.new(pitch_args) == Pitch.from_string(string)
                   end do
    [
      # Default octave
      c: {"c", number: 0, octave: Pitch.default_octave()},
      d: {"d", number: 2},
      e: {"e", number: 4},
      g: {"g", number: 7},
      b: {"b", number: 11, octave: Pitch.default_octave()},

      # Different octaves
      "c'": {"c'", number: 0, octave: Pitch.default_octave() + 1},
      "f''": {"f''", number: 5, octave: Pitch.default_octave() + 2},
      "b'''''": {"b'''''", number: 11, octave: Pitch.default_octave() + 5},
      "a,": {"a,", number: 9, octave: Pitch.default_octave() - 1},
      "a,,": {"a,,", number: 9, octave: Pitch.default_octave() - 2},

      # Accidentals
      cis: {"cis", number: 1, alteration: 1},
      disis: {"disis", number: 4, alteration: 2},
      ees: {"ees", number: 3, alteration: -1},
      geses: {"geses", number: 5, alteration: -2},

      # Octaves + Accidentals
      "fis,": {"fis,", number: 6, octave: Pitch.default_octave() - 1, alteration: 1},
      "ges'": {"ges'", number: 6, octave: Pitch.default_octave() + 1, alteration: -1},

      # Accidentals shouldn't affect the octave
      bis: {"bis", number: 0, octave: Pitch.default_octave(), alteration: 1},
      ces: {"ces", number: 11, octave: Pitch.default_octave(), alteration: -1}
    ]
  end
end
