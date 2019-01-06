defmodule ExComposerBotTest.PartimentoChordsGenerator do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExComposerBot.{PartimentoChordsGenerator, Voice, Note}

  test "generate_bass/1 create a voice containing multiple notes" do
    %Voice{notes: [%Note{} | _]} = PartimentoChordsGenerator.generate_bass(number_of_notes: 3)
  end
end
