defmodule MixTest.Tasks.Generate do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Generate
  import ExUnit.CaptureIO

  test "does not crash" do
    capture_io fn ->
      Generate.run([])
    end
  end
end

