function []=circle(x,y,r)
rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'edgecolor','r','facecolor','k');axis equal;
end
