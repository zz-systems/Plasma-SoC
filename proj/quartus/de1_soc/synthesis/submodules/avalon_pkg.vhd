library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

package avalon_pkg is 

    -- response values
    -- refer to Avalon interface specifications, Page 15
    subtype response_t is std_logic_vector(1 downto 0);
    constant response_okay : response_t := "00";
    constant response_reserved : response_t := "01";
    constant response_slaveerror : response_t := "10";
    constant response_decodeerror : response_t := "11";
    
end package avalon_pkg;