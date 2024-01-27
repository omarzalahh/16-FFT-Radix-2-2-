module  Register_File # ( parameter WIDTH = 16            , 
                                    DEPTH = 8             
                                    )
  (
    input     wire    signed    [WIDTH-1:0]   Input_Re    ,
    input     wire    signed    [WIDTH-1:0]   Input_Im    ,
    input     wire                            clk         ,
    input     wire                            rst         ,
    input     wire                            Enable      ,
    output    wire    signed    [WIDTH-1:0]   Output_Re   ,
    output    wire    signed    [WIDTH-1:0]   Output_Im     
  );
  
  reg signed  [WIDTH-1:0] reg_re [DEPTH-1:0];
  reg signed  [WIDTH-1:0] reg_im [DEPTH-1:0];
integer I;

assign Output_Re = reg_re [DEPTH-1];
assign Output_Im = reg_im [DEPTH-1];

  always @  ( posedge  clk  or  negedge rst )
  begin
    if(~rst)
      begin
        for (  I = 0  ;  I <  DEPTH ; I = I+1 )
        begin
          reg_re[I] <=  'b0 ;
          reg_im[I] <=  'b0 ;
        end
      end
    else
      begin
        if(Enable)
          begin
            reg_re[0] <=  Input_Re ;
            reg_im[0] <=  Input_Im ;
            for(  I = 1 ; I < DEPTH ; I = I+1  )
            begin
             reg_re[I] <=  reg_re[I-1];
             reg_im[I] <=  reg_im[I-1];
            end
          end
        else
          begin
             for (  I = 0  ;  I <  DEPTH ; I = I+1 )
              begin
                reg_re[I] <=  'b0 ;
                reg_im[I] <=  'b0 ;
             end
          end
      end
  end
endmodule
/*--------------------------------------------------Mapping----------------------------------------------------------------
Register_File #(.WIDTH(),.DEPTH()) Instanse_Name
(
.Input_Re   () ,
.Input_Im   () ,
.clk        () ,
.rst        () ,
.Enable     () ,
.Output_Re  () ,
.Output_Im  ()   
);
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment                                                          |                
|                   |                   |                                                                        |
|                   |                   |                     |
|                   |                   |                     |
*/