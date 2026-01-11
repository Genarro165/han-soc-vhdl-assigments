--------------------------------------------------------------------
--! \file      alu_operation.vhd
--! \date      see top of 'Version History'
--! \brief     Component to contain logic- and arthmetic unit and flaghandler of ALU
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! Version History
--! ---------------
--!
--! Nr:    |Date:      |Author: |Remarks:
--! -------|-----------|--------|-----------------------------------
--! 001    |25-11-2020 |WLGRW   |Inital version
--! 002    |10-12-2020 |WLGRW   |Added documentation
--! 003    |6-4-2021   |WLGRW   |Corrected figure 1.
--!
--! Function:
--! -----------
--! The ALU-operation component combines the Arithmetic- and logic-unit in to 
--! the ALU unit and adds flag- and SIGNED operation handling.
--! 
--! The ALU-operation component is build using structured VHDL.
--!
--! To make the ALU-operation component work, replace the following 
--! files which ware completed at assignment 3:
--!  - logicUnit.vhd
--!  - arithmeticUnit.vhd.
--!
--! The flaghandler is implemented already, but not completely.
--! The student is free to enhance it and verify operation.
--! This is not mandatory.
--!
--! Design:
--! -------
--! Figure 1 presents the component diagram of the ALU-operation component.
--! 
--! \verbatim
--!
--!  Figure 1: Input-output diagram of ALU-operation component.
--! 
--!                              ##################
--!                          n   #                #
--!  Operand A ----------+---/---#                #
--!                      |       #                #
--!                      |   n   #                #
--!  Operand B -------+--|---/---#                #
--!                   |  |       # Arthmetic unit #   n+1
--!                   |  |   3   #                #---/------+
--!  Opcode F -----+--|--|---/---#                #          |
--!                |  |  |       #                #          |
--!                |  |  |   4   #                #          |    +----------+
--!  Flags P ---+--|--|--|---/---#                #          |    |  unit    |
--!             |  |  |  |       #                #          +----|          |
--!             |  |  |  |       ##################          |    | selector |   4
--!             |  +--|--|-----------------------------------|----|          |---/--- Result R
--!             |  |  |  |       ###########                 |    | (Imple-  |
--!             |  |  |  |   n   #         #              +--|----|  mented) |
--!             |  |  |  +---/---#         #              |  |    |          |
--!             |  |  |  |   n   #  logic  #   4          |  |    +----------+
--!             |  |  +--|---/---#         #---/----------+  |
--!             |  |  |  |   3   #  unit   #     Result   |  |
--!             |  +--|--|---/---#         #              |  |
--!             |  |  |  |       #         #              |  |
--!             |  |  |  |       ###########              |  |
--!             |  |  |  |                     n          |  |
--!             |  |  |  |  +------------------/----------+  |
--!             |  |  |  |  |                                |
--!             |  |  |  |  |                  n             |
--!             |  |  |  |  |  +---------------/-------------+
--!             |  |  |  |  |  |
--!             |  |  |  |  |  | +----------------+
--!             |  |  |  |  |  | |                |
--!             |  |  |  |  |  +-|                |
--!             |  |  |  |  |    |                |
--!             |  |  |  |  |    |                |
--!             |  |  |  |  +----|                |
--!             |  |  |  |       |                |
--!             |  |  |  |   n   |     Flag-      |
--!             |  |  |  +---/---|                |
--!             |  |  |          |     handler    |
--!             |  |  |      n   |                |
--!             |  |  +------/---|                |
--!             |  |             |                |                           4
--!             |  |         3   |                |---------------------------/--- Flags
--!             |  +---------/---|  (Implemented) |
--!             |                |                |
--!             |            4   |                |
--!             +------------/---|                |
--!                              |                |  
--!  Signed operation -----------|                |  
--!                              |                |  
--!                              +----------------+  
--! \endverbatim
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  --! STD_LOGIC
USE ieee.numeric_std.all;     --! SIGNED
library WORK;
USE WORK.all;
------------------------------------------------------------------------------
ENTITY alu_operation is

   GENERIC (
      N: INTEGER := 4 --! Width of the data bus.
   );
   
   PORT (
      A : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! Operand A n-bit binary input
      B : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! Operand B n-bit binary input
      P : IN  STD_LOGIC_VECTOR (3   DOWNTO 0); --! Flags input P(0)=Carry-bit
      F : IN  STD_LOGIC_VECTOR (3   DOWNTO 0); --! 4-bit opcode
      O : IN  STD_LOGIC;                       --! indicates signed operation
      R : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! Result n-bit binary output
      S : OUT STD_LOGIC_VECTOR (3   DOWNTO 0)  --! Flag output as result of operation.
   );
   
END ENTITY alu_operation;
------------------------------------------------------------------------------
ARCHITECTURE alu_operation OF alu_operation IS

   SIGNAL arithmeticResultWithCarry : STD_LOGIC_VECTOR(N   DOWNTO 0); --! Result from Arithmetic unit with carry.
   SIGNAL logicResult,                                                --! result of logic unit.
          arithmeticResult          : STD_LOGIC_VECTOR(N-1 DOWNTO 0); --! Result from Arithmetic unit without carry.
   SIGNAL operation                 : STD_LOGIC_VECTOR(2   DOWNTO 0); --| Function without logic or arthmetic selection

BEGIN

   --! strip logic or arithmetic operation selection bit 3
   operation(0) <= F(0);
   operation(1) <= F(1);
   operation(2) <= F(2);

   --! artihmetic units:
   artihmeticUnit : ENTITY work.arithmeticUnit PORT MAP ( 
      A,                        --! A: n-bit binary input
      B,                        --! B: n-bit binary input
      P,                        --! P: 4-bit Flags
      operation,                --! F: 3-bit opcode (function)
      arithmeticResultWithCarry --! R: 4-bit binary output with carry
   );

   --! Logic unit
   logicUnit : ENTITY work.logicUnit PORT MAP (    
      A,          --! A: n-bit binary input
      B,          --! B: n-bit binary input
      operation,  --! F: 3-bit opcode (function)
      logicResult --! R: n-bit binary output
   ); 

   --! Strip carrry-bit from artihmetic unit result.
   arithmeticResult(0) <= arithmeticResultWithCarry(0);
   arithmeticResult(1) <= arithmeticResultWithCarry(1);
   arithmeticResult(2) <= arithmeticResultWithCarry(2);
   arithmeticResult(3) <= arithmeticResultWithCarry(3);
   
   
   --! Select unit output 
   R <= arithmeticResult WHEN F(3) = '0' ELSE 
        logicResult;
        

   --! flag handler
   flagOperation: ENTITY work.flagHandler PORT MAP (
      O,                         --! Signed operation
      A,
      B,
      F,                         --! opcode
      P,
      logicResult,               --! n-bit binary result of logic unit
      arithmeticResultWithCarry, --! n-bit binary result of arithmetic unit with carry
      S                          --! Flags as result of the operation
   );

END ARCHITECTURE alu_operation;
