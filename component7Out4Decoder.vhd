--------------------------------------------------------------------
--! \file      component7Out4Decoder.vhd
--! \date      see top of 'Version History'
--! \brief     Exercises week 2 
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students that submit this code have to complete their details:
--!
--! -Student 1 name         : 
--! -Student 1 studentnumber: 
--! -Student 1 email address: 
--!
--! -Student 2 name         : 
--! -Student 2 studentnumber: 
--! -Student 2 email address: 
--!
--! Version History:
--! ----------------
--!
--! Nr: |Date:      |Author: |Remarks:
--! ----|-----------|--------|-----------------------------------
--! 001 |17-10-2019 |WLGRW   |Inital version
--! 006 |11-1-2021  |WLGRW   |Added control signals for updated driver.
--! 
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
--!       7-segment displays (HEX)  | | | | | | | | | | | <= Leds (LEDR)
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
--! Function 1:
--! -----------
--! With this function Switches 0 to 3 (A) and 4 to 7 (B) are 
--! used as input and are connected to HEX0 and HEX1. See figure 1.
--! Switch 9 will toggle the dot of both HEX dipslays.
--!
--! \verbatim
--!  
--!  Figure 1: GUI for function 1 on DE10-Lite
--!                               
--!       7-segment displays (HEX)
--!      +---+---+---+---+---+---+
--!      |   |   |   |   |YYY|XXX|
--!      |   |   |   |   |YYY|XXX|  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |YYY|XXX|  | | | | | | | | | | |
--!      |   |   |   |   |YYY|XXX|  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |YYY|XXX|  |D|C|B|B|B|B|A|A|A|A| <= Switch (SW)
--!      +---+---+---+---+---+---+  +-+-+-+-+-+-+-+-+-+-+
--!                        1   0     9 8 7 6 5 4 3 2 1 0  <- Number
--!  A = input for HEX0
--!  B = input for HEX1
--!  C = input to swith to extended characters for HEX1
--!  D = input to toggle dot on displays HEX0 and HEX1.
--!  X = 7-segment display HEX0
--!  Y = 7-segment display HEX1
--!
--! \endverbatim
--!
--! Design:
--! -------
--! Figure 2 shows in a graphical way how the vectors are connected.
--!
--! Switches are defined as a STD_LOGIC_VECTOR 0 TO 9. 4 bits of the 
--! 9-bit vector are reversed (LSB <> MSB) using a SIGNAL STD_LOGIC_VECTOR 3 DOWNTO 0
--! because the 7 out of 4 decoder requires 3 DOWNTO 0 order of the vector.
--! This is repeated for both displays.
--!
--! The switch for the dot is aplied to dot on HEX0 and inverted to dot on HEX1.
--!
--! \verbatim
--!
--!  Figure 2: Architecture of the display driver.
--!
--! INPUT  SW  Reverse MSB-LSB   7out4dec             HEX
--!
--!                                                   +-+
--!        +-+     |\   /|       +---------+          |0|
--!        |0|   4 | \ / |    4  | 7 out   |          |1|
--! Binary |1|--/--|  X  |----/--|  of 4   |   6      |2|
--! data   |2|     | / \ |       | decoder |--/-------|3|
--!        |3|     |/   \|       |         |          |5|
--!        +-+                   +---------+      +---|6|
--! Dot----|9|------------------------------------+   +-+
--!        +-+                                    |   +-+
--!        +-+     |\   /|       +---------+     NOT  |0|
--!        |4|   4 | \ / |    4  | 7 out   |      |   |1|
--! Binary |5|--/--|  X  |----/--|  of 4   |   6  |   |2|
--! data   |6|     | / \ |       | decoder |--/-------|3|
--!        |7|     |/   \|     +-|         |      |   |5|
--!        +-+                 | +---------+      +---|6|
--! Ctrl---|8|-----------------+                      +-+
--!        +-+
--!
--! \endverbatim
--!
--------------------------------------------------------------------
LIBRARY ieee;                      -- this lib needed for STD_LOGIC
USE ieee.std_logic_1164.all;       -- the package with this info
--------------------------------------------------------------------

