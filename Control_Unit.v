/*
Module      :   Control_Unit Module
Auth        :   Omar  Salah El-Din
Date        :   17Jan.2024
_____________________________________

Description :
**************
- That module to control the 6 stages of the module
*/
module Control_Unit # ( parameter   WIDTH     = 16  ,
                                    STAGES    = 6   
                                    )
  (
  input   wire                clk                 ,   
  input   wire                rst                 ,
  input   wire                Cordic_Valid        ,
  output  reg                 Multiplier_Enable   ,
  output  reg                 FFT_Valid           ,
  output  wire   [STAGES-1:0] Control_Signal_Out
  );
 
  //Counter for detecte the stages we need to count the 16 ofdm so counter will be 4 bit
  reg   [4:0] counter ;//count to 32
  //I reduced the fsm to only 1 case statment and counter cause if i want to make a fsm i will need 4 of 1 counters  
  wire     c1,c2,c3,c4,c5,c6;
  
  //reg   [1:0]  CS,NS;
  
  assign Control_Signal_Out = {c6,c5,c4,c3,c2,c1} ;
  
/*FSM FOR COUNTER USING 2 SIGNALS when cordic valid is set 0 the counter should continue the the all bits become 0 then stop the module 
Intial state wait the cordic valid then go to the first state which is count 
if cordic become 0 the counter should count 16 more counts then become stop working
so i make a signal called continue to continue count 16 counts more then if the all bits become zero that signal become zero and go to the initial state again 
*/

/*localparam    [1:0]       IDEAL   = 'b00,
                          INITIAL = 'b01,
                          CONTINUE= 'b11;
  
  */
  
  
  always @(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        FFT_Valid <= 'b0;
        Multiplier_Enable <= 'b0;
    end
    else
    begin
        if(counter == 'd14)
          begin
            FFT_Valid <= 'b1;
          end
        else
          begin
            FFT_Valid <=FFT_Valid;  
          end
        if(counter == 'd11)
        begin
            Multiplier_Enable <= 'b1;
        end
        
    end
end
always  @ ( posedge clk or  negedge rst)
begin
  if(!rst)
   begin
     counter  <=  'b0;
   end  
  else
    begin
      if(Cordic_Valid)
        begin
          counter <= counter  + 'b1;   
        end
      else
        begin
          counter <=  counter ;
        end
    end
end

 /*
 c1 toggle  every 8 cycles 
 c3 toggle  every 4
 c4 toggle  every 2
 c5 each 4 counter will enable for once
 c6 toggle  every 1
 ----------------------
 c2 from 12 to 16
 enable of mulitipier from 
 */
//-------------------------------------------case depends on input (counter) so I reduced the case and fsm by K-MAP only -------------------------

assign c6 = counter[0]                                    ;
assign c5= counter[0] &(!counter[1])                      ;
assign c4 = counter[1]                                    ;
assign c3 = counter[2]                                    ;
assign c2 = (~counter[3]&counter[2])                        ;//((~(counter[3]&counter[2])&counter[1])|(~counter[3]&counter[1]&~counter[0])|(~counter[3]&counter[2]&~counter[1]))&counter[4];
assign c1 = counter[3]                                    ;      
endmodule


/*--------------------------------------------------Mapping----------------------------------------------------------------

Control_Unit #(.WIDTH(),.STAGES()) Instanse_Name
(
.clk                 (),   
.rst                 (),
.Cordic_Valid        (),
.Multiplier_Enable   (),
.FFT_Valid           (),
.Control_Signal_Out  ()
);
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment       |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/