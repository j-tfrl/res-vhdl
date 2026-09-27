-- by: @jtfrl 
-- interligação dos três modulos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calc is
	PORT(
    	clk				: IN STD_LOGIC;
        rst				: IN STD_LOGIC;
        row_in			: IN STD_LOGIC_VECTOR(3 downto 0);
        col_out			: IN STD_LOGIC_VECTOR(3 downto 0);
        
        -- 7seg
        an				: OUT STD_LOGIC_VECTOR(3 downto 0);
        seg				: OUT STD_LOGIC_VECTOR(6 downto 0);
        Cout			: OUT STD_LOGIC
        
    );
end entity;

architecture structural of calc is
	signal dig_A		: STD_LOGIC_VECTOR(11 downto 0);
    signal dig_B		: STD_LOGIC_VECTOR(11 downto 0);
    signal op			: STD_LOGIC;
    signal resultado 	: STD_LOGIC_VECTOR(11 downto 0);
    signal overflow		: STD_LOGIC_VECTOR(12 downto 0);

begin 
	
    kb 			: entity work.kdb_encoder
    	port map(
        	clk		=> 	clk,
            rst		=> 	rst,
            row_in	=>	row_in,
            col_out	=>	col_out,
            dig_A	=>	dig_A,
            dig_B	=> 	dig_B,
            op		=> 	op
        );
    adder		: entity work.soma_sub
        port map(
        	A		=> dig_A,
            B		=> dig_B,
            op		=> op,
            Cout	=> overflow(12),
            S		=> resultado
            );

    -- subtractor	: entity work.soma_sub
    --     port map(
    --         A		=> dig_A,
    --         B		=> dig_B,
    --         op		=> '1'
    --         Cout	=> overflow(12),
    --         S		=> resultado
    --         );
    
    bcd7seg		: entity work.bcd7seg
    	port map(
        	sw_debounce =>  resultado & "0000" -- indica estado de desocupação
            an			=> an,
            seg			=> seg
        );
     
    Cout <= overflow(12);
end architecture;
    
 end architecture;
    
