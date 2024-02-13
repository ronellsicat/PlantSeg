This Matlab application provides a mix of automatic and manual segmentation and analysis tools for images of plant roots and shoots.
Follow the steps below to use it and refer to app screenshot below for guidance.

1. Run PlantSeg. If you have Matlab installed, just double click and run the PlantSeg.mlapp application. If you don't have Matlab and are using Windows, run the app installer in "PlantSegApp/for_redistribution/PlantSegInstaller_web.exe" and follow the installation instructions. Then run the installed PlantSeg application. If you can't find it, you can also run it from "PlantSegApp/for_redistribution_files_only/PlantSeg.exe".
3. Click "New" or "Load" button to start a new session or load a previous session. For a new session, choose a folder containing the images you want to analyze. The "input" folder contains example images that can be used for testing.
4. Click "Prev" or "Next" button to select an image to process.
5. Click "Auto Segment" button to apply automatic segmentation. You can change the parameters in "Segmentation" panel. See tooltips for more info. 
6. Use the left mouse button to manually brush on the segmentation mask. Use right mouse button to erase pixels from input image (to separate roots/shoots from boundary region). When "Auto Segment" button is pressed, the mask is recomputed considering the erased pixels and removing manually segmented pixels.
7. After segmentation, click the "Run Analysis" button to get the four individual plant masks - they will be plotted and the sizes (in number of pixels) will be displayed. If the "# Comps." box turns red, this means the number of detected components in the segmentation mask is not equal to four. Click the "Show Components" button to display the detected components, which can guide you in further modifying the segmentation mask to achieve your goal of getting the plants to be the four largest detected connected components. If there are less than four plants in the image, you can manually edit the "Shoots" and "Roots" pixel counts to match the plant indices.
8. Click "Save" button to save your session. This will save the settings and all input and segmentation data.
9. Click "Export Data" to export metadata (filename, plate number, condition, gentype 1 and 2, root and shoot sizes) to a csv file.

Note that the "Mask Appearance" tab allows you to modify the mask appearance in the plot. The "Help" tab will show the above instructions.
You can also hover the mouse cursor over any button to see the tooltips.

![PlantSeg UI](archive/plantseg_ui.png?raw=true "PlantSeg UI")
