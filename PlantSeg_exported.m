classdef PlantSeg_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        AnalysisPanel                matlab.ui.container.Panel
        SaveButton                   matlab.ui.control.Button
        ShowComponentsButton         matlab.ui.control.Button
        NumComponentsEditField       matlab.ui.control.NumericEditField
        CompsEditFieldLabel          matlab.ui.control.Label
        Gentype2EditField            matlab.ui.control.NumericEditField
        Gentype2Label                matlab.ui.control.Label
        Gentype1EditField            matlab.ui.control.NumericEditField
        Gentype1EditFieldLabel       matlab.ui.control.Label
        ConditionEditField           matlab.ui.control.NumericEditField
        ConditionEditFieldLabel      matlab.ui.control.Label
        PlateEditField               matlab.ui.control.NumericEditField
        PlateEditFieldLabel          matlab.ui.control.Label
        RootsEditField_4             matlab.ui.control.NumericEditField
        RootsEditField_3             matlab.ui.control.NumericEditField
        RootsEditField_2             matlab.ui.control.NumericEditField
        RootsLabel                   matlab.ui.control.Label
        RootsEditField_1             matlab.ui.control.NumericEditField
        ShootsEditField_4            matlab.ui.control.NumericEditField
        ShootsEditField_3            matlab.ui.control.NumericEditField
        ShootsEditField_2            matlab.ui.control.NumericEditField
        ShootsLabel                  matlab.ui.control.Label
        ShootsEditField_1            matlab.ui.control.NumericEditField
        RunAnalysisButton            matlab.ui.control.Button
        TabGroup                     matlab.ui.container.TabGroup
        MainTab                      matlab.ui.container.Tab
        ExportDataButton             matlab.ui.control.Button
        AutoSegmentButton            matlab.ui.control.Button
        LoadButton                   matlab.ui.control.Button
        SegmentationPanel            matlab.ui.container.Panel
        ShowMaskButton               matlab.ui.control.StateButton
        IslandsSpinnerRoot           matlab.ui.control.Spinner
        IslandsSpinner_3Label        matlab.ui.control.Label
        IslandsSpinnerShoot          matlab.ui.control.Spinner
        IslandsSpinner_2Label        matlab.ui.control.Label
        IslandsSpinnerPlant          matlab.ui.control.Spinner
        IslandsSpinnerLabel          matlab.ui.control.Label
        RootCheckBox                 matlab.ui.control.CheckBox
        ShootCheckBox                matlab.ui.control.CheckBox
        PlantCheckBox                matlab.ui.control.CheckBox
        NextButton                   matlab.ui.control.Button
        PrevButton                   matlab.ui.control.Button
        CurrentImageDropDown         matlab.ui.control.DropDown
        BrushButtonGroup             matlab.ui.container.ButtonGroup
        ResetAllButton               matlab.ui.control.Button
        RootLamp                     matlab.ui.control.Lamp
        ShootLamp                    matlab.ui.control.Lamp
        BackgroundLamp               matlab.ui.control.Lamp
        BackgroundButton             matlab.ui.control.ToggleButton
        ShootButton                  matlab.ui.control.ToggleButton
        RootButton                   matlab.ui.control.ToggleButton
        NewButton                    matlab.ui.control.Button
        MaskAppearanceTab            matlab.ui.container.Tab
        SetUncertainColorButton      matlab.ui.control.Button
        SetRootColorButton           matlab.ui.control.Button
        SetShootColorButton          matlab.ui.control.Button
        SetBackgroundColorButton     matlab.ui.control.Button
        MaskVisibilityAndColorLabel  matlab.ui.control.Label
        CheckBoxShowUncertain        matlab.ui.control.CheckBox
        CheckBoxShowRoot             matlab.ui.control.CheckBox
        CheckBoxShowShoot            matlab.ui.control.CheckBox
        CheckBoxShowBackground       matlab.ui.control.CheckBox
        SliderMaskAlpha              matlab.ui.control.Slider
        MaskAlphaLabel               matlab.ui.control.Label
        HelpTab                      matlab.ui.container.Tab
        StepsTextArea                matlab.ui.control.TextArea
        StepsTextAreaLabel           matlab.ui.control.Label
        UIAxesPlant_4                matlab.ui.control.UIAxes
        UIAxesPlant_3                matlab.ui.control.UIAxes
        UIAxesPlant_2                matlab.ui.control.UIAxes
        UIAxesPlant_1                matlab.ui.control.UIAxes
        UIAxesSeg                    matlab.ui.control.UIAxes
    end

    
    % Private variables:
    properties (Access = private)

        % These parameters can be changed:
        settings = struct( ...
            'bgColor', [0, 0, 0], ...       % Color for displaying background pixels.
            'shootColor', [0, 1, 1], ...    % Color for displaying shoot pixels.
            'rootColor', [1, 0, 0], ...     % Color for displaying root pixels.
            'uncertainColor', [1, 1, 0], ...% Color for displaying uncertain pixels.
            'maskAlpha', 0.5, ...           % Mask transparency value.
            'showBackgroundColor', false, ...% Toggle display of background color.
            'showShootColor', true, ...     % Toggle display of shoot color.
            'showRootColor', true, ...      % Toggle display of root color.
            'showUncertainColor', true, ... % Toggle display of uncertain color.
            'plantSegEnabled', true, ...    % Enable plant segmentation.
            'shootSegEnabled', true, ...    % Enable shoot segmentation.
            'rootSegEnabled', true, ...     % Enable root segmentation.
            'plantSegIslands', 200, ...     % Maximum size of pixel islands allowed.
            'shootSegIslands', 150, ...     % Maximum size of pixel islands allowed.
            'rootSegIslands', 150 ...       % Maximum size of pixel islands allowed.
        );

        data = struct;

        % These parameters should not be changed unless you know what you
        % are doing:
        dataMagicString = "PlantSegData: v1.0"; % For file save/load.
        saveFile = "none";          % Data filename.
        bgMaskValue = 0;            % Value of background pixels in mask image.
        erasedMaskValue = 10;       % Values of erased pixels in mask image.
        shootMaskValue = 100;       % Value of shoot pixels in mask image.
        rootMaskValue = 150;        % Value of root pixels in mask image.
        uncertainMaskValue = 250;   % Value of uncertain (root or shoot) pixels in mask image.
        activeMaskValue = 0;        % Value to be painted in mask using mouse.
        segColorMap = 0;
        imagePlot = 0;              % Handle to main image plot.
        mouseDown = false;          % Is left mouse button currently pressed?
        inputFiles = [];            % List of input filenames.
        
        % Data that changes per image:
        inputFilename = "";         % Filename of current image with directory.
        inputImage = 0;             % Input image with 3 channels RGB of uint8.
        mask = 0;                   % Output mask (uint8 single channel).
        %maskPainted = 0;            % User's manual segmentation (used for input erasures and mask corrections).
        maskPlant1 = 0;             % Output mask for plant 1.
        maskPlant2 = 0;             % Output mask for plant 2.
        maskPlant3 = 0;             % Output mask for plant 3.
        maskPlant4 = 0;             % Output mask for plant 4.
        
        % Data that changes per session:
        inputDir = "";              % File folder or directory where all input images are.
        curInputIndex = 1;          % Index of current image from from list. 
    end
    
    % Private functions:
    methods (Access = private)

        function SaveSettings(app)
            appSettings = app.settings;
            save(app.saveFile, 'appSettings', '-append');
        end

        function LoadSettings(app, loadedData)
            app.settings = loadedData.appSettings;
        end

        function SaveCurrentImageData(app)
            if(sum(app.mask, "all") > 0)
                imageFieldname = GetImageFieldName(app, app.inputFilename);
                if(~isfield(app, imageFieldname))
                    app.data.(imageFieldname) = 0;
                end

                app.data.(imageFieldname) = struct( ...
                    'inputImage', app.inputImage, ...
                    'mask', app.mask, ... %'maskPainted', app.maskPainted, ...
                    'maskPlant1', app.maskPlant1, ...
                    'maskPlant2', app.maskPlant2, ...
                    'maskPlant3', app.maskPlant3, ...
                    'maskPlant4', app.maskPlant4, ...
                    'metadata', [app.PlateEditField.Value app.ConditionEditField.Value app.Gentype1EditField.Value app.Gentype2EditField.Value], ...
                    'shoots', [app.ShootsEditField_1.Value app.ShootsEditField_2.Value app.ShootsEditField_3.Value app.ShootsEditField_4.Value], ...
                    'roots', [app.RootsEditField_1.Value app.RootsEditField_2.Value app.RootsEditField_3.Value app.RootsEditField_4.Value] ...
                    );
            end

            appData = app.data;
            save(app.saveFile, 'appData', '-append');
        end

        function imageFieldname = GetImageFieldName(~, imageFilename)
            [~,filename,~] = fileparts(imageFilename);
            imageFieldname = "i" + filename;
        end

        function UpdateSegmentationPlot(app)
            cla(app.UIAxesSeg);
            imagesc(app.inputImage, "Parent", app.UIAxesSeg);
            hold(app.UIAxesSeg, "on");
            app.imagePlot = imagesc(app.mask, "Parent", app.UIAxesSeg);
            colormap(app.UIAxesSeg, app.segColorMap);
            caxis(app.UIAxesSeg, [0 app.uncertainMaskValue]);

            if(app.ShowMaskButton.Value)
                alphaImage = ComputeMaskAlphaImage(app);
            else
                alphaImage = zeros(size(app.mask));
            end

            set(app.imagePlot, 'AlphaData', alphaImage);  
            app.UIAxesSeg.XLim = [0 app.imagePlot.XData(2)];
            app.UIAxesSeg.YLim = [0 app.imagePlot.YData(2)];
            hold(app.UIAxesSeg, "off")
            set(app.imagePlot, 'Tag', 'WindowTag')
        end
        
        function InitializeVariables(app)
            app.SliderMaskAlpha.Value = app.settings.maskAlpha;
            app.CheckBoxShowBackground.Value = app.settings.showBackgroundColor;
            app.BackgroundLamp.Color = app.settings.bgColor;
            app.CheckBoxShowShoot.Value = app.settings.showShootColor;
            app.ShootLamp.Color = app.settings.shootColor;
            app.CheckBoxShowRoot.Value = app.settings.showRootColor;
            app.RootLamp.Color = app.settings.rootColor;
            app.CheckBoxShowUncertain.Value = app.settings.showUncertainColor;
            app.segColorMap = [app.settings.bgColor; app.settings.shootColor; app.settings.rootColor; app.settings.uncertainColor];
            app.PlantCheckBox.Value = app.settings.plantSegEnabled;
            app.ShootCheckBox.Value = app.settings.shootSegEnabled;
            app.RootCheckBox.Value = app.settings.rootSegEnabled;
            app.IslandsSpinnerPlant.Value = app.settings.plantSegIslands;
            app.IslandsSpinnerShoot.Value = app.settings.shootSegIslands;
            app.IslandsSpinnerRoot.Value = app.settings.rootSegIslands;
            app.ShowMaskButton.Value = true;
        end
        
        function RecomputeSegmentationMask(app)  
            if(app.RootCheckBox.Value)
                rootsMask = SegmentRoots(app.inputImage, app.IslandsSpinnerRoot.Value, app.PlantCheckBox.Value, app.IslandsSpinnerPlant.Value);
            end

            if(app.ShootCheckBox.Value)
                shootsMask = SegmentShoots(app.inputImage, app.IslandsSpinnerShoot.Value, app.PlantCheckBox.Value, app.IslandsSpinnerPlant.Value);
            end

            if(app.RootCheckBox.Value && app.ShootCheckBox.Value)
                app.mask = (uint8(rootsMask) * app.rootMaskValue) + (uint8(shootsMask) * app.shootMaskValue);
            elseif(app.RootCheckBox.Value && ~app.ShootCheckBox.Value)
                
                plantMask = SegmentPlant(app.inputImage, app.IslandsSpinnerPlant.Value);
                shootsMask = plantMask - rootsMask;
                shootsMask = bwareaopen(shootsMask, app.IslandsSpinnerShoot.Value);
                app.mask = (uint8(rootsMask) * app.rootMaskValue) + (uint8((shootsMask)) * app.shootMaskValue);
            elseif(~app.RootCheckBox.Value && app.ShootCheckBox.Value)
                plantMask = SegmentPlant(app.inputImage, app.IslandsSpinnerPlant.Value);
                rootsMask = plantMask - shootsMask;
                rootsMask = bwareaopen(rootsMask, app.IslandsSpinnerRoot.Value);
                app.mask = (uint8(shootsMask) * app.shootMaskValue) + (uint8((rootsMask)) * app.rootMaskValue); 
            else
                app.mask = zeros(size(app.inputImage), 'uint8');
                app.mask = app.mask(:,:,1);
            end
        end
        
        function UpdateMaskFromMouse(app, event)
            mouseButtonFlag = get(event.Source,'SelectionType');
            mousePos = get(app.UIAxesSeg,'CurrentPoint');
            mouseRowPos = round(mousePos(1,2));
            mouseColPos = round(mousePos(1,1));

            if(strcmp(mouseButtonFlag, 'normal'))
                app.mask(mouseRowPos, mouseColPos) = app.activeMaskValue;
                %app.maskPainted(mouseRowPos, mouseColPos) = app.activeMaskValue;
                alphaImage = ComputeMaskAlphaImage(app);
                set(app.imagePlot, 'CData', app.mask, 'alphadata', alphaImage);
            else
                app.inputImage(mouseRowPos, mouseColPos, :) = app.erasedMaskValue;
                app.mask(mouseRowPos, mouseColPos) = app.erasedMaskValue;
                alphaImage = ComputeMaskAlphaImage(app);
                set(app.imagePlot, 'CData', app.inputImage, 'alphadata', alphaImage);
            end
        end
        
        function alphaImage = ComputeMaskAlphaImage(app)
            alphaImage = ones(size(app.mask));
            if ~app.CheckBoxShowBackground.Value
                alphaImage = alphaImage - single(app.mask == app.bgMaskValue);
            end
            if ~app.CheckBoxShowShoot.Value
                alphaImage = alphaImage - single(app.mask == app.shootMaskValue);
            end
            if ~app.CheckBoxShowRoot.Value
                alphaImage = alphaImage - single(app.mask == app.rootMaskValue);
            end
            if ~app.CheckBoxShowUncertain.Value
                alphaImage = alphaImage - single(app.mask == app.uncertainMaskValue);
            end

            alphaImage = alphaImage * app.settings.maskAlpha;
        end

        function result = GetTifImageFiles(~, inputDir)
            listing = dir(strcat(inputDir, filesep, '*.tif'));
            numFilenames = size(listing, 1);
            fileIndex = 1;
            result = strings(1, size(listing, 1));
            while(fileIndex <= numFilenames)
                result(1, fileIndex) = string(listing(fileIndex).name);
                fileIndex = fileIndex + 1;
            end
        end

        function ResetMask(app)
            %app.maskPainted = ones([size(app.inputImage, 1) size(app.inputImage, 2)], 'uint8') * app.bgMaskValue;
            app.mask = ones([size(app.inputImage, 1) size(app.inputImage, 2)], 'uint8') * app.bgMaskValue;
            UpdateSegmentationPlot(app);
        end

        function LoadMask(app, imageFieldname)
            %app.maskPainted = app.data.(imageFieldname).maskPainted;
            app.mask = app.data.(imageFieldname).mask;
            UpdateSegmentationPlot(app);
        end

        function ResetAnalysis(app)
            app.PlateEditField.Value = 0;
            app.ConditionEditField.Value = 0;
            app.Gentype1EditField.Value = 0;
            app.Gentype2EditField.Value = 0;
            app.NumComponentsEditField.Value = 0;
            app.ShootsEditField_1.Value = 0;
            app.ShootsEditField_2.Value = 0;
            app.ShootsEditField_3.Value = 0;
            app.ShootsEditField_4.Value = 0;
            app.RootsEditField_1.Value = 0;
            app.RootsEditField_2.Value = 0;
            app.RootsEditField_3.Value = 0;
            app.RootsEditField_4.Value = 0;
            app.NumComponentsEditField.BackgroundColor = [1 1 1];

            app.maskPlant1 = 0;
            app.maskPlant2 = 0;
            app.maskPlant3 = 0;
            app.maskPlant4 = 0;

            cla(app.UIAxesPlant_1);
            cla(app.UIAxesPlant_2);
            cla(app.UIAxesPlant_3);
            cla(app.UIAxesPlant_4);
        end

        function LoadAnalysis(app, imageFieldname)
            
            metadata = app.data.(imageFieldname).metadata;
            shoots = app.data.(imageFieldname).shoots;
            roots = app.data.(imageFieldname).roots;
            app.maskPlant1 = app.data.(imageFieldname).maskPlant1;
            app.maskPlant2 = app.data.(imageFieldname).maskPlant2;
            app.maskPlant3 = app.data.(imageFieldname).maskPlant3;
            app.maskPlant4 = app.data.(imageFieldname).maskPlant4;

            app.PlateEditField.Value = metadata(1);
            app.ConditionEditField.Value = metadata(2);
            app.Gentype1EditField.Value = metadata(3);
            app.Gentype2EditField.Value = metadata(4);
            app.NumComponentsEditField.Value = 0;
            app.ShootsEditField_1.Value = shoots(1);
            app.ShootsEditField_2.Value = shoots(2);
            app.ShootsEditField_3.Value = shoots(3);
            app.ShootsEditField_4.Value = shoots(4);
            app.RootsEditField_1.Value = roots(1);
            app.RootsEditField_2.Value = roots(2);
            app.RootsEditField_3.Value = roots(3);
            app.RootsEditField_4.Value = roots(4);
            app.NumComponentsEditField.BackgroundColor = [1 1 1];

            PlotPlantMask(app, app.maskPlant1, app.UIAxesPlant_1, app.segColorMap, [0 app.uncertainMaskValue]);
            PlotPlantMask(app, app.maskPlant2, app.UIAxesPlant_2, app.segColorMap, [0 app.uncertainMaskValue]);
            PlotPlantMask(app, app.maskPlant3, app.UIAxesPlant_3, app.segColorMap, [0 app.uncertainMaskValue]);
            PlotPlantMask(app, app.maskPlant4, app.UIAxesPlant_4, app.segColorMap, [0 app.uncertainMaskValue]);
        end

        function ReloadCurrentImage(app)
            app.inputFilename = strcat(app.inputDir, filesep, app.inputFiles(app.curInputIndex));
            app.inputImage = imread(app.inputFilename);
        end

        function LoadImage(app, imageFieldname)
            app.inputFilename = strcat(app.inputDir, filesep, app.inputFiles(app.curInputIndex));
            app.inputImage = app.data.(imageFieldname).inputImage;
        end

        function LoadNewImage(app)
            imageFieldname = GetImageFieldName(app, app.inputFiles(app.curInputIndex));
            if(isfield(app.data, imageFieldname))
                LoadImage(app, imageFieldname);
                LoadMask(app, imageFieldname);
                LoadAnalysis(app, imageFieldname);
            else
                ReloadCurrentImage(app);
                ResetMask(app);
                ResetAnalysis(app);
            end
        end

        function UpdateSegmentationPlotAppearance(app)
            if(app.ShowMaskButton.Value)
                alphaImage = ComputeMaskAlphaImage(app);
            else
                alphaImage = zeros(size(app.mask));
            end
           
            set(app.imagePlot, 'CData', app.mask, 'alphadata', alphaImage);
            app.segColorMap = [app.settings.bgColor; app.settings.shootColor; app.settings.rootColor; app.settings.uncertainColor];
            colormap(app.UIAxesSeg, app.segColorMap);
            caxis(app.UIAxesSeg, [0 app.uncertainMaskValue]);
        end

        function [plantMask, shootArea, rootArea] = GetPlantStats(app, bbox, plantPixelIndexList)
            left = round(bbox(1));
            top = round(bbox(2));
            width = round(bbox(3));
            height = round(bbox(4));
            tempMask = app.mask .* 0;
            tempMask(plantPixelIndexList) = 1;
            tempMask = tempMask .* app.mask;
            plantMask = tempMask(top:top+height, left:left+width, :);
            % We count uncertain pixels as both shoots and roots:
            shootArea = sum((plantMask == app.shootMaskValue) | (plantMask == app.uncertainMaskValue),'all');
            rootArea = sum((plantMask == app.rootMaskValue) | (plantMask == app.uncertainMaskValue),'all');
        end

        function PlotPlantMask(~, plantMask, uiAxes, plotColorMap, valueRange)
            cla(uiAxes);
            if(plantMask == 0)
                return;
            end
            plot = imshow(plantMask, 'Parent', uiAxes);
            colormap(uiAxes, plotColorMap);
            caxis(uiAxes, valueRange);
            uiAxes.XLim = [0 plot.XData(2)];
            uiAxes.YLim = [0 plot.YData(2)];
        end

        function [connectedComponents, numDetectedObjects] = ComputePlantConnectedComponents(app, filterTopFourComponents)
            % Note that connected components are, by default, sorted from
            % left to right, then top to bottom.
            plantMask = (app.mask == app.rootMaskValue | app.mask == app.shootMaskValue | app.mask == app.uncertainMaskValue);
            connectedComponents = bwconncomp(plantMask);
            numDetectedObjects = connectedComponents.NumObjects;
            app.NumComponentsEditField.Value = numDetectedObjects;
            if(numDetectedObjects ~= 4)
                app.NumComponentsEditField.BackgroundColor = [0.8, 0, 0];
            else
                app.NumComponentsEditField.BackgroundColor = [1, 1, 1];
            end

            if(filterTopFourComponents)
                % Get top four components then redo connected component
                % analysis (keep original number of components):
                plantMask = bwareafilt(plantMask, 4);
                connectedComponents = bwconncomp(plantMask);
            end
        end

        function PlotConnectedComponents(app)
            connectedComponents = ComputePlantConnectedComponents(app, false);
            labels = labelmatrix(connectedComponents);
            coloredLabels = label2rgb(labels, @lines, "black", "shuffle");
            imshow(coloredLabels);
        end

        function ClearPlantMasksAndPlots(app)
            app.maskPlant1 = 0;
            app.maskPlant2 = 0;
            app.maskPlant3 = 0;
            app.maskPlant4 = 0;
            cla(app.UIAxesPlant_1);
            cla(app.UIAxesPlant_2);
            cla(app.UIAxesPlant_3);
            cla(app.UIAxesPlant_4);
            app.RootsEditField_1.Value = 0;
            app.RootsEditField_2.Value = 0;
            app.RootsEditField_3.Value = 0;
            app.RootsEditField_4.Value = 0;
            app.ShootsEditField_1.Value = 0;
            app.ShootsEditField_2.Value = 0;
            app.ShootsEditField_3.Value = 0;
            app.ShootsEditField_4.Value = 0;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            InitializeVariables(app);
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            if(strcmp(app.saveFile, "none"))
                app.saveFile = uiputfile('*.mat', "Save PlantSeg Data" );
            end
            if(app.saveFile)
                app_dataMagicString = app.dataMagicString;
                save(app.saveFile, 'app_dataMagicString');
                app_inputDir = app.inputDir;
                save(app.saveFile, 'app_inputDir', '-append');
                app_curInputIndex = app.curInputIndex;
                save(app.saveFile, 'app_curInputIndex', '-append');

                SaveSettings(app);

                SaveCurrentImageData(app);
            end
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            app.saveFile = uigetfile('*.mat', "Load PlantSeg Data");
            if(app.saveFile)
               loadedData = load(app.saveFile);
               if(isfield(loadedData, 'appData'))
                   app.data = loadedData.appData;
               end
            end
            
            if(~isfield(loadedData, 'app_dataMagicString') || ~strcmp(app.dataMagicString, loadedData.app_dataMagicString))
                message = {'Invalid PlantSeg file!','Please load a valid PlantSeg data file.'};
                uialert(app.UIFigure,message,'Warning',...
                'Icon','warning');
                return;
            end

            LoadSettings(app, loadedData);
            InitializeVariables(app);

            app.inputDir = loadedData.app_inputDir;
            app.inputFiles = GetTifImageFiles(app, app.inputDir);
            app.CurrentImageDropDown.Items = app.inputFiles;
            app.CurrentImageDropDown.ItemsData = 1 : size(app.inputFiles, 2);
            app.curInputIndex = loadedData.app_curInputIndex;
            set(app.CurrentImageDropDown, 'Value', app.curInputIndex);

            LoadNewImage(app);
        end

        % Button pushed function: NewButton
        function NewButtonPushed(app, event)
            
            app.inputDir = uigetdir;
            app.inputFiles = GetTifImageFiles(app, app.inputDir);
            app.curInputIndex = 1;
            app.CurrentImageDropDown.Items = app.inputFiles;
            app.CurrentImageDropDown.ItemsData = 1 : size(app.inputFiles, 2);
            
            LoadNewImage(app);
        end

        % Value changed function: SliderMaskAlpha
        function SliderMaskAlphaValueChanged(app, event)
            app.settings.maskAlpha = app.SliderMaskAlpha.Value;
            UpdateSegmentationPlotAppearance(app);
        end

        % Window button down function: UIFigure
        function UIFigureWindowButtonDown(app, event)
            if ~isempty(event.Source.CurrentObject) && isequal(event.Source.CurrentObject.Tag,'WindowTag')
                app.mouseDown = true;
                UpdateMaskFromMouse(app, event);
            end
        end

        % Window button motion function: UIFigure
        function UIFigureWindowButtonMotion(app, event)
            if ~isempty(event.Source.CurrentObject) && isequal(event.Source.CurrentObject.Tag,'WindowTag')
                if(app.mouseDown)
                    UpdateMaskFromMouse(app, event);
                end
            end
        end

        % Window button up function: UIFigure
        function UIFigureWindowButtonUp(app, event)
            if ~isempty(event.Source.CurrentObject) && isequal(event.Source.CurrentObject.Tag,'WindowTag')
                app.mouseDown = false;
            end
        end

        % Selection changed function: BrushButtonGroup
        function BrushButtonGroupSelectionChanged(app, event)
            selectedButton = app.BrushButtonGroup.SelectedObject;
            if(strcmp(selectedButton.Text, "Background"))
                app.activeMaskValue = app.bgMaskValue;
            end
            if(strcmp(selectedButton.Text, "Root"))
                app.activeMaskValue = app.rootMaskValue;
            end
            if(strcmp(selectedButton.Text, "Shoot"))
                app.activeMaskValue = app.shootMaskValue;
            end
        end

        % Value changed function: CurrentImageDropDown
        function CurrentImageDropDownValueChanged(app, event)
            app.curInputIndex = app.CurrentImageDropDown.Value;
            LoadNewImage(app);
        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            if (app.curInputIndex == size(app.inputFiles, 2))
                message = {'End of files list!','Use dropdown menu to select file.'};
                uialert(app.UIFigure,message,'Warning',...
                'Icon','warning');
            else
                app.curInputIndex = app.curInputIndex + 1;
                set(app.CurrentImageDropDown, 'Value', app.curInputIndex);
                LoadNewImage(app);
            end            
        end

        % Button pushed function: PrevButton
        function PrevButtonPushed(app, event)
            if (app.curInputIndex == 1)
                message = {'Beginning of files list!','Use dropdown menu to select file.'};
                uialert(app.UIFigure,message,'Warning',...
                'Icon','warning');
            else
                app.curInputIndex = app.curInputIndex - 1;
                set(app.CurrentImageDropDown, 'Value', app.curInputIndex);
                LoadNewImage(app);
            end    
        end

        % Button pushed function: AutoSegmentButton
        function AutoSegmentButtonPushed(app, event)
            RecomputeSegmentationMask(app);
            UpdateSegmentationPlot(app);
        end

        % Button pushed function: ResetAllButton
        function ResetAllButtonPushed(app, event)
            ReloadCurrentImage(app); % We do this to reset the manually enforced changes to the input.
            ResetMask(app);
        end

        % Value changed function: CheckBoxShowBackground
        function CheckBoxShowBackgroundValueChanged(app, event)
            app.settings.showBackgroundColor = app.CheckBoxShowBackground.Value;
            UpdateSegmentationPlotAppearance(app);
        end

        % Value changed function: CheckBoxShowShoot
        function CheckBoxShowShootValueChanged(app, event)
            app.settings.showShootColor = app.CheckBoxShowShoot.Value;
            UpdateSegmentationPlotAppearance(app);
        end

        % Value changed function: CheckBoxShowRoot
        function CheckBoxShowRootValueChanged(app, event)
            app.settings.showRootColor = app.CheckBoxShowRoot.Value;
            UpdateSegmentationPlotAppearance(app);
        end

        % Value changed function: CheckBoxShowUncertain
        function CheckBoxShowUncertainValueChanged(app, event)
            app.settings.showUncertainColor = app.CheckBoxShowUncertain.Value;
            UpdateSegmentationPlotAppearance(app);
        end

        % Callback function
        function ToggleMaskVisibilityButtonPushed(app, event)
            ToggleMaskVisibility(app);
            UpdateSegmentationPlot(app);
        end

        % Button pushed function: RunAnalysisButton
        function RunAnalysisButtonPushed(app, event)
            [connectedComponents, numDetectedObjects] = ComputePlantConnectedComponents(app, true);
            stats = regionprops(connectedComponents, "basic");

            if(numDetectedObjects == 1)
                [bbox1] = stats.BoundingBox;
            end
            if(numDetectedObjects == 2)
                [bbox1, bbox2] = stats.BoundingBox;
            end
            if(numDetectedObjects == 3)
                [bbox1, bbox2, bbox3] = stats.BoundingBox;
            end
            if(numDetectedObjects >= 4)
                [bbox1, bbox2, bbox3, bbox4] = stats.BoundingBox;
            end

            ClearPlantMasksAndPlots(app);

            if(numDetectedObjects > 0)
                [app.maskPlant1, app.ShootsEditField_1.Value, app.RootsEditField_1.Value] = GetPlantStats(app, bbox1, connectedComponents.PixelIdxList{1});
                PlotPlantMask(app, app.maskPlant1, app.UIAxesPlant_1, app.segColorMap, [0 app.uncertainMaskValue]);
            end
            if(numDetectedObjects > 1)
                [app.maskPlant2, app.ShootsEditField_2.Value, app.RootsEditField_2.Value] = GetPlantStats(app, bbox2, connectedComponents.PixelIdxList{2});
                PlotPlantMask(app, app.maskPlant2, app.UIAxesPlant_2, app.segColorMap, [0 app.uncertainMaskValue]);
            end
            if(numDetectedObjects > 2)
                [app.maskPlant3, app.ShootsEditField_3.Value, app.RootsEditField_3.Value] = GetPlantStats(app, bbox3, connectedComponents.PixelIdxList{3});
                PlotPlantMask(app, app.maskPlant3, app.UIAxesPlant_3, app.segColorMap, [0 app.uncertainMaskValue]);
            end
            if(numDetectedObjects > 3)
                [app.maskPlant4, app.ShootsEditField_4.Value, app.RootsEditField_4.Value] = GetPlantStats(app, bbox4, connectedComponents.PixelIdxList{4});
                PlotPlantMask(app, app.maskPlant4, app.UIAxesPlant_4, app.segColorMap, [0 app.uncertainMaskValue]);
            end
            
            % Try to detect digits on image:
