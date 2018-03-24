---------------------------------------------------------------------
-- TITLE: Random Access Memory for Xilinx
-- AUTHOR: Steve Rhoads (rhoadss@yahoo.com)
-- DATE CREATED: 11/06/05
-- FILENAME: ram_xilinx.vhd
-- PROJECT: Plasma CPU core
-- COPYRIGHT: Software placed into the public domain by the author.
--    Software 'as is' without warranty.  Author liable for nothing.
-- DESCRIPTION:
--    Implements the RAM for Spartan 3 Xilinx FPGA
--
--    Compile the MIPS C and assembly code into "text.exe".
--    Run convert.exe to change "text.exe" to "code.txt" which
--    will contain the hex values of the opcodes.
--    Next run "run_image ram_xilinx.vhd code.txt ram_image.vhd",
--    to create the "ram_image.vhd" file that will have the opcodes
--    corectly placed inside the INIT_00 => strings.
--    Then include ram_image.vhd in the simulation/synthesis.
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mlite_pack.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity ram is
   generic(memory_type : string := "DEFAULT");
   port(clk               : in std_logic;
        enable            : in std_logic;
        write_byte_enable : in std_logic_vector(3 downto 0);
        address           : in std_logic_vector(31 downto 2);
        data_write        : in std_logic_vector(31 downto 0);
        data_read         : out std_logic_vector(31 downto 0));
end; --entity ram

