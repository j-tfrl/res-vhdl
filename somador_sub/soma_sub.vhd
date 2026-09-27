-- by: @jtfrl

-- SOMADOR COMPLETO COM RIPPLE CARRY
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity soma_sub is
	PORT(
    	A	 	: IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- cada dígito tem 4 bits
        B		: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		op		: IN STD_LOGIC; -- '0' para '+' e 1 para '-'
        Cout	: OUT STD_LOGIC;
        S		: OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- resultado de soma ou subtração
    );
end entity;

  
architecture dataflow of soma_sub is 
    -- soma de cada par de dígitos e seu respec. carry
	    signal op_col : STD_LOGIC_VECTOR(11 DOWNTO 0);
	    signal carry	: STD_LOGIC_VECTOR(12 DOWNTO 0); -- carry in
	begin
		-- operações
	    op_col<=(not B) when op='1' else B; -- troca de bits para subtração
	    carry(0)<=op; 
	    
	    gen_bits: for i in 0 to 11 generate
	    	S(i) <= A(i) XOR op_col(i) XOR carry(i)
	        carry(i+1)<= (A(i) AND op_col(i)) OR
	        			 (A(i) AND carry(i))  OR
	                     (op_col(i) AND carry(i));
	    end generate;
	    
	    Cout<=carry(12);
	 
	 end architecture;
	-- op0:
 --    	s0<= A xor B xor Cin;
 --        c0<= (A and Cin) or (B and Cin) or (A and B);
 --    op1: 
 --    	s1<= Cin xor s0 xor Cin;
 --        Cout<= (s0 and Cin) or (s1 and Cin) or (s0 and s1);
 --    op2:
 --   	 	S<= A xor B xor Cin;
 --        Cout<= (A and Cin) or (B and Cin) or (A and B);
 --    carry<=c1 or s2;
    
end dataflow;
