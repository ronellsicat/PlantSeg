function binaryMask = SegmentRoots(inputImage, maxIslandNumPixels)
%SegmentRoots Computes the binary mask for roots in the image, using color
%thresholding in RGB, YCBCR, and LAB color spaces.
%   After segmentation, small islands of size maxIslandNumPixels are
%   removed.

    if nargin < 2
        maxIslandNumPixels = 100;
    end

    plantMask = SegmentPlant(inputImage);
    imageHist = histeq(inputImage);
    inputImage = uint8(plantMask) .* inputImage;
    imageHist = uint8(plantMask) .* imageHist;
    
    binaryMask = createMaskRootsLABorig(inputImage) & ...
        createMaskRootsLABhist(imageHist);                    
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