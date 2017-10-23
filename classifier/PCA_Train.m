function W_PCA = PCA_Train(data, cutoff)

% Train PCA -- Eigen decomposition
if size(data,2) < size(data,1)
    C = data'*data;
    [FullV, FullD] = eig(C);
    FullD = diag(FullD);
    FullD = FullD(end:-1:1);
    FullV = FullV(:, end:-1:1);
    disp('Eigen decomposition done.');
    
    % Train PCA -- Truncate
    if cutoff < 1
        I = cumsum(FullD)/sum(FullD);
        I = find(I>=cutoff);
        n_PCA_Reserved = I(1);
        fprintf('n_PCA is %d at %f energy.\n', n_PCA_Reserved, cutoff);
    else
        n_PCA_Reserved = cutoff;
    end
    V = FullV(:, 1:n_PCA_Reserved);
    D = FullD(1:n_PCA_Reserved);
    
    W_PCA = data * V;% ./ repmat(sqrt(D'), [size(img1_train,1), 1]);
    parfor i = 1 : size(W_PCA,2)
        W_PCA(:,i) = W_PCA(:,i) / sqrt(D(i));
    end
else
    C = data * data';
    [FullV, FullD] = eig(C);
    FullD = diag(FullD);
    FullD = FullD(end:-1:1);
    FullV = FullV(:, end:-1:1);
    disp('Eigen decomposition done.');
    % Train PCA -- Truncate
    if cutoff < 1
        I = cumsum(FullD)/sum(FullD);
        I = find(I>=cutoff);
        n_PCA_Reserved = I(1);
        fprintf('n_PCA is %d at %f energy.\n', n_PCA_Reserved, cutoff);
    else
        n_PCA_Reserved = cutoff;
    end
    V = FullV(:, 1:n_PCA_Reserved);
    D = FullD(1:n_PCA_Reserved);
    
    W_PCA = V;   
end
