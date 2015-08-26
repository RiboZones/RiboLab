function colorGrad = computeHexGrad(numColors)
colorGrad=cell(numColors,1);
maxColors= 256*256*256;

colorSpacing=maxColors/numColors;
ColorSpread=1:colorSpacing:maxColors;

ExtraColors = 8400;
maxDesiredColors=15400000;
numpins=numColors*(numColors+1)/2;%Use bowling pin formula
offset_base = ExtraColors / numpins; %Value of each pin

ColorSpread_Offset =  ColorSpread(1:numColors) + (offset_base * (1:numColors)); % Add accumlating offset to help colors spread out more.
ColorSpread_norm =  round(ColorSpread_Offset * (maxDesiredColors/max(ColorSpread_Offset))); %normalize to full desired range, and make integer
ColorSpread_norm = ColorSpread_norm - min(ColorSpread_norm) + 1; % normalize first color to pure red. Last color will vary slightly.
for i=1:numColors
    %RGB
    %thirdarg = dec2hex(rem(rem(ColorSpread(i),(256*256)),256),2);
    %secondarg = dec2hex(rem(((ColorSpread(i) - hex2dec(thirdarg))/256),256),2);
    %firstarg = dec2hex((ColorSpread(i) - hex2dec(thirdarg) - 256*hex2dec(secondarg))/(256*256),2);
    %colorGrad{i}=['#', firstarg, secondarg, thirdarg] ;
    
    %HSV
    thirdarg = rem(rem(ColorSpread_norm(i),(256*256)),256);
    secondarg = rem((ColorSpread_norm(i) - thirdarg)/256,256);
    firstarg = (ColorSpread_norm(i) - thirdarg - 256*secondarg)/(256*256);
    hsvcolor = [firstarg,secondarg,thirdarg];
    hsv_adj = [0,256,256] - [-1, .5, .5] .* hsvcolor;
    rgb=255*hsv2rgb(hsv_adj/256) ;
    colorGrad{i}=['#', dec2hex(round(rgb(1)),2), dec2hex(round(rgb(2)),2), dec2hex(round(rgb(3)),2)] ;
end
 
end