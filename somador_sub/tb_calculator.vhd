library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_calculator is
    -- sem entradas aqui
end tb_calculator;

architecture behavior of tb_calculator is
    component calc
        PORT(
            clk     : IN STD_LOGIC;
            rst     : IN STD_LOGIC;    
            row_in  : IN STD_LOGIC_VECTOR(3 downto 0);
            -- DISPLAY
            col_out : OUT STD_LOGIC_VECTOR(3 downto 0);
            an      : OUT STD_LOGIC_VECTOR(3 downto 0);
            seg     : OUT STD_LOGIC_VECTOR(6 downto 0);
            Cout    : OUT STD_LOGIC
        );
    end component;

signal clk      : STD_LOGIC :='0';
signal rst      : STD_LOGIC :='1'; 

signal row_in   : STD_LOGIC_VECTOR(3 downto 0) := "1111";
signal col_out  : STD_LOGIC_VECTOR(3 downto 0);
signal an       : STD_LOGIC_VECTOR(3 downto 0);
signal seg      : STD_LOGIC_VECTOR(6 downto 0);
signal cout_tb  : STD_LOGIC;

constant clk_period: time:=20 ns; -- 50 Mhz

procedure press_key(
    signal row_sig        : OUT STD_LOGIC_VECTOR(3 downto 0);
    signal clk_sig        : IN STD_LOGIC;
    constant row_pattern  : IN STD_LOGIC_VECTOR(3 downto 0);
    constant col_pattern  : IN STD_LOGIC_VECTOR(3 downto 0)
) is

    begin
        row_sig<=row_pattern;

        wait until rising_edge(clk_sig);
        wait until rising_edge(clk_sig);
        wait until rising_edge(clk_sig);

        -- solta a tecla
        row_sig<="1111";

        -- aguarda debounce
        wait until rising_edge(clk_sig);
        wait until rising_edge(clk_sig);


    end procedure;

begin 

        uet: calc PORT MAP(
            clk         =>clk,
            rst         =>rst,
            row_in      =>row_in,
            col_out     =>col_out,
            an          =>an,
            seg         =>seg,
            Cout        =>cout_tb
        );

        clk_process: process
        begin
            clk <= '0';
            wait for clk_period/2;   
            clk <= '1';                
            wait for clk_period/2;
        end process;
        
        -- estimulador de processo
        stim_proc: process
        begin
            wait for 100 ns;
            rst <= '1';
            wait for 100 ns;   
            rst <= '0';                
            wait for 50 ns;

        report "COMECANDO TESTE 1: 7+3";

        -- 1 para executar
        press_key(row_in, clk, "1110", "1110");
        -- 7 pressionado
        press_key(row_in, clk, "1011", "1110");
        -- soma
        press_key(row_in, clk, "1110", "0111");
        -- 3 pressionado
        press_key(row_in, clk, "1110", "1011");
        -- 0 (checar)
        press_key(row_in, clk, "0111", "1101");

        wait for 200 ns;
        report "TESTE 1 FINALIZADO. CHEQUE AS ONDAS NO GTK";

        report "COMECANDO TESTE 2: 9-2";
        -- 9 pressionado
        press_key(row_in, clk, "1011", "1011");
        -- subtração
        press_key(row_in, clk, "0111", "1101");
        
        press_key(row_in, clk, "1101", "0111");
        -- 2 pressionado
        press_key(row_in, clk, "1110", "1101");
        
        press_key(row_in, clk, "0111", "1101");

        wait for 200 ns;
        report "TESTE 2 FINALIZADO. CHEQUE AS ONDAS NO GTK";
        
        report "COMECANDO TESTE 3: 5+5";
        press_key(row_in, clk, "1101", "1101");
        press_key(row_in, clk, "0111", "1101");
        press_key(row_in, clk, "1110", "0111");
        press_key(row_in, clk, "1101", "1101");
        press_key(row_in, clk, "0111", "1101");

        wait for 200 ns;
        report "TESTE 3 FINALIZADO. CHEQUE AS ONDAS NO GTK";

        report "COMECANDO TESTE 4: 8-8";
        press_key(row_in, clk, "1011", "1101");
        press_key(row_in, clk, "0111", "1101");
        press_key(row_in, clk, "1101", "0111");
        press_key(row_in, clk, "1011", "1101");
        press_key(row_in, clk, "0111", "1101");

        wait for 200 ns;

        report "TESTE 4 FINALIZADO. CHEQUE AS ONDAS NO GTK";

        wait for 100 ns;
        report "TODOS OS TESTES FORAM EXECUTADOS COM SUCESSO";
        wait;
    end process;
end behavior;



