function d = DistanceBetweenXYs(coord1, coord2)

% Given the coordinates of one point and another (or a point and a list of
% other points), returns the distances between the points.
%
% INPUTS
% coord1: A matrix with 2 columns and any number of rows. The first column
% specifies the x-coordinate of a point, and the second column specifies
% its y-coordinate. e.g., [x y] or [x1 y1; x2 y2]
%
% coord2: A matrix of the same format as coords1.
%
% If coord1 has more than 2 rows (specifies many points), coord2 must
% have only 1 row (specify a single point); and vice versa.
%
% OUTPUTS
% d: a vector containing the Euclidean distances between the single point
% specified in coord1 or coord2 and all the points specified in the other
%
% Randy Bruno, May 2016
% ed. Grace Paquelet February 2018 to account for NaN values in inputs

% make sure the user is passing inputs in the correct format
if size(coord1,2) ~= 2 || size(coord2,2) ~= 2
    error('DistanceBetweenCoords: coord1 and coord2 must be of the form [x y]');
end

if size(coord1,1) > 1 && size(coord2,1) > 1
    disp(size(coord1))
    disp(size(coord2))
    error('DistanceBetweenCoords: either coord1 or coord2 or both must be a single point');
end

% extract points or lists of points
x1 = coord1(:,1);
y1 = coord1(:,2);

x2 = coord2(:,1);
y2 = coord2(:,2);

% return Euclidean distance(s)
L = max([length(x1) length(x2)]);
d = NaN(L,1);
for i = 1:L
    if length(coord1) > length(coord2)
        if ~isnan(x1(i)) && ~isnan(y1(i))
            d(i) = sqrt((x1(i)-x2).^2 + (y1(i)-y2).^2);
        else
            d(i) = NaN;
        end
    else 
        if ~isnan(x2(i)) && ~isnan(y2(i)) 
            d(i) = sqrt((x1-x2(i)).^2 + (y1-y2(i)).^2);
        else
            d(i) = NaN;
        end
    end
end
