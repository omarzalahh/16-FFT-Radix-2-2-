%function [FFT_OUT_omar]=FFT_RADIX2(input)
input=[-0.0327+0.0034i    0.295+0.0078i   -0.437+0.0767i   -0.1504+0.0342i 0.4058+-0.3740i ];
input = [input 0.1465-0.4575i -0.0903+0.4097i -0.2817+0.0679i 0.0557+0.4302i -0.1333-0.0591i];
input = [input -0.0933-0.0444i 0.0854-0.3818i -0.0015+0.2412i -0.0762+0.0005i 0.3135-0.1816i -0.1899+0.0405i];
V=input;
N=16;%number of Samples in fft
stage1_fft=[];
stage2_fft=[];
stage3_fft=[];
stage4_fft=[];
fft_bitreverse=[];
W=[];
%-------------------------------first stage-------------------------------
for k=1:1:N
    if(k<=(3*N/4))
    W(k)=1;    
    else
    W(k)=-1i;
    end
end
for k=1:1:N
    if (k<=N/2)
        stage1_fft(k)=V(k+(N/2))+V(k); 
    else
        stage1_fft(k)=-V(k)+V(k-(N/2));
    end
    stage1_fft(k)=W(k)*stage1_fft(k);
end

%------------------------------second stage--------------------------------
    n=0;j=0;m=0;
for k=1:1:N
    if(k<=N/4)
        W(k)=1;
    elseif (k<=N/2)
        W(k)=exp(-1i*2*pi*n/N);
        n=n+2;
    elseif (k<=((3*N)/4))
        W(k)=exp(-1i*2*pi*j/N);
        j=j+1;    
    elseif(k<=N)
        W(k)=exp(-1i*2*pi*m/N);
        m=m+3;
     end
end

for k=1:1:N
   if(k<=N/4)
       stage2_fft(k)=stage1_fft(k+(N/4))+stage1_fft(k);
   elseif (k<=N/2)
       stage2_fft(k)=stage1_fft(k-(N/4))-stage1_fft(k);
   elseif (k<=((3*N)/4))
       stage2_fft(k)=stage1_fft(k+(N/4))+stage1_fft(k);  
   else
       stage2_fft(k)=stage1_fft(k-(N/4))-stage1_fft(k); 
   end
   stage2_fft(k)=W(k)*stage2_fft(k);
end

%---------------------------------third stage-----------------------------
for k=1:4:N
   W(k)=1;
   W(k+1)=1;
   W(k+2)=1;
   W(k+3)=exp(-1i*2*pi*4/16);%-1i
end
for k=1:4:N
        stage3_fft(k)=stage2_fft(k+2)+stage2_fft(k); 
        stage3_fft(k+1)=stage2_fft(k+3)+stage2_fft(k+1);
        stage3_fft(k+2)=stage2_fft(k)-stage2_fft(k+2);
        
        stage3_fft(k+3)=stage2_fft(k+1)-stage2_fft(k+3);
        stage3_fft(k+3)=(W(k+3)*stage3_fft(k+3));
end

%-------------------------------Four stage---------------------------------
for k=1:2:N
    stage4_fft(k)=stage3_fft(k+1)+stage3_fft(k);
    stage4_fft(k+1)=stage3_fft(k)-stage3_fft(k+1);
end
%bitreverse
fft_bitreverse(0+1)=stage4_fft(0+1);
fft_bitreverse(1+1)=stage4_fft(8+1);
fft_bitreverse(2+1)=stage4_fft(4+1);
fft_bitreverse(3+1)=stage4_fft(12+1);
fft_bitreverse(4+1)=stage4_fft(2+1);
fft_bitreverse(5+1)=stage4_fft(10+1);
fft_bitreverse(6+1)=stage4_fft(6+1);
fft_bitreverse(7+1)=stage4_fft(14+1);
fft_bitreverse(8+1)=stage4_fft(1+1);
fft_bitreverse(9+1)=stage4_fft(9+1);
fft_bitreverse(10+1)=stage4_fft(5+1);
fft_bitreverse(11+1)=stage4_fft(13+1);
fft_bitreverse(12+1)=stage4_fft(3+1);
fft_bitreverse(13+1)=stage4_fft(11+1);
fft_bitreverse(14+1)=stage4_fft(7+1);
fft_bitreverse(15+1)=stage4_fft(15+1);
%12 ofdm symbole only from the 16 
% we will take 
FFT_OUT_omar=fft_bitreverse;



 
%end