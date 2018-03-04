-- phv util package
-- @author Sergej Zuyev

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.math_real.all;

package util_pkg is
    type FIFO_DIRECTION is (LEFT, RIGHT);

    component fifo
    generic (
      buckets      : natural := 4;
      bucket_width : natural := 8;
      direction    : FIFO_DIRECTION := LEFT;
      autoreset    : std_logic
    );
    port (
      clk      : in  std_logic;
      reset    : in  std_logic;
      en       : in  std_logic;
      dout     : out std_logic_vector(buckets * bucket_width - 1 downto 0);
      din      : in  std_logic_vector(bucket_width - 1 downto 0);
      overflow : out std_logic
    );
    end component fifo;


    function to_std_logic(L: BOOLEAN) return std_ulogic;
    function bit_width(L : natural) return integer;
end package;

package body util_pkg is
    function to_std_logic(L: BOOLEAN) return std_ulogic is
    begin
        if L then
            return('1');
        else
            return('0');
        end if;
    end function to_std_logic;

    function bit_width(L : natural) return integer is
    begin
        return integer(ceil(log2(real(L))));
    end function;
end package body;
