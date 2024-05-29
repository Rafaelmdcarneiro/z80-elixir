defmodule Z80Test do
  use ExUnit.Case
  doctest Z80

  test "NOP" do
    assert Instruction.decode(<<0x00>>) == "NOP"
  end

  test "RET" do
    assert Instruction.decode(<<0xc9>>) == "RET"
  end

  test "LD C, 23" do 
    assert Instruction.decode(<<0x0e>>, <<23::size(8)>>) == "LD C, 23"
  end

  test "LD B, 23" do 
    assert Instruction.decode(<<0x06>>, <<23::size(8)>>) == "LD B, 23"
  end

  test "LD HL, 35" do
    assert Instruction.decode(<<0x21>>, <<35>>, <<0>>) == "LD HL, 35"
  end

  test "JP 25" do
    assert Instruction.decode(<<0xc3>>, <<25>>, <<0>>) == "JP 25"
  end

  test "DI" do 
    assert Instruction.decode(<<0xf3>>) == "DI"
  end
end
