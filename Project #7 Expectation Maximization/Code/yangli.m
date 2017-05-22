close all;
clear;
clc;

%% Sample Generate
N=5000;
a_real =[3/10,5/10,2/10];
mu_real = [7,12;12,7;14,15];
cov_real(:,:,1) = [1,0;0,1];
cov_real(:,:,2) = [3,1;1,3];
cov_real(:,:,3) = [3,1;1,3];
X_1 = mvnrnd(mu_real(1,:),cov_real(:,:,1),N*a_real(1));
X_2 = mvnrnd(mu_real(2,:),cov_real(:,:,2),N*a_real(2));
X_3 = mvnrnd(mu_real(3,:),cov_real(:,:,2),N*a_real(3));

X=[X_1;X_2;X_3];
X = X(randperm(size(X,1)),:);

%% Sample Ploting
x = 0:0.5:20;
y = 0:0.5:20;
[x y]=meshgrid(x,y);
mesh = [x(:),y(:)];

z_real = a_real(1)*mvnpdf(mesh,mu_real(1,:),cov_real(:,:,1))+...
        a_real(2)* mvnpdf(mesh,mu_real(2,:),cov_real(:,:,2))+...
        a_real(3)* mvnpdf(mesh,mu_real(3,:),cov_real(:,:,3));
subplot(2,3,1);
plot(X_1(:,1),X_1(:,2),'x',X_2(:,1),X_2(:,2),'o',X_3(:,1),X_3(:,2),'<')

subplot(2,3,2);
contour(x,y,reshape(z_real,size(x,2),size(y,2)));

subplot(2,3,3);
surf(x,y,reshape(z_real,size(x,2),size(y,2)));

subplot(2,3,4);
plot(X(:,1),X(:,2),'x');
%%subplot(2,2,3);
%%surf(x,y,reshape(z_real,size(x,2),size(y,2)));
%%shading interp;

%% Parameter Initialization
a = [1/3, 1/3,1/3];
cov(:,:,1) = [1,0;0,1];
cov(:,:,2) = [1,0;0,1];
cov(:,:,3) = [1,0;0,1];
mu_y_init = (max(X(:,1))+min(X(:,1)))/2;
mu_x1_init = max(X(:,2))/4+3*min(X(:,2))/4;
mu_x2_init = 2*max(X(:,2))/4+2*min(X(:,2))/4;
mu_x3_init = 3*max(X(:,2))/4+1*min(X(:,2))/4;
w = zeros(size(X,1),length(a)); %%w(i,j),i??????j??????w(i,j)??????i????j?????????i???
mu = [mu_x1_init,mu_y_init;mu_x2_init,mu_y_init;mu_x3_init,mu_y_init];

%% EM Implementation
iter = 40;
for i = 1:iter
    %% Expectaion: ???????????????????????????????????????
    for j = 1 : length(a)
        w(:,j)=a(j)*mvnpdf(X,mu(j,:),cov(:,:,j));
    end   
w=w./repmat(sum(w,2),1,size(w,2)); %%????./????????w?????????????????????w(:,1)+w(:,2)??

%% Maximum: ????????????????????????????????????????
    a = sum(w,1)./size(w,1); %%?w?????????????????????
    
    mu = w'*X; %%????X??????????????mu(i,j),i????j????
    mu= mu./repmat((sum(w,1))',1,size(mu,2));
        
    for j = 1 : length(a)
        vari = repmat(w(:,j),1,size(X,2)).*(X- repmat(mu(j,:),size(X,1),1)); %%????????X???????????w??????????????X?
        cov(:,:,j) = (vari'*vari)/sum(w(:,j),1);      
    end
end

%% Estimation
[c estimate] = max(w,[],2);

%% Estimation Plotting
z = a(1)*mvnpdf(mesh,mu(1,:),cov(:,:,1))+...
        a(2)* mvnpdf(mesh,mu(2,:),cov(:,:,2))+...
        a(3)* mvnpdf(mesh,mu(3,:),cov(:,:,3));
subplot(2,3,5);
contour(x,y,reshape(z,size(x,2),size(y,2)));

one = find(estimate==1); 
two = find(estimate == 2);
three = find(estimate == 3);
% Plot Examples
subplot(2,3,6);
plot(X(one, 1), X(one, 2), 'x',X(two, 1), X(two, 2), 'o', X(three, 1), X(three, 2), '<');
%plot(X(neg, 1), X(neg, 2), 'o');
