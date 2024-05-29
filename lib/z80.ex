defmodule Z80 do
  @moduledoc """
  Documentation for Z80.
  """

  def start(_type, _args) do
    {:ok, rom_contents} = File.read("/Users/bill/Projects/z80/lib/level1.rom")
    Rom.fetch(rom_contents)
    Task.start(fn -> :timer.sleep(1); IO.puts("done sleeping") end)
  end
end

