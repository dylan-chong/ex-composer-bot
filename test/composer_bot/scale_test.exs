defmodule ComposerBotTest.Scale do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ComposerBot.{Scale, Pitch}

  describe "major_scale should be correct for" do
    test "c major" do
      s = Scale.major_scale(%Pitch{note_num: 0})
      assert s == [%Pitch{note_num: 0},
                   %Pitch{note_num: 2},
                   %Pitch{note_num: 4},
                   %Pitch{note_num: 5},
                   %Pitch{note_num: 7},
                   %Pitch{note_num: 9},
                   %Pitch{note_num: 11}]
    end

    # test "g major" do
      # s = Scale.major_scale(%Pitch{note_num: 0})
      # assert s == [%Pitch{note_num: 7},
                   # %Pitch{note_num: 9},
                   # %Pitch{note_num: 11},
                   # %Pitch{note_num: 0},
                   # %Pitch{note_num: 2},
                   # %Pitch{note_num: 4},
                   # %Pitch{note_num: 6, alteration: 1}]
    # end
  end
end
