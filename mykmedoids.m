function [ class, centroid ] = mykmedoids( pixels, K )
%
% Your goal of this assignment is implementing your own K-medoids.
% Please refer to the instructions carefully, and we encourage you to
% consult with other resources about this algorithm on the web.
%
% Input:
%     pixels: data set. Each row contains one data point. For image
%     dataset, it contains 3 columns, each column corresponding to Red,
%     Green, and Blue component.
%
%     K: the number of desired clusters. Too high value of K may result in
%     empty cluster error. Then, you need to reduce it.
%
% Output:
%     class: the class assignment of each data point in pixels. The
%     assignment should be 1, 2, 3, etc. For K = 5, for example, each cell
%     of class should be either 1, 2, 3, 4, or 5. The output should be a
%     column vector with size(pixels, 1) elements.
%
%     centroid: the location of K centroids in your result. With images,
%     each centroid corresponds to the representative color of each
%     cluster. The output should be a matrix with size(pixels, 1) rows and
%     3 columns. The range of values should be [0, 255].
%     
%
% You may run the following line, then you can see what should be done.
% For submission, you need to code your own implementation without using
% the kmeans matlab function directly. That is, you need to comment it out.
 %Initializing the centroids
 
%  centroid(1,:)=[0,0,0];
%  centroid(2,:)=[255,255,255];
%  centroid(3,:)=[128,128,128];

% centroid(1,:)=[1,1,1];
% centroid(2,:)=[2,2,2];
% centroid(3,:)=[3,3,3];
rows=size(pixels,1);
centroid=zeros(K,3);
interval=floor(255/K);

  for i=1:K
    centroid(i,:)=randi([(i-1)*interval,i*interval],1,3);
  end
cnt=0; 
flag=0;
  while flag~=1
      [class,dist]=mycluster(centroid,rows,K,pixels);
      [newcentroid]=Newcentroids(class,pixels,K,dist,rows,centroid);
      flag=stop(newcentroid,centroid,cnt);
      cnt=cnt+1;
      centroid=newcentroid;
    
  end
   
end
	

 

  
   
       
	
%clustering points to the center with minimum manhattan distance
function [class,dist]=mycluster(centroid,rows,K,pixels)
class= zeros(rows,1);
centroidCNT=zeros(K,1);
cluster_dist=zeros(K,1);
for i=1:rows
       min=inf;
       for k=1:K
           temp=0;
           for j=1:3
               temp=temp+abs(pixels(i,j)-centroid(k,j));
           end
        if temp<min
            min=temp;
            index=k;
        end
       end
        cluster_dist(index)=min+cluster_dist(index);
        class(i)=index;
        centroidCNT(index)=centroidCNT(index)+1;
end
       
    dist=sum(cluster_dist);  
end


 
function [newcentroid]=Newcentroids(class,pixels,K,dist,rows,centroid)
newcentroid=centroid;
     %swap centroid with other point
    for i=1:K
        for j=1:rows
            centroid(i,:)=pixels(j,:);
            %calculate dissimiliarity after swap
             for k=1:rows
                 new_dist=sum(sum(abs(pixels(k,:)-centroid(class(k),:))));
             end
             %swap is successful if new centroids have less dissimiliarity
              if new_dist<dist
                newcentroid=centroid;
                break;
              end
        end
         break;
    end        
end

%stop running when centroids become stable or reach particular loops
 function flag=stop(newcentroid,centroid,cnt)
flag=1;
dist=sum(sum(abs(newcentroid-centroid)));
      if dist>1 && cnt<200;
          flag=0;
      end
end
