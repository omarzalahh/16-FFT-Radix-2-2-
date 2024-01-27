module  exponential # ( parameter   WIDTH=16 )
  (
  input   wire            Multiplier_Enable   ,
  input   wire            clk                 ,
  input   wire            rst                 ,
  output  reg             mux_selection       ,
  output  reg [WIDTH-1:0] br                  ,
  output  reg [WIDTH-1:0] bi                  
  );
  
  reg [3:0] counter;
  localparam       [WIDTH-1:0]        w2R = 'b0000010110101000 ,
								                      W2I = 'b1111101001011000 ,
								                     	W4R = 'b0000000000000000 ,
								                     	W4I = 'b1111100000000000 ,
								                     	W6R = 'b1111101001011000 ,
								                     	W6I = 'b1111101001011000 ,
								                     	W1R = 'b0000011101100100 ,
								                     	W1I = 'b1111110011110000 ,
								                     	W3R = 'b0000001100010000 ,
								                     	W3I = 'b1111100010011100 ,
								                     	W9R = 'b1111100010011100 ,
								                     	W9I = 'b0000001100010000 ;
  
  
always  @ ( posedge clk or  negedge rst)
begin
   if(!rst)
    begin
      counter <=  'b0;
    end
   else
    begin
      if(Multiplier_Enable)
         begin
          counter <= counter +1'b1;
        end
     else
        begin
         counter <=counter;
        end
    end
end
  //if mux selection is 1 the output will be the multiplier if mux selection is 0 the out put will be same as input only
always @(*)
begin
	if(counter =='d5 || counter == 'd10)
	begin
		br = w2R;
		bi = W2I;
		mux_selection = 'b1;
	end
	else if(counter =='d6)
	begin
		br = W4R;
		bi = W4I;
		mux_selection = 'b1;
	end
	else if (counter =='d7 || counter == 'd14)
	begin
		br = W6R;
		bi = W6I;
		mux_selection = 'b1;
	end
	else if (counter =='d9 )
	begin
		br = W1R;
		bi = W1I;
		mux_selection = 'b1;
	end
	else if (counter =='d11 || counter == 'd13)
	begin
		br = W3R;
		bi = W3I;
		mux_selection = 'b1;
	end
	else if (counter =='d15 )
	begin
		br = W9R;
		bi = W9I;
		mux_selection = 'b1;
	end
	else
	begin
		br = 'b1;
		bi = 'b1;
		mux_selection = 'b0;
	end
end
endmodule
/*--------------------------------------------------Mapping----------------------------------------------------------------

exponential #(.WIDTH()) Instanse_Name
(
.Multiplier_Enable   (),
.clk                 (),
.rst                 (),
.mux_selection       (),
.br                  (),
.bi                  () 
  );
*/
/*-------------------------------------------------Last Edit------------------------------------------------------------
|       Name        |       Date        |       Comment       |                
|                   |                   |                     |
|                   |                   |                     |
|                   |                   |                     |
*/

