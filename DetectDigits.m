function digits = DetectDigits(inputImageHistEq, bboxROI)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    m = createMaskDigits(inputImageHistEq);
    m = imclearborder(m, 8);
    m = bwareaopen(m, 50);

    results = ocr(m, bboxROI, 'CharacterSet','0123456789');

    digits = str2double(results.Text);
    if(isnan(digits))
       digits = 0;
    end
end