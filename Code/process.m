function z_mod = process(z)
window=15;
load('points.mat');
z_mod = zeros(size(z));
for i= 1:window:size(z,1)
    for j= 1:window:size(z,2)
        if i+window<size(z,1) && j+window<size(z,2)
        A = z(i:i+window,j:j+window);
        %range =max(points(i:i+2,j:j+2))
        A= rescale(A,min(points(i:i+window,j:j+window)),max(points(i:i+window,j:j+window)+35));
        z_mod(i:i+window,j:j+window)=A;
        end
    end
end