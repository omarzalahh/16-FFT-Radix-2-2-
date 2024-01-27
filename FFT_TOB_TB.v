module FFT_TOP_TB();
  
 parameter                               DEPTH_BUTTER_ONE    = 8    ;
 parameter                               DEPTH_BUTTER_TWO    = 4    ;
 parameter                               DEPTH_BUTTER_THREE  = 2    ;
 parameter                               DEPTH_BTTER_FOUR    = 1    ;  
 parameter                               WIDTH               = 16   ;
 parameter                               STAGES              = 6    ;
 parameter                               FIXED_POINT         = 11   ;
 
reg    signed      [WIDTH-1:0]     Input_re_tb          ;
reg    signed      [WIDTH-1:0]     Input_Im_tb          ;
reg                                cordic_Valid_tb      ;
reg                                clk_tb               ;
reg                                rst_tb               ;
wire   signed      [WIDTH-1:0]     Output_FFT_Re_tb     ;
wire   signed      [WIDTH-1:0]     Output_FFT_Im_tb     ;
wire                               Data_Valid_tb        ;

//Memory for take input and output from text file to check the system
reg [WIDTH-1:0] in_real [31:0];
reg [WIDTH-1:0] in_imag [31:0];
reg [WIDTH-1:0] out_real [15:0];
reg [WIDTH-1:0] out_imag [15:0];

//Counter for for loop check
integer i,m;

initial 
begin
  forever #10 clk_tb = ~clk_tb ;
end

initial 
begin
   $dumpfile("FFT.vcd") ;       
 $dumpvars;

   $readmemb("I_Sample_i_b.txt",in_real);
	 $readmemb("Q_Sample_i_b.txt",in_imag);
	 $readmemb("I_Sample_o_b.txt",out_real);
	 $readmemb("Q_Sample_o_b.txt",out_imag);
	 
  Initialization ();
  Reset();
  Check();
  #100
  $stop;  
end

task Initialization ;
  begin
    clk_tb =0;
    rst_tb =0;
    cordic_Valid_tb ='b0;
    Input_re_tb       = 'b0;
    Input_Im_tb       = 'b0;
    i=0;
    m=0;
  end
endtask
task Reset ;
  begin
    #2
    rst_tb =1;
  end
endtask
//-------------------------------------------------CHECK RESULTS-----------------------------------
task Check ;
  begin
  repeat(32)@(posedge clk_tb) 
  begin
    cordic_Valid_tb   = 'b1;
    Input_re_tb       = in_real[i];
    Input_Im_tb       = in_imag[i];
    i=i+1;
  end    
  /*
  repeat(16)@(negedge clk_tb)
    begin
   if( (Output_FFT_Re_tb == out_real[m]*2^11) && (Output_FFT_Im_tb == out_imag[m]*2^11) ) 
    begin
     $display("Test Case is succeeded  %d",Output_FFT_Re_tb);
    end
   else
    begin
     $display("Test Case is failed ");
    end
    m=m+1;
    end */
  end
endtask
//--------------------------------------------DUT MAPPING----------------------------
FFT_TOB #(.DEPTH_BUTTER_ONE(DEPTH_BUTTER_ONE)     ,
          .DEPTH_BUTTER_TWO(DEPTH_BUTTER_TWO)     ,
          .DEPTH_BUTTER_THREE(DEPTH_BUTTER_THREE) ,
          .DEPTH_BTTER_FOUR(DEPTH_BTTER_FOUR)     ,
          .WIDTH(WIDTH)                           ,
          .STAGES(STAGES)                         ,
          .FIXED_POINT(FIXED_POINT)
          ) DUT

(
.Input_re       (Input_re_tb)                     ,
.Input_Im       (Input_Im_tb)                     ,
.cordic_Valid   (cordic_Valid_tb)                 ,
.clk            (clk_tb)                          ,
.rst            (rst_tb)                          ,
.Output_FFT_Re  (Output_FFT_Re_tb)                ,
.Output_FFT_Im  (Output_FFT_Im_tb)                ,
.Data_Valid     (Data_Valid_tb)
);
endmodule
