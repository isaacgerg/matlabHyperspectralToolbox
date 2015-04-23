function hyperSaveFigure(h, filename, fmt)
% HYPERSAVEFIGURE Writes a figure to disk as an image.
%
% Usage
%   hyperSaveFigure(gcf, 'filename.png');
% Inputs
%   h - Handle to figure
%   filename - Filename for output file.  Extension determines image type.
%   fmt - Format of output image.  'wysiwyg' or wysiwyp' for 'what you see
%         is what you get' and what 'you see is what you print' respectively.
% Outputs
%   none

if (nargin == 2)
    fmt = 'wysiwyg';
end

fmt = lower(fmt);

if strcmp(fmt, 'wysiwyp')
    saveas(h, filename);
elseif strcmp(fmt, 'wysiwyg')
    set(h, 'Color',[1 1 1]);
    frame = getframe(h);
    [X,map] = frame2im(frame);
    imwrite(X ,filename);
else
    error('Bad format string specified.');
end
%print(h, '-dpng', filename);