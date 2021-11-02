%function [surfNormals,z] =  Stereo_v3( directory, imagename, numImages)
    directory = 'Images';
    imagename = 'F';
    numImages = 7;
    %numImages = 12;
  %Read the lights and directions:
%   ***********************************************************************
   % numLights = 7;
    %numLights = 12;
    %lightMatrix = load('C:\Users\Asus\Documents\Research\3DFingerprint\After8May\PhotometricStereo\New_Code\Images\11Oct\Light.mat');
    lightMatrix = load(strcat( directory, '/', imagename, '/','Light.mat'));
    
    lightMatrix = cell2mat(struct2cell( lightMatrix) );
   % Read the lights and directions:
%   ***********************************************************************
%     lightfile = strcat( directory, '/',imagename,'/', 'lights.txt')  %stores the name of the lightfile
%     fid = fopen(lightfile, 'r');                       %opening the lightfile
%     numLights = 1;                                     %defining the dimension of value telling the number of lights 
%     numLights = fscanf(fid, '%d \n', [1]);             %at the top of the lights file the number of lights is written
%                                                        %as integer which is scanned in the mentioned format
%     LightMatrix = [];
%     for i = 1:numLights
%         lightDir = fscanf(fid, '%f %f %f \n', [3]);    %scanning the direction component of normal vectors of Light direction
% 	lightDir = lightDir/norm(lightDir);                %converting light vectors to unit normals
% 	lightMatrix(i,:) = lightDir;                       %conpiling all light directions in the light matrix
    %end
%     %   *************************************************************************
%   Read the mask file and threshold the values
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
	grayImageSet(:,:,im) = rgb2gray(newImage);            % Matrix containing all gray images of one object 
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
    z = zeros(nrows, ncols);                           % Matrix of zeros equal to size of one image channel

%   *****************************************************************************
% %   Process Red Channel for Red Albedo
% %   *****************************************************************************
%    [surfNormals_red, albedo_red] = NormalMap(images, lightMatrix, maskImage, 1); % Albedo for Red means how much red was reflected
%    prompt='Red_Channel_Depth'
%    z_red = DepthMap_small( surfNormals_red, maskImage );
%    surfl(z_red)   %function to create 3D depthmap
%    shading interp; colormap gray
%    save_data( surfNormals_red, albedo_red, maskImage, z_red, strcat( directory, '/', imagename, '/','redChannel.dat'));
%    pixels=surfNormals_red*255;
%    im=image(pixels);
%    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_red.png'));
% %   *****************************************************************************
% %   Process Green Channel for Green Albedo
% %   *****************************************************************************
%  
% [surfNormals_green, albedo_green] = NormalMap(images, lightMatrix, maskImage, 1); % Albedo for Red means how much red was reflected
%    prompt='green_Channel_Depth'
%    z_green = DepthMap_small( surfNormals_green, maskImage );
%    surfl(z_green)  %function to create 3D depthmap
%    shading interp; colormap gray
%    save_data( surfNormals_green, albedo_green, maskImage, z_green, strcat( directory, '/', imagename, '/','greenChannel.dat'));
%    pixels=surfNormals_green*255;
%    im=image(pixels);
%    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_green.png'));  %   *****************************************************************************
% %   Process Blue Channel for Blue Albedo
% %   *****************************************************************************
% [surfNormals_blue, albedo_blue] = NormalMap(images, lightMatrix, maskImage, 1); % Albedo for Red means how much red was reflected
%    prompt='Blue_Channel_Depth'
%    z_blue = DepthMap_small( surfNormals_blue, maskImage );
%    surfl(z_blue)  %function to create 3D depthmap
%    shading interp; colormap gray
%    save_data( surfNormals_blue, albedo_blue, maskImage, z_blue, strcat( directory, '/', imagename, '/','blueChannel.dat'));
%    pixels=surfNormals_blue*255;
%    im=image(pixels);
%    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_blue.png'));  
%   *****************************************************************************
%   Use Gray channel for Normal and Depth Map
%   *****************************************************************************

   [surfNormals, albedo] = NormalMap(images, lightMatrix, maskImage, 0);
%    
   %    directory = 'Images';
   % imagename = 'finger';
   prompt ='Gray_Channel_Depth'
%      z = DepthMap_small( surfNormals, maskImage );
%      surfl(z)   %function to create 3D depthmap
%      shading interp; colormap gray
%     save_data( uint8(pixels), albedo, maskImage, z,strcat( directory, '/', imagename, '/','leastsquare_gray.dat'));
%    pixels=surfNormals*255;
%    im=image(pixels);
%    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_gray_ls.jpg')); 
   %surfl(z);   %function to create 3D depthmap
   %shading interp; colormap gray
%    ptCloud = pCloud(z);
%    pcwrite(ptCloud,'PointCloud.ply','PLYFormat','ascii');
%end
z = GradientofNormal_v2(surfNormals,maskImage);
figure,surfl(z)   %function to create 3D depthmap
shading interp;colormap gray
point_cloud_generator(z,directory,imagename);    
   %pixels=surfNormals*255;
   %im=image(pixels);
%    save_data( uint8(pixels), albedo, maskImage, z,strcat( directory, '/', imagename, '/','least_square.dat'));
%    imwrite(pixels,strcat( directory, '/', imagename, '/','NormalMap_gray_ls.jpg')); 
%*******************************************************************************

% ptCloud = pCloud(z);
% pcwrite(ptCloud,'PointCloud.ply','PLYFormat','ascii');
% function [ptCloud] = pCloud(z)
%     x=size(z,1);
%     y=size(z,2);
%     ptCloud=zeros(x*y,3);
%     k=1;
%     for i =1:x
%         for j=1:y
%             ptCloud(k,1)=i;
%             ptCloud(k,2)=j;
%             ptCloud(k,3)=z(i,j);
%             k=k+1;
%         end
%     end
%     ptCloud = pointCloud(ptCloud);
% end
function save_data( surfNormals, albedo, maskImage, z, filename )

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
       fprintf( fid, '%d %f %f %f %f %f %f %f \n', msk, xg(i,j), yg(i,j), z(i,j), nx, ny, nz, alb);
   end
   end

end


