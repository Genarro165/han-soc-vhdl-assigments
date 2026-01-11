--------------------------------------------------------------------
--! \file      alu_tb.vhd
--! \date      see top of 'Version History'
--! \brief     ALU assignment for HAN H-EHE-SOC class
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! This file contains a Vhdl test bench template that is freely editable to
--! suit user's needs. Comments are provided in each section to help the user
--! fill out necessary details.
--! 
--! Generated on "04/30/2021 13:58:06"
--! Vhdl Test Bench template for design  :  alu
--! Simulation tool : ModelSim-Altera (VHDL)
--!
--! Version History:
--! ----------------
--!
--! Nr:    |Date:      |Author: |Remarks:
--! -------|-----------|--------|-----------------------------------
--! 101    |25-11-2020 |WLGRW   |Inital version building upon version 002 for H-EHE-SOC class
--! 102    |24-12-2012 |WLGRW   |First release for assessing DIG2 class 2122
--! 103    |04-01-2022 |WLGRW   |Corrected signal errors to fit 36 tests
--!
--!
--!
--------------------------------------------------------------------
LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
USE std.textio.all; -- for text
--------------------------------------------------------------------
ENTITY alu_vhd_tst IS

   GENERIC (
      T: INTEGER := 35
   );

   END alu_vhd_tst;
--------------------------------------------------------------------
ARCHITECTURE alu_arch OF alu_vhd_tst IS
   -- constants                                                 
   
   TYPE student_data_type IS RECORD
      student_name:   string;
      student_number: string;
   END RECORD;
   
   TYPE student_type IS ARRAY (0 TO 1) OF student_data_type;
   
-- =================================================================================
   --! Enter here student names: 
   --! 1 - Ensure that string length are the same size for all student names!
   --! 2 - Ensure that the number of students is equal to student_type ARRAY size. 
   
   CONSTANT STUDENTS: student_type := (
      ("Remko Welling ", "111111"), 
      ("Jan Klaassen  ", "222222")
   );
