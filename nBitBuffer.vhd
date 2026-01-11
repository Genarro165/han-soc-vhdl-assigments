------------------------------------------------------------------------------
--! \file      nBitBuffer.vhd
--! \date      See top of 'Version History'
--! \brief     D-H-EHE-SOC assignment-1
--!            Place holder for n-bit buffer (D-FLIP-FLOP) 
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 1
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------------
ENTITY nBitBuffer is

   GENERIC (
      N: INTEGER := 4
   );
   
   PORT (
      input  : IN     STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! n-bit binary input
      clk    : IN     STD_LOGIC;                       --! trigger to initiate latch function
      output : BUFFER STD_LOGIC_VECTOR (N-1 DOWNTO 0)  --! n-bit binary output
   );
   
END ENTITY nBitBuffer;
-----------------------------------------------------------------------------
ARCHITECTURE implementation OF nBitBuffer IS
BEGIN

--  #########################################################################
--  #########################################################################
--  ##                                                                     ##
--  ##                                                                     ##
--  ##  This file shall be replaced by the file produced in assignment 1   ##
--  ##                                                                     ##
--  ##                                                                     ##
--  #########################################################################
--  #########################################################################

END ARCHITECTURE implementation;
-----------------------------------------------------------------------------