function binaryMask = SegmentRoots(inputImage, maxIslandNumPixels, segmentPlantFirst, maxIslandNumPixelsPlant)
%SegmentRoots Computes the binary mask for roots in the image, using color
%thresholding in RGB, YCBCR, and LAB color spaces.
%   After segmentation, small islands of size maxIslandNumPixels are
%   removed.
    if nargin < 2
        maxIslandNumPixels = 100;
    end

    if nargin < 3
            segmentPlantFirst = true;
    end

    if nargin < 4
        maxIslandNumPixelsPlant = 50;
    end

    imageHist = histeq(inputImage);

    if segmentPlantFirst
        plantMask = SegmentPlant(inputImage, maxIslandNumPixelsPlant);
        inputImage = uint8(plantMask) .* inputImage;
        imageHist = uint8(plantMask) .* imageHist;
    end
   
    binaryMask = createMaskRootsLABorig(inputImage) & ...
        createMaskRootsLABhist(imageHist);  
    binaryMask = imclearborder(binaryMask, 8);
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