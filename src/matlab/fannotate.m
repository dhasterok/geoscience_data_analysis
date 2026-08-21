function fannotate(x,y,style)

% Prepare the annotation's X position
% Note: we need 2 X values: one for the annotation's head, another for the tail
xlim = get(gca,'XLim');
 
% Prepare the annotation's Y position
% Note: we need 2 Y values: one for the annotation's head, another for the tail
% Note: we use a static Y position here, spanning the center of the axes.
% ^^^^  We could have used some other Y data value for this
yLim = get(gca,'YLim');

% Ensure that the annotation fits in the window by enlarging
% the axes limits as required
if x(1) < xlim(1) || x(2) > xlim(2)
    hold(gca,'on');
    plot(gca,xValue,y(2),'-w');
    drawnow;
end

% Convert axes data position to figure normalized position
% uses %matlabroot%/toolbox/matlab/scribe/@scribe/@scribepin/topixels.m
scribepin = scribe.scribepin('parent',gca,'DataAxes',gca,'DataPosition',[x;y;[0,0]]');
figPixelPos = scribepin.topixels;
hFig = ancestor(gca,'figure');
figPos = getpixelposition(hFig);
figPixelPos(:,2) = figPos(4) - figPixelPos([2,1],2);
figNormPos = hgconvertunits(hFig,[figPixelPos(1,1:2),diff(figPixelPos)],'pixels','norm',hFig);
annotationX = figNormPos([1,1]);
annotationY = figNormPos([2,2]) + figNormPos(4)*[1,0];

return