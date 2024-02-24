function diff_im = adap_ST_filter(m,num_iter,de_t,ka,opt)
fprintf('Removing noise\n');
fprintf('Filtering Completed !!');


im = double(m);
diff_im = im;
dx = 1;
dy = 1;
dd = sqrt(2);
hN = [0 1 0; 0 -1 0; 0 0 0];
hS = [0 0 0; 0 -1 0; 0 1 0];
hE = [0 0 0; 0 -1 1; 0 0 0];
hW = [0 0 0; 1 -1 0; 0 0 0];
hNE = [0 0 1; 0 -1 0; 0 0 0];
hSE = [0 0 0; 0 -1 0; 0 0 1];
hSW = [0 0 0; 0 -1 0; 1 0 0];
hNW = [1 0 0; 0 -1 0; 0 0 0];


for t = 1:num_iter

       
        nablaN = imfilter(diff_im,hN,'conv');
        nablaS = imfilter(diff_im,hS,'conv');   
        nablaW = imfilter(diff_im,hW,'conv');
        nablaE = imfilter(diff_im,hE,'conv');   
        nablaNE = imfilter(diff_im,hNE,'conv');
        nablaSE = imfilter(diff_im,hSE,'conv');   
        nablaSW = imfilter(diff_im,hSW,'conv');
        nablaNW = imfilter(diff_im,hNW,'conv'); 
        
        
        if opt == 1
            cN = exp(-(nablaN/ka).^2);
            cS = exp(-(nablaS/ka).^2);
            cW = exp(-(nablaW/ka).^2);
            cE = exp(-(nablaE/ka).^2);
            cNE = exp(-(nablaNE/ka).^2);
            cSE = exp(-(nablaSE/ka).^2);
            cSW = exp(-(nablaSW/ka).^2);
            cNW = exp(-(nablaNW/ka).^2);
        elseif opt == 2
            cN = 1./(1 + (nablaN/ka).^2);
            cS = 1./(1 + (nablaS/ka).^2);
            cW = 1./(1 + (nablaW/ka).^2);
            cE = 1./(1 + (nablaE/ka).^2);
            cNE = 1./(1 + (nablaNE/ka).^2);
            cSE = 1./(1 + (nablaSE/ka).^2);
            cSW = 1./(1 + (nablaSW/ka).^2);
            cNW = 1./(1 + (nablaNW/ka).^2);
        end

       
        diff_im = diff_im + ...
                  de_t*(...
                  (1/(dy^2))*cN.*nablaN + (1/(dy^2))*cS.*nablaS + ...
                  (1/(dx^2))*cW.*nablaW + (1/(dx^2))*cE.*nablaE + ...
                  (1/(dd^2))*cNE.*nablaNE + (1/(dd^2))*cSE.*nablaSE + ...
                  (1/(dd^2))*cSW.*nablaSW + (1/(dd^2))*cNW.*nablaNW );
           
       
        
end