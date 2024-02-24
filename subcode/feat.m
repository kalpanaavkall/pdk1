function [f1 f2 f3 f4 f5 f6 f7 f8 f9 f10]=feat(bBlob)

 f1=mean2(bBlob);
  f2=std2(bBlob);
  f3=1/(1+f2^2);
  f4=skewness(bBlob);
  bwp=edge(bBlob,'sobel');
  f5=sum(sum(bBlob));
  f6=sum(sum(bwp));
  f7=f6^2/f5;
  nh=bBlob/f5;
  f8=sum(nh.^2);
  f9=sum(nh.*log10(nh));
  f10=sum(nh'*bBlob)-f1/f2;