architecture logic of ram is
begin

   RAMB16_S9_inst0 : RAMB16_S9
   generic map (
INIT_00 => X"28008C3C3C14AC2C008C3C24083C00088C3C3C08000000000003273C0003273C",
INIT_01 => X"3CAC24ACAC003C24003400088C24AC3C243C2410AC3C243C00248CACAC102410",
INIT_02 => X"0C8024240C001400100080AF2400270003AC3C1030008C3C000000030014008C",
INIT_03 => X"243C243C273C273C000000038C3C1030008C3C30038C3C00032703008F001000",
INIT_04 => X"AC8C243C243C243C24142400AC8C243C243C243C241400AC243C243C241400AC",
INIT_05 => X"00AF00AF2340AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF2308000C24142400",
INIT_06 => X"8F8F8F8F8F8F8F8F8F0008ACAC3C00208F230CAF0008200010002000108C3CAF",
INIT_07 => X"8C0003001030008C00000040034040033423038F038F8F8F8F8F8F8F8F8F8F8F",
INIT_08 => X"0024003C0003AC00248C0003AC34008C0003AC00008CAC34248C000300103000",
INIT_09 => X"AC00008CAC00008C3CAC000024003C24300003AC3C3400033C13008C0017008C",
INIT_0A => X"000800080003AC340003ACAC340003AC000003AC00308CAC00008CAC0030008C",
INIT_0B => X"AF10AFAF3230AF270003AC00008CAC34248C0003AC00248C0003AC34008C0008",
INIT_0C => X"8F028FACAE10240C001232AC0010020CAE14240C001032ACACACAC0010240C00",
INIT_0D => X"3010008100AF000027000300AC242403A0AC24001000248C3010008C27038F8F",
INIT_0E => X"8C008E00AFAF8CAF270003AC240014008C2703008F0000100010008D00250C01",
INIT_0F => X"00080008000027088F028F000CAFAF272703AC8F8F8F0010260C8E9200100200",
INIT_10 => X"AE8F000C00AFAFAF2727038F8FAE8F000C00AFAFAF2727038F8E8F000CAFAF27",
INIT_11 => X"00140010008224240000AFAFAFAFAFAF2727038F8E8F000CAFAF2727038F8F00",
INIT_12 => X"3CAF0CAF2424273C00030003000027038F8F8F8F8F8F0010AE020C8226AE020C",
INIT_13 => X"260C343CAF0CAFAC3CAF262727AFAF3C27AF27240C240C243C240C243C240C24",
INIT_14 => X"544953410010360C24360C24260C343C360C24360C24260C243C360C24360C24",
INIT_15 => X"455443646C2E2E6E61730000000F410003273C000000000A4F4C49004F4C4921",
INIT_16 => X"61730000000F410003273C00000000000000000075747500547361742E612E65",
INIT_17 => X"00000000000000000000000075747500547361742E612E65455443646C2E2E6E",
INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1A => X"000000000000000000000000000000000000000000000000006F000000000000",
INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DO   => data_read(31 downto 24),
      DOP  => open, 
      ADDR => address(12 downto 2),
      CLK  => clk, 
      DI   => data_write(31 downto 24),
      DIP  => ZERO(0 downto 0),
      EN   => enable,
      SSR  => ZERO(0),
      WE   => write_byte_enable(3));

   RAMB16_S9_inst1 : RAMB16_S9
   generic map (
INIT_00 => X"65004302044064440062038400040000440204000000000000405A1A00405A1A",
INIT_01 => X"03430343440002038202000084A540054202A5004305420262024340430063A0",
INIT_02 => X"00A4A504000046004000A2BF0680BD00E044024042006203000000E000400062",
INIT_03 => X"8404A505BD1D9C1C000000E04202404200620342E0420200E0BDE000BF000000",
INIT_04 => X"A3C38404A505C606A560C6A4A3C38404A505C606A560A4A08404A505A560A4A0",
INIT_05 => X"00BB00BA5A1ABFB9B8AFAEADACABAAA9A8A7A6A5A4A3A2A1BD000000A560C6A4",
INIT_06 => X"A9A8A7A6A5A4A3A2A10000C0C5068505A4A500A400008406A8C5050006C606BB",
INIT_07 => X"8200E0004042008200000084E0029B401BBD60BB60BBBABFB9B8AFAEADACABAA",
INIT_08 => X"8242040200E08243038200E08242008200E0824300828242038200E000404200",
INIT_09 => X"448303444464004402444602C6430603A200E043026300200320005900200099",
INIT_0A => X"0000000000E085A500E08582A200E0850000E045A3A543436405444486840546",
INIT_0B => X"B040B2BF22B1B1BD00E0824300828242038200E08243038200E0824200820000",
INIT_0C => X"B200BF4202400400002031420000000002400400004022404040524040040080",
INIT_0D => X"A5A0000500BFA080BD00E000820202E085628200C0866664A5600083BDE0B0B1",
INIT_0E => X"43002280BFB190B0BD00E0820200400082BDE000BF000000E0400022E2080020",
INIT_0F => X"000000000000BD00B000BF8000BFB0BDBDE042B0B1BF00001000240500600300",
INIT_10 => X"11BF8000A0B0B1BFBDBDE0B0B111BF8000A0B0B1BFBDBDE0B002BF8000B0BFBD",
INIT_11 => X"0052004000021312A080B4BFB0B1B2B3BDBDE0B002BF8000B0BFBDBDE0B0B100",
INIT_12 => X"04B000BF8405BD0400E000E00000BDE0B0B1B2B3B4BF00003420001410332000",
INIT_13 => X"0400A505A000A44302A204A3A2A2A210A2A2A204008400050484000504840005",
INIT_14 => X"494F534300000400050400050400A5050400050400050400A505040005040005",
INIT_15 => X"004154006462676F62742E0701670000405A1A0000000000464552004E45520A",
INIT_16 => X"62742E0701670000405A1A00000000000000000074722E2E4173006469747278",
INIT_17 => X"00000000000000000000000074722E2E4173006469747278004154006462676F",
INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1A => X"00000000000000000000000000000000000000000000000000FF000000000000",
INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DO   => data_read(23 downto 16),
      DOP  => open, 
      ADDR => address(12 downto 2),
      CLK  => clk, 
      DI   => data_write(23 downto 16),
      DIP  => ZERO(0 downto 0),
      EN   => enable,
      SSR  => ZERO(0),
      WE   => write_byte_enable(2));

   RAMB16_S9_inst2 : RAMB16_S9
   generic map (
INIT_00 => X"00000A0000000A00000A000A000000010A004001000000000000020000000100",
INIT_01 => X"200200020220200000C300010A0A000003200A000000032018000A0A0A000000",
INIT_02 => X"00FF000000000000000000000028FF00000120FF000000200000000000FF0002",
INIT_03 => X"0B000A000D000A00000000000120FF000000200000002000000000000000FF00",
INIT_04 => X"00000A000A000A0000FF001800000A000A000A0000FF18000A000A0000FF1800",
INIT_05 => X"D800D800FF70000000000000000000000000000000000000FF00000200FF0018",
INIT_06 => X"0000000000000000000000000020280000000100000000300040002000002000",
INIT_07 => X"00000000FF000000000000600060600000000000000000000000000000000000",
INIT_08 => X"200A200000000010FF000000000000000000001000000000FF00000000FF0000",
INIT_09 => X"0020180000200000200010100A1800000000000320BE0000DE00000000000000",
INIT_0A => X"000100010000000000000000000000000000000028000000182C000020002400",
INIT_0B => X"00000000000000FF0000001000000000FF0000000010FF000000000000000001",
INIT_0C => X"0010000000FF0001000000008000200100000001000000000000008000000190",
INIT_0D => X"0000000038004048FF0000100000000000000010003000000000000000000000",
INIT_0E => X"0000008800000000FF10000000000000000000000010000010FF000038000120",
INIT_0F => X"000200020000000100200080010000FF00000000000000FF0002000000001800",
INIT_10 => X"0000800088000000FF000000000000800088000000FF000000000080000000FF",
INIT_11 => X"00000000000000008088000000000000FF000000000080000000FF0000000010",
INIT_12 => X"000001000000FF00000010000000000000000000000000FF002000FF00002000",
INIT_13 => X"020184170001000A000001000000002000000000000001000000010000000100",
INIT_14 => X"4F4C204300FF0201000201000201A10002010002010002014B00020100020100",
INIT_15 => X"2E424F562D756E7400727304006E00000002000000000000464443000D444300",
INIT_16 => X"00727304006E00000002000000000000000000006569616743002E616E616F74",
INIT_17 => X"0000000000000000000000006569616743002E616E616F742E424F562D756E74",
INIT_18 => X"000000000000000A000000000000000000000B00000000000000000000000000",
INIT_19 => X"0B0B00000000000000000B0A00000000000000000B0A00000000000000000B0A",
INIT_1A => X"0000000000000000000000000B0000000000000000000B0000FF000000000002",
INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DO   => data_read(15 downto 8),
      DOP  => open, 
      ADDR => address(12 downto 2),
      CLK  => clk, 
      DI   => data_write(15 downto 8),
      DIP  => ZERO(0 downto 0),
      EN   => enable,
      SSR  => ZERO(0),
      WE   => write_byte_enable(1));

   RAMB16_S9_inst3 : RAMB16_S9
   generic map (
INIT_00 => X"0700B8000013B40100B40070510000D7B000005C0000000000089C000008E000",
INIT_01 => X"00000A000C120009185000B7B094080000008406080000000401B8B8B8020103",
INIT_02 => X"48FF010D480003000B0000140A25E800080800FC020008000000000800FD0008",
INIT_03 => X"5000B0005000B000000000080000FC010008000108080000081808001400F300",
INIT_04 => X"0000B000B000700004FB042A0000B000B000700004FD2A00B000B00004FD2A00",
INIT_05 => X"125C1058FC0054504C4844403C3834302C2824201C18141098A6005804FB042A",
INIT_06 => X"302C2824201C18141000C2101000040164001C6400C601420424012013080060",
INIT_07 => X"04000800FC010004000000000800000801681360115C5854504C4844403C3834",
INIT_08 => X"21C0800000080024FD000008000200000008002400000001FE00000800FC0200",
INIT_09 => X"142427141825001800002180C00400011F00080800EF0008AD03008000050000",
INIT_0A => X"0010000600080002000800000100080C0000081C25011C1C24421C1425010214",
INIT_0B => X"1013181C03FF14E0000800240000000CF30000080024F7000008000800000016",
INIT_0C => X"18251C4008F544FC00060240250A25FE040544FC000A010C080400250E10FC25",
INIT_0D => X"FF0B000025142525E80008250C02010800400125092B4040FF0B000820081014",
INIT_0E => X"400008251C180814E025080C02000300081808001425000225F5000C2101A425",
INIT_0F => X"00560054000018FE10251425D71410E820084014181C00F40117000000072B00",
INIT_10 => X"081C25F82514181CE020081418081C25F82514181CE0180810081425FF1014E8",
INIT_11 => X"0004000D00000D0A252520241014181CD8180810081425FF1014E82008141825",
INIT_12 => X"00A82FAC3804500000082508000028081014181C202400F10825F8FF010825F8",
INIT_13 => X"005000D7A41098B000A00098549C500010945401F2482F1F00302F0200542F03",
INIT_14 => X"4E41564500FF20580C2053082050200710580C1053081050404C00580C005308",
INIT_15 => X"744C5245696975652E74680100750000089C0000000000000D2020000A202000",
INIT_16 => X"2E74680100750000089C000000000000000000007362746E4B53627469006400",
INIT_17 => X"0B00000000000000000000007362746E4B53627469006400744C524569697565",
INIT_18 => X"3201300010000040D03007012A0001000020440000011E0004000024A0000207",
INIT_19 => X"505003084700100000A050B00308420001000000647001013801040000341070",
INIT_1A => X"00000000000000000000000074000003010001000010640000F54D0001000000",
INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DO   => data_read(7 downto 0),
      DOP  => open, 
      ADDR => address(12 downto 2),
      CLK  => clk, 
      DI   => data_write(7 downto 0),
      DIP  => ZERO(0 downto 0),
      EN   => enable,
      SSR  => ZERO(0),
      WE   => write_byte_enable(0));

end; --architecture logic