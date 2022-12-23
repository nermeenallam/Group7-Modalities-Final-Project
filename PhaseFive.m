classdef PhaseFive < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DicomViewer          matlab.ui.Figure
        BrowseButton         matlab.ui.control.Button
        SagittalSlidesLabel  matlab.ui.control.Label
        ObliqueSlidesLabel   matlab.ui.control.Label
        AxialSlidesLabel     matlab.ui.control.Label
        CoronalSlidesLabel   matlab.ui.control.Label
        AxialAxes            matlab.ui.control.UIAxes
        CoronalAxes          matlab.ui.control.UIAxes
        SagittalAxes         matlab.ui.control.UIAxes
        ObliqueAxes          matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        Axial
        Sagittal
        Coronal
        AxialMidPoint
        SagittalMidPoint
        CoronalMidPoint
        axialVertical
        axialHorizontal
        sagittalVertical
        sagittalHorizontal
        coronalVertical
        coronalHorizontal
        obliqueLine
        V
        B
        x1
        x2
        y1
        y2
        chcoordinate
        ahcoordinate
        svcoordinate
        shcoordinate
        cvcoordinate
        avcoordinate
    end
 
    
    methods (Access = private)
        
        function AxialVerticalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    
                    app.avcoordinate=round(evt.CurrentPosition(1,1));
                    app.coronalVertical.Position=[app.avcoordinate 0; app.avcoordinate app.Axial];
                    imshow(rot90(permute(app.V(:,app.avcoordinate,:),[1 3 2])),[],'Parent' ,app.SagittalAxes);
                    disp(app.avcoordinate);
                    app.svcoordinate=app.ahcoordinate;
                    app.shcoordinate=app.chcoordinate;
                    app.sagittalVertical=drawline('Parent',app.SagittalAxes,'Position',[app.svcoordinate 0; app.svcoordinate app.Axial],'LineWidth',0.25,'Color','r');
                    app.sagittalVertical.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                    app.sagittalHorizontal=drawline('Parent',app.SagittalAxes,'Position',[0 app.shcoordinate; app.Coronal app.shcoordinate],'LineWidth',0.25,'Color','g');
                    app.sagittalHorizontal.DrawingArea = [0,0,(app.Coronal),(app.Axial)]; 
                    addlistener(app.sagittalVertical,'ROIMoved',@app.SagittalVerticalChanging);
                    addlistener(app.sagittalHorizontal,'ROIMoved',@app.SagittalHorizontalChanging);  
            end     
        end
        
        function AxialHorizontalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.ahcoordinate=round(evt.CurrentPosition(1,2));
                    app.sagittalVertical.Position=[app.ahcoordinate 0; app.ahcoordinate app.Axial];
                    imshow(rot90(permute(app.V(app.ahcoordinate,:,:),[2 3 1])),[],'Parent' ,app.CoronalAxes);
                    app.cvcoordinate=app.avcoordinate;
                    app.chcoordinate=app.shcoordinate;
                    app.coronalVertical=drawline('Parent',app.CoronalAxes,'Position',[app.cvcoordinate 0; app.cvcoordinate app.Axial],'LineWidth',0.25,'Color','b');
                    app.coronalVertical.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    app.coronalHorizontal=drawline('Parent',app.CoronalAxes,'Position',[0 app.chcoordinate; app.Sagittal app.chcoordinate],'LineWidth',0.25,'Color','g');                
                    app.coronalHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    addlistener(app.coronalVertical,'ROIMoved',@app.CoronalVerticalChanging);
                    addlistener(app.coronalHorizontal,'ROIMoved',@app.CoronalHorizontalChanging);                       
            end        
        end
        
        function SagittalVerticalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.svcoordinate=round(evt.CurrentPosition(1,1));
                    app.axialHorizontal.Position=[0 app.svcoordinate ; app.Sagittal app.svcoordinate];
                    imshow(rot90(permute(app.V(app.svcoordinate,:,:),[2 3 1])),[],'Parent' ,app.CoronalAxes);
                    app.cvcoordinate=app.avcoordinate;
                    app.chcoordinate=app.shcoordinate;
                    app.coronalVertical=drawline('Parent',app.CoronalAxes,'Position',[app.cvcoordinate 0; app.cvcoordinate app.Axial],'LineWidth',0.25,'Color','b');
                    app.coronalVertical.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    app.coronalHorizontal=drawline('Parent',app.CoronalAxes,'Position',[0 app.chcoordinate; app.Sagittal app.chcoordinate],'LineWidth',0.25,'Color','g');                
                    app.coronalHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    addlistener(app.coronalVertical,'ROIMoved',@app.CoronalVerticalChanging);
                    addlistener(app.coronalHorizontal,'ROIMoved',@app.CoronalHorizontalChanging);                     
            end
        end
        
        function SagittalHorizontalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.shcoordinate=round(evt.CurrentPosition(1,2));
                    app.coronalHorizontal.Position=[0 app.shcoordinate ; app.Sagittal app.shcoordinate];
                    imshow(app.V(:,:,(app.Axial-app.shcoordinate-1)),[],'Parent' ,app.AxialAxes);
                    app.avcoordinate=app.cvcoordinate;
                    app.ahcoordinate=app.svcoordinate;
                    app.axialVertical=drawline('Parent',app.AxialAxes,'Position',[app.avcoordinate 0; app.avcoordinate app.Coronal],'LineWidth',0.25,'Color','b');
                    app.axialVertical.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    app.axialHorizontal=drawline('Parent',app.AxialAxes,'Position',[0 app.ahcoordinate; app.Sagittal app.ahcoordinate],'LineWidth',0.25,'Color','r');
                    app.axialHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    addlistener(app.axialVertical,'ROIMoved',@app.AxialVerticalChanging);
                    addlistener(app.axialHorizontal,'ROIMoved',@app.AxialHorizontalChanging);
                    app.obliqueLine=drawline('Parent',app.AxialAxes,'Position',[app.x1 app.y1; app.x2 app.y2],'LineWidth',0.25,'Color','w');
                    app.obliqueLine.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);
            end            
        end
        
        function CoronalVerticalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.cvcoordinate=round(evt.CurrentPosition(1,1));
                    app.axialVertical.Position=[app.cvcoordinate 0;app.cvcoordinate app.Coronal ];
                    imshow(rot90(permute(app.V(:,app.cvcoordinate,:),[1 3 2])),[],'Parent' ,app.SagittalAxes);
                    app.svcoordinate=app.ahcoordinate;
                    app.shcoordinate=app.chcoordinate;
                    app.sagittalVertical=drawline('Parent',app.SagittalAxes,'Position',[app.svcoordinate 0; app.svcoordinate app.Axial],'LineWidth',0.25,'Color','r');
                    app.sagittalVertical.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                    app.sagittalHorizontal=drawline('Parent',app.SagittalAxes,'Position',[0 app.shcoordinate; app.Coronal app.shcoordinate],'LineWidth',0.25,'Color','g');
                    app.sagittalHorizontal.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                    addlistener(app.sagittalVertical,'ROIMoved',@app.SagittalVerticalChanging);
                    addlistener(app.sagittalHorizontal,'ROIMoved',@app.SagittalHorizontalChanging);  
            end              
        end
        
        function CoronalHorizontalChanging(app,src,evt)
                    app.chcoordinate=round(evt.CurrentPosition(1,2));
                    app.sagittalHorizontal.Position=[0 app.chcoordinate ; app.Coronal app.chcoordinate];
                    imshow(app.V(:,:,(app.Axial-app.chcoordinate-1)),[],'Parent' ,app.AxialAxes);
                    app.avcoordinate=app.cvcoordinate;
                    app.ahcoordinate=app.svcoordinate;
                    app.axialVertical=drawline('Parent',app.AxialAxes,'Position',[app.avcoordinate 0; app.avcoordinate app.Coronal],'LineWidth',0.25,'Color','b');
                    app.axialVertical.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    app.axialHorizontal=drawline('Parent',app.AxialAxes,'Position',[0 app.ahcoordinate; app.Sagittal app.ahcoordinate],'LineWidth',0.25,'Color','r');
                    app.axialHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    app.obliqueLine=drawline('Parent',app.AxialAxes,'Position',[app.x1 app.y1; app.x2 app.y2],'LineWidth',0.25,'Color','w');
                    app.obliqueLine.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);
                    addlistener(app.axialVertical,'ROIMoved',@app.AxialVerticalChanging);
                    addlistener(app.axialHorizontal,'ROIMoved',@app.AxialHorizontalChanging);
                    
        end
        
        function ObliqueChanging(app,src,evt)
            app.x1=app.obliqueLine.Position(1,1);
            app.y1=app.obliqueLine.Position(1,2);
            app.x2=app.obliqueLine.Position(2,1);
            app.y2=app.obliqueLine.Position(2,2);
            midpointX=(app.x1+app.x2)/2;
            midpointY=(app.y1+app.y2)/2;
            rise=app.y2-app.y1;
            run=app.x2-app.x1;
            angle = atand(rise/run);
            newrise=-run;
            newrun=rise;
            point=[midpointX midpointY 100];
            normal = [newrun newrise 0];    
            app.B = obliqueslice(app.V,point,normal,'OutputSize','Full');
            imshow(imrotate(app.B,(angle-180)),[],'Parent' ,app.ObliqueAxes);
            addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
       
            folder = uigetdir; 
