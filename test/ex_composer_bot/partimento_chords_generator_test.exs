defmodule ExComposerBotTest.PartimentoChordsGenerator do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExComposerBot.{PartimentoChordsGenerator}

  test "generate does not crash" do
    PartimentoChordsGenerator.generate_bass()
  end

  # TODO more tests
end
