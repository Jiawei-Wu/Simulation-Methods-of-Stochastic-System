%Implement random number generator
for i=1:1000
sigma=[3 -1 1; -1 5 3; 1 3 4];
A=chol(sigma,'lower');%Applying the cholesky decomposition to given matrix
Z=randn(3,1);
mu=[1;2;3];
X(i,:)=A*Z+mu;
end

%Compute sample covariance matrix
for i=1:3
    for j=1:3
        cov1=cov(X(:,i),X(:,j));
        cov2(i,j)=cov1(1,2);
    end
end

%Compute sample mean matrix
for i=1:3
   mean1(i)=mean(X(:,i));
end

sigma_matrix=cov2;
mean_matrix=mean1';
scatter3(X(:,1),X(:,2),X(:,3));
title('3D Sample Distribution');
figure;
scatter(X(:,1),X(:,2));
title('2D Sample Distribution');
figure;
scatter(X(:,1),X(:,3));
title('2D Sample Distribution');
figure;
scatter(X(:,2),X(:,3));
title('2D Sample Distribution');