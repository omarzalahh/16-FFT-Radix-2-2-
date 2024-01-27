/*
Module      :   Complex Multiplier 
Auth        :   Omar  Salah El-Din
Date        :   15Jan.2024
_____________________________________

Description :
**************
Complex multiplier that takes 4 inputs the real and imaginary for 2 number are signed 
(a_r+ j a_i ) (b_r + j b_i)
 
the output should be 
                      (a_r * b_r)-(a_i*b_i)+j(a_r*b_i + b_r * a_i)
here the number of multiplication (4) and addition (2)
we want to decrease number of multiplication so we will reshape the equation 
                    {br(a_r-ai) + a_i(b_r-b_i)}    +    j{bi(ar+ai)+ai(br-bi)}

he in that new equation we have only 3 multipliers because ai(b_r-bi) is repeated and 5 addition/subtraction

*/

module multiplier #(parameter WIDTH       =16        ,
                              FIXED_POINT =11
                              )

(
  input   wire signed   [WIDTH-1:0]     In_One_Re    ,
  input   wire signed   [WIDTH-1:0]     In_One_Im    ,
  input   wire signed   [WIDTH-1:0]     In_Two_Re    ,
  input   wire signed   [WIDTH-1:0]     In_Two_Im    ,
  input   wire                          clk          ,
  input   wire                          rst          ,
  input   wire                          Enable       ,
  output  reg  signed   [WIDTH-1:0]     Out_Re       ,
  output  reg  signed   [WIDTH-1:0]     Out_Im
  );
  //First stage 3  adding\subtracting
  wire  signed [WIDTH-1:0]      subtractor_one; //(a_r-ai)
  wire  signed [WIDTH-1:0]      subtractor_two; //(b_r-b_i)
  wire  signed [WIDTH-1:0]      add_one       ; //(ar+ai)
  //Second stage 3 multiply  
  wire  signed [(2*WIDTH)-1:0]  multi_one     ; //b_r(a_r-ai) multiply br with subtractor_one
  wire  signed [(2*WIDTH)-1:0]  multi_two     ; //a_i(b_r-bi) multiply ai with subtractor_two
  wire  signed [(2*WIDTH)-1:0]  multi_three   ; //b_i(a_r+ai) multiply bi with add_one
  //Third stage 2 adder
  wire  signed [2*WIDTH:0]      add_re        ; //br(a_r-ai) + a_i(b_r-b_i) add multi_one   with multi_two
  wire  signed [2*WIDTH:0]      add_im        ; //bi(ar+ai)+ai(br-bi)       add multi_three with multi_two

//First stage implementation
assign subtractor_one   =   In_One_Re-In_One_Im;
assign subtractor_two   =   In_Two_Re-In_Two_Im;
assign add_one          =   In_One_Re+In_One_Im;

//Second stage implementation
assign multi_one     =   In_Two_Re  * subtractor_one;
assign multi_two     =   In_One_Im  * subtractor_two;
assign multi_three   =   In_Two_Im  * add_one       ;

//Third stage implementation
assign add_re       =    multi_one   + multi_two      ;
assign add_im       =    multi_three + multi_two      ;


/*always @(posedge clk or negedge rst)
begin
  if(!rst)//asynchronus reset
    begin
      Out_Re  <=  'b0;
      Out_Im  <=  'b0;
    end
  else*/
always @ (*)
begin
     if(Enable)
       begin
        Out_Re = add_re[WIDTH+FIXED_POINT-1:FIXED_POINT] ;
        Out_Im = add_im[WIDTH+FIXED_POINT-1:FIXED_POINT] ;
       end
     else
      begin
        Out_Re  =  'b0;
        Out_Im  =  'b0;  
      end
end
endmodule
/*--------------------------------------------------Mapping----------------------------------------------------------------

multiplier #(.WIDTH(),.FIXED_POINT()) Instanse_Name

(
.In_One_Re   () ,
.In_One_Im   () ,
.In_Two_Re   () ,
.In_Two_Im   () ,
.clk         () ,
.rst         () ,
.Enable      () ,
.Out_Re      () ,
.Out_Im      ()
  );
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment       |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/



