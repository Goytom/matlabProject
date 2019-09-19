% Question 3 
function ThirdQuestion()
  Image3 = imread("mystery.png");  
  orgnlImage = rgb2gray(Image3);
  %%% Outputs
  linScaled = uint8(linScaling(orgnlImage));
  HistEqualized = uint8(histEqualization(orgnlImage));
  % '20' as a block size gave best results, that helped to catch hidden images
  blockSize = 20;
  [lin_scaled_img, ~] = updateHistInBlocks(orgnlImage, blockSize);
  
  subplot(2,2,1)
  imshow(orgnlImage);
  title('Original Image');
  
  subplot(2,2,2);
  imshow(linScaled);
  title('Linearly Scaled');
  
  subplot(2,2,3);
  imshow(HistEqualized);
  title('Histogram Equalized');
  
  subplot(2,2,4);
  imshow(uint8(lin_scaled_img));
  title("Blockwise Linearly Equalized");
  
  % Part-1 Linear Scaling
  
  function im_scaled = linScaling(Im)
    % Function  for computing linear scaling
    img = double(Im);
    [x, y] = size(img);
    im_scaled = zeros(x, y);
    mn = min(min(img));
    mx = max(max(img));
    for i = 1: x
        for k = 1: y
            % use the histogram formula
            im_scaled(i, k) = (img(i, k) - mn)*255/(mx - mn);
        end
    end
  end

  % Part-2 Histogram Equalisation
  
  % 2.1 Image Histogram  
  function histogr = calcHist(im)
    % To calculate histogram of an image    
    imag = double(im);
    [h, k] = size(imag);
    % Create a frequency array of size 256
    histogr = 1:256;
    count = 0; 
    % Iterate every possible intensity value and count them 
    for i = 1 : 256 
        for jj = 1 : h 
            for kk = 1 : k      
                % if image pixel value at location (jj, kk) is i-1 
                % then increment count 
                if imag(jj, kk) == i-1 
                        count = count + 1; 
                end
            end
        end
        % update i'th position of frequency array with count 
        histogr(i) = count;
        % reset count 
        count = 0; 
    end
    
  end

  % 2.2 Cumulative Density Function
  
  function C = imageCDF(Histo)
    % Function to calculate CDF of an image
    C = zeros(1,256);
    for n = 1:256
        % Accomulate values from the first value to the current index value
        C(n) = sum(Histo(1:n));
    end
  end

  % 2.3 Applying Histogram Equalisation
  
  function im_equalized = histEqualization(im) 
      % Function to enhance contrast 
      % by applying histogram and CDF functions
      img = double(im);
      [x,y] = size(im);
      im_equalized = zeros(x,y);
      histo = calcHist(img);
      C = imageCDF(histo);
      Cx = C(C~=0);
      CDFmnm = min(Cx);
      N = size(img,1)*size(img,2);
      W = 255/(N-CDFmnm); 
      for n = 1:x
          for m = 1:y
              % Make use of transfer function
              im_equalized(n,m) = W*(C(img(n,m) + 1) - CDFmnm);
           end
      end
  end

  % 3 Block-wise Contrast Enhancement
  
  function [lin_scaled_im, hist_eq_im]  = updateHistInBlocks(im, blocksize)
      % Apply Linear scaling and Histogram equalization block-by-block
      img = double(im);
      [x,y] = size(im);
      blocksRow = 1:blocksize:size(im,1);
      blocksColumn = 1:blocksize:size(im,2);
      lin_scaled_im = zeros(x,y,3);
      hist_eq_im = zeros(x,y);
      for n = 1:size(blocksRow,2)-1
          for m = 1:size(blocksColumn,2)-1
              v1 = blocksRow(n):blocksRow(n+1)-1;
              v2 = blocksColumn(m):blocksColumn(m+1)-1;
              blockIm = img(v1,v2);
              % Required inputs for Linear Enhancement
              mn = min(min(blockIm));
              mx = max(max(blockIm));
              % Inputs for Histogram equalization
              histo = calcHist(blockIm);
              C = imageCDF(histo);
              Cx = C(C~=0);
              CDFmnm = min(Cx);
              N = size(img,1)*size(img,2);
              W = 255/(N-CDFmnm);              
              for i = v1
                  for k = v2
                      % Use enhancement functions on the current block 
                      lin_scaled_im(i,k,2) = (img(i,k) - mn)*255/(mx - mn);
                      hist_eq_im(i,k) = W*(C(img(n,m) + 1) - CDFmnm);
                  end
              end
          end
      end
             
    end

end