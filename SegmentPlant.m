function binaryMask = SegmentPlant(inputImage, maxIslandNumPixels)
%SegmentPlant Computes the binary mask for plants, i.e., combined
%roots/shoots, in the image, using color thresholding in RGB, YCBCR, and
%LAB color spaces.
%   Histogram equalization is first applied to the image to enhance
%   contrast. After segmentation, the border pixels and small islands of
%   size maxIslandNumPixels.

    if nargin < 2
        maxIslandNumPixels = 50;
    end

    imageHist = histeq(inputImage);
    
    binaryMask = imageHist(:,:,2) >= 128;
    binaryMask = binaryMask & createMaskYCBCR(imageHist);
    binaryMask = binaryMask & createMaskLAB(imageHist);
    binaryMask = imclearborder(binaryMask, 8);
    binaryMask = bwareaopen(binaryMask, maxIslandNumPixels);
    
%     close all
%     imshow(imageHist)
%     figure
%     imshow(binaryMask)
end