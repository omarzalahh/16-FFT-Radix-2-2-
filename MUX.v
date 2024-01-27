/*
Module      :   MUX 2*1 
Auth        :   Omar  Salah El-Din
Date        :   16Jan.2024
_____________________________________

Description :
**************
- Mux module that is to give the input 1 ,2 and selection line of 1 bit and then get the output
  from one of the two inputs
- The output is registered to prevent any combinational loop in feedback
*/

module  MUX2x1_SYNC #  ( parameter  WIDTH = 16 )
  (
  input    wire signed [WIDTH-1:0]           Input_One   ,
  input    wire signed [WIDTH-1:0]           Input_Two   ,
  input    wire                              Selection   ,
  input    wire                              clk         ,
  input    wire                              rst         ,
  output   reg         [WIDTH-1:0]           Output_Mux 
  );
wire  [WIDTH-1:0]       output_mux;

assign  output_mux  = (Selection) ? Input_One:Input_Two;
  
  always  @ (posedge  clk or  negedge rst)
  begin
    if(!rst)
      begin
        Output_Mux  <=  'b0;
      end
    else
      begin
        Output_Mux  <=  output_mux;
      end  
  end
endmodule
/*--------------------------------------------------Mapping----------------------------------------------------------------

MUX2x1 #(.WIDTH()) Instanse_Name

(
.Input_One  () ,
.Input_Two  () ,
.Selection  () ,
.clk        () ,
.rst        () ,
.Output_Mux ()
  );
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment       |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/