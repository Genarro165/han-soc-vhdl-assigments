--------------------------------------------------------------------
--! \file      flagHandler.vhd
--! \date      see top of 'Version History'
--! \brief     Generate flags for ALU
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN AEA-ESE Arnhem 
--!
--! Version History:
--! ----------------
--!
--! Nr:    |Date:      |Author: |Remarks:
--! -------|-----------|--------|-----------------------------------
--! 001    |24-11-2020 |WLGRW   |Inital version
--! 002    |25-11-2020 |WLGRW   |Adapted version for H-EHE-SOC class
--! 003    |7-4-2021   |WLGRW   |Corrected Zero flag handling
--! 004    |1-12-2023  |WLGRW   |Updated code with source by Xinyu Tian (student)
--!
--! Map named signals to flag register for output flagResult consists of 4 flags:
--!  - Carry (C-flag)
--!  - Sign (S-flag)
--!  - oVerflow (V-flag)
--!  - Zero (Z-Flag)
--! flagResult has the bit sequence CSVZ (C = MSB).
--!
--! Opcodes
--! -------
--!
--!   Bin  | Opcode  | Functionality/Operation
--!   -----|---------|--------------------------------------------------------------------------------------
--!   0000 | OP_CLRR | CLR R, clear R (R:=0), all flag bits are affected
--!   0001 | OP_INCA | INC A, Increment A, R:=A+1, all flag bits are affected 
--!   0010 | OP_DECA | DEC A, Decrement A, R:=A-1, all flag bits are affected
--!   0011 | OP_ADD  | ADD A with B, R:=A+B, all flag bits are affected
--!   0100 | OP_ADC  | ADC A with B and Carry, R:=A+B+C, all flag bits are affected
--!   0101 | OP_ADB  | ADB A with B and Carry, R:=A+B+C using BCD arithmetic, C and Z flag bits are affected
--!   0110 | OP_SUB  | SUB B from A, R:=A-B, flag bits are affected
--!   0111 | OP_SBC  | SBC B from A including C, R:=A-B-C, flag bits are affected
--!   1000 | OP_AND  | AND A with B, R:=A AND B, bitwise AND, Z-flag bit is affected
--!   1001 | OP_OR   | OR A with B, R:=A OR B, bitwise OR, Z-flag bit is affected
--!   1010 | OP_XOR  | XOR A with B, R:=A XOR B, bitwise XOR, Z-flag bit is affected
--!   1011 | OP_NOTA | NOT A, R:=NOT A, Z-flag bit is affected
--!   1100 | OP_SHLA | SHL A, R:=SHL A, flag bits are not affected
--!   1101 | OP_ROLA | ROL A, R:=ROL A, flag bits are not affected
--!   1110 | OP_SHRA | SHR A, R:=SHR A, flag bits are not affected
--!   1111 | OP_RORA | ROR A, R:=ROR A, flag bits are not affected
--!
--! \todo correct flag handler. 
--! \todo add documentation: https://vhdlwhiz.com/how-to-check-if-a-vector-is-all-zeros-or-ones/
--! \todo Decide on how to treat carry and overflow in this ALU. https://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt

--   Carry indicates the result isn't mathematically correct when interpreted as unsigned, 
--   overflow indicates the result isn't mathematically correct when interpreted as signed.

--  #########################################################################
--  #########################################################################
--  ##                                                                     ##
--  ##                                                                     ##
--  ## The flag-handler is delivered as is and is not part of assignments  ##
--  ##                                                                     ##
--  ##      No modification or adaptations by students are required        ##
--  ##                                                                     ##
--  #########################################################################
--  #########################################################################

