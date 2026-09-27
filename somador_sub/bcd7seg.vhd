-- by @jtfrl

-- DISPLAY DE SETE SEGMENTOS
-- ENTRADA
-- dados de soma ou subtração
-- SAÍDA
-- resultado da soma
-- idem para sub. (deve mostrar '-' se o res. é negativo)

library IEEE;
use IEEE.std_logic_1164.all;
-- use IEEE.NUMERIC_STD.all;

entity bcd7seg is
	PORT(
        sw_debounce		: IN STD_LOGIC_VECTOR(15 downto 0);
        an				: OUT STD_LOGIC_VECTOR(3 downto 0); -- coluna dos dados (anodo)
        seg				: OUT STD_LOGIC_VECTOR(6 downto 0) -- próprio segmento
    );
end bcd7seg;

entity bcd_decoder is
	PORT(
    	input : IN STD_LOGIC_VECTOR(3 downto 0);
        output: OUT STD_LOGIC_VECTOR(6 downto 0)
    );
end bcd_decoder;

architecture structural of bcd7seg is
	component bcd_decoder is
    	PORT(
        	input : IN STD_LOGIC_VECTOR(3 downto 0);
            output: OUT STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    signal seg1, seg2, seg3, seg4: STD_LOGIC_VECTOR(6 downto 0);
    signal is_negative: STD_LOGIC;
    begin 
    	decoder1: bcd_decoder port map (input=>sw_debounce(3 downto 0), output=>seg1);
        decoder2: bcd_decoder port map (input=>sw_debounce(7 downto 4), output=>seg2);
        decoder3: bcd_decoder port map (input=>sw_debounce(11 downto 8), output=>seg3);
        decoder4: bcd_decoder port map (input=>sw_debounce(15 downto 12), output=>seg4);
        seg<="0111111" when is_negative='1' else seg4; --padrão de aplicação do '-'
        an <= "0000"; -- digitos mostrados completamente
end architecture;

architecture combinational of bcd7seg is
begin
        process(input)
        begin
                case input is
                    WHEN "0000" => output <= "1000000"; --0
                    WHEN "0001" => output <= "1111001"; --1
                    WHEN "0010" => output <= "0100100"; --2
                    WHEN "0011" => output <= "0110000"; --3
                    WHEN "0100" => output <= "0011001"; --4
                    WHEN "0101" => output <= "0010010"; --5
                    WHEN "0110" => output <= "0000010"; --6
                    WHEN "0111" => output <= "1111000"; --7
                    WHEN "1000" => output <= "0000000"; --8
                    WHEN "1001" => output <= "0011000"; --9
                    WHEN others => output <= "1000000";
                end case;
        end process;
end combinational;
     
        
            
