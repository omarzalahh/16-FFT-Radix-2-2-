module FFT_TOB  # ( parameter   DEPTH_BUTTER_ONE    = 8    ,
                                DEPTH_BUTTER_TWO    = 4    ,
                                DEPTH_BUTTER_THREE  = 2    ,
                                DEPTH_BTTER_FOUR    = 1    ,  
                                WIDTH               = 16   ,
                                STAGES              = 6    ,
                                FIXED_POINT         = 11   )
                                
( 
input     wire    signed      [WIDTH-1:0]     Input_re          ,
input     wire    signed      [WIDTH-1:0]     Input_Im          ,
input     wire                                cordic_Valid      ,
input     wire                                clk               ,
input     wire                                rst               ,
output    wire    signed      [WIDTH-1:0]     Output_FFT_Re     ,
output    wire    signed      [WIDTH-1:0]     Output_FFT_Im     ,
output    wire                                Data_Valid    
);
//Control signals
wire   [STAGES-1:0]   control_output        ;
wire                  multiplier_enable     ;
wire                  mux_selection         ;
//4 stages Butterfly signals output
wire     [WIDTH-1:0]  output_re_stage_one   ;
wire     [WIDTH-1:0]  output_im_stage_one   ;
wire     [WIDTH-1:0]  output_re_stage_two   ;
wire     [WIDTH-1:0]  output_im_stage_two   ;
wire     [WIDTH-1:0]  output_re_stage_three ;
wire     [WIDTH-1:0]  output_im_stage_three ;
//2 swap signals output
wire     [WIDTH-1:0]  output_re_swap_one    ;
wire     [WIDTH-1:0]  output_im_swap_one    ;
wire     [WIDTH-1:0]  output_re_swap_two    ;
wire     [WIDTH-1:0]  output_im_swap_two    ;
//twiddle signals output
wire     [WIDTH-1:0]  output_re_twiddle     ;
wire     [WIDTH-1:0]  output_im_twiddle     ;
//multiplier signals output
wire     [WIDTH-1:0]  output_re_multiplier  ;
wire     [WIDTH-1:0]  output_im_multiplier  ;
// 2 signals for mux output real and imaginiry
wire     [WIDTH-1:0]  output_re_mux         ;
wire     [WIDTH-1:0]  output_im_mux         ;
//Mapping Top Moduel
Control_Unit #(.WIDTH(WIDTH),.STAGES(STAGES)) U1_Control
(
.clk                 (clk)                  ,   
.rst                 (rst)                  ,
.Cordic_Valid        (cordic_Valid)         ,
.Multiplier_Enable   (multiplier_enable)    ,
.FFT_Valid           (Data_Valid)           ,
.Control_Signal_Out  (control_output)
);
//----------------------------------------------Butterfly stage 1----------------------------------------
Butterfly #(.WIDTH(WIDTH),.DEPTH(DEPTH_BUTTER_ONE)) U1_Butterfly
(
.Input_Re      (Input_re)                   ,
.Input_Im      (Input_Im)                   ,
.clk           (clk)                        ,
.rst           (rst)                        ,
.ctrl_signal   (control_output[0])          ,
.cordic_valid  (cordic_Valid)               ,
.Output_Re     (output_re_stage_one)        ,
.Output_Im     (output_im_stage_one)
);
//-----------------------------------------------Swap ---------------------------------------------------- 
Swap #(.WIDTH(WIDTH)) U1_Swap
(
.Input_Re         (output_re_stage_one)    ,
.Input_Im         (output_im_stage_one)    ,
.Control_signal   (control_output[1])      ,
.Output_Re        (output_re_swap_one)     ,
.Output_Im        (output_im_swap_one)
);
//----------------------------------------------Butterfly stage 2----------------------------------------  
Butterfly #(.WIDTH(WIDTH),.DEPTH(DEPTH_BUTTER_TWO)) U2_Butterfly
(
.Input_Re      (output_re_swap_one)        ,
.Input_Im      (output_im_swap_one)        ,
.clk           (clk)                       ,
.rst           (rst)                       ,
.ctrl_signal   (control_output[2])         ,
.cordic_valid  (cordic_Valid)              ,
.Output_Re     (output_re_stage_two)       , 
.Output_Im     (output_im_stage_two)
);
//Multiplier , Twiddle factor,Mux selection between multiplier or between the normal output from satage 1 
//----------------------------------------------Exponential------------------------------------------------
exponential #(.WIDTH(WIDTH)) U1_Exponential
(
.Multiplier_Enable   (multiplier_enable)                   ,
.clk                 (clk)                ,
.rst                 (rst)                ,
.mux_selection       (mux_selection)      ,
.br                  (output_re_twiddle)  ,
.bi                  (output_im_twiddle) 
);
//----------------------------------------------Multiplier-------------------------------------------------------
multiplier #(.WIDTH(WIDTH),.FIXED_POINT(FIXED_POINT)) U1_Multiplier
(
.In_One_Re   (output_re_stage_two)        ,
.In_One_Im   (output_im_stage_two)        ,
.In_Two_Re   (output_re_twiddle)          ,
.In_Two_Im   (output_im_twiddle)          ,
.clk         (clk)                        ,
.rst         (rst)                        ,
.Enable      (multiplier_enable)          ,
.Out_Re      (output_re_multiplier)       ,
.Out_Im      (output_im_multiplier)
);
//------------------------------------------------Mux real------------------------------------------------------
MUX2x1_ASYNC #(.WIDTH(WIDTH))  U1_Mux_Re_Multiplier
(
.Input_One  (output_re_multiplier)        ,    
.Input_Two  (output_re_stage_two)         ,
.Selection  (mux_selection)               ,
.Output_Mux (output_re_mux)
);
//-----------------------------------------------Mux Imaginiry--------------------------------------------------
MUX2x1_ASYNC #(.WIDTH(WIDTH))  U1_Mux_Im_Multiplier
(
.Input_One  (output_im_multiplier)        ,
.Input_Two  (output_im_stage_two)         ,
.Selection  (mux_selection)               ,
.Output_Mux (output_im_mux)
);
//----------------------------------------------Butterfly stage 3----------------------------------------
Butterfly #(.WIDTH(WIDTH),.DEPTH(DEPTH_BUTTER_THREE)) U3_Butterfly
(
.Input_Re      (output_re_mux)            ,
.Input_Im      (output_im_mux)            ,
.clk           (clk)                      ,
.rst           (rst)                      ,
.ctrl_signal   (control_output[3])        ,
.cordic_valid  (cordic_Valid)             ,
.Output_Re     (output_re_stage_three)    ,
.Output_Im     (output_im_stage_three)
 );
