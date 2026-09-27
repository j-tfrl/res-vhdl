-- impl; @jtfl
-- TECLADO 0-9 PARA ENTRADAS A e B (DÍGITOS)
-- Deve receber
-- >>> sinais de ADD + e de SUB -
-- >>> dígitos de zero a 9
-- 
-- Deve retornar
-- <<< Vetores de dígitos (000 a 999)
-- <<< A op de operador (ADD ou SUB) via saída OP

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity kbd_encoder is
	PORT(
    	clk 	: IN STD_LOGIC;
        rst		: IN STD_LOGIC;
      	row_in	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);  
        col_out	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- fluxo de input
        dig_A 	: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        dig_B 	: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		op		: OUT STD_LOGIC
    );
end kbd_encoder;

-- == ESCANEAMENTO E DECODIFICAÇÃO
architecture behavioral of kbd_encoder is 
	SIGNAL scan_col		: INTEGER range 0 to 3:=0;
    SIGNAL key_code 	: STD_LOGIC_VECTOR(3 DOWNTO 0); -- 0-9
    -- >< era key_strobe
    SIGNAL status_ide 	: STD_LOGIC :='0'; --define se está ocupado ou não
    
    -- ajuda a converter os números em binário (BCD)
    FUNCTION bin_to_bcd (bin: integer) return STD_LOGIC_VECTOR is 
    	variable bcd : STD_LOGIC_VECTOR(11 DOWNTO 0):= (others=> '0');
        variable temp: integer;
       begin 
       	if bin>999 then temp:=999;
        else temp:=bin;
        end if;
        for i in 0 to 2 loop
        	bcd(i*4+3 downto i*4) :=STD_LOGIC_VECTOR(to_unsigned((temp/10**i)) mod 10,4);
        end loop;
     return bcd;
     end function;
begin
 --=== LOGICA COMBINACIONAL
 
 col_out<="1110"; -- valor digitado para cada numero
 process(row_in, col_out)
   begin 
   key_code<="1111"; -- sem tecla pressionada
   status_idle<='0';
   case row_in is
   	when "1110"=> -- linha 0 ativa
    	case col_out is
            WHEN "1110" => key_code <= "0001"; status_idle<='1'; -- digitou 1
            WHEN "1101" => key_code <= "0010"; status_idle<='1'; -- digitou 2
            WHEN "1011" => key_code <= "0011"; status_idle<='1'; -- digitou 3
            WHEN "0111" => key_code <= "0100"; status_idle<='1'; -- digitou '+'
            WHEN others => NULL;
        end case;
    when "1101"=> -- linha 1 ativa
    	case col_out is
            WHEN "1110" => key_code <= "0100"; status_idle<='1'; -- digitou 4
            WHEN "1101" => key_code <= "0101"; status_idle<='1'; -- digitou 5
            WHEN "1011" => key_code <= "0110"; status_idle<='1'; -- digitou 6
            WHEN "0111" => key_code <= "1011"; status_idle<='-'; -- digitou '-'
        	WHEN others => NULL;
         end case;
     when "1011"=> -- linha 2 ativa
    	case col_out is
            WHEN "1110" => key_code <= "0111"; status_idle<='1'; -- digitou 7
            WHEN "1101" => key_code <= "1000"; status_idle<='1'; -- digitou 8
            WHEN "1011" => key_code <= "1001"; status_idle<='1'; -- digitou 9
            WHEN others => NULL;
         end case;
      when "0111"=> -- linha 3 ativa
    	case col_out is
       		WHEN "1101" => key_code <= "0000"; status_idle<='1'; -- digitou 0
            WHEN others => NULL;
		end case;
      when others=> null;
     end case;
  end process;
     
     
  process(clk, rst)
	variable num_A 		: INTEGER range 0 to 999 := 0;
    variable num_B 		: INTEGER range 0 to 999 := 0;
    variable atual_dig 	: INTEGER range 0 to 9   := 0; -- inteiro atual que está sendo digitado
    variable state		: INTEGER range 0 to 1	 := 0; -- se o usuário digita a entrada de A ou de B
    variable prev_strobe: STD_LOGIC 			 := '0';
  begin 
  	if rst='1' then
    	num_A<=0;
        num_B<=0;
        state<=0;
        op<='0';
        dig_A<=(others=>'0');
        dig_B<=(others=>'0');
        prev_strobe<='0';
     elsif rising_edge(clk) then
     	if (status_idle='1' and prev_strobe='0') then
        	if (key_code >= "0000" and key_code <= "1001") then
            	atual_dig:=to_integer(unsigned(key_code));
                -- shifts (mudança de potência de dez)
                if state=0 then
                	if num_A<=99 then
                    	num_A:=(num_A * 10) + atual_dig;
                    end if;
                    dig_A<=bin_to_bcd(num_A);
                else
                	if num_B<=99 then
                    	num_B:=(num_B * 10) + atual_dig;
                    end if;
                elsif (key_code="1010" or key_code="1011") then
                	if key_code="1010" then
                    	op<='0'; -- opera '+'
                        -- note que como a variável é declarada como constante, não usamos :=
                    else
                    	op<='1'; -- opera '-'
                    end if;
                    
                    state:='1'; -- estado é uma variável (indicamos que houve interação)
        end if;
    end if;  
              prev_strobe<=status_idle;
           end if;
  end process;
end Behavioral;
