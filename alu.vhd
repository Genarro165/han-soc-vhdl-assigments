--------------------------------------------------------------------
--! \file      alu.vhd
--! \date      see top of 'Version History'
--! \brief     ALU assignment for HAN H-EHE-SOC class
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! Version History:
--! ----------------
--!
--! Nr:    |Date:      |Author: |Remarks:
--! -------|-----------|--------|-----------------------------------
--! 101    |25-11-2020 |WLGRW   |Inital version building upon version 002 for H-EHE-SOC class
--! 102    |26-10-2021 |WLGRW   |Added ENTITY to instatiation for compatibilty reasons in ModelSim
--! 103    |04010-2021 |WLGRW   |Added ENTITY to instatiation for compatibilty reasons in ModelSim
--!
--! # Layout DE10-Lite
--!
--! \verbatim
--!                                                  +--+
--!      DE10-Lite KEY, SW, LED, and HEX layout      |##| <= KEY0
--!                                                  +--+
--!                                                  |##| <= KEY1
--!                                                  +--+
--!
--!                                  9 8 7 6 5 4 3 2 1 0  <- Number
--!                                 +-+-+-+-+-+-+-+-+-+-+
--!    7-segment hexDisplays (HEX)  | | | | | | | | | | | <= Leds (LEDR)
--!      +---+---+---+---+---+---+  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |   |   |                     
--!      |   |   |   |   |   |   |  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |   |   |  | | | | | | | | | | |
--!      |   |   |   |   |   |   |  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |   |   |  |#|#|#|#|#|#|#|#|#|#| <= Switch (SW)
--!      +---+---+---+---+---+---+  +-+-+-+-+-+-+-+-+-+-+
--!        5   4   3   2   1   0     9 8 7 6 5 4 3 2 1 0  <- Number
--!
--! \endverbatim
--!
--!
--!
--! \verbatim
--!                                  9 8 7 6 5 4 3 2 1 0  <- Number
--!                                 +-+-+-+-+-+-+-+-+-+-+
--!                                 | | | | | | | | | | | <= Leds (LEDR)
--!                                 +-+-+-+-+-+-+-+-+-+-+
--!                                              ^ ^ ^ ^
--!                                              | | | +- Zero
--!                                              | | +--- Overflow
--!                                              | +----- Signed
--!                                              +------- Carry
--! \endverbatim
--!
--!
--!


--------------------------------------------------------------------
LIBRARY ieee;                      -- this lib needed for STD_LOGIC
USE ieee.std_logic_1164.all;       -- the package with this info
USE ieee.numeric_std.all;          -- UNSIGNED
--------------------------------------------------------------------
ENTITY alu is

   GENERIC (
      N: INTEGER := 4;   --! Width of the databus

      OPCODE_KEY:  INTEGER := 0; --! Function of KEY0 
      EXECUTE_KEY: INTEGER := 1  --! Function of KEY1
   );
   
   PORT( 
      SW   : IN  STD_LOGIC_VECTOR(0 TO 9);  --! SWitches on DE10-Lite board
      KEY  : IN  STD_LOGIC_VECTOR(0 TO 1);  --! KEYs on DE10-Lite board
      LEDR : OUT STD_LOGIC_VECTOR(0 TO 9);  --! LEDs on DE10-Lite board
      HEX0,
      HEX1,
      HEX2,
      HEX3,
      HEX4,
      HEX5 : OUT STD_LOGIC_VECTOR(0 TO 7)   --! 7-segment displays HEX0..5 on DE10-Lite board
   );

END ENTITY alu;
--------------------------------------------------------------------
ARCHITECTURE implementation OF alu IS
   
   SIGNAL hexSignal0, --! signals hexSignalX are used to reverse MSB-LSB and interconnect to HEX displays.
          hexSignal1,
          hexSignal2,
          hexSignal3,
          hexSignal4,
          hexSignal5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
   
   SIGNAL dotSignal0, --! Signals dotSignalX are used to connect the dot on the decoder.
          dotSignal1,
          dotSignal2,
          dotSignal3,
          dotSignal4,
          dotSignal5 : STD_LOGIC;
   
   SIGNAL control0,
          control1,
          control2,
          control3,
          control4,
          control5 : STD_LOGIC;
   
   SIGNAL opCode,          --! Opcode
          operandA,        --! Operand A
          operandB,        --! Operand B
          displayFlags,
          operationResult, --! ALU result out
          flagResult,      --! ALU flags out 
          displayResult    --! result buffered for display
                        : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

   SIGNAL signedMode: STD_LOGIC; --! Operation is SIGNED '1' or unsigned '0' mode

BEGIN

--! Map all components
--! ==================

