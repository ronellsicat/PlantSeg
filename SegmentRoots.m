function binaryMask = SegmentRoots(inputImage, maxIslandNumPixels)
%SegmentPlant Computes the binary mask for plants, i.e., combined
%roots/shoots, in the image, using color thresholding in RGB, YCBCR, and
%LAB color spaces.
%   Histogram equalization is first applied to the image to enhance
%   contrast. After segmentation, the border pixels and small islands of
%   size maxIslandNumPixels.

    if nargin < 2
        maxIslandNumPixels = 100;
    end

    plantMask = SegmentPlant(inputImage);

    

    imageHist = histeq(inputImage);
    %imageHist = (inputImage);

    inputImage = uint8(plantMask) .* inputImage;
    imageHist = uint8(plantMask) .* imageHist;
    
    binaryMask = createMaskRootsLABorig(inputImage) & createMaskRootsLABhisteq(imageHist);
                    
    %binaryMask = imclearborder(binaryMask, 8);
    binaryMask = bwareaopen(binaryMask, maxIslandNumPixels);
    
    close all
    imshow(imageHist)
    figure
    imshow(inputImage)
    figure
    imshow(imageHist)
    figure
    imshow(binaryMask)
end