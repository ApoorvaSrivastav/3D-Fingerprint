function PS()
prompt = 'What is the directory name?(string)';
directory = input(prompt);
prompt = 'What is the Image name?(string)';
imagename = input(prompt);
prompt = 'What is the number of Images?(int)';
numImages = input(prompt);
[surfNormals,surfNormals_red,surfNormals_green,surfNormals_Blue] =  Stereo_Normal( directory, imagename, numImages);
Depth( maskImage,surfNormals,surfNormals_red,surfNormals_green,surfNormals_Blue);
end
