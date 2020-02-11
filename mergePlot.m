%% mergePlot is a powerful tool to plot the vector graphics of massive data. 
% It uses the degenerate displaying technique, which only shows the 
% superficial portrait of the whole data volume by ignoring the other parts 
% that have no actual contribution to the superficial portrait. 
%
% This code is aimed at only selecting the records that have at least 
% one pixel visible in the final output bitmap under a given resolution, 
% by judging the superposition relationship between all records in the 
% virtual bitmap in the memory. The degenerate vector graphics show 
% exactly the same results as the original figure plotted using the whole data set; 
% whereas, the wait time for plotting is greatly suppressed, and the figure size 
% is also significantly reduced. 
%
% We mark one record as active if one or more of its pixels can be seen 
% in the virtual bitmap in the memory, after judging the superposition relationship
% between this record and all previous marked records. This approach does not 
% degrade the quality of the final vector graphics, since it only selects 
% those marked records to plot. It can greatly suppress the final size of 
% the vector graphics and can significantly reduce the wait time of 
% drawing, editing, and displaying the vector graphics. 
%
% In an example of 410,642 earthquake catalogs, only 2577 records were selected. 
% The resulted degenerate vector graphics is only ~2.2 megabyte in size, 
% which is much smaller than that of the original size (~100+ megabyte). 
% The run time of the plotting is only several minutes, which is greatly reduced 
% from several hours for plotting all the records. The run time of the Matlab code
% for selecting the active records spends only ~14 s. 
%
% The degenerate vector graphics can drastically save on memory demand and 
% is helpful for wide dissemination of electronic publications in terms of vector graphics. 
% This technique would be helpful in plotting various types of massive data by faithfully presenting 
% all actual records involved, especially for the rapidly increasing amount of mass data.
%
%% subroutine 1:
% getmidpointcircle.m is used to simulate the pixel painting process by the midpoint circle algorithm.  
% This code is from Tinevez J. (2012). Circle pixel coordinates using mid-point algorithm, 
% https://www.mathworks.com/matlabcentral/fileexchange/33844-circle-pixel-coordinates-using-mid-point-algorithm
%% subroutine 2:
% circle.m: is used to plot circles by 
%% Input data: txt file in sequence of 
% x1, y1, a1;
% x2, y2; a2;
% ......
% Please refer to the demo data "M1.0-JapaEqMainland30km.dat".
%% Output data: active records that actually contribute to the final image.
% The output file is in the same sequence and data format as the input file.
%% Output figures: 
% circleSelected.pdf  % default
% circleAll.pdf       % need to uncomment the corresponding paragraph
% plotSelected.pdf    % need to uncomment the corresponding sentence
% plotAll.pdf         % need to uncomment the corresponding paragraph
%
%% Contact information
% Prof. Jinhai Zhang
% Institute of Geology and Geophysics,
% Chinese Academy of Sciences.
% P. O. Box 9825
% Beitucheng Western Road, 19#
% Beijing, 100029
% CHINA
%
% Phone:
% 86-10-82998013(Office)
% 86-13552750211(Mobile)
%  
% Email: zjh@mail.iggcas.ac.cn , geophysics.zhang@gmail.com
%
% Homepage:  http://sourcedb.igg.cas.cn/cn/zjrck/201001/t20100119_2728795.html 
% ResearchGate: https://www.researchgate.net/profile/Jin_Hai_Zhang 
% ORCID: https://orcid.org/0000-0001-6314-5299 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
w=7.5;  % Set the plot width w (cm)(in x-direction). One column 8.46->7.5; two column 17.5->16.5. This setting should be kept during the post processing of the vector graphics of the selected data set to guarantee the correctness of results.
        % The figure should be shown in equal size between x and y; thus, the height is determined by range of coordinates as well as the plot width w. 
dpi=300;% Set the output resolution dpi (number of points per inch).
amp=0.1;% Set the marker size (radius in longitude) for magnitude 1. 
%%%%%%%%%%%%%%
data=importdata('M1.0-JapanEqMainland30km.dat'); %input the data, which is in the following sequence:
n=data(:,1); % year
m=data(:,2); % month
d=data(:,3); % day
h=data(:,4); % hour
f=data(:,5); % minute
g=data(:,6); % second
y=data(:,7); % latitude   --- to be used
x=data(:,8); % longitude  --- to be used
z=data(:,9); % depth (km)
j=data(:,10);% magnitude  --- to be used
clear data

x0=min(x);   % minimum of longitude
y0=min(y);   % minimum of  latitude
x1=max(x);   % maximum of longitude
y1=max(y);   % maximum of  latitude 
maxJ=max(j); % maximum of magnitude
xx=x1-x0+2*amp*maxJ;    %range of plot width (in longitude) 
yy=y1-y0+2*amp*maxJ;    %range of plot height (in latitude)
N=floor(w*dpi/2.54+0.5);% number of pixels in x-direction 
M=floor(w*dpi/2.54*yy/xx+0.5);% number of pixels in y-direction 
s=xx/N; % width (in longitude) of each pixel

tic % Show current clock

