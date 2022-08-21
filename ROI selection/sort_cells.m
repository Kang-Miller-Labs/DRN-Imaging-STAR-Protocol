function [traces_sorted,contours_sorted,ind_del] = sort_cells(traces,contours,frame_rate)
%-------------------------------------------------------------------------
%DELETE CELLS FROM AN ARRAY BY VIEWING THEIR TRACES
%Grace Paquelet, 2018
%
%   INPUT: Requires a matrix of traces (t x F), the contours used to
%   generate those traces, and the frame rate.
%
%   OUTPUT: Returns the reduced traces and contours variables, and a vector
%   the length of the original data indicating which indices were deleted.
%
%-------------------------------------------------------------------------

    t = linspace(0,length(traces)/frame_rate,length(traces));
    ind_del = false(size(traces,2),1);

    figure
    m = 1;
    while m <= size(traces,2)
        cla;
        plot(t,traces(:,m),'b')
        title(['ROI # ' num2str(m)])
        ylim([min(traces(:,m))-1 max(traces(:,m))+1])
        ylabel('ROI on Ysignal')
        xlabel('time (s)')

        fprintf('Plot %d: proceed? (k(keep,default)/d(delete)/b(back)/e(end)):    ',m);
        temp = input('','s');
        if temp == 'k'
            m = m + 1;
        elseif strcmpi(temp,'d')
            ind_del(m) = true;
            m = m + 1;
        elseif strcmpi(temp,'b')
            m = m - 1;
        elseif strcmpi(temp,'e')
            break
        else
            m = m + 1;
        end
    end
    
    traces(:,ind_del) = [];
    traces_sorted = traces;
    
    contours_sorted = cell(1,size(traces_sorted,2));
    n = 1;
    for i = 1:size(contours,2)
        if ind_del(i) == false
            contours_sorted{1,n} = contours{1,i};
            n = n + 1;
        end
    end
    
    save('contours_sorted','contours_sorted')
    save('traces_sorted','traces_sorted')
    save('ind_del','ind_del')

end

