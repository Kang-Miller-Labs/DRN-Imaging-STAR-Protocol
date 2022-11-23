function name = matrixCorrection(pnm,dnm, corrections ,indices)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

absindex=2;
output = cell(length(dnm),1);
%data = cell(length(dnm),2);

%infolist = cell(length(dnm),1);
   sum=0;
   sum1=0;
for i=1:(length(indices)-1)

    dt = indices(i+1)-indices(i);

    
   scale1=1/(sqrt(corrections{i}.tdata.T(1,2)^2+corrections{i}.tdata.T(1,1)^2));
   scale2=1/(sqrt(corrections{i+1}.tdata.T(1,2)^2+corrections{i+1}.tdata.T(1,1)^2));
    
   theta1 = asin(corrections{i}.tdata.T(1,2)/scale1);
   theta2 = asin(corrections{i+1}.tdata.T(1,2)/scale2);
   dtheta=(theta2-theta1)/dt;
   offset = 2/(length(indices)-1);
        sum=sum+corrections{i}.tdata.T(3,1);
        sum1=sum1+corrections{i}.tdata.T(3,2);
    for t=1:dt
        tform=corrections{i};
        scale=(sqrt(tform.tdata.T(1,2)^2+tform.tdata.T(1,1)^2));
        
        theta=theta1+(theta2/dt)*t;
        %theta=theta1+dtheta*t;

%         tform.tdata.T(3,1)=corrections{i}.tdata.T(3,1)+((corrections{i+1}.tdata.T(3,1))/dt)*t;
%         tform.tdata.T(3,2)=corrections{i}.tdata.T(3,2)+((corrections{i+1}.tdata.T(3,2))/dt)*t;
        tform.tdata.T(3,1)=sum+((corrections{i+1}.tdata.T(3,1))/dt)*t;
        tform.tdata.T(3,2)=sum1+((corrections{i+1}.tdata.T(3,2))/dt)*t;        
        if i>3
            tform.tdata.T(3,1)=corrections{i}.tdata.T(3,1)+((corrections{i+1}.tdata.T(3,1)-1)/dt)*t;
            tform.tdata.T(3,2)=corrections{i}.tdata.T(3,2)+((corrections{i+1}.tdata.T(3,2)-1)/dt)*t;
            
        end

         
         tform.tdata.T(1,2)=sin(theta);
         
         tform.tdata.T(2,1)=-tform.tdata.T(1,2);
         
         tform.tdata.T(1,1)=cos(theta);
         
         tform.tdata.T(2,2)=tform.tdata.T(1,1);
       
%          tform.tdata.T(1,2)=corrections{i}.tdata.T(1,2);
%          tform.tdata.T(2,2)=corrections{i}.tdata.T(2,2);
%          tform.tdata.T(1,1)=corrections{i}.tdata.T(1,1);
%          tform.tdata.T(2,1)=corrections{i}.tdata.T(2,1);

         tform.tdata.T(3,1)=tform.tdata.T(3,1)*scale;
         tform.tdata.T(3,2)=tform.tdata.T(3,2)*scale;
%         
         tform.tdata.T(1,1)=tform.tdata.T(1,1)*scale;
         tform.tdata.T(1,2)=tform.tdata.T(1,2)*scale;
         tform.tdata.T(2,1)=tform.tdata.T(2,1)*scale;
         tform.tdata.T(2,2)=tform.tdata.T(2,2)*scale;
        
         tform.tdata.Tinv=inv(tform.tdata.T);
        
          
        data(absindex,1)=tform.tdata.T(3,2)/(i*t);
        data(absindex,2)=tform.tdata.T(3,1)/(i*t);
        fnm=strcat(pnm, '/', dnm(absindex).name);
        movie(:,:,absindex)=imread(fnm,'tif');
        
        output{absindex} = imtransform(movie(:,:,absindex),tform,'XData',[1 size(movie(:,:,absindex),2)],'YData',[1 size(movie(:,:,absindex),1)]);
        %[output{absindex},xdata,ydata] = imtransform(movie(:,:,absindex),tform,'XYScale',1);
        temp=output{absindex};
        dnm='images/';
        

        filename = sprintf(dnm,'%s_%d%s','img',absindex,'.tif');
        imwrite(output{absindex},filename,'tif');
        
        absindex=absindex+1;
        
        fprintf('motion correcting...');
        fprintf('\nframe %d\n',absindex);

        

    end
end
name=dnm;
end

