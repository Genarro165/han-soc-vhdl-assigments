------------------------------------------------------------------------------
--! \file      lsevenOut4Decoder.vhd
--! \date      see top of 'Version History'
--! \brief     Placegolder for 7 segment decoder with dot-driver and extended characters
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 2
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------------
ENTITY sevenOut4Decoder is

   PORT (
      input   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dot     : IN  STD_LOGIC;                   
      ctrl    : IN  STD_LOGIC;                   
      display : OUT STD_LOGIC_VECTOR(0 TO 7)     
   );
   
END ENTITY sevenOut4Decoder;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF sevenOut4Decoder IS
BEGIN

--  #########################################################################
--  #########################################################################
--  ##                                                                     ##
--  ##                                                                     ##
--  ##  This file shall be replaced by the file produced in assignment 2   ##
--  ##                                                                     ##
--  ##                                                                     ##
--  #########################################################################
--  #########################################################################


END ARCHITECTURE implementation;
------------------------------------------------------------------------------