--! Registers:

   --! Function register "FUNC-REG" use KEY0 as clk
   functionRegister : ENTITY work.nBitBuffer PORT MAP ( 
      operandA, 
      NOT KEY(OPCODE_KEY), 
      opCode 
   );
   
   --! First part of Output register "OUT-REG" use KEY1 as clk
   resultRegister : ENTITY work.nBitBuffer PORT MAP (
      operationResult, 
      NOT KEY(EXECUTE_KEY), 
      displayResult
   );
   
   --! Second part of Output register "OUT-REG" use KEY1 as clk
   flagRegister : ENTITY work.nBitBuffer PORT MAP (
      flagResult, 
      NOT KEY(EXECUTE_KEY), 
      displayFlags
   ); 

   --! 7-segment Displays:
   --! Here the HEX displays are immediately connected to the drivers
   hexDisplay0 : ENTITY work.sevenOut4Decoder PORT MAP ( hexSignal0, dotSignal0, control0, HEX0 ); --! 7-segment decoder 0
   hexDisplay1 : ENTITY work.sevenOut4Decoder PORT MAP ( hexSignal1, dotSignal1, control1, HEX1 ); --! 7-segment decoder 1
   hexDisplay2 : ENTITY work.sevenOut4Decoder PORT MAP ( hexSignal2, dotSignal2, control2, HEX2 ); --! 7-segment decoder 2
   hexDisplay3 : ENTITY work.sevenOut4Decoder PORT MAP ( hexSignal3, dotSignal3, control3, HEX3 ); --! 7-segment decoder 3
   hexDisplay4 : ENTITY work.sevenOut4Decoder PORT MAP ( hexSignal4, dotSignal4, control4, HEX4 ); --! 7-segment decoder 4
   hexDisplay5 : ENTITY work.sevenOut4Decoder PORT MAP ( hexSignal5, dotSignal5, control5, HEX5 ); --! 7-segment decoder 5
   
   --! ALU
   aluOperation: ENTITY work.alu_operation PORT MAP (
      operandA,
      operandB,
      displayFlags,
      opCode,
      signedMode,
      operationResult,
      flagResult
   );

   --! Display drivers
   displayDriverResult : ENTITY work.operandResultInterpreter PORT MAP (
      opCode,       --! opcode:     4-bit opcode
      displayResult,--! res:        4-bit binary input carrying Result
      signedMode,   --! sign_ops:   Sign operation
      hexSignal0,   --! hexSignal0: HEX0
      hexSignal1,   --! hexSignal1: HEX1
      dotSignal0,   --! dotSignal0: dot at HEX0
      control0,     --! control0:   Select control operation of HEX0,
      dotSignal1,   --! dotSignal1: dot at HEX1
      control1      --! control1 :  Select control operation of HEX1
   );

   displayDriverOperandA : ENTITY work.operandResultInterpreter PORT MAP (
      opCode,       --! opcode:     4-bit opcode
      operandA,     --! res:        4-bit binary input carrying Operand A
      signedMode,   --! sign_ops:   Sign operation
      hexSignal4,   --! hexSignal1: HEX4
      hexSignal5,   --! hexSignal1: HEX5
      dotSignal4,   --! dotSignal0: dot at HEX4
      control4,     --! control0:   Select control operation of HEX4,
      dotSignal5,   --! dotSignal1: dot at HEX5
      control5      --! control1 :  Select control operation of HEX5
   );
   
   displayDriverOperandB : ENTITY work.operandResultInterpreter PORT MAP (
      opCode,       --! opcode:     4-bit opcode
      operandB,     --! res:        4-bit binary input carrying operand B
      signedMode,   --! sign_ops:   Sign operation
      hexSignal2,   --! hexSignal0: HEX2
      hexSignal3,   --! hexSignal1: HEX3
      dotSignal2,   --! dotSignal0: dot at HEX2
      control2,     --! control0:   Select control operation of HEX2,
      dotSignal3,   --! dotSignal1: dot at HEX3
      control3      --! control1 :  Select control operation of HEX3
   );

   --! User interface: Switches, LEDs and Displays
   --! ===========================================

   --! Switches Operand B to operand B
   operandB(0) <= SW(0);
   operandB(1) <= SW(1);
   operandB(2) <= SW(2);
   operandB(3) <= SW(3);
   
   --! Switches Operand A/Opcode to operand  A
   operandA(0) <= SW(4);
   operandA(1) <= SW(5);
   operandA(2) <= SW(6);
   operandA(3) <= SW(7);

   --! displayFlags carrying the ALU status to leds
   LEDR(3) <= displayFlags(0);
   LEDR(2) <= displayFlags(1);
   LEDR(1) <= displayFlags(2);
   LEDR(0) <= displayFlags(3);

   --! opCode carrying the active opcode to LEDs   
   LEDR(4) <= opCode(0);
   LEDR(5) <= opCode(1);
   LEDR(6) <= opCode(2);
   LEDR(7) <= opCode(3);
   
   --! Switch 8 setting SIGNED/UNSIGNED mode to LED 8   
   signedMode <= SW(8);
   LEDR(8) <= signedMode;
   
--   LEDR(8) <= '0';
   LEDR(9) <= '0';

END ARCHITECTURE implementation;
--------------------------------------------------------------------
