function Depth( maskImage,surfNormals,surfNormals_red,surfNormals_green,surfNormals_Blue)
    
    % Red Channel
       %Least Square
    z_red = DepthMap_small( surfNormals_red, maskImage );
    figure, surfl(z_red)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_red_ls.fig')
    save_data( surfNormals_red, maskImage, z_red, strcat( directory, '/', imagename, '/','redChannel_ls.dat'));
       %Chellappa
    z_red = GradientofNormal_v2(surfNormals_red);
    figure,surfl(z_red)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_red_Chellappa.fig')
    save_data( surfNormals_red, maskImage, z_red, strcat( directory, '/', imagename, '/','redChannel_Chellappa.dat'));

    
 %   *****************************************************************************
 % Green Channel
       %Least Square
    z_green = DepthMap_small( surfNormals_green, maskImage );
    figure, surfl(z_green)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_green_ls.fig')
    save_data( surfNormals_green, maskImage, z_green, strcat( directory, '/', imagename, '/','greenChannel_ls.dat'));
       %Chellappa
    z_green = GradientofNormal_v2(surfNormals_green);
    figure,surfl(z_green)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_green_Chellappa.fig')
    save_data( surfNormals_green, maskImage, z_green, strcat( directory, '/', imagename, '/','greenChannel_Chellappa.dat'));

    
 %   *****************************************************************************
 % Blue Channel
       %Least Square
    z_Blue = DepthMap_small( surfNormals_Blue, maskImage );
    figure, surfl(z_Blue)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_Blue_ls.fig')
    save_data( surfNormals_Blue, maskImage, z_Blue, strcat( directory, '/', imagename, '/','BlueChannel_ls.dat'));
       %Chellappa
    z_Blue = GradientofNormal_v2(surfNormals_Blue);
    figure,surfl(z_Blue)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_Blue_Chellappa.fig')
    save_data( surfNormals_Blue, maskImage, z_Blue, strcat( directory, '/', imagename, '/','BlueChannel_Chellappa.dat')); 
    
  
 %   *****************************************************************************
 % Gray Channel
       %Least Square
    z = DepthMap_small( surfNormals, maskImage );
    figure, surfl(z)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_Gray_ls.fig')
    save_data( surfNormals, maskImage, z, strcat( directory, '/', imagename, '/','GrayChannel_ls.dat'));
       %Chellappa
    z = GradientofNormal_v2(surfNormals);
    figure,surfl(z)   %function to create 3D depthmap
    shading interp; colormap gray
    saveas(gcf,'z_Gray_Chellappa.fig')
    save_data( surfNormals, maskImage, z, strcat( directory, '/', imagename, '/','GrayChannel_Chellappa.dat'));   
end
function save_data( surfNormals, maskImage, z, filename )

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
       
       if( maskImage(i,j)  )
           msk = 1;
       else
           msk = 0;
       end
       fprintf( fid, '%d %f %f %f %f %f %f %f \n', msk, xg(i,j), yg(i,j), z(i,j), nx, ny, nz);
   end
   end

end


