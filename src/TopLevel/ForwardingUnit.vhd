library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardingUnit is
   port (
      i_CLK              : in std_logic;     -- Clock input
      i_RST              : in std_logic;     -- Reset input
      EX_MEM_RegWrite    : in std_logic;
      MEM_WB_RegWrite    : in std_logic;
      EX_MEM_RegisterRd  : in std_logic_vector(4 downto 0);
      MEM_WB_RegisterRd  : in std_logic_vector(4 downto 0);
      ID_EX_RegisterRs   : in std_logic_vector(4 downto 0);
      ID_EX_RegisterRt   : in std_logic_vector(4 downto 0);
      ForwardA           : out std_logic_vector(1 downto 0)
      ForwardB           : out std_logic_vector(1 downto 0)
   );
end entity ForwardingUnit;

architecture Behavioral of ForwardingUnit is
   begin
      -- Hazard detection and control logic for ForwardA
      ForwardA <= "01" when (MEM_WB_RegWrite = '1'
                       and (MEM_WB_RegisterRd /= "00000") 
                       and not(EX_MEM_RegWrite = '1' and (EX_MEM_RegisterRd /= "00000") 
                           and (EX_MEM_RegisterRd = ID_EX_RegisterRs)) 
                       and (MEM_WB_RegisterRd = ID_EX_RegisterRs)) else
                  "10" when (EX_MEM_RegWrite = '1'
                       and (EX_MEM_RegisterRd /= "00000")
                       and (EX_MEM_RegisterRd = ID_EX_RegisterRs)) else
                  "00";
      

   
      -- Hazard detection and control logic for ForwardB
      ForwardB <= "01" when (MEM_WB_RegWrite = '1'
                       and (MEM_WB_RegisterRd /= "00000") 
                       and not(EX_MEM_RegWrite = '1' and (EX_MEM_RegisterRd /= "00000") 
                           and (EX_MEM_RegisterRd = ID_EX_RegisterRt)) 
                       and (MEM_WB_RegisterRd = ID_EX_RegisterRt)) else
                  "10" when (EX_MEM_RegWrite = '1'
                       and (EX_MEM_RegisterRd /= "00000")
                       and (EX_MEM_RegisterRd = ID_EX_RegisterRt)) else
                  "00";
   

   
end Behavioral;
   
   