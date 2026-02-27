function bolder_apb(fontsize, linewidth, markersize)
%bolder this function will make your current figure better.
   
    set(gcf, 'color', 'w')
    
    if exist('fontsize','var') == 0
        fontsize = 12; % Default fontsize
    end
    
    if exist('fontname','var') == 0
        fontname = 'Arial'; % Default fontsize
    end
    
    if exist('linewidth','var') == 0
        linewidth = 1.5; % Default linewidth
    end
    
    if exist('markersize','var') == 0
        markersize = 5; % Default markersize
    end   
    
    set(findall(gcf,'type','axes'), 'linewidth', linewidth, 'fontsize', fontsize,'fontname',fontname);
    set(findall(gcf,'type','line'), 'linewidth', linewidth, 'markersize', markersize);
    set(findall(gcf,'type','text'), 'fontsize', fontsize);
end
