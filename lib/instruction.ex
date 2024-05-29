defmodule Instruction do
  def two_byte?(<<0xD6::size(8)>>), do: true
  def two_byte?(<<0x10::size(8)>>), do: true
  def two_byte?(<<0x18::size(8)>>), do: true
  def two_byte?(<<0x20::size(8)>>), do: true
  def two_byte?(<<0x28::size(8)>>), do: true
  def two_byte?(<<0x30::size(8)>>), do: true
  def two_byte?(<<0x36::size(8)>>), do: true
  def two_byte?(<<0x38::size(8)>>), do: true
  def two_byte?(<<0xc6::size(8)>>), do: true
  def two_byte?(<<0xcb::size(8)>>), do: true
  def two_byte?(<<0xce::size(8)>>), do: true
  def two_byte?(<<0xd3::size(8)>>), do: true
  def two_byte?(<<0xdb::size(8)>>), do: true
  def two_byte?(<<0xe6::size(8)>>), do: true
  def two_byte?(<<0xed::size(8)>>), do: true
  def two_byte?(<<0xee::size(8)>>), do: true
  def two_byte?(<<0xf6::size(8)>>), do: true
  def two_byte?(<<0xfe::size(8)>>), do: true
  def two_byte?(<<0x0::size(2)>> <> <<_dest::size(3)>> <> <<0x6::size(3)>>), do: true
  def two_byte?(_), do: false

  def three_byte?(<<0x22::size(8)>>), do: true
  def three_byte?(<<0x2a::size(8)>>), do: true
  def three_byte?(<<0x32::size(8)>>), do: true
  def three_byte?(<<0x3a::size(8)>>), do: true
  def three_byte?(<<0xc3::size(8)>>), do: true
  def three_byte?(<<0xc4::size(8)>>), do: true
  def three_byte?(<<0xcc::size(8)>>), do: true
  def three_byte?(<<0xcd::size(8)>>), do: true
  def three_byte?(<<0x3::size(2)>> <> <<_cond_code::size(3)>> <> <<0x2::size(3)>>), do: true
  def three_byte?(<<0x3::size(2)>> <> <<_cond_code::size(3)>> <> <<0x4::size(3)>>), do: true
  def three_byte?(<<0x0::size(2)>> <> <<_dest::size(2)>> <> <<0x1::size(4)>>), do: true
  def three_byte?(_), do: false

  #
  # One byte instructions
  #
  def decode(<<0x00::size(8)>>), do: "NOP"
  def decode(<<0x02::size(8)>>), do: "LD (BC),A"
  def decode(<<0x07::size(8)>>), do: "RLCA"
  def decode(<<0x08::size(8)>>), do: "EX AF, AF'"
  def decode(<<0xD9::size(8)>>), do: "EXX"
  def decode(<<0x0a::size(8)>>), do: "LD A, (BC)"
  def decode(<<0x0f::size(8)>>), do: "RRCA"
  def decode(<<0x12::size(8)>>), do: "LD (DE),A"
  def decode(<<0x17::size(8)>>), do: "RLA"
  def decode(<<0x1a::size(8)>>), do: "LD A,(DE)"
  def decode(<<0x1f::size(8)>>), do: "RRA"
  def decode(<<0x2f::size(8)>>), do: "CPL"
  def decode(<<0x35::size(8)>>), do: "DEC (HL)"
  def decode(<<0x37::size(8)>>), do: "SCF"
  def decode(<<0x3f::size(8)>>), do: "CCF"
  def decode(<<0x86::size(8)>>), do: "ADD A, (HL)"
  def decode(<<0x8e::size(8)>>), do: "ADC A, (HL)"
  def decode(<<0xae::size(8)>>), do: "XOR (HL)"
  def decode(<<0xb6::size(8)>>), do: "OR (HL)"
  def decode(<<0xbe::size(8)>>), do: "CP (HL)"
  def decode(<<0xc9::size(8)>>), do: "RET"
  def decode(<<0xdd::size(8)>>), do: "DD ***"
  def decode(<<0xe3::size(8)>>), do: "EX (SP), HL"
  def decode(<<0xe9::size(8)>>), do: "JP (HL)"
  def decode(<<0xeb::size(8)>>), do: "EX DE, HL"
  def decode(<<0xf3::size(8)>>), do: "DI"
  def decode(<<0xf9::size(8)>>), do: "LD SP, HL"
  def decode(<<0xfb::size(8)>>), do: "EI"
  def decode(<<0xfd::size(8)>>), do: "FD ***"
  def decode(<<0xff::size(8)>>), do: "RST"


  def decode(<<0x13::size(5)>> <> <<dest::size(3)>>) do
    dest_reg = Decode.reg8(<<dest::size(3)>>)
    "SBC A,#{dest_reg}"
  end

  def decode(<<0x0e::size(5)>> <> <<dest::size(3)>>) do
    dest_reg = Decode.reg8(<<dest::size(3)>>)
    "LD (HL),#{dest_reg}"
  end

  def decode(<<1::size(2)>> <> <<src::size(3)>> <> <<0x6::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    "LD #{src_reg},(HL)"
  end

  def decode(<<0::size(2)>> <> <<src::size(3)>> <> <<0x4::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    "INC #{src_reg}"
  end

  def decode(<<0x3::size(2)>> <> <<page::size(3)>> <> <<0x7::size(3)>>) do
    "RST #{Decode.page_val(page)}"
  end

  def decode(<<0x14::size(5)>> <> <<src::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    "AND #{src_reg}"
  end

  def decode(<<0x16::size(5)>> <> <<src::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    "OR #{src_reg}"
  end

  # LD r,r - 0b01_ddd_sss
  def decode(<<1::size(2)>> <> <<dest::size(3)>> <> <<src::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    dest_reg = Decode.reg8(<<dest::size(3)>>)
    "LD #{dest_reg},#{src_reg}"
  end

  def decode(<<0x17::size(5)>> <> <<src::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    "CP #{src_reg}"
  end

  def decode(<<0x3::size(2)>> <> <<cond_code::size(3)>> <> <<0x0::size(3)>>) do
    cond_code_val = Decode.cond_code(<<cond_code::size(3)>>)
    "RET #{cond_code_val}"
  end

  def decode(<<0x0::size(2)>> <> <<dest::size(2)>> <> <<0x0b::size(4)>>) do
    dest_reg = Decode.reg16(<<dest::size(2)>>)
    "DEC #{dest_reg}"
  end

  def decode(<<0::size(2)>> <> <<dest::size(2)>> <> <<0x3::size(4)>>) do
    dest_reg = Decode.reg16(<<dest::size(2)>>)
    "INC #{dest_reg}"
  end

  def decode(<<0x3::size(2)>> <> <<dest::size(2)>> <> <<0x1::size(4)>>) do
    dest_reg = Decode.reg16(<<dest::size(2)>>)
    "POP #{dest_reg}"
  end

  def decode(<<0x12::size(5)>> <> <<dest::size(3)>>) do
    dest_reg = Decode.reg8(<<dest::size(3)>>)
    "SUB #{dest_reg}"
  end

  def decode(<<0x10::size(5)>> <> <<dest::size(3)>>) do
    dest_reg = Decode.reg8(<<dest::size(3)>>)
    "ADD #{dest_reg}"
  end

  def decode(<<0x0::size(2)>> <> <<dest::size(2)>> <> <<0x9::size(4)>>) do
    dest_reg = Decode.reg16(<<dest::size(2)>>)
    "ADD HL,#{dest_reg}"
  end

  def decode(<<0x3::size(2)>> <> <<dest::size(2)>> <> <<0x5::size(4)>>) do
    dest_reg = Decode.reg16(<<dest::size(2)>>)
    "PUSH #{dest_reg}"
  end

  def decode(<<0x15::size(5)>> <> <<src::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    "XOR #{src_reg}"
  end

  def decode(<<0x0::size(2)>> <> <<src::size(3)>> <> <<0x5::size(3)>>) do
    src_reg = Decode.reg8(<<src::size(3)>>)
    "DEC #{src_reg}"
  end
 
  def decode(<<0x11::size(5)>> <> <<dest::size(3)>>) do
    dest_reg = Decode.reg8(<<dest::size(3)>>)
    "ADC A,#{dest_reg}"
  end

  def decode(<<_byte>>) do
    raise "Illegal instruction"
  end

  #
  # Two byte instructions
  #
  def decode(<<0x36::size(8)>>, <<operand::size(8)>>) do
    "LD (HL),#{operand}"
  end

  # LD r, n - 0b00_ddd_110
  def decode(<<0x0::size(2)>> <> <<dest::size(3)>> <> <<0x6::size(3)>>, << operand::size(8) >>) do
    dest_reg = Decode.reg8(<<dest::size(3)>>)
    "LD #{dest_reg}, #{operand}"
  end

  def decode(<<0xD6::size(8)>>, <<operand::size(8)>>), do: "SUB #{operand}"
  def decode(<<0x10::size(8)>>, <<operand::size(8)>>), do: "DJNZ #{operand}"
  def decode(<<0x18::size(8)>>, <<operand::size(8)>>), do: "JR #{operand}"
  def decode(<<0x20::size(8)>>, <<operand::size(8)>>), do: "JR NZ,#{operand}"
  def decode(<<0x28::size(8)>>, <<operand::size(8)>>), do: "JR Z,#{operand}"
  def decode(<<0x30::size(8)>>, <<operand::size(8)>>), do: "JR NC, #{operand}"
  def decode(<<0x38::size(8)>>, <<operand::size(8)>>), do: "JR C,#{operand}"
  def decode(<<0xc6::size(8)>>, <<operand::size(8)>>), do: "ADD A, #{operand}"
  def decode(<<0xcb::size(8)>>, <<operand::size(8)>>), do: "CB #{operand} ***"
  def decode(<<0xce::size(8)>>, <<operand::size(8)>>), do: "ADC A, #{operand}"
  def decode(<<0xd3::size(8)>>, <<operand::size(8)>>), do: "OUT #{operand}"
  def decode(<<0xdb::size(8)>>, <<operand::size(8)>>), do: "IN A,(#{operand})"
  def decode(<<0xe6::size(8)>>, <<operand::size(8)>>), do: "AND #{operand}"
  def decode(<<0xed::size(8)>>, <<operand::size(8)>>), do: "ED #{operand} ***"
  def decode(<<0xee::size(8)>>, <<operand::size(8)>>), do: "XOR #{operand}"
  def decode(<<0xf6::size(8)>>, <<operand::size(8)>>), do: "OR #{operand}"
  def decode(<<0xfe::size(8)>>, <<operand::size(8)>>), do: "CP #{operand}"
  def decode(<<_instr>>, _operand), do: raise "Invalid instruction"

  #
  # Three byte instructions
  #
  def decode(<<0xC3::8>>, operand1, operand2) do
    <<operand::size(16)>> = operand2 <> operand1
    "JP #{operand}"
  end

  def decode(<<0xCD::8>>, operand1, operand2) do
    <<operand::size(16)>> = operand2 <> operand1
    "CALL #{operand}"
  end

  def decode(<<0x2a::size(8)>>, operand1, operand2) do
    <<operand::size(16)>> = operand2 <> operand1
    "LD HL,(#{operand})"
  end

  def decode(<<0x32::size(8)>>, operand1, operand2) do
    <<operand::size(16)>> = operand2 <> operand1
    "LD (#{operand}),A"
  end

  def decode(<<0x3a::size(8)>>, operand1, operand2) do
    <<operand::size(16)>> = operand2 <> operand1
    "LD A,(#{operand})"
  end

  def decode(<<0x22::size(8)>>, operand1, operand2) do
    <<operand::size(16)>> = operand2 <> operand1
    "LD (#{operand}),HL"
  end

  def decode(<<0::size(2)>> <> <<dest::size(2)>> <> <<0x1::size(4)>>, operand1, operand2) do
    dest_reg = Decode.reg16(<<dest::size(2)>>)
    <<operand::size(16)>> = operand2 <> operand1
    "LD #{dest_reg}, #{operand}"
  end

  def decode(<<0x3::size(2)>> <> <<cond_code::size(3)>> <> <<0x2::size(3)>>, operand1, operand2) do
    cond_code_val = Decode.cond_code(<<cond_code::size(3)>>)
    <<operand::size(16)>> = operand2 <> operand1
    "JP #{cond_code_val}, #{operand}"
  end

  def decode(<<0x3::size(2)>> <> <<cond_code::size(3)>> <> <<0x4::size(3)>>, operand1, operand2) do
    cond_code_val = Decode.cond_code(<<cond_code::size(3)>>)
    <<operand::size(16)>> = operand2 <> operand1
    "CALL #{cond_code_val}, #{operand}"
  end
end