%             try
                app.V = dicomreadVolume(folder);                          
                app.V = squeeze(app.V);
                disableDefaultInteractivity(app.AxialAxes)
                disableDefaultInteractivity(app.SagittalAxes)
                disableDefaultInteractivity(app.CoronalAxes)
                
                app.Axial=size(app.V, 3);
                app.Sagittal=size(app.V, 2);
                app.Coronal=size(app.V, 1);
                
                
                 app.avcoordinate=round(app.Sagittal/2);
                 app.ahcoordinate=round(app.Coronal/2);
                 app.svcoordinate=round(app.Coronal/2);
                 app.shcoordinate=round(app.Axial/2);
                 app.cvcoordinate=round(app.Sagittal/2);
                 app.chcoordinate=round(app.Axial/2);
                 
                app.AxialMidPoint=round(app.Axial/2);
                app.SagittalMidPoint=round(app.Sagittal/2);
                app.CoronalMidPoint=round(app.Coronal/2);
               
                
%                 normal = [20 0 20];
%                 point = [ObliqueSlide 256 117];
%                 B = obliqueslice(app.V,point,normal,'OutputSize','Full');
                
                
                
                
                imshow(app.V(:,:,app.AxialMidPoint),[],'Parent' ,app.AxialAxes);
                app.axialVertical=drawline('Parent',app.AxialAxes,'Position',[app.avcoordinate 0; app.avcoordinate app.Coronal],'LineWidth',0.25,'Color','b');
                app.axialVertical.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                app.axialHorizontal=drawline('Parent',app.AxialAxes,'Position',[0 app.ahcoordinate; app.Sagittal app.ahcoordinate],'LineWidth',0.25,'Color','r');
                app.axialHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                addlistener(app.axialVertical,'ROIMoved',@app.AxialVerticalChanging);
                addlistener(app.axialHorizontal,'ROIMoved',@app.AxialHorizontalChanging);
                
                
                imshow(rot90(permute(app.V(:,app.SagittalMidPoint,:),[1 3 2])),[],'Parent' ,app.SagittalAxes);
                app.sagittalVertical=drawline('Parent',app.SagittalAxes,'Position',[app.svcoordinate 0; app.svcoordinate app.Axial],'LineWidth',0.25,'Color','r');
                app.sagittalVertical.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                app.sagittalHorizontal=drawline('Parent',app.SagittalAxes,'Position',[0 app.shcoordinate; app.Coronal app.shcoordinate],'LineWidth',0.25,'Color','g');
                app.sagittalHorizontal.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                addlistener(app.sagittalVertical,'ROIMoved',@app.SagittalVerticalChanging);
                addlistener(app.sagittalHorizontal,'ROIMoved',@app.SagittalHorizontalChanging);                
                
                imshow(rot90(permute(app.V(app.CoronalMidPoint,:,:),[2 3 1])),[],'Parent' ,app.CoronalAxes);
                app.coronalVertical=drawline('Parent',app.CoronalAxes,'Position',[app.cvcoordinate 0; app.cvcoordinate app.Axial],'LineWidth',0.25,'Color','b');
                app.coronalVertical.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                app.coronalHorizontal=drawline('Parent',app.CoronalAxes,'Position',[0 app.chcoordinate; app.Sagittal app.chcoordinate],'LineWidth',0.25,'Color','g');                
                app.coronalHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Axial)]; 
                addlistener(app.coronalVertical,'ROIMoved',@app.CoronalVerticalChanging);
                addlistener(app.coronalHorizontal,'ROIMoved',@app.CoronalHorizontalChanging);                
                
                
                app.obliqueLine=drawline('Parent',app.AxialAxes,'Position',[0 0; app.Sagittal app.Coronal],'LineWidth',0.25,'Color','w');
                app.obliqueLine.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                point=[app.SagittalMidPoint app.CoronalMidPoint 100];
