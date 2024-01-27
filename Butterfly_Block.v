/*
Module      :   Butterfly Top module
Auth        :   Omar  Salah El-Din
Date        :   16Jan.2024
_____________________________________

Description :
**************
- The main equation of butterfly as in pdf is (a+b)W or (a-b)W , so we need to add a1_re+b1_re real and a1_im+b1_im and same for subtraction 
- So we need 2 addtion and 2 subtractions and 4 muxs to make that equation 
- we need 2 reg files each of width 16 as our symbol and 8 depth we take save the first 8 clk cycles in the register then start the first from our 
  reg to the number 9 in our clock which we didnt save cause each symbol (16-bit) is entered to our module cycle by cycle
- we wil then take the output to make swap on it and decrease the reg file to 4 then 2 
*/
module Butterfly #    ( parameter         WIDTH    = 16 ,
                                          DEPTH    = 8  
                                          )
  (
  input   wire    signed    [WIDTH-1:0]   Input_Re      ,
  input   wire    signed    [WIDTH-1:0]   Input_Im      ,
  input   wire                            clk           ,
  input   wire                            rst           ,
  input   wire                            ctrl_signal   ,
  input   wire                            cordic_valid  ,
  output  wire    signed    [WIDTH-1:-0]  Output_Re     ,
  output  wire    signed    [WIDTH-1:0]   Output_Im
  );
  //For reg out
  wire  signed [WIDTH-1:0]    reg_re_out      ;
  wire  signed [WIDTH-1:0]    reg_im_out      ;
  //reg in put from the 2 muxes
  wire  signed [WIDTH-1:0]    mux_out_one     ;//input to reg im\out from mux 1
  wire  signed [WIDTH-1:0]    mux_out_two     ;//input to reg re \out from mux 2
  //------------------------------------------------out from mux 3 and four is the out from the top module butterfly
  //input for the 4 muxes from the adding and subtracting
  wire  signed [WIDTH-1:0]    mux_one_in      ;//the other input from the top module input Imaginry
  wire  signed [WIDTH-1:0]    mux_two_in      ;//the other input from the top module input real
  wire  signed [WIDTH-1:0]    mux_three_in    ;//the other input from the register out imaginry
  wire  signed [WIDTH-1:0]    mux_four_in     ;//the other input from the register out real
//---------------------------------------------Start functions--------------------------------------------------------------
  assign mux_two_in   =  reg_re_out - Input_Re  ;
  assign mux_one_in   =  reg_im_out - Input_Im  ;
  assign mux_three_in =  Input_Im + reg_im_out;
  assign mux_four_in  =  Input_Re + reg_re_out;
//---------------------------------------------Top Mapping-------------------------------------------------------------------
  
  Register_File #(.WIDTH(16),.DEPTH(DEPTH)) U1_REGFILE
(
.Input_Re   (mux_out_two)   ,
.Input_Im   (mux_out_one)   , 
.clk        (clk)           ,
.rst        (rst)           ,
.Output_Re  (reg_re_out)    ,
.Enable     (cordic_valid)  ,
.Output_Im  (reg_im_out)   
);
  
MUX2x1_ASYNC #(.WIDTH(WIDTH)) U1_MUX//IMAGINRY
(
.Input_One  (mux_one_in)      ,
.Input_Two  (Input_Im)        ,
.Selection  (ctrl_signal)     ,
.Output_Mux (mux_out_one)
);
MUX2x1_ASYNC #(.WIDTH(WIDTH)) U2_MUX//REAL
(
.Input_One  (mux_two_in)      ,
.Input_Two  (Input_Re)        ,
.Selection  (ctrl_signal)     ,
.Output_Mux (mux_out_two)
);
MUX2x1_ASYNC #(.WIDTH(WIDTH)) U3_MUX//IMAG
(
.Input_One  (mux_three_in)    ,
.Input_Two  (reg_im_out)      ,
.Selection  (ctrl_signal)     ,
.Output_Mux (Output_Im)
);
MUX2x1_ASYNC #(.WIDTH(WIDTH)) U4_MUX//REAL
(
.Input_One  (mux_four_in)    ,
.Input_Two  (reg_re_out)     ,
.Selection  (ctrl_signal)    ,
.Output_Mux (Output_Re)
);  
endmodule
/*--------------------------------------------------Mapping----------------------------------------------------------------

Butterfly #(.WIDTH(),.DEPTH()) Instanse_Name
(
.Input_Re      (),
.Input_Im      (),
.clk           (),
.rst           (),
.ctrl_signal   (),
.cordic_valid  (),
.Output_Re     (),
.Output_Im     ()
  );
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment                                                        |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/

