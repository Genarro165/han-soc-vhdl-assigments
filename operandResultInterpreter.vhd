--------------------------------------------------------------------
--! \file      operandResultInterpreter.vhd
--! \date      see top of 'Version History'
--! \brief     Interpreter of operand and result with carry and opcode
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 4
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  --! STD_LOGIC
USE ieee.numeric_std.all;     --! SIGNED
------------------------------------------------------------------------------
ENTITY operandResultInterpreter is

   PORT (
      opcode :           IN   STD_LOGIC_VECTOR(3 DOWNTO 0); --! 4-bit opcode
      result :           IN   STD_LOGIC_VECTOR(3 DOWNTO 0); --! n-bit binary input carrying Result
      signed_operation : IN   STD_LOGIC;
      hexSignal0,
      hexSignal1 :       OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dotSignal0,
      control0,
      dotSignal1,
      control1 :         OUT  STD_LOGIC
   );
   
END ENTITY operandResultInterpreter;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF operandResultInterpreter IS
BEGIN

--  #########################################################################
--  #########################################################################
--  ##                                                                     ##
--  ##                                                                     ##
--  ##  This file shall be replaced by the file produced in assignment 4   ##
--  ##                                                                     ##
--  ##                                                                     ##
--  #########################################################################
--  #########################################################################

END ARCHITECTURE implementation;
------------------------------------------------------------------------------
