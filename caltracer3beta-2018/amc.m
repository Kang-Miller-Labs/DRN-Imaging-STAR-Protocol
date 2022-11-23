function pathname = amc(pnm)
%affine motion correction
clear;clc;

pnm=input('image folder path name: ' );
dnm=dir(pnm);
dnm(length(dnm))=[]; %getting rid of the last element (thumbnail file)
dnm(1:2)=[]; %getting rid of the first two files
nims=length(dnm); %number of images equal to directory length

bpchoice=input(['would you like to enter your own breakpoints' '\n' '[0=no(default) 1=yes]?: ']);
switch bpchoice
    case 0
        nbp=input('number of breakpoints: ');
        if isempty(nbp)
            nbp=10;
        end
        
        bps=zeros(nbp,1); %allocating space for a one-dimensional array of breakpoints
        im=cell(nbp+1,1); %getting the first image to send to control point selection tool, +1 to include first frame
        im{1}=imread((strcat(pnm, '/', dnm(1).name)),'tif'); %reading in the first file
        
        for i=1:nbp %calculating the breakpoint positions at even intervals
            bps(i)=floor(i*nims/nbp);
            
            fnm=strcat(pnm, '/', dnm(bps(i)).name);%------ %getting the images to send to control point selection tool
            im{i+1}=imread(fnm,'tif');%-----
        end
        
    case 1
        bps=input('what are your breakpoints (vector format, space between frame numbers)?: ');
        bps=bps';
        im=cell(length(bps)+1,1);
        im{1}=imread((strcat(pnm, '/', dnm(1).name)),'tif');
        for i=1:length(bps)
            fnm=strcat(pnm, '/', dnm(bps(i)).name);
            im{i+1}=imread(fnm,'tif');
        end
end

nbks=length(im); %nbks = nbp+1 to include first frame
tinfo=cell(nbks,1);
for i=1:nbks-1
    base=uint8(im{i});
    input=uint8(im{i+1});
%     if i==1
    [inputpts,basepts]=cpselect(input,base,'Wait',true);
%     else
%        [inputpts,basepts]=cpselect(input,base,xyinputin,xybasein);
%     end
     inputpts=cpcorr(inputpts,basepts,input,base);
%     xyinputin=inputpts;
%     xybasein=basepts;
    tinfo{i+1}=cp2tform(inputpts,basepts,'nonreflective similarity');
end
tinfo{1}=tinfo{2};
tinfo{1,1}=tinfo{2,1};
tinfo{1,1}.tdata.T(:,:)=diag(ones(3,1));
tinfo{1,1}.tdata.Tinv=inv(tinfo{1,1}.tdata.T);

bps=cat(1,1,bps);

 pathname = matrixCorrection(pnm,dnm,tinfo,bps);
end