%             if(app.PlateEditField.Value == 0)
%                 imageHistEq = histeq(app.inputImage);
%                 
%                 app.PlateEditField.Value = DetectDigits(imageHistEq, [32.0000 22.0000 282 212]);
%                 app.ConditionEditField.Value = DetectDigits(imageHistEq, [673 21.0000 302 221]);
%                 app.Gentype1EditField.Value = DetectDigits(imageHistEq, [34 771 291 209]);
%                 app.Gentype2EditField.Value = DetectDigits(imageHistEq, [661 733 313 250]);
%             end
        end

        % Value changed function: ShowMaskButton
        function ShowMaskButtonValueChanged(app, event)
            %UpdateSegmentationPlot(app);
            UpdateSegmentationPlotAppearance(app);
        end

        % Button pushed function: ShowComponentsButton
        function ShowComponentsButtonPushed(app, event)
            PlotConnectedComponents(app);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app)
            close all;
        end

        % Button pushed function: ExportDataButton
        function ExportDataButtonPushed(app, event)
            exportFile = uiputfile('*.csv', "Save PlantSeg Metadata");
            fn = fieldnames(app.data);
            numFiles = numel(fn);
            FileName = strings([numFiles 1]);
            PlateNumber = strings([numFiles 1]);
            Condition = strings([numFiles 1]);
            GenType1 = strings([numFiles 1]);
            GenType2 = strings([numFiles 1]);
            Shoots1 = strings([numFiles 1]);
            Shoots2 = strings([numFiles 1]);
            Shoots3 = strings([numFiles 1]);
            Shoots4 = strings([numFiles 1]);
            Roots1 = strings([numFiles 1]);
            Roots2 = strings([numFiles 1]);
            Roots3 = strings([numFiles 1]);
            Roots4 = strings([numFiles 1]);

            for k = 1:numel(fn)
                imageFieldname = fn{k};
                FileName(k) = imageFieldname;
                metadata = app.data.(imageFieldname).metadata;
                shootsdata = app.data.(imageFieldname).shoots;
                rootsdata = app.data.(imageFieldname).roots;

                PlateNumber(k) = string(metadata(1));
                Condition(k) = string(metadata(2));
                GenType1(k) = string(metadata(3));
                GenType2(k) = string(metadata(4));
                Shoots1(k) = string(shootsdata(1));
                Shoots2(k) = string(shootsdata(2));
                Shoots3(k) = string(shootsdata(3));
                Shoots4(k) = string(shootsdata(4));
                Roots1(k) = string(rootsdata(1));
                Roots2(k) = string(rootsdata(2));
                Roots3(k) = string(rootsdata(3));
                Roots4(k) = string(rootsdata(4));
            end
            exportTable = table(FileName, PlateNumber, Condition, GenType1, GenType2, ...
                Shoots1, Shoots2, Shoots3, Shoots4, ...
                Roots1, Roots2, Roots3, Roots4);
            writetable(exportTable, exportFile);
        end

        % Button pushed function: SetBackgroundColorButton
        function SetBackgroundColorButtonPushed(app, event)
            app.settings.bgColor = uisetcolor(app.settings.bgColor);
            app.BackgroundLamp.Color = app.settings.bgColor;
            UpdateSegmentationPlotAppearance(app);
        end

        % Button pushed function: SetShootColorButton
        function SetShootColorButtonPushed(app, event)
            app.settings.shootColor = uisetcolor(app.settings.shootColor);
            app.ShootLamp.Color = app.settings.shootColor;
            UpdateSegmentationPlotAppearance(app);
        end

        % Button pushed function: SetRootColorButton
        function SetRootColorButtonPushed(app, event)
            app.settings.rootColor = uisetcolor(app.settings.rootColor);
            app.RootLamp.Color = app.settings.rootColor;
            UpdateSegmentationPlotAppearance(app);
        end

        % Button pushed function: SetUncertainColorButton
        function SetUncertainColorButtonPushed(app, event)
            app.settings.uncertainColor = uisetcolor(app.settings.uncertainColor);
            UpdateSegmentationPlotAppearance(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 911 842];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.UIFigure.WindowButtonDownFcn = createCallbackFcn(app, @UIFigureWindowButtonDown, true);
            app.UIFigure.WindowButtonUpFcn = createCallbackFcn(app, @UIFigureWindowButtonUp, true);
            app.UIFigure.WindowButtonMotionFcn = createCallbackFcn(app, @UIFigureWindowButtonMotion, true);

            % Create UIAxesSeg
            app.UIAxesSeg = uiaxes(app.UIFigure);
            app.UIAxesSeg.XTick = [];
            app.UIAxesSeg.YTick = [];
            app.UIAxesSeg.Box = 'on';
            app.UIAxesSeg.Position = [2 217 600 600];

            % Create UIAxesPlant_1
            app.UIAxesPlant_1 = uiaxes(app.UIFigure);
            app.UIAxesPlant_1.XTick = [];
            app.UIAxesPlant_1.YTick = [];
            app.UIAxesPlant_1.Box = 'on';
            app.UIAxesPlant_1.Position = [600 516 150 300];

            % Create UIAxesPlant_2
            app.UIAxesPlant_2 = uiaxes(app.UIFigure);
            app.UIAxesPlant_2.XTick = [];
            app.UIAxesPlant_2.YTick = [];
            app.UIAxesPlant_2.Box = 'on';
            app.UIAxesPlant_2.Position = [749 516 150 300];

            % Create UIAxesPlant_3
            app.UIAxesPlant_3 = uiaxes(app.UIFigure);
            app.UIAxesPlant_3.XTick = [];
            app.UIAxesPlant_3.YTick = [];
            app.UIAxesPlant_3.Box = 'on';
            app.UIAxesPlant_3.Position = [600 218 150 300];

            % Create UIAxesPlant_4
            app.UIAxesPlant_4 = uiaxes(app.UIFigure);
            app.UIAxesPlant_4.XTick = [];
            app.UIAxesPlant_4.YTick = [];
            app.UIAxesPlant_4.Box = 'on';
            app.UIAxesPlant_4.Position = [749 218 150 300];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [6 9 590 210];

            % Create MainTab
            app.MainTab = uitab(app.TabGroup);
            app.MainTab.Title = 'Main';

            % Create NewButton
            app.NewButton = uibutton(app.MainTab, 'push');
            app.NewButton.ButtonPushedFcn = createCallbackFcn(app, @NewButtonPushed, true);
            app.NewButton.BackgroundColor = [0.8196 0.9882 0.7294];
            app.NewButton.Tooltip = {'Start a new session by selecting a folder where all input tif images are located.'};
            app.NewButton.Position = [5 150 50 23];
            app.NewButton.Text = 'New';

            % Create BrushButtonGroup
            app.BrushButtonGroup = uibuttongroup(app.MainTab);
            app.BrushButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @BrushButtonGroupSelectionChanged, true);
            app.BrushButtonGroup.Title = 'Brush:';
            app.BrushButtonGroup.Position = [322 4 143 136];

            % Create RootButton
            app.RootButton = uitogglebutton(app.BrushButtonGroup);
            app.RootButton.Tooltip = {'Set brush to paint roots pixels.'};
            app.RootButton.Text = 'Root';
            app.RootButton.Position = [9 32 100 23];

            % Create ShootButton
            app.ShootButton = uitogglebutton(app.BrushButtonGroup);
            app.ShootButton.Tooltip = {'Set brush to paint shoots pixels.'};
            app.ShootButton.Text = 'Shoot';
            app.ShootButton.Position = [9 60 100 23];

            % Create BackgroundButton
            app.BackgroundButton = uitogglebutton(app.BrushButtonGroup);
            app.BackgroundButton.Tooltip = {'Set brush to paint background pixels.'};
            app.BackgroundButton.Text = 'Background';
            app.BackgroundButton.Position = [9 88 100 23];
            app.BackgroundButton.Value = true;

            % Create BackgroundLamp
            app.BackgroundLamp = uilamp(app.BrushButtonGroup);
            app.BackgroundLamp.Position = [117 90 20 20];

            % Create ShootLamp
            app.ShootLamp = uilamp(app.BrushButtonGroup);
            app.ShootLamp.Position = [117 60 20 20];

            % Create RootLamp
            app.RootLamp = uilamp(app.BrushButtonGroup);
            app.RootLamp.Position = [117 33 20 20];

            % Create ResetAllButton
            app.ResetAllButton = uibutton(app.BrushButtonGroup, 'push');
            app.ResetAllButton.ButtonPushedFcn = createCallbackFcn(app, @ResetAllButtonPushed, true);
            app.ResetAllButton.Tooltip = {'Reset segmentation mask (including erased pixels in input image).'};
            app.ResetAllButton.Position = [9 5 100 23];
            app.ResetAllButton.Text = 'Reset All';

            % Create CurrentImageDropDown
            app.CurrentImageDropDown = uidropdown(app.MainTab);
            app.CurrentImageDropDown.Items = {};
            app.CurrentImageDropDown.ValueChangedFcn = createCallbackFcn(app, @CurrentImageDropDownValueChanged, true);
            app.CurrentImageDropDown.Position = [194 151 210 22];
            app.CurrentImageDropDown.Value = {};

            % Create PrevButton
            app.PrevButton = uibutton(app.MainTab, 'push');
            app.PrevButton.ButtonPushedFcn = createCallbackFcn(app, @PrevButtonPushed, true);
            app.PrevButton.Tooltip = {'Go to previous image in image list. If segmentation data exists, it is loaded and plotted.'};
            app.PrevButton.Position = [135 150 50 23];
            app.PrevButton.Text = 'Prev.';

            % Create NextButton
            app.NextButton = uibutton(app.MainTab, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.Tooltip = {'Go to next image in image list. If segmentation data exists, it is loaded and plotted.'};
            app.NextButton.Position = [414 150 50 23];
            app.NextButton.Text = 'Next';

            % Create SegmentationPanel
            app.SegmentationPanel = uipanel(app.MainTab);
            app.SegmentationPanel.Title = 'Segmentation:';
            app.SegmentationPanel.Position = [134 4 178 136];

            % Create PlantCheckBox
            app.PlantCheckBox = uicheckbox(app.SegmentationPanel);
            app.PlantCheckBox.Enable = 'off';
            app.PlantCheckBox.Text = 'Plant';
            app.PlantCheckBox.Position = [8 89 50 22];

            % Create ShootCheckBox
            app.ShootCheckBox = uicheckbox(app.SegmentationPanel);
            app.ShootCheckBox.Text = 'Shoot';
            app.ShootCheckBox.Position = [8 64 54 22];

            % Create RootCheckBox
            app.RootCheckBox = uicheckbox(app.SegmentationPanel);
            app.RootCheckBox.Text = 'Root';
            app.RootCheckBox.Position = [8 39 48 22];

            % Create IslandsSpinnerLabel
            app.IslandsSpinnerLabel = uilabel(app.SegmentationPanel);
            app.IslandsSpinnerLabel.HorizontalAlignment = 'right';
            app.IslandsSpinnerLabel.Position = [63 90 47 22];
            app.IslandsSpinnerLabel.Text = 'Islands:';

            % Create IslandsSpinnerPlant
            app.IslandsSpinnerPlant = uispinner(app.SegmentationPanel);
            app.IslandsSpinnerPlant.Step = 10;
            app.IslandsSpinnerPlant.Limits = [0 Inf];
            app.IslandsSpinnerPlant.RoundFractionalValues = 'on';
            app.IslandsSpinnerPlant.Tooltip = {'After thresholding, connected components with fewer pixels than this value are removed from the output mask.'};
            app.IslandsSpinnerPlant.Position = [114 89 59 22];
            app.IslandsSpinnerPlant.Value = 200;

            % Create IslandsSpinner_2Label
            app.IslandsSpinner_2Label = uilabel(app.SegmentationPanel);
            app.IslandsSpinner_2Label.HorizontalAlignment = 'right';
            app.IslandsSpinner_2Label.Position = [64 64 47 22];
            app.IslandsSpinner_2Label.Text = 'Islands:';

            % Create IslandsSpinnerShoot
            app.IslandsSpinnerShoot = uispinner(app.SegmentationPanel);
            app.IslandsSpinnerShoot.Step = 10;
            app.IslandsSpinnerShoot.Limits = [0 Inf];
            app.IslandsSpinnerShoot.RoundFractionalValues = 'on';
            app.IslandsSpinnerShoot.Tooltip = {'After thresholding, connected components with fewer pixels than this value are removed from the output mask.'};
            app.IslandsSpinnerShoot.Position = [114 64 59 22];
            app.IslandsSpinnerShoot.Value = 150;

            % Create IslandsSpinner_3Label
            app.IslandsSpinner_3Label = uilabel(app.SegmentationPanel);
            app.IslandsSpinner_3Label.HorizontalAlignment = 'right';
            app.IslandsSpinner_3Label.Position = [64 39 47 22];
            app.IslandsSpinner_3Label.Text = 'Islands:';

            % Create IslandsSpinnerRoot
            app.IslandsSpinnerRoot = uispinner(app.SegmentationPanel);
            app.IslandsSpinnerRoot.Step = 10;
            app.IslandsSpinnerRoot.Limits = [0 Inf];
            app.IslandsSpinnerRoot.RoundFractionalValues = 'on';
            app.IslandsSpinnerRoot.Tooltip = {'After thresholding, connected components with fewer pixels than this value are removed from the output mask.'};
            app.IslandsSpinnerRoot.Position = [114 39 59 22];
            app.IslandsSpinnerRoot.Value = 150;

            % Create ShowMaskButton
            app.ShowMaskButton = uibutton(app.SegmentationPanel, 'state');
            app.ShowMaskButton.ValueChangedFcn = createCallbackFcn(app, @ShowMaskButtonValueChanged, true);
            app.ShowMaskButton.Tooltip = {'Toggle visibility of segmentation mask in plot.'};
            app.ShowMaskButton.Text = 'Show Mask';
            app.ShowMaskButton.Position = [52 5 73 23];

            % Create LoadButton
            app.LoadButton = uibutton(app.MainTab, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.BackgroundColor = [0.8196 0.9882 0.7294];
            app.LoadButton.Tooltip = {'Load a PlantSeg file (*.mat) file to load settings and segmentation data.'};
            app.LoadButton.Position = [60 150 50 23];
            app.LoadButton.Text = 'Load';

            % Create AutoSegmentButton
            app.AutoSegmentButton = uibutton(app.MainTab, 'push');
            app.AutoSegmentButton.ButtonPushedFcn = createCallbackFcn(app, @AutoSegmentButtonPushed, true);
            app.AutoSegmentButton.Tooltip = {'Apply auto segmentation. This will overwrite manually painted "background", "shoot", and "root" pixels (not the erased pixels).'};
            app.AutoSegmentButton.Position = [482 150 100 23];
            app.AutoSegmentButton.Text = 'Auto Segment';

            % Create ExportDataButton
            app.ExportDataButton = uibutton(app.MainTab, 'push');
            app.ExportDataButton.ButtonPushedFcn = createCallbackFcn(app, @ExportDataButtonPushed, true);
            app.ExportDataButton.Position = [5 117 106 23];
            app.ExportDataButton.Text = 'Export Data';

            % Create MaskAppearanceTab
            app.MaskAppearanceTab = uitab(app.TabGroup);
            app.MaskAppearanceTab.Title = 'Mask Appearance';

            % Create MaskAlphaLabel
            app.MaskAlphaLabel = uilabel(app.MaskAppearanceTab);
            app.MaskAlphaLabel.HorizontalAlignment = 'center';
            app.MaskAlphaLabel.WordWrap = 'on';
            app.MaskAlphaLabel.FontWeight = 'bold';
            app.MaskAlphaLabel.Position = [231 154 91 22];
            app.MaskAlphaLabel.Text = 'Mask Alpha:';

            % Create SliderMaskAlpha
            app.SliderMaskAlpha = uislider(app.MaskAppearanceTab);
            app.SliderMaskAlpha.Limits = [0 1];
            app.SliderMaskAlpha.ValueChangedFcn = createCallbackFcn(app, @SliderMaskAlphaValueChanged, true);
            app.SliderMaskAlpha.Position = [247 140 150 3];

            % Create CheckBoxShowBackground
            app.CheckBoxShowBackground = uicheckbox(app.MaskAppearanceTab);
            app.CheckBoxShowBackground.ValueChangedFcn = createCallbackFcn(app, @CheckBoxShowBackgroundValueChanged, true);
            app.CheckBoxShowBackground.Text = '';
            app.CheckBoxShowBackground.Position = [10 125 26 22];

            % Create CheckBoxShowShoot
            app.CheckBoxShowShoot = uicheckbox(app.MaskAppearanceTab);
            app.CheckBoxShowShoot.ValueChangedFcn = createCallbackFcn(app, @CheckBoxShowShootValueChanged, true);
            app.CheckBoxShowShoot.Text = '';
            app.CheckBoxShowShoot.Position = [10 94 26 22];

            % Create CheckBoxShowRoot
            app.CheckBoxShowRoot = uicheckbox(app.MaskAppearanceTab);
            app.CheckBoxShowRoot.ValueChangedFcn = createCallbackFcn(app, @CheckBoxShowRootValueChanged, true);
            app.CheckBoxShowRoot.Text = '';
            app.CheckBoxShowRoot.Position = [10 65 26 22];

            % Create CheckBoxShowUncertain
            app.CheckBoxShowUncertain = uicheckbox(app.MaskAppearanceTab);
            app.CheckBoxShowUncertain.ValueChangedFcn = createCallbackFcn(app, @CheckBoxShowUncertainValueChanged, true);
            app.CheckBoxShowUncertain.Text = '';
            app.CheckBoxShowUncertain.Position = [10 35 26 22];

            % Create MaskVisibilityAndColorLabel
            app.MaskVisibilityAndColorLabel = uilabel(app.MaskAppearanceTab);
            app.MaskVisibilityAndColorLabel.FontWeight = 'bold';
            app.MaskVisibilityAndColorLabel.Position = [11 152 153 22];
            app.MaskVisibilityAndColorLabel.Text = 'Mask Visibility And Color:';

            % Create SetBackgroundColorButton
            app.SetBackgroundColorButton = uibutton(app.MaskAppearanceTab, 'push');
            app.SetBackgroundColorButton.ButtonPushedFcn = createCallbackFcn(app, @SetBackgroundColorButtonPushed, true);
            app.SetBackgroundColorButton.Position = [32 125 135 23];
            app.SetBackgroundColorButton.Text = 'Set Background Color';

            % Create SetShootColorButton
            app.SetShootColorButton = uibutton(app.MaskAppearanceTab, 'push');
            app.SetShootColorButton.ButtonPushedFcn = createCallbackFcn(app, @SetShootColorButtonPushed, true);
            app.SetShootColorButton.Position = [32 94 135 23];
            app.SetShootColorButton.Text = 'Set Shoot Color';

            % Create SetRootColorButton
            app.SetRootColorButton = uibutton(app.MaskAppearanceTab, 'push');
            app.SetRootColorButton.ButtonPushedFcn = createCallbackFcn(app, @SetRootColorButtonPushed, true);
            app.SetRootColorButton.Position = [32 65 135 23];
            app.SetRootColorButton.Text = 'Set Root Color';

            % Create SetUncertainColorButton
            app.SetUncertainColorButton = uibutton(app.MaskAppearanceTab, 'push');
            app.SetUncertainColorButton.ButtonPushedFcn = createCallbackFcn(app, @SetUncertainColorButtonPushed, true);
            app.SetUncertainColorButton.Position = [32 35 135 23];
            app.SetUncertainColorButton.Text = 'Set Uncertain Color';

            % Create HelpTab
            app.HelpTab = uitab(app.TabGroup);
            app.HelpTab.Title = 'Help';

            % Create StepsTextAreaLabel
            app.StepsTextAreaLabel = uilabel(app.HelpTab);
            app.StepsTextAreaLabel.HorizontalAlignment = 'right';
            app.StepsTextAreaLabel.Position = [20 151 40 22];
            app.StepsTextAreaLabel.Text = 'Steps:';

            % Create StepsTextArea
            app.StepsTextArea = uitextarea(app.HelpTab);
            app.StepsTextArea.Position = [75 2 500 174];
            app.StepsTextArea.Value = {'1. Click "New" or "Load" button to start a new session or load a previous session.'; '2. Click "Prev" or "Next" button to select an image to process.'; '3. Click "Auto Segment" button to apply automatic segmentation. You can change the parameters in "Segmentation" panel. See tooltips for more info. '; '4.  Use the left mouse button to manually brush on the segmentation mask. Use right mouse button to erase pixels from input image (to separate roots/shoots from boundary region). When "Auto Segment" button is pressed, the mask is recomputed considering the erased pixels and removing manually segmented pixels.'; '5. After segmentation, click the "Run Analysis" button to get the four individual plant masks - they will be plotted and sizes (in number of pixels) displayed. If the "# Comps." box turns red, this means the number of detected components in the segmentation mask is not equal to four. Click the "Show Components" button to display the detected components, which can guide you in further modifying the segmentation to mask to achieve your goal of getting the plants to be the four largest detected connected components. If there are less than four plants in the image, you can manually edit the "Shoots" and "Roots" pixel counts to match the plant indices.'; '6. Click "Save" button to save your session. This will save the settings and all input and segmentation data.'; '7. Click "Export Data" to export metadata (filename, plate number, condition, gentype 1 and 2, root and shoot sizes) to a csv file.'; ''; 'Note that the "Mask Appearance" tab allows you to modify the mask appearance in the plot.'};

            % Create AnalysisPanel
            app.AnalysisPanel = uipanel(app.UIFigure);
            app.AnalysisPanel.Title = 'Analysis';
            app.AnalysisPanel.Position = [604 10 291 209];

            % Create RunAnalysisButton
            app.RunAnalysisButton = uibutton(app.AnalysisPanel, 'push');
            app.RunAnalysisButton.ButtonPushedFcn = createCallbackFcn(app, @RunAnalysisButtonPushed, true);
            app.RunAnalysisButton.Tooltip = {'Run analysis on connected components. The top four (in terms of size) components are used for plants 1, 2, 3, and 4 (based on location in image from left to right).'};
            app.RunAnalysisButton.Position = [131 150 94 23];
            app.RunAnalysisButton.Text = 'Run Analysis';

            % Create ShootsEditField_1
            app.ShootsEditField_1 = uieditfield(app.AnalysisPanel, 'numeric');
            app.ShootsEditField_1.Tooltip = {'Number of shoots pixels in plant 1 mask.'};
            app.ShootsEditField_1.Position = [80 43 40 22];

            % Create ShootsLabel
            app.ShootsLabel = uilabel(app.AnalysisPanel);
            app.ShootsLabel.Position = [36 43 46 22];
            app.ShootsLabel.Text = 'Shoots:';

            % Create ShootsEditField_2
            app.ShootsEditField_2 = uieditfield(app.AnalysisPanel, 'numeric');
            app.ShootsEditField_2.Tooltip = {'Number of shoots pixels in plant 2 mask.'};
            app.ShootsEditField_2.Position = [135 43 40 22];

            % Create ShootsEditField_3
            app.ShootsEditField_3 = uieditfield(app.AnalysisPanel, 'numeric');
            app.ShootsEditField_3.Tooltip = {'Number of shoots pixels in plant 3 mask.'};
            app.ShootsEditField_3.Position = [188 43 40 22];

            % Create ShootsEditField_4
            app.ShootsEditField_4 = uieditfield(app.AnalysisPanel, 'numeric');
            app.ShootsEditField_4.Tooltip = {'Number of shoots pixels in plant 4 mask.'};
            app.ShootsEditField_4.Position = [241 43 40 22];

            % Create RootsEditField_1
            app.RootsEditField_1 = uieditfield(app.AnalysisPanel, 'numeric');
            app.RootsEditField_1.Tooltip = {'Number of roots pixels in plant 1 mask.'};
            app.RootsEditField_1.Position = [80 11 40 22];

            % Create RootsLabel
            app.RootsLabel = uilabel(app.AnalysisPanel);
            app.RootsLabel.Position = [42 11 40 22];
            app.RootsLabel.Text = 'Roots:';

            % Create RootsEditField_2
            app.RootsEditField_2 = uieditfield(app.AnalysisPanel, 'numeric');
            app.RootsEditField_2.Tooltip = {'Number of roots pixels in plant 2 mask.'};
            app.RootsEditField_2.Position = [135 11 40 22];

            % Create RootsEditField_3
            app.RootsEditField_3 = uieditfield(app.AnalysisPanel, 'numeric');
            app.RootsEditField_3.Tooltip = {'Number of roots pixels in plant 3 mask.'};
            app.RootsEditField_3.Position = [188 11 40 22];

            % Create RootsEditField_4
            app.RootsEditField_4 = uieditfield(app.AnalysisPanel, 'numeric');
            app.RootsEditField_4.Tooltip = {'Number of roots pixels in plant 4 mask.'};
            app.RootsEditField_4.Position = [241 11 40 22];

            % Create PlateEditFieldLabel
            app.PlateEditFieldLabel = uilabel(app.AnalysisPanel);
            app.PlateEditFieldLabel.Position = [91 117 56 22];
            app.PlateEditFieldLabel.Text = 'Plate #:';

            % Create PlateEditField
            app.PlateEditField = uieditfield(app.AnalysisPanel, 'numeric');
            app.PlateEditField.Position = [135 117 40 22];

            % Create ConditionEditFieldLabel
            app.ConditionEditFieldLabel = uilabel(app.AnalysisPanel);
            app.ConditionEditFieldLabel.Position = [185 120 60 22];
            app.ConditionEditFieldLabel.Text = 'Condition:';

            % Create ConditionEditField
            app.ConditionEditField = uieditfield(app.AnalysisPanel, 'numeric');
            app.ConditionEditField.Position = [240 120 40 22];

            % Create Gentype1EditFieldLabel
            app.Gentype1EditFieldLabel = uilabel(app.AnalysisPanel);
            app.Gentype1EditFieldLabel.Position = [73 88 64 22];
            app.Gentype1EditFieldLabel.Text = 'Gentype 1:';

            % Create Gentype1EditField
            app.Gentype1EditField = uieditfield(app.AnalysisPanel, 'numeric');
            app.Gentype1EditField.Position = [135 88 40 22];

            % Create Gentype2Label
            app.Gentype2Label = uilabel(app.AnalysisPanel);
            app.Gentype2Label.Position = [180 88 64 22];
            app.Gentype2Label.Text = 'Gentype 2:';

            % Create Gentype2EditField
            app.Gentype2EditField = uieditfield(app.AnalysisPanel, 'numeric');
            app.Gentype2EditField.Position = [240 88 40 22];

            % Create CompsEditFieldLabel
            app.CompsEditFieldLabel = uilabel(app.AnalysisPanel);
            app.CompsEditFieldLabel.HorizontalAlignment = 'right';
            app.CompsEditFieldLabel.Position = [3 112 57 22];
            app.CompsEditFieldLabel.Text = '# Comps:';

            % Create NumComponentsEditField
            app.NumComponentsEditField = uieditfield(app.AnalysisPanel, 'numeric');
            app.NumComponentsEditField.Editable = 'off';
            app.NumComponentsEditField.Tooltip = {'Number of connected components in segmentation mask. The box turns red if the number of components detected is not equal to four.'};
            app.NumComponentsEditField.Position = [9 88 50 22];

            % Create ShowComponentsButton
            app.ShowComponentsButton = uibutton(app.AnalysisPanel, 'push');
            app.ShowComponentsButton.ButtonPushedFcn = createCallbackFcn(app, @ShowComponentsButtonPushed, true);
            app.ShowComponentsButton.Tooltip = {'Show connected components in a separate figure.'};
            app.ShowComponentsButton.Position = [7 150 117 23];
            app.ShowComponentsButton.Text = 'Show Components';

            % Create SaveButton
            app.SaveButton = uibutton(app.AnalysisPanel, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.BackgroundColor = [0.5176 0.8431 0.9804];
            app.SaveButton.Tooltip = {'Save the settings and input + segmentation data to a file.'};
            app.SaveButton.Position = [232 150 50 23];
            app.SaveButton.Text = 'Save';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PlantSeg_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end