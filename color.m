X = imread('floral.png');
X = X(1:760, 1:760, :);

R = X(:, :, 1);
G = X(:, :, 2);
B = X(:, :, 3);

C = dctmtx(8);
dct = @(block) C' * block.data * C;
inv = @(block) C * block.data * C';
quant = @(block) round(block.data./Q).*Q

s = 8;
Q = zeros(8);
for i = 1:8
    for j = 1:8
        if (i+j)<(s+2)
            Q(i,j) = 1;
        end
    end
end
f = @(block) round(block.data ./ Q).*Q;
%red
R = im2double(R);

R = 255*R - 128;
%R(1:8, 1:8) make sure its integers
Y = blockproc(R, [8 8], dct);
Y1 = blockproc(Y, [8 8], f);
R1 = blockproc(Y1, [8 8], inv);
R1 = R1 + 128;

R1(1:20, 1:20)

%green
G = im2double(G);
G = 255*G -128;
Y = blockproc(G, [8 8], dct);
Y1 = blockproc(Y, [8 8], f);
G1 = blockproc(Y1, [8 8], inv);
G1 = G1 + 128;

G1(1:20, 1:20)

%blue
B = im2double(B);
B = 255*B -128;
Y = blockproc(B, [8 8], dct);
Y1 = blockproc(Y, [8 8], f);
B1 = blockproc(Y1, [8 8], inv);
B1 = B1 + 128;

B1(1:20, 1:20)

X2 = X;
X2 = im2double(X2);
X2(:, :, 1) = R1;
X2(:, :, 2) = G1;
X2(:, :, 3) = B1;


%rank k approximations with sing val decomp
k = 50;

[U, S, V] = svd(R);
Rk = U(:, 1:k) * S(1:k, 1:k) * V(:, 1:k)';

[U, S, V] = svd(G);
Gk = U(:, 1:k) * S(1:k, 1:k) * V(:, 1:k)';

[U, S, V] = svd(B);
Bk = U(:, 1:k) * S(1:k, 1:k) * V(:, 1:k)';

Xk = X;
Xk(:,:, 1) = Rk;
Xk(:, :, 2) = Gk;
Xk(:, :, 3) = Bk;

imshow(Xk);