------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  -- STD_LOGIC
USE ieee.numeric_std.all;     -- SIGNED
------------------------------------------------------------------------------
ENTITY flagHandler is

   GENERIC (
      CARRY_FLAG:     INTEGER := 0; 
      SIGN_FLAG:      INTEGER := 1;
      OVER_FLOW_FLAG: INTEGER := 2;
      ZERO_FLAG:      INTEGER := 3;
      
      CONSTANT OP_CLRR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
      CONSTANT OP_INCA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
      CONSTANT OP_DECA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
      CONSTANT OP_ADD  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
      CONSTANT OP_ADC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
      CONSTANT OP_ADB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
      CONSTANT OP_SBC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
      CONSTANT OP_SUB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110"
   );
   
   PORT (
      signedOperation :  IN STD_LOGIC;
      operandA,
      operandB,
      opcode,                                              --! 4-bit opcode
      flagStatus,
      logicResult :      IN  STD_LOGIC_VECTOR(3 DOWNTO 0); --! n-bit binary input carrying Result
      arithmeticresult : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      flagResult :       OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
   );
   
END ENTITY flagHandler;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF flagHandler IS

   SIGNAL carryFlag,                    --! carry flag
          signFlag,                     --! Sign flag
          oVerflowFlag,                 --! overflow flag
          zeroFlag : STD_LOGIC := '0';  --! zero flag

   SIGNAL oVerflowFlag_signed,
          oVerflowFlag_unsigned : STD_LOGIC;

BEGIN

   flagResult(CARRY_FLAG)     <= carryFlag;
   flagResult(SIGN_FLAG)      <= signFlag;
   flagResult(OVER_FLOW_FLAG) <= oVerflowFlag;
   flagResult(ZERO_FLAG)      <= zeroFlag; 

--! FLAG handling
   
   --! Transport carry from arithmetic result to carry flag.
   carryFlag <= arithmeticresult(4) WHEN opcode(3)='0' ELSE  --! carry is MSB of the result (Not sure about this, should handly differently for signed and unsigned?)
                flagStatus(CARRY_FLAG);                      --! when flags not influenced, copy the status from the input

   --! 
   signFlag <= signedOperation;
   
   --!
   oVerflowFlag_unsigned <= arithmeticresult(4);  --! For unsigned arithmetic operations, overflowFlag is the same of carryFlag
                            
   oVerflowFlag_signed <=  '1' WHEN (opcode = OP_INCA AND operandA(3) = '0' AND arithmeticresult(3)= '1') OR
                                    (opcode = OP_DECA AND operandA(3) = '1' AND arithmeticresult(3)= '0')                                            ELSE --! for increment 7 and decriment -8 overflow
                           '1' WHEN (opcode = OP_ADD OR opcode = OP_ADC) AND operandA(3) = operandB(3) AND arithmeticresult(3) = NOT operandA(3)     ELSE --! for ADD and ADC
                           '1' WHEN (opcode = OP_SUB OR opcode = OP_SBC) AND operandA(3) = NOT operandB(3) AND arithmeticresult(3) = NOT operandA(3) ELSE --! for SUB and SBC
                           '1' WHEN (opcode = OP_ADB AND arithmeticresult(4) = '1')                                                                  ELSE --! for ADB, only 4-bit unsigned number considered
                           '0';                                                  
   
   --!
   oVerflowFlag <=   oVerflowFlag_unsigned WHEN signedOperation = '0' AND opcode(3) = '0' ELSE  --! For unsigned arithmetic operation              
                     oVerflowFlag_signed   WHEN signedOperation = '1' AND opcode(3) = '0' ELSE  --! For signed arithmetic operation
                     flagStatus(OVER_FLOW_FLAG);                                                --! For logic operation, flags not influenced, copy the status from the input
   
   --!
   zeroFlag <= '0' WHEN (opcode(3) = '1')                                      ELSE --! Switch off zeroFlag when using logic functions
               '1' WHEN (opcode(3) = '0') AND (arithmeticresult = "00000")     ELSE --! Arthmic operation result is 0 and no carry
               '1' WHEN (opcode(3) = '0') AND (arithmeticresult = "10000")     ELSE --! Arthmic operation result is 0 with carry
               '0' WHEN (opcode(3) = '0')                                      ELSE
               '1' WHEN (opcode(3 DOWNTO 2) = "10") AND (logicResult = "0000") ELSE --! Logic operation result is 0
               '0' WHEN (opcode(3 DOWNTO 2) = "10")                            ELSE
               flagStatus(ZERO_FLAG);                                               --! when flags not influenced, copy the status from the input
               

END ARCHITECTURE implementation;
------------------------------------------------------------------------------