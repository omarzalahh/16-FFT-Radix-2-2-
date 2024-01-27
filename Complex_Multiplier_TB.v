
module multiplier_TB();

parameter WIDTH = 16;
parameter FIXED_POINT = 11;

reg signed   [WIDTH-1:0]     In_One_Re_TB    ;
reg signed   [WIDTH-1:0]     In_One_Im_TB    ;
reg signed   [WIDTH-1:0]     In_Two_Re_TB    ;
reg signed   [WIDTH-1:0]     In_Two_Im_TB    ;
reg                          clk_TB          ;
reg                          rst_TB          ;
reg                          Enable_TB       ;
wire  signed   [WIDTH-1:0]   Out_Re_TB       ;
wire  signed   [WIDTH-1:0]   Out_Im_TB       ;

  initial 
    begin
      initilization();
      reset();
      check();
      #1000
      $stop;
    end

  initial
    begin
      forever #20 clk_TB=~clk_TB;   
    end
    
    task initilization ;
    begin
      In_One_Re_TB='b0;
      In_One_Im_TB='b0;
      In_Two_Re_TB='b0;
      In_Two_Im_TB='b0;
      clk_TB=0;
      rst_TB=0;
      Enable_TB='b0;
    end
  endtask
  
    task reset ;
    begin
      #3
      rst_TB=1;
    end
  endtask

    task check ;
    begin
      In_One_Re_TB='b0000011101100100;
      In_One_Im_TB='b1111110011110000; //2i ,0.9238 - 0.3828i = 0000011101100100 + 1111110011110000 i
      In_Two_Re_TB='b0000010110101000; //0.7070 - 0.7070i = 0000010110101000 + 1111101001011000 i
      In_Two_Im_TB='b1111101001011000;   //result should be 0.38247-0.9237i
      Enable_TB='b1;
    end
  endtask  


multiplier #(.WIDTH(WIDTH) ,.FIXED_POINT(FIXED_POINT)) DUT
(
.In_One_Re(In_One_Re_TB)    ,
.In_One_Im(In_One_Im_TB)    ,
.In_Two_Re(In_Two_Re_TB)    ,
.In_Two_Im(In_Two_Im_TB)    ,
.clk(clk_TB)                ,
.rst(rst_TB)                ,
.Enable(Enable_TB)          ,
.Out_Re(Out_Re_TB)          ,
.Out_Im(Out_Im_TB)       
);



endmodule