-- =================================================================================
   
   CONSTANT strLine: string := "----------------------------------------------------------";
   
   CONSTANT TEST_PERIOD: time := 10 ns;
   CONSTANT MAX_DELAY:   time := 1  ns;
   CONSTANT TEST_DELAY:  time := 10  ns;
   
   --! output aliasses for hex-displays
   --                             segment number -> 01234567
   --                                               --------
   CONSTANT hex_off:   STD_LOGIC_VECTOR(0 TO 7) := "11111111"; --! display off
   CONSTANT hex_minus: STD_LOGIC_VECTOR(0 TO 7) := "11111101"; --! display min symbol
   CONSTANT hex_plus:  STD_LOGIC_VECTOR(0 TO 7) := "10011101"; --! display plus-symbol
       
   CONSTANT hex_zero:  STD_LOGIC_VECTOR(0 TO 7) := "00000011"; --! HEX representation of 0
   CONSTANT hex_one:   STD_LOGIC_VECTOR(0 TO 7) := "10011111"; --! HEX representation of 1
   CONSTANT hex_two:   STD_LOGIC_VECTOR(0 TO 7) := "00100101"; --! HEX representation of 2
   CONSTANT hex_three: STD_LOGIC_VECTOR(0 TO 7) := "00001101"; --! HEX representation of 3
   CONSTANT hex_four:  STD_LOGIC_VECTOR(0 TO 7) := "10011001"; --! HEX representation of 4
   CONSTANT hex_five:  STD_LOGIC_VECTOR(0 TO 7) := "01001001"; --! HEX representation of 5
   CONSTANT hex_six:   STD_LOGIC_VECTOR(0 TO 7) := "01000001"; --! HEX representation of 6
   CONSTANT hex_seven: STD_LOGIC_VECTOR(0 TO 7) := "00011111"; --! HEX representation of 7
   CONSTANT hex_eight: STD_LOGIC_VECTOR(0 TO 7) := "00000001"; --! HEX representation of 8
   CONSTANT hex_nine:  STD_LOGIC_VECTOR(0 TO 7) := "00001001"; --! HEX representation of 9
   CONSTANT hex_a:     STD_LOGIC_VECTOR(0 TO 7) := "00010001"; --! HEX representation of a
   CONSTANT hex_b:     STD_LOGIC_VECTOR(0 TO 7) := "11000001"; --! HEX representation of b
   CONSTANT hex_c:     STD_LOGIC_VECTOR(0 TO 7) := "01100011"; --! HEX representation of c
   CONSTANT hex_d:     STD_LOGIC_VECTOR(0 TO 7) := "10000101"; --! HEX representation of d
   CONSTANT hex_e:     STD_LOGIC_VECTOR(0 TO 7) := "01100001"; --! HEX representation of e
   CONSTANT hex_f:     STD_LOGIC_VECTOR(0 TO 7) := "01110001"; --! HEX representation of f
   
   CONSTANT OP_CLRR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
   CONSTANT OP_INCA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
   CONSTANT OP_DECA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
   CONSTANT OP_ADD  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
   CONSTANT OP_ADC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
   CONSTANT OP_ADB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
   CONSTANT OP_SBC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
   CONSTANT OP_SUB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
   CONSTANT OP_AND  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
   CONSTANT OP_OR   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
   CONSTANT OP_XOR  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
   CONSTANT OP_NOTA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
   CONSTANT OP_SHLA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
   CONSTANT OP_ROLA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
   CONSTANT OP_SHRA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
   CONSTANT OP_RORA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
   
   CONSTANT CARRY_FLAG:     INTEGER := 0; 
   CONSTANT SIGN_FLAG:      INTEGER := 1;
   CONSTANT OVER_FLOW_FLAG: INTEGER := 2;
   CONSTANT ZERO_FLAG:      INTEGER := 3;
   
   -- signals                                                   
   SIGNAL HEX0 : STD_LOGIC_VECTOR(0 TO 7);
   SIGNAL HEX1 : STD_LOGIC_VECTOR(0 TO 7);
   SIGNAL HEX2 : STD_LOGIC_VECTOR(0 TO 7);
   SIGNAL HEX3 : STD_LOGIC_VECTOR(0 TO 7);
   SIGNAL HEX4 : STD_LOGIC_VECTOR(0 TO 7);
   SIGNAL HEX5 : STD_LOGIC_VECTOR(0 TO 7);
   SIGNAL KEY  : STD_LOGIC_VECTOR(0 TO 1);
   SIGNAL LEDR : STD_LOGIC_VECTOR(0 TO 9);
   SIGNAL SW   : STD_LOGIC_VECTOR(0 TO 9);
   
   
   SIGNAL template_index : NATURAL range 0 to T := 0;
   
   SIGNAL simulationReady : boolean := false; 
   SIGNAL errors: natural range 0 to T+1 := 0; --! to keep track of any errors for presenting final result.
   SIGNAL tests:  natural range 0 to T := 0; --! to keep track of any errors for presenting final result.
   
   SIGNAL setOpCode,    --! signal to set opcode from operand A to opcode
          execOpCode,   --! signal to execute opcode set.
          signedMode    --! Signal to set mode of ALU '1'=signed.
                     : STD_LOGIC := '0';
   SIGNAL ledFlags,     --! ALU flags out 
          ledOpcode,    --! ALU opcode out 
          operandA,     --! Operand A
          operandB      --! Operand B
                     : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
   
   FILE results_file:  text OPEN write_mode IS "results.txt";

   TYPE test_data_type IS RECORD
      case_opCode:            STRING;
      stimulus_signed:        STD_LOGIC;
      stimulus_opCode:        STD_LOGIC_VECTOR(3 DOWNTO 0);
      stimulus_operandA:      STD_LOGIC_VECTOR(3 DOWNTO 0);
      stimulus_operandB:      STD_LOGIC_VECTOR(3 DOWNTO 0);
      responce_flag_carry:    STD_LOGIC;
      responce_flag_sign:     STD_LOGIC;
      responce_flag_overflow: STD_LOGIC;
      responce_flag_zero:     STD_LOGIC;
      responce_HEX5:          STD_LOGIC_VECTOR(0 TO 7);
      responce_HEX4:          STD_LOGIC_VECTOR(0 TO 7);
      responce_HEX3:          STD_LOGIC_VECTOR(0 TO 7);
      responce_HEX2:          STD_LOGIC_VECTOR(0 TO 7);
      responce_HEX1:          STD_LOGIC_VECTOR(0 TO 7);
      responce_HEX0:          STD_LOGIC_VECTOR(0 TO 7);
      
   END RECORD;

   TYPE template_type IS ARRAY (0 TO T) OF test_data_type;
   
   --! Test cases for sevenOut4Decoder
   --! These test cases test for 16 symbols and 4 control characters.
   CONSTANT TEMPLATE: template_type := (
   --   case_opCode
   --   |        stimulus_signed
   --   |         |  stimulus_opCode
   --   |         |   |        stimulus_operandA   
   --   |         |   |         |      stimulus_operandB
   --   |         |   |         |       |      carry
   --   |         |   |         |       |       |   sign
   --   |         |   |         |       |       |    |   overflow
   --   |         |   |         |       |       |    |    |   zero
   --   |         |   |         |       |       |    |    |    |   responce_HEX5
   --   |         |   |         |       |       |    |    |    |    |          responce_HEX4
   --   |         |   |         |       |       |    |    |    |    |           |         responce_HEX3
   --   |         |   |         |       |       |    |    |    |    |           |          |         responce_HEX2
   --   |         |   |         |       |       |    |    |    |    |           |          |          |         responce_HEX1
   --  UNSIGNED   |   |         |       |       |    |    |    |    |           |          |          |          |         responce_HEX0
   --   |         |   |         |       |       |    |    |    |    |           |          |          |          |          |
      ("CLRR 1", '0', OP_CLRR, x"0"  , x"0"  , '0', '0', '0', '1', hex_off   , hex_zero , hex_off  , hex_zero , hex_off  , hex_zero ), -- 0
      ("INCA 1", '0', OP_INCA, x"0"  , x"0"  , '0', '0', '0', '0', hex_off   , hex_zero , hex_off  , hex_zero , hex_off  , hex_one  ), -- 1
      ("INCA 2", '0', OP_INCA, x"F"  , x"F"  , '1', '0', '1', '1', hex_off   , hex_f    , hex_off  , hex_f    , hex_off  , hex_zero ), -- 2
      ("DECA 1", '0', OP_DECA, x"6"  , x"F"  , '0', '0', '0', '0', hex_off   , hex_six  , hex_off  , hex_f    , hex_off  , hex_five ), -- 3
      ("DECA 2", '0', OP_DECA, x"0"  , x"F"  , '1', '0', '1', '0', hex_off   , hex_zero , hex_off  , hex_f    , hex_off  , hex_f    ), -- 4
      ("ADD  1", '0', OP_ADD , x"8"  , x"2"  , '0', '0', '0', '0', hex_off   , hex_eight, hex_off  , hex_two  , hex_off  , hex_a    ), -- 5
      ("ADD  2", '0', OP_ADD , x"E"  , x"2"  , '1', '0', '1', '1', hex_off   , hex_e    , hex_off  , hex_two  , hex_off  , hex_zero ), -- 6
      ("CLRR 2", '0', OP_CLRR, x"0"  , x"0"  , '0', '0', '0', '1', hex_off   , hex_zero , hex_off  , hex_zero , hex_off  , hex_zero ), -- 7
      ("ADC   ", '0', OP_ADC , x"0"  , x"1"  , '0', '0', '0', '0', hex_off   , hex_zero , hex_off  , hex_one  , hex_off  , hex_one  ), -- 8
--      ("ADB  1", '0', OP_ADB , x"8"  , x"4"  , '1', '0', '1', '0', hex_off   , hex_eight, hex_off  , hex_four , hex_off  , hex_two  ), -- 9
--      ("ADB  2", '0', OP_ADB , x"0"  , x"4"  , '0', '0', '0', '0', hex_off   , hex_zero , hex_off  , hex_four , hex_off  , hex_four ), -- 10
--      ("ADB  3", '0', OP_ADB , x"F"  , x"2"  , '1', '0', '1', '0', hex_off   , hex_f    , hex_off  , hex_two  , hex_off  , hex_one  ), -- 11
      ("SUB  1", '0', OP_SUB , x"8"  , x"4"  , '0', '0', '0', '0', hex_off   , hex_eight, hex_off  , hex_four , hex_off  , hex_four ), -- 12
      ("SUB  2", '0', OP_SUB , x"2"  , x"4"  , '1', '0', '1', '0', hex_off   , hex_two  , hex_off  , hex_four , hex_off  , hex_e    ), -- 13
      ("SBC   ", '0', OP_SBC , x"0"  , x"0"  , '1', '0', '1', '0', hex_off   , hex_zero , hex_off  , hex_zero , hex_off  , hex_f    ), -- 14

  --    SIGNED ---------------------------------------------------------------------------------------------------------------------
      ("INCAS1", '1', OP_INCA, x"0"  , x"1"  , '0', '1', '0', '0', hex_plus  , hex_zero , hex_plus , hex_one  , hex_plus , hex_one  ), -- 15
      ("INCAS2", '1', OP_INCA, x"7"  , x"1"  , '0', '1', '1', '0', hex_plus  , hex_seven, hex_plus , hex_one  , hex_minus, hex_eight), -- 16
      ("CLRRS1", '1', OP_CLRR, x"0"  , x"0"  , '0', '1', '0', '1', hex_plus  , hex_zero , hex_plus , hex_zero , hex_plus , hex_zero ), -- 17
      ("DECAS1", '1', OP_DECA, x"0"  , x"1"  , '1', '1', '1', '0', hex_plus  , hex_zero , hex_plus , hex_one  , hex_minus, hex_one  ), -- 18
      ("DECAS2", '1', OP_DECA, x"8"  , x"1"  , '0', '1', '1', '0', hex_minus , hex_eight, hex_plus , hex_one  , hex_plus , hex_seven), -- 19
      ("CLRRS2", '1', OP_CLRR, x"0"  , x"0"  , '0', '1', '0', '1', hex_plus  , hex_zero , hex_plus , hex_zero , hex_plus , hex_zero ), -- 20
      ("ADD S1", '1', OP_ADD , x"8"  , x"E"  , '1', '1', '1', '0', hex_minus , hex_eight, hex_minus, hex_two  , hex_plus , hex_six  ), -- 21
      ("ADC S ", '1', OP_ADC , x"1"  , x"1"  , '0', '1', '0', '0', hex_plus  , hex_one  , hex_plus , hex_one  , hex_plus , hex_three), -- 23
--      ("ADB S1", '1', OP_ADB , x"8"  , x"4"  , '1', '0', '1', '0', hex_off   , hex_eight, hex_off  , hex_four , hex_off  , hex_two  ), --  result is -2
--      ("ADB S2", '1', OP_ADB , x"0"  , x"4"  , '0', '0', '0', '0', hex_off   , hex_zero , hex_off  , hex_four , hex_off  , hex_four ), -- 
--      ("ADB S3", '1', OP_ADB , x"F"  , x"2"  , '1', '0', '1', '0', hex_off   , hex_f    , hex_off  , hex_two  , hex_off  , hex_one  ), --
      ("CLRRS3", '1', OP_CLRR, x"0"  , x"0"  , '0', '1', '0', '1', hex_plus  , hex_zero , hex_plus , hex_zero , hex_plus , hex_zero ), -- 24
      ("SUB S1", '1', OP_SUB , x"8"  , x"4"  , '0', '1', '1', '0', hex_minus , hex_eight, hex_plus , hex_four , hex_plus , hex_four ), -- 25
      ("SBC S1", '1', OP_SBC , x"2"  , x"1"  , '0', '1', '0', '1', hex_plus  , hex_two  , hex_plus , hex_one  , hex_plus , hex_zero ), -- 26

 --    LOGIC ---------------------------------------------------------------------------------------------------------------------
      ("AND  1", '0', OP_AND , "1100", "0101", '0', '0', '0', '0', hex_off   , hex_c    , hex_off  , hex_five , hex_off  , hex_four ), -- 
      ("AND  2", '0', OP_AND , "1100", "0011", '0', '0', '0', '1', hex_off   , hex_c    , hex_off  , hex_three, hex_off  , hex_zero ), -- 
      ("OR    ", '0', OP_OR  , "1100", "0101", '0', '0', '0', '0', hex_off   , hex_c    , hex_off  , hex_five , hex_off  , hex_d    ), -- 
      ("XOR   ", '0', OP_XOR , "1100", "0101", '0', '0', '0', '0', hex_off   , hex_c    , hex_off  , hex_five , hex_off  , hex_nine ), -- 
      ("NOTA  ", '0', OP_NOTA, "1100", "0000", '0', '0', '0', '0', hex_off   , hex_c    , hex_off  , hex_zero , hex_off  , hex_three), -- 
      ("SHLA 1", '0', OP_SHLA, "0001", "0000", '0', '0', '0', '0', hex_off   , hex_one  , hex_off  , hex_zero , hex_off  , hex_two  ), -- 
      ("SHLA 2", '0', OP_SHLA, "1000", "0000", '0', '0', '0', '0', hex_off   , hex_eight, hex_off  , hex_zero , hex_off  , hex_zero ), -- 
      ("ROLA 1", '0', OP_ROLA, "0001", "0000", '0', '0', '0', '0', hex_off   , hex_one  , hex_off  , hex_zero , hex_off  , hex_two  ), -- 
      ("ROLA 2", '0', OP_ROLA, "1000", "0000", '0', '0', '0', '0', hex_off   , hex_eight, hex_off  , hex_zero , hex_off  , hex_one  ), -- 
      ("SHRA 1", '0', OP_SHRA, "0100", "0000", '0', '0', '0', '0', hex_off   , hex_four , hex_off  , hex_zero , hex_off  , hex_two  ), -- 
      ("SHRA 2", '0', OP_SHRA, "0001", "0000", '0', '0', '0', '0', hex_off   , hex_one  , hex_off  , hex_zero , hex_off  , hex_zero ), -- 
      ("RORA 1", '0', OP_RORA, "0100", "0000", '0', '0', '0', '0', hex_off   , hex_four , hex_off  , hex_zero , hex_off  , hex_two  ), -- 
      ("RORA 2", '0', OP_RORA, "0001", "0000", '0', '0', '0', '0', hex_off   , hex_one  , hex_off  , hex_zero , hex_off  , hex_eight)  -- 
   );
   
   -- component (DUT)
   COMPONENT alu
      PORT (
         SW   : IN  STD_LOGIC_VECTOR(0 TO 9);
         KEY  : IN  STD_LOGIC_VECTOR(0 TO 1);
         LEDR : BUFFER STD_LOGIC_VECTOR(0 TO 9);
         HEX0 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
         HEX1 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
         HEX2 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
         HEX3 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
         HEX4 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
         HEX5 : BUFFER STD_LOGIC_VECTOR(0 TO 7)
      );
   END COMPONENT;

