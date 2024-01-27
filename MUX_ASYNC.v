/*
Module      :   MUX 2*1 Asynchrouns output
Auth        :   Omar  Salah El-Din
Date        :   16Jan.2024
_____________________________________

Description :
**************
- Mux module that is to give the input 1 ,2 and selection line of 1 bit and then get the output
  from one of the two inputs
- The output is n't registered so it's asycnhrouns 
*/

module  MUX2x1_ASYNC #  ( parameter  WIDTH = 16 )
  (
  input    wire signed [WIDTH-1:0]           Input_One   ,
  input    wire signed [WIDTH-1:0]           Input_Two   ,
  input    wire                              Selection   ,
  output   wire        [WIDTH-1:0]           Output_Mux 
  );
  
assign  Output_Mux  = (Selection) ? Input_One:Input_Two;

endmodule

/*--------------------------------------------------Mapping----------------------------------------------------------------

MUX2x1_ASYNC #(.WIDTH()) Instanse_Name

(
.Input_One  () ,
.Input_Two  () ,
.Selection  () ,
.Output_Mux ()
  );
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment       |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/

