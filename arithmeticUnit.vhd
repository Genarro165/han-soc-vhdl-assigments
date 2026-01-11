--------------------------------------------------------------------
--! \file      arithmeticUnit.vhd
--! \date      see top of 'Version History'
--! \brief     n-bit arithmetic unit
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 3
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  --! STD_LOGIC
USE ieee.numeric_std.all;     --! SIGNED
------------------------------------------------------------------------------
ENTITY arithmeticUnit is

   GENERIC (
      N: INTEGER := 4  --! logic unit is designed for 4-bits
   );
   
   PORT (
      A : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
      B : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
      P : IN  STD_LOGIC_VECTOR (3   DOWNTO 0);
      F : IN  STD_LOGIC_VECTOR (2   DOWNTO 0);
      R : OUT STD_LOGIC_VECTOR (N   DOWNTO 0) 
   );
   
END ENTITY arithmeticUnit;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF arithmeticUnit IS
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