%                 slope=
                normal = [1 -1 0];    
                app.B = obliqueslice(app.V,point,normal);
                imshow(imrotate(app.B,-135),[],'Parent' ,app.ObliqueAxes);
                addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);

                
                
                
%             catch 
%                 warndlg('Select Dicom Folder.','Warning');
%             end 
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DicomViewer and hide until all components are created
            app.DicomViewer = uifigure('Visible', 'off');
            app.DicomViewer.Color = [0.149 0.149 0.149];
            app.DicomViewer.Position = [100 100 785 531];
            app.DicomViewer.Name = 'MATLAB App';
            app.DicomViewer.Scrollable = 'on';

            % Create BrowseButton
            app.BrowseButton = uibutton(app.DicomViewer, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.FontName = 'Yu Gothic Medium';
            app.BrowseButton.FontSize = 16;
            app.BrowseButton.Position = [34 473 85 34];
            app.BrowseButton.Text = 'Browse';

            % Create SagittalSlidesLabel
            app.SagittalSlidesLabel = uilabel(app.DicomViewer);
            app.SagittalSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.SagittalSlidesLabel.FontSize = 16;
            app.SagittalSlidesLabel.FontWeight = 'bold';
            app.SagittalSlidesLabel.FontColor = [1 1 1];
            app.SagittalSlidesLabel.Position = [34 31 128 32];
            app.SagittalSlidesLabel.Text = 'Sagittal Slides';

            % Create ObliqueSlidesLabel
            app.ObliqueSlidesLabel = uilabel(app.DicomViewer);
            app.ObliqueSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.ObliqueSlidesLabel.FontSize = 16;
            app.ObliqueSlidesLabel.FontWeight = 'bold';
            app.ObliqueSlidesLabel.FontColor = [1 1 1];
            app.ObliqueSlidesLabel.Position = [416 34 101 24];
            app.ObliqueSlidesLabel.Text = 'Oblique Slides';

            % Create AxialSlidesLabel
            app.AxialSlidesLabel = uilabel(app.DicomViewer);
            app.AxialSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.AxialSlidesLabel.FontSize = 16;
            app.AxialSlidesLabel.FontWeight = 'bold';
            app.AxialSlidesLabel.FontColor = [1 1 1];
            app.AxialSlidesLabel.Position = [37 251 105 32];
            app.AxialSlidesLabel.Text = 'Axial Slides';

            % Create CoronalSlidesLabel
            app.CoronalSlidesLabel = uilabel(app.DicomViewer);
            app.CoronalSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.CoronalSlidesLabel.FontSize = 16;
            app.CoronalSlidesLabel.FontWeight = 'bold';
            app.CoronalSlidesLabel.FontColor = [1 1 1];
            app.CoronalSlidesLabel.Position = [416 255 100 24];
            app.CoronalSlidesLabel.Text = 'Coronal Slides';

            % Create AxialAxes
            app.AxialAxes = uiaxes(app.DicomViewer);
            zlabel(app.AxialAxes, 'Z')
            app.AxialAxes.Toolbar.Visible = 'off';
            app.AxialAxes.PlotBoxAspectRatio = [2.29468599033816 1 1];
            app.AxialAxes.XColor = [1 1 1];
            app.AxialAxes.XTick = [];
            app.AxialAxes.YColor = [1 1 1];
            app.AxialAxes.YTick = [];
            app.AxialAxes.Position = [18 277 341 177];

            % Create CoronalAxes
            app.CoronalAxes = uiaxes(app.DicomViewer);
            zlabel(app.CoronalAxes, 'Z')
            app.CoronalAxes.PlotBoxAspectRatio = [2.31707317073171 1 1];
            app.CoronalAxes.XColor = [1 1 1];
            app.CoronalAxes.XTick = [];
            app.CoronalAxes.YColor = [1 1 1];
            app.CoronalAxes.YTick = [];
            app.CoronalAxes.Position = [392 277 341 176];

            % Create SagittalAxes
            app.SagittalAxes = uiaxes(app.DicomViewer);
            zlabel(app.SagittalAxes, 'Z')
            app.SagittalAxes.PlotBoxAspectRatio = [2.28985507246377 1 1];
            app.SagittalAxes.XColor = [1 1 1];
            app.SagittalAxes.XTick = [];
            app.SagittalAxes.YColor = [1 1 1];
            app.SagittalAxes.YTick = [];
            app.SagittalAxes.Position = [17 57 341 177];

            % Create ObliqueAxes
            app.ObliqueAxes = uiaxes(app.DicomViewer);
            zlabel(app.ObliqueAxes, 'Z')
            app.ObliqueAxes.PlotBoxAspectRatio = [2.30097087378641 1 1];
            app.ObliqueAxes.XColor = [1 1 1];
            app.ObliqueAxes.XTick = [];
            app.ObliqueAxes.YColor = [1 1 1];
            app.ObliqueAxes.YTick = [];
            app.ObliqueAxes.Position = [391 58 341 176];

            % Show the figure after all components are created
            app.DicomViewer.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PhaseFive
            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DicomViewer)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DicomViewer)
        end
    end
end