BEGIN

   i1 : alu PORT MAP (
   -- list connections between master ports and signals
      SW   => SW,
      KEY  => KEY,
      LEDR => LEDR,
      HEX0 => HEX0,
      HEX1 => HEX1,
      HEX2 => HEX2,
      HEX3 => HEX3,
      HEX4 => HEX4,
      HEX5 => HEX5
   );

   -- Keys
   KEY(0) <= setOpCode;
   KEY(1) <= execOpCode;
   
   -- Switches
   -- Opcode to Switches / Operand A to Switches
   SW(4) <= operandA(0);
   SW(5) <= operandA(1);
   SW(6) <= operandA(2);
   SW(7) <= operandA(3);
   -- Operand B to Switches
   SW(0) <= operandB(0);
   SW(1) <= operandB(1);
   SW(2) <= operandB(2);
   SW(3) <= operandB(3);
   -- Signed mode
   SW(8) <= signedMode;
   SW(9) <= '0';
   
   -- LEDs
   --! displayFlags carrying the ALU status to leds
   ledFlags(CARRY_FLAG)     <= LEDR(3);
   ledFlags(SIGN_FLAG)      <= LEDR(2);
   ledFlags(OVER_FLOW_FLAG) <= LEDR(1);
   ledFlags(ZERO_FLAG)      <= LEDR(0);
   --! opCode carrying the active opcode to LEDs   
   ledOpcode(0) <= LEDR(4);
   ledOpcode(1) <= LEDR(5);
   ledOpcode(2) <= LEDR(6);
   ledOpcode(3) <= LEDR(7);

   --! \brief stimulus_generator
   --! - Generates all test cases. 
   --! - Writes header with student information and footer with summary to file.
   stimulus_generator: PROCESS 
   
      -- Header constants
      CONSTANT str1: STRING := "Students: ";
      CONSTANT str2: STRING := ", ";
      
      -- Footer constants
      CONSTANT res1: STRING := "Success = ";
      CONSTANT res2: STRING := " of ";
      
      VARIABLE current_line_out: line;
      
   BEGIN
      
      -- Write header of file
      write(current_line_out, str1);
      writeline(results_file, current_line_out);
      
      FOR j IN STUDENTS'range LOOP
         write(current_line_out, STUDENTS(j).student_name);
         write(current_line_out, str2);
         write(current_line_out, STUDENTS(j).student_number);
         writeline(results_file, current_line_out);
      END LOOP;
      
      write(current_line_out, strLine);
      writeline(results_file, current_line_out);
      
      -- Generate test cases
      FOR i IN TEMPLATE'range LOOP
         template_index <=i;
         
         -- set opcode to operandA with stimulus_opCode
         operandA <= TEMPLATE(i).stimulus_opCode;
         WAIT FOR MAX_DELAY;
         
         -- toggle setOpCode
         setOpCode <= '0';
         WAIT FOR MAX_DELAY;
         setOpCode <= '1';
         WAIT FOR MAX_DELAY;
         setOpCode <= '0';
         WAIT FOR MAX_DELAY;
         
         -- set opcode to operandA with stimulus_operandA
         operandA <= TEMPLATE(i).stimulus_operandA;
         -- set opcode to operandB with stimulus_operandB
         operandB <= TEMPLATE(i).stimulus_operandB;
         
         -- set signed mode with stimulus_signed (Signed mode = true)
         signedMode <= TEMPLATE(i).stimulus_signed;
         WAIT FOR MAX_DELAY;
         
         -- toggle execOpCode
         execOpCode <= '0';
         WAIT FOR MAX_DELAY;
         execOpCode <= '1';
         WAIT FOR MAX_DELAY;
         execOpCode <= '0';
         WAIT FOR MAX_DELAY;
         
         tests <= i;
         WAIT FOR TEST_PERIOD;
      END LOOP;
      
      
      -- Evaluate results: print to console and write footer.
      IF (errors = 0) THEN
         REPORT "End of simulation. No erros found.";
      ELSE
         REPORT "Errors = "& to_string(errors);
         
         write(current_line_out, strLine);
         writeline(results_file, current_line_out);
      END IF;
      
      write(current_line_out, res1);
      write(current_line_out, tests - errors);
      write(current_line_out, res2);
      write(current_line_out, tests);
      writeline(results_file, current_line_out);
      
      file_close(results_file);

      WAIT;
      
   END PROCESS; -- stimulus_generator


   --! \brief Evaluate test case results and print to file.
   responce_analyzer_reporter: PROCESS 
   
      CONSTANT str1: STRING := " Error = ";
      CONSTANT str2: STRING := " value = ";
      CONSTANT str3: STRING := " expected value = ";

      VARIABLE current_line_out: line;
      
   BEGIN
   
      WAIT ON template_index'transaction;
      WAIT FOR TEST_PERIOD;
      
      -- compare HEX5 with responce_HEX5 (operand A sign)
      IF ( HEX5 /= template(template_index).responce_HEX5 ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", HEX5 failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, HEX5);
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_HEX5);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare HEX4 with responce_HEX4 (Operand A)
      IF ( HEX4 /= template(template_index).responce_HEX4 ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", HEX4 failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, HEX4);
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_HEX4);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare HEX3 with responce_HEX3 (operand B sign)
      IF ( HEX3 /= template(template_index).responce_HEX3 ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", HEX3 failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, HEX3);
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_HEX3);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare HEX2 with responce_HEX2 (Operand B))
      IF ( HEX2 /= template(template_index).responce_HEX2 ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", HEX2 failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, HEX2);
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_HEX2);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare HEX1 with responce_HEX1 (Result sign)
      IF ( HEX1 /= template(template_index).responce_HEX1 ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", HEX1 failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, HEX1);
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_HEX1);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare HEX0 with responce_HEX0 (Result)
      IF ( HEX0 /= template(template_index).responce_HEX0 ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", HEX0 failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, HEX0);
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_HEX0);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare ledOpcode with stimulus_opCode
      IF ( ledOpcode /= template(template_index).stimulus_opCode ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", LED opcode failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, ledOpcode);
         write(current_line_out, str3);
         write(current_line_out, template(template_index).stimulus_opCode);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare ledFlags(CARRY_FLAG) with responce_flag_carry:   
      IF ( ledFlags(CARRY_FLAG) /= template(template_index).responce_flag_carry ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", Carry-flag failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, ledFlags(CARRY_FLAG));
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_flag_carry);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare ledFlags(SIGN_FLAG) with responce_flag_sign:    
      IF ( ledFlags(SIGN_FLAG) /= template(template_index).responce_flag_sign ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", Sign-flag failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, ledFlags(SIGN_FLAG));
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_flag_sign);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare ledFlags(OVER_FLOW_FLAG) with responce_flag_overflow:
      IF ( ledFlags(OVER_FLOW_FLAG) /= template(template_index).responce_flag_overflow ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", Overflow-flag failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, ledFlags(OVER_FLOW_FLAG));
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_flag_overflow);
         writeline(results_file, current_line_out);
      END IF;
      
      -- compare ledFlags(ZERO_FLAG) with responce_flag_zero:    
      IF ( ledFlags(ZERO_FLAG)  /= template(template_index).responce_flag_zero ) then
         REPORT "Error at test index " & to_string(template_index) & ". "& template(template_index).case_opCode & ", Zero-flag failed. ";
         errors <= errors + 1;
         
         write(current_line_out, template(template_index).case_opCode);
         write(current_line_out, str1);
         write(current_line_out, errors + 1);
         write(current_line_out, str2);
         write(current_line_out, ledFlags(ZERO_FLAG) );
         write(current_line_out, str3);
         write(current_line_out, template(template_index).responce_flag_zero);
         writeline(results_file, current_line_out);
      END IF;

   END PROCESS ; -- responce_analyzer_reporter
   
END alu_arch;
