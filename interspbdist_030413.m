%dataset 11111111111111111111111111111111111111111111111111111
%initialize vectors and set filepaths
allresults = zeros(1,1);
datathisround = 0;
totaldataafterlastround = 0;
totaldata = 0;
%GREENfiles = dir('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/process_imagej/*1wt*FITC*');
REDfiles =  dir('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/process_imagej/*1wt*');
lastfile = size(REDfiles);


for i=1:lastfile(1);
    %filenamegreen = getfield(GREENfiles,{i}, 'name');
    filenamered = getfield(REDfiles,{i}, 'name');
    cd('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/process_imagej/');
    img=imread(filenamered);
    
%get centroid list for a given file (i)
se = strel('disk',5);       %create structural element for mexican hat filter
J = imtophat(img,se);        %do filter
BW = im2bw(J,.001);         %convert filtered img to bw - .0002 is intensity threshold
CC = bwconncomp(BW);        %find connected components
S = regionprops(CC,'Centroid');  %get centroids for the connected things
BWlab = bwlabel (BW, 8);     %label objects in the BW image (ignoring CC for now)
meas = regionprops(BWlab, BW, 'centroid'); %get centroid coords for 'dots' to make them 'pixels'
centroids = cat(1, meas.Centroid);   %write centroids to simple array
finish = size(centroids,1);
rawresults = zeros(finish,3);
imgsize = size(img);
%img2=imread(filenamegreen);

%find nearest neighbor (red-red) for each observation and rec'd distance, D
[IDX,D]=knnsearch(centroids,centroids,'k',2);
rawresults(:,3)=(D(:,2));

%sort rawresults by y position so i can go back and get rid of bogus
%measurements. write position to coords file without intensity meas (no
%bias)
sort_rawdata = zeros(finish,3);
sort_rawdata(:,1) = (rawresults(:,1)-rawresults(:,2));
sort_rawdata(:,2) = rawresults(:,1);
sort_rawdata(:,3) = rawresults(:,3);
sort_rawdata = sortrows(sort_rawdata, 1);

%truncate results to remove anomalous green spots (prob autofluorescence)
saturated = find(sort_rawdata(:,2) < 450);
length = size(saturated);
useable = length(1);
rawresults_truncate = sort_rawdata(1:useable,:);
rawresults_trash = sort_rawdata((useable+1):finish,:);
finish2 = size(rawresults_truncate,1);

%truncate results again to remove dots that are too far from each other
rawresults_truncate = sortrows(rawresults_truncate, 3);
toofar = find(rawresults_truncate(:,3) > 20);
rejectlength = size(toofar);
fulllength = size(rawresults_truncate(:,1));
useable2 = fulllength(1)-rejectlength(1);
rrtrunc2 = rawresults_truncate(1:useable2,:);
rrtrash2 = rawresults_truncate((useable2+1):finish2,:);

%add this image's stats to growing list of stats for all images
datathisround = size(rrtrunc2,1);
totaldataafterlastround = totaldata;
totaldata = datathisround + totaldata;
for x = 1:datathisround
    allresults(totaldataafterlastround+x,1) = (rrtrunc2(x,3));
end
end
cartesiandist=allresults*.1068;
csvwrite('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/data_int/01_450', cartesiandist);


%dataset 22222222222222222222222222222222222222222222222222
%initialize vectors and set filepaths
allresults = zeros(1,1);
datathisround = 0;
totaldataafterlastround = 0;
totaldata = 0;
%GREENfiles = dir('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/process_imagej/*_2wt*FITC*');
REDfiles =  dir('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/process_imagej/*2wt*');
lastfile = size(REDfiles);


for i=1:lastfile(1);
    %filenamegreen = getfield(GREENfiles,{i}, 'name');
    filenamered = getfield(REDfiles,{i}, 'name');
    cd('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/process_imagej/');
    img=imread(filenamered);
    
%get centroid list for a given file (i)
se = strel('disk',5);       %create structural element for mexican hat filter
J = imtophat(img,se);        %do filter
BW = im2bw(J,.001);         %convert filtered img to bw - .0002 is intensity threshold
CC = bwconncomp(BW);        %find connected components
S = regionprops(CC,'Centroid');  %get centroids for the connected things
BWlab = bwlabel (BW, 8);     %label objects in the BW image (ignoring CC for now)
meas = regionprops(BWlab, BW, 'centroid'); %get centroid coords for 'dots' to make them 'pixels'
centroids = cat(1, meas.Centroid);   %write centroids to simple array
finish = size(centroids,1);
rawresults = zeros(finish,3);
imgsize = size(img);
%img2=imread(filenamegreen);

%find nearest neighbor (red-red) for each observation and rec'd distance, D
[IDX,D]=knnsearch(centroids,centroids,'k',2);
rawresults(:,3)=(D(:,2));

%sort rawresults by y position so i can go back and get rid of bogus
%measurements. write position to coords file without intensity meas (no
%bias)
sort_rawdata = zeros(finish,3);
sort_rawdata(:,1) = (rawresults(:,1)-rawresults(:,2));
sort_rawdata(:,2) = rawresults(:,1);
sort_rawdata(:,3) = rawresults(:,3);
sort_rawdata = sortrows(sort_rawdata, 1);

%truncate results to remove anomalous green spots (prob autofluorescence)
saturated = find(sort_rawdata(:,2) < 450);
length = size(saturated);
useable = length(1);
rawresults_truncate = sort_rawdata(1:useable,:);
rawresults_trash = sort_rawdata((useable+1):finish,:);
finish2 = size(rawresults_truncate,1);

%truncate results again to remove dots that are too far from each other
rawresults_truncate = sortrows(rawresults_truncate, 3);
toofar = find(rawresults_truncate(:,3) > 20);
rejectlength = size(toofar);
fulllength = size(rawresults_truncate(:,1));
useable2 = fulllength(1)-rejectlength(1);
rrtrunc2 = rawresults_truncate(1:useable2,:);
rrtrash2 = rawresults_truncate((useable2+1):finish2,:);

%add this image's stats to growing list of stats for all images
datathisround = size(rrtrunc2,1);
totaldataafterlastround = totaldata;
totaldata = datathisround + totaldata;
for x = 1:datathisround
    allresults(totaldataafterlastround+x,1) = (rrtrunc2(x,3));
end
end
cartesiandist=allresults*.1068;
csvwrite('/nfs/xray/sch/hinshaw/yeast_imaging/20141219_spb_spt/data_int/02_450', cartesiandist);