//-----------------------------------------------Swap--------------------------------------------------------------
Swap #(.WIDTH(WIDTH)) U2_Swap
(
.Input_Re         (output_re_stage_three) ,
.Input_Im         (output_im_stage_three) ,
.Control_signal   (control_output[4])     ,
.Output_Re        (output_re_swap_two)    ,
.Output_Im        (output_im_swap_two)
);
//----------------------------------------------Butterfly stage 4----------------------------------------
Butterfly #(.WIDTH(WIDTH),.DEPTH(DEPTH_BTTER_FOUR)) U4_Butterfly
(
.Input_Re      (output_re_swap_two)     ,  
.Input_Im      (output_im_swap_two)     ,
.clk           (clk)                    ,
.rst           (rst)                    ,
.ctrl_signal   (control_output[5])      ,
.cordic_valid  (cordic_Valid)           ,
.Output_Re     (Output_FFT_Re)          ,
.Output_Im     (Output_FFT_Im)
);
endmodule
/*--------------------------------------------------Mapping----------------------------------------------------------------

FFT_TOB #(.DEPTH_BUTTER_ONE()  ,
          .DEPTH_BUTTER_TWO()  ,
          .DEPTH_BUTTER_THREE(),
          .DEPTH_BTTER_FOUR()  ,
          .WIDTH()             ,
          .STAGES()            ,
          .FIXED_POINT()
          ) Instanse_Name

(
.Input_re       ()   ,
.Input_Im       ()   ,
.cordic_Valid   ()   ,
.clk            ()   ,
.rst            ()   ,
.Output_FFT_Re  ()   ,
.Output_FFT_Im  ()   ,
.Data_Valid     ()
);
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment       |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/