ENTITY component7Out4Decoder IS
   PORT (
      SW   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
      HEX0 : OUT STD_LOGIC_VECTOR(0 TO 7);
      HEX1 : OUT STD_LOGIC_VECTOR(0 TO 7)
   );
END component7Out4Decoder;

ARCHITECTURE rtl OF component7Out4Decoder IS

   -- cijfers
   CONSTANT C0 : STD_LOGIC_VECTOR(0 TO 6) := "0000001";
   CONSTANT C1 : STD_LOGIC_VECTOR(0 TO 6) := "1001111";
   CONSTANT C2 : STD_LOGIC_VECTOR(0 TO 6) := "0010010";
   CONSTANT C3 : STD_LOGIC_VECTOR(0 TO 6) := "0000110";
   CONSTANT C4 : STD_LOGIC_VECTOR(0 TO 6) := "1001100";
   CONSTANT C5 : STD_LOGIC_VECTOR(0 TO 6) := "0100100";
   CONSTANT C6 : STD_LOGIC_VECTOR(0 TO 6) := "0100000";
   CONSTANT C7 : STD_LOGIC_VECTOR(0 TO 6) := "0001111";
   CONSTANT C8 : STD_LOGIC_VECTOR(0 TO 6) := "0000000";
   CONSTANT C9 : STD_LOGIC_VECTOR(0 TO 6) := "0000100";

   -- extended
   CONSTANT CE : STD_LOGIC_VECTOR(0 TO 6) := "0110000"; -- E
   CONSTANT CS : STD_LOGIC_VECTOR(0 TO 6) := "0100100"; -- S
   CONSTANT CD : STD_LOGIC_VECTOR(0 TO 6) := "1111110"; -- -

   SIGNAL hex0_char     : STD_LOGIC_VECTOR(0 TO 6);
   SIGNAL hex1_normal   : STD_LOGIC_VECTOR(0 TO 6);
   SIGNAL hex1_extended : STD_LOGIC_VECTOR(0 TO 6);

BEGIN
   ------------------------------------------------------------------
   -- DOT
   ------------------------------------------------------------------
   HEX0(7) <= NOT SW(9);
   HEX1(7) <= SW(9);

   ------------------------------------------------------------------
   -- HEX0: normaal (SW3..0)
   ------------------------------------------------------------------
   WITH SW(3 DOWNTO 0) SELECT
      hex0_char <=
         C0 WHEN "0000",
         C1 WHEN "0001",
         C2 WHEN "0010",
         C3 WHEN "0011",
         C4 WHEN "0100",
         C5 WHEN "0101",
         C6 WHEN "0110",
         C7 WHEN "0111",
         C8 WHEN "1000",
         C9 WHEN "1001",
         C0 WHEN OTHERS;

   HEX0(0 TO 6) <= hex0_char;

   ------------------------------------------------------------------
   -- HEX1 normaal (SW7..4)
   ------------------------------------------------------------------
   WITH SW(7 DOWNTO 4) SELECT
      hex1_normal <=
         C0 WHEN "0000",
         C1 WHEN "0001",
         C2 WHEN "0010",
         C3 WHEN "0011",
         C4 WHEN "0100",
         C5 WHEN "0101",
         C6 WHEN "0110",
         C7 WHEN "0111",
         C8 WHEN "1000",
         C9 WHEN "1001",
         C0 WHEN OTHERS;

   ------------------------------------------------------------------
   -- HEX1 extended (SW7..4)
   ------------------------------------------------------------------
   WITH SW(7 DOWNTO 4) SELECT
      hex1_extended <=
         CE WHEN "0000", -- E
         CS WHEN "0001", -- S
         CD WHEN "0010", -- -
         C1 WHEN "0011", -- 1
         C0 WHEN OTHERS;

   ------------------------------------------------------------------
   -- ctrl kiest normaal / extended voor HEX1
   ------------------------------------------------------------------
   WITH SW(8) SELECT
      HEX1(0 TO 6) <= hex1_normal   WHEN '0',
                      hex1_extended WHEN '1';

END rtl;
