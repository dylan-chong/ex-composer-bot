defmodule MixTest.Tasks.Generate do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Generate
  import ExUnit.CaptureIO

  test "does not crash when not given arguments" do
    capture_io(fn ->
      Generate.run([])
    end)
  end

  test "creates the given file" do
    file_path = "tmp/test-file"
    File.rm(file_path)

    capture_io(fn ->
      Generate.run([file_path])
    end)

    assert File.exists?(file_path)
    assert String.length(File.read!(file_path)) > 0
  end
end
