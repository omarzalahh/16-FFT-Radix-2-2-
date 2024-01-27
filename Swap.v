/*
Module      :   Swap Module
Auth        :   Omar  Salah El-Din
Date        :   17Jan.2024
_____________________________________

Description :
**************
- That module will take control signal in first stage we need to multiply last 4 ofdm symbols by -j 
- we made swap for the real and imaginry with 2's complemnt to them cause
Ex: (1+1i)*(-1i)=
    The real part is converted to imaginery with negative sign (2's complement +1'b1)
    The imaginery part is converted to real with same sign cause (i*-i)=1,(-i*-i)=-1 so the sign bit of imaginry stay the same
    the swap is done by mux 2*1 and 2's complement and adding 1'b1;
*/
module Swap # ( parameter WIDTH = 16  )
  (
  input   wire    signed  [ WIDTH-1  : 0 ]    Input_Re        ,
  input   wire    signed  [ WIDTH-1  : 0 ]    Input_Im        ,
  input   wire                                Control_signal  ,
  output  wire    signed  [ WIDTH-1  : 0 ]    Output_Re       ,
  output  wire    signed  [ WIDTH-1  : 0 ]    Output_Im       
  );
  
 //signals for 2's complement and adding 1'b1 
  wire    signed  [ WIDTH-1  : 0 ]    input_re_complement       ;  
  wire    signed  [ WIDTH-1  : 0 ]    input_im_complement       ;  
    
assign input_re_complement  =    Input_Im ;
assign input_im_complement  =    (~Input_Re )+1'b1;
    
    
MUX2x1_ASYNC #(.WIDTH(WIDTH)) U5_MUX_Re
(
.Input_One  (input_re_complement)               ,
.Input_Two  (Input_Re)    ,
.Selection  (Control_signal)         ,
.Output_Mux (Output_Re)
);
MUX2x1_ASYNC #(.WIDTH(WIDTH)) U6_MUX_Im
(
.Input_One  (input_im_complement)               ,
.Input_Two  (Input_Im)    ,
.Selection  (Control_signal)         ,
.Output_Mux (Output_Im)
);
endmodule
/*--------------------------------------------------Mapping----------------------------------------------------------------

Swap #(.WIDTH()) Instanse_Name
(
.Input_Re         (),
.Input_Im         (),
.Control_signal   (),
.Output_Re        (),
.Output_Im        ()
  );
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment       |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/