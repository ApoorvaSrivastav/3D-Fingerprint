function [surfNormals,surfNormals_red,surfNormals_green,surfNormals_Blue] =  Stereo_Normal( directory, imagename, numImages)
    
  %Read the lights and directions:
%   ***********************************************************************
   
    lightMatrix = load('C:\Users\Asus\Documents\Research\3DFingerprint\After8May\PhotometricStereo\New_Code\Calibration Images\17 July\Light.mat');
    lightMatrix = load(strcat( directory, '/', imagename, '/','Light.mat'));
    
    lightMatrix = cell2mat(struct2cell( lightMatrix) );
Read the mask file and threshold the values
%   *************************************************************************
    maskfile  = strcat( directory, '/', imagename, '/', imagename,'.mask.jpg'); %thresholding the mask for a given image
    maskImage = imread( maskfile );

    nrows  = size(maskImage,1);
    ncols  = size(maskImage,2);

    maxval = max(max(maskImage) );

    for i = 1:nrows
    for j = 1:ncols
       if( maskImage(i,j) == maxval)
           maskImage(i,j) = 1;
       else
           maskImage(i,j) = 0;
       end
    end
    end

%   *****************************************************************************
%   Read all the images .,, ( In RGB Format...
%   *****************************************************************************
    accumImage = zeros(nrows, ncols, 3);           % Summing the pixel-wise values of all images of same object 
%   Read all the images..                          % in different lights in a single matrix 
    for im = 1:numImages                           % numImages provided as input to the functionn at the very beginning
        id = num2str(im-1);
        filename = strcat( directory, '/', imagename, '/', imagename, '.', id, '.jpg');
        newImage = imread(filename);                   % each image is read in the variable newImage one-by-one
	if( size(newImage,1) ~= nrows) 
	    fprintf( ' mask image and source image size do not match ');
	    return;
        end
	if( size(newImage,2) ~= ncols) 
	    fprintf( ' mask image and source image size do not match ');
	    return;
        end

        for i = 1:nrows
        for j = 1:ncols
            accumImage(i,j,1) = accumImage(i,j,1) + double(newImage(i,j,1));
            accumImage(i,j,2) = accumImage(i,j,2) + double(newImage(i,j,2));
            accumImage(i,j,3) = accumImage(i,j,3) + double(newImage(i,j,3));
        end
        end

	images(:,:,:,im) = newImage;                          % Matrix containing all rgb images of one object 
	%grayImageSet(:,:,im) = rgb2gray(newImage);            % Matrix containing all gray images of one object 
    end

    for i = 1:nrows
    for j = 1:ncols
        r = accumImage(i,j,1);
        g = accumImage(i,j,2);
        b = accumImage(i,j,3);                               % Masking out those image pixel regions 
       if( r  < 1.0 || g < 1.0 || b < 1.0 )              % where lighting couldn't reach in any lighting condition 
           maskImage(i,j) = 0;                           % and hence can't be used for photomeetric stereo calculation
       end
    end
    end
%   *****************************************************************************
%   Photometric Calculations starts from here 
%   *****************************************************************************
%   *****************************************************************************
% %   Process Red Channel for Red Albedo and Normals
% %   *****************************************************************************
    [surfNormals_red, albedo_red] = NormalMap(images, lightMatrix, maskImage, 1); % Albedo for Red means how much red was reflected  
    save_data( surfNormals_red, albedo_red, maskImage, strcat( directory, '/', imagename, '/','redChannel.dat'));
    pixels=surfNormals_red*255;
    image(pixels)
    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_red.png'));
    
    %*****************************************************************************
% %   Process Green Channel for Green Albedo and Normals
% %   *****************************************************************************
    [surfNormals_green, albedo_green] = NormalMap(images, lightMatrix, maskImage, 2); % Albedo for Red means how much red was reflected  
    save_data( surfNormals_green, albedo_green, maskImage, strcat( directory, '/', imagename, '/','greenChannel.dat'));
    pixels=surfNormals_green*255;
    image(pixels)
    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_green.png'));
    
    % %   Process Blue Channel for Blue Albedo and Normals
% %   *****************************************************************************
    [surfNormals_Blue, albedo_Blue] = NormalMap(images, lightMatrix, maskImage, 3); % Albedo for Blue means how much red was reflected  
    save_data( surfNormals_Blue, albedo_Blue, maskImage, strcat( directory, '/', imagename, '/','BlueChannel.dat'));
    pixels=surfNormals_Blue*255;
    image(pixels)
    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_Blue.png'));
    
    % %   Process Gray Channel for Gray Albedo and Normals
% %   *****************************************************************************
    [surfNormals, albedo] = NormalMap(images, lightMatrix, maskImage, 0); % Albedo for Blue means how much red was reflected  
    save_data( surfNormals, albedo, maskImage, strcat( directory, '/', imagename, '/','GrayChannel.dat'));
    pixels=surfNormals*255;
    image(pixels)
    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap.png'));

end
%*******************************************************************************
function save_data( surfNormals, albedo, maskImage, filename )

   fid = fopen( filename, 'w' );

   nrows  = size(maskImage,1);
   ncols  = size(maskImage,2);

   for i = 1:nrows
   for j = 1:ncols
       xg(i,j) = double(j)/double(ncols);                             % normalized x location in right handed coordinate systems
       yg(i,j) = double(nrows-i+1)/double(nrows);                     % normalized x location in right handed coordinate systems
   end
   end

   fprintf( fid, '%d %d \n', nrows, ncols); 
   for i = 1:nrows
   for j = 1:ncols
       nx  = surfNormals(i,j,1);
       ny  = surfNormals(i,j,2);
       nz  = surfNormals(i,j,3);
       alb = albedo(i,j);
       if( maskImage(i,j)  )
           msk = 1;
       else
           msk = 0;
       end
       fprintf( fid, '%d %f %f %f %f %f %f %f \n', msk, xg(i,j), yg(i,j), nx, ny, nz, alb);
   end
   end

end
