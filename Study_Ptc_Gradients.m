%% Script to study Ptc gradients from different experimental samples and conditions

% Software to normalize and compute statistical studies for PTC
% gradient profiles in Drosophila wing discs 


data=Libro1; % Rename the input data
th=0.3; % Initial signal value (threshold for the origin)
span=15; % Number of neighbors points that take into account for the averaging. (Smooth parameter for the discrete intensities of confocal data)
NumInt=2; % Number of columns per sample
CorrFE1=10; % Factor of correction of the Intensities (To compensate problems of compatibility between numerical data from FIJI, Excel and Matlab)
CorrFE2=1000; % Factor of correction of the Normalization values (To compensate problems of compatibility between numerical data from FIJI, Excel and Matlab)
bin=0.002; % Min size in microns for statistical sample study
length=0.4; % Length to plot and study of the total sample
colorV='y'; % Color of the variability area
separate=0; % If the value is 1 then plot separate figures
reverse=0; % If the value is 1 then plot x inverse direction
GL=0.2; % Value of the length (Normalized to 1) that you want to study of the total gradient (Ltot=1)
RI=0.01; % Range of intensities values for the threshold

%% Script: 

% Organized the input data


s=size(data,1); % Identify the size of the x data
n=size(data,2)/NumInt; % Identify the number of discs
EXPNorm=Libro2(1:NumInt:NumInt*n)/CorrFE2;
for l=1:s
    for k=1:NumInt*n    
        if Libro1(l,k)<=1.1        
        else       
            data(l,k)=Libro1(l,k)/CorrFE1;
        end 
    end
end

    for k=1:NumInt:NumInt*n    
    data(1,k)=0;
    end
for l=2:12
    for k=1:NumInt:NumInt*n    
    if isnan(Libro1(l,k))==1
        data(l,k)=data(l-1,k)+(data(14,k)-data(13,k));
    end
    end
end

% Creates NaN matrix to organize and operate the data
xExp=NaN(s,n);
IntPTCExp=NaN(s,n);
IntCIExp=NaN(s,n);
XNorm=NaN(s,n);
INorm=NaN(s,n);
IPTCNorm=NaN(s,n);
ICINorm=NaN(s,n);
INorm2=NaN(s,n);
IPTCNorm2=NaN(s,n);
ICINorm2=NaN(s,n);
SmoX=NaN(s,n);
SmoI=NaN(s,n);
SmoIPTC=NaN(s,n);
SmoICI=NaN(s,n);
SmoXNorm=NaN(s,n);
SmoINorm=NaN(s,n);
SmoIPTCNorm=NaN(s,n);
SmoICINorm=NaN(s,n);


% For loop to define and calculate the PTC curves

i=1;
for l=1:NumInt:(n*NumInt-1) 
    
xExp(:,i)=data(:,l); % Rename the matrix column of x
XNorm(:,i)=xExp(:,i)/EXPNorm(i); % Normalization by Lp

IntPTCExp(:,i)=data(:,l+1);

SmoIPTC(:,i)=smooth(IntPTCExp(:,i),span);

% Smooth of the experimental intensity data
p=find(XNorm(:,i)<length, 1, 'last' );
MaxPTCI=nanmax(SmoIPTC(1:p,i));  % Find the maximum of the signal
MinPTCI=nanmin(SmoIPTC(1:p,i)); % Find the minimum of the signal
IPTCNorm2(:,i)=(SmoIPTC(:,i)-MinPTCI)/(MaxPTCI-MinPTCI); % Normalization of the intensity by the max and min

i=i+1;

end

%% Plot the data

% Plot data organized from AP border

XNS=NaN(s,n);
PtcEXP=NaN(s,n);

j=1;
for i=1:n
l=find(IPTCNorm2(:,i)>th, 1, 'first' );
a=XNorm(2,i)-XNorm(1,i);
xn=NaN((s-l+1),1);
xn(1)=0;
for g=2:(s-l+1)
xn(g)=xn(g-1)+a;
end

XNS(l:s,i)=xn;
PtcEXP(l:s,i)=IPTCNorm2(l:s,i);

j=j+1;
end

%% Find the lenth of the gradient

% Compute the length of the gradient for the threshold considered

Lg=NaN(1,n);
XN2=XNorm;
for z=1:n
    p=find(XNorm(:,z)<length, 1, 'last' );
    [ith]=find((GL-RI)<PtcEXP(1:p,z) & PtcEXP(1:p,z)<(GL+RI),3,'first');
    Temp=isnan(PtcEXP(:,z));
    temp1=find(Temp==0,1,'first');
    XN2(:,z)=XN2(:,z)-XN2(temp1,z);
    Lg(z)=mean(XN2(ith,z));
    
end

%% Compute the mean and the variability to plot the data

dataX=reshape(XNS,size(XNS,1)*size(XNS,2),1);
dataEXP=reshape(PtcEXP,size(PtcEXP,1)*size(PtcEXP,2),1);
f2=NaN(size(dataX,1),round(length/bin));
j=1;
for l=0:bin:(length-bin)
    
for i=1:size(dataX,1)

    if dataX(i,1)>l
    if dataX(i,1)<=(l+bin)
        f2(i,j)=dataEXP(i,1);
    end
    end
    
end
j=j+1;
end

MeanID2=nanmean(f2);
StdID2=nanstd(f2);
Variability2=NaN(round(length/bin),2);

for l=1:length/bin
Variability2(l,1)=MeanID2(l)+StdID2(l);
Variability2(l,2)=MeanID2(l)-StdID2(l);
end

if separate==1
figure;   
end
xN=bin:bin:length;
hold on
plot(xN,MeanID2,'.--','Markersize',5)
fstr=colorV;
y2=Variability2';

    px2=[y2(1,:), fliplr(y2(2,:))];
    py2=[xN,fliplr(xN)];
    patch(py2,px2,1,'FaceColor',fstr,'EdgeColor','none');
    alpha(.2); % make patch transparent

        xlabel('Normalized X','Fontsize',18);ylabel('Normalized Ptc signal','Fontsize',18);
if reverse==1
        set(gca,'XDir','Reverse')
end
        grid on   

        [ith]=find((GL-RI)<MeanID2 & MeanID2<(GL+RI));
        lg=mean(xN(ith));