------------------------------------------------------------------------------
--! \file      logicUnit.vhd
--! \date      see top of 'Version History'
--! \brief     n-bit logic unit
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 3
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------------
ENTITY logicUnit is

   GENERIC (
      N: INTEGER := 4   --! logic unit is designed for 4-bits
   );
   
   PORT (
      A : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! n-bit binary input
      B : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! n-bit binary input
      F : IN  STD_LOGIC_VECTOR (2   DOWNTO 0); --! 3-bit opcode
      R : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)  --! n-bit binary output
   );
   
END ENTITY logicUnit;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF logicUnit IS
BEGIN

--  #########################################################################
--  #########################################################################
--  ##                                                                     ##
--  ##                                                                     ##
--  ##  This file shall be replaced by the file produced in assignment 3   ##
--  ##                                                                     ##
--  ##                                                                     ##
--  #########################################################################
--  #########################################################################

END ARCHITECTURE implementation;