p=zeros(N,M);        % pixel occupation:  1:occupied; 0:not occupied
q=logical(zeros(N,M));        % pixel occupation:  1:occupied; 0:not occupied
flag=zeros(size(j)); % mark the record:  1:marked; 0:not marked
for i=size(j,1):-1:1 % Plot the latest record uppermost; thus, we judge from the last record to simplify the algorithm. 
    r=j(i)*amp; % radius of circle marker (in longitude)
    ix2=floor((x(i)-x0+amp*maxJ)/s+0.5); % center of a circle (in pixel index)
    iy2=floor((y(i)-y0+amp*maxJ)/s+0.5); % center of a circle (in pixel index)
    radius=floor(r/s+0.5); % radius in pexels
    rr(i)=radius;
    [x3 y3]=getmidpointcircle(ix2, iy2, radius); % Plot the circle by the midpoint circle algorithm in the memory. 
                                                 % This founction is from Tinevez (2012), Circle pixel coordinates using mid-point algorithm, 
                                                 % https://www.mathworks.com/matlabcentral/fileexchange/33844-circle-pixel-coordinates-using-mid-point-algorithm
    for ii=1:round(numel(x3)/2)
        iy=y3(ii);
        for ix=x3(numel(x3)-ii+1 ):x3(ii)
            if  p(ix,iy)==0 %if 
                flag(i)=1; % mark the record as active by setting its flag==1
                p(ix,iy)=1;% paint the pixels that are not occupied before
            end
        end
    end
end

%% Output all selected records in the same sequence as the input data
fid = fopen('M1.0-JapanEqMainland30kmMerge.dat','wt');
for i=1:size(j,1) % output the marked records (if flag==1) in the same sequence as the input. 
    if flag(i)>0
        fprintf(fid,'%4d %2d %2d %2d %2d %6.2f %8.3f %8.3f %8.1f %7.1f \n',n(i),m(i),d(i),h(i),f(i),g(i),y(i),x(i),z(i),j(i));
    end
end
fclose(fid);

% %% This paragraph would show the side view of all records. 
% tic
% figure(1) 
% scatter3(x,y,z,j*amp*1000,'k');hold on; %'k' here means dot (not black color)
% xlabel('x'),ylabel('y'),zlabel('z');
% view(-120, 30);%set view angle
% title('Side view of all')
% tScatter3All=toc

% %% This paragraph would show the plot of all records with 'plot' command.
% tic
% figure(2);
% for i=1:size(j,1)
%     plot(x(i)-x0+amp*maxJ,y(i)-y0+amp*maxJ,'k.','Markersize',j(i)*amp*200);hold on
% end
% axis equal
% axis off
% title('Plot-command all')
% % saveas(gcf, 'plotAll', 'pdf'); % save the current figure as "plotAll.pdf"
% tPlotAll=toc

% %% Plot all records with "rectangle" command (Note: this paragraph would run for 10+ hours!!)
% tic
% figure(3);
% set(gca,'position',[0 0 1 1]);% only show the contents within the axis ranges
% axis off;
% axis equal;
% rectangle('Position',[0,0,xx,yy],'Curvature',[0,0],'edgecolor','c','facecolor','c');%plot a colorful ractangle
% axis([0 xx 0 yy]);% limit the plot range
% for i=1:size(j,1)
%     circle(x(i)-x0+amp*maxJ,y(i)-y0+amp*maxJ,j(i)*amp);hold on % plot with 'rectangle' command
% end
% axis equal
% axis off
% title('Circle-command all')
% saveas(gcf, 'circleAll', 'pdf'); % save the current figure as "circleAll.pdf"
% tCircleAll=toc



%% load active data (i.e. selected records)
clear data j x y;
data=importdata('M1.0-JapanEqMainland30kmMerge.dat'); 
n=data(:,1); % year
m=data(:,2); % month
d=data(:,3); % day
h=data(:,4); % hour
f=data(:,5); % minute
g=data(:,6); % second
y=data(:,7); % latitude   --- to be used
x=data(:,8); % longitude  --- to be used
z=data(:,9); % depth (km)
j=data(:,10);% magnitude  --- to be used
clear data

%% This paragraph would show the side view of selected records. 
tic
figure(4);
scatter3(x,y,z,j*amp*200,'k');hold on; %'k' here means dot (not black color)
xlabel('x'),ylabel('y'),zlabel('z');
view(-120, 30);%set view angle
title('Side view of selected')
tScatter3=toc

%% This paragraph would show the plot of selected records with 'plot' command.
tic
figure(5);
for i=1:size(j,1)
    plot(x(i)-x0+amp*maxJ,y(i)-y0+amp*maxJ,'k.','Markersize',j(i)*amp*200);hold on
end
axis equal
axis off
title('Plot-command Selected')
% saveas(gcf, 'plotSelected', 'pdf'); % save the current figure as "plotSelected.pdf"
tPlot=toc

%% Plot all records with "rectangle" command (Note: this paragraph would run for 10+ hours!!)
tic
figure(6);
set(gca,'position',[0 0 1 1]);% only show the contents within the axis ranges
axis off;
axis equal;
rectangle('Position',[0,0,xx,yy],'Curvature',[0,0],'edgecolor','c','facecolor','c');%plot a colorful ractangle
axis([0 xx 0 yy]);% limit the plot range
for i=1:size(j,1)
    circle(x(i)-x0+amp*maxJ,y(i)-y0+amp*maxJ,j(i)*amp);hold on % plot with 'rectangle' command
end
axis equal
axis off
title('Circle-command all')
saveas(gcf, 'circleSelected', 'pdf'); % save the current figure as "circleSelected.pdf"
tCircle=toc

%% Sound alarm after running the code
load splat;%laughter;
player=audioplayer(y,Fs);
for ii=1:5
    play(player)
    pause(3)
end