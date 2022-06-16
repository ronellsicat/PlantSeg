function binaryMask = SegmentShoots(inputImage, maxIslandNumPixels)
%SegmentShoots Computes the binary mask for shoots in the image, using color
%thresholding in RGB, YCBCR, and LAB color spaces.
%   After segmentation, small islands of size maxIslandNumPixels are
%   removed.

    if nargin < 2
        maxIslandNumPixels = 100;
    end

    plantMask = SegmentPlant(inputImage);

%     imageHist = histeq(inputImage);
%     imageHist = uint8(plantMask) .* imageHist;
    
    inputImage = uint8(plantMask) .* inputImage;
    binaryMask = createMaskShootsHSVorig(inputImage);
    binaryMask = bwareaopen(binaryMask, maxIslandNumPixels);
    
%     close all
%     imshow(imageHist)
%     figure
%     imshow(inputImage)
%     figure
%     imshow(imageHist)
%     figure
%     imshow(binaryMask)
end