function varargout = feature_selection_main(varargin)
% FEATURE_SELECTION_MAIN MATLAB code for feature_selection_main.fig
%      FEATURE_SELECTION_MAIN, by itself, creates a new FEATURE_SELECTION_MAIN or raises the existing
%      singleton*.
%
%      H = FEATURE_SELECTION_MAIN returns the handle to a new FEATURE_SELECTION_MAIN or the handle to
%      the existing singleton*.
%
%      FEATURE_SELECTION_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEATURE_SELECTION_MAIN.M with the given input arguments.
%
%      FEATURE_SELECTION_MAIN('Property','Value',...) creates a new FEATURE_SELECTION_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before feature_selection_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to feature_selection_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help feature_selection_main

% Last Modified by GUIDE v2.5 15-May-2014 11:12:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @feature_selection_main_OpeningFcn, ...
                   'gui_OutputFcn',  @feature_selection_main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before feature_selection_main is made visible.
function feature_selection_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to feature_selection_main (see VARARGIN)

% Choose default command line output for feature_selection_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set waiting flag in appdata
%setappdata(handles.main,'waiting',1)
% UIWAIT makes feature_selection_main wait for user response (see UIRESUME)
uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = feature_selection_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global data
data = getappdata(handles.main,'data');
if ~isempty(data)
    cla(handles.data_plot) % clear axes
    index = get(handles.norm_algs,'Value');    % What plot type is requested?
    strlist = get(handles.norm_algs,'String');        % Get the choice's name
    nas = strlist(index);
    %nas = getappdata(handles.main,'norm_alg_sel');
    if ~isempty(nas)
        nas_str = nas{1};
        if ~strcmp(nas,'None')
            X = data_norm2(data.X,nas_str);
        else
            X = data.X;
        end
        axes(handles.data_plot); %set the current axes to data_plot
        c = random_color(length(unique(data.Y)));
        [plot_h,lgd_h] = plotMeanStd(X,data.Y,'',c);
        setappdata(handles.main,'lgd_h',lgd_h);
        setappdata(handles.main,'plot_h',plot_h);
    else
        msgbox('Select normalization algorithm','Aviso','warn');
    end
else
    msgbox('No data loaded','Aviso','warn');
end

% --- Executes on selection change in fs_algs.
function fs_algs_Callback(hObject, eventdata, handles)
% hObject    handle to fs_algs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fs_algs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fs_algs

%fs_algs = {'T-Test','Sequential Forward Selection','ReliefF'};
%set(hObject,'String',fs_algs);
%contents = cellstr(get(hObject,'String'));
%contents{get(hObject,'Value')};

index = get(hObject,'Value');    % What plot type is requested?
strlist = get(hObject,'String');        % Get the choice's name
fsas = strlist(index);

setappdata(handles.main,'fs_alg_sel',fsas);


% --- Executes during object creation, after setting all properties.
function fs_algs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_algs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
fs_algs = {'ReliefF','Sequential Forward Selection','T-Test','Anova'};
set(hObject,'String',fs_algs);

index = get(hObject,'Value');    % What plot type is requested?
strlist = get(hObject,'String');        % Get the choice's name
fsas = strlist(index);
%setappdata(handles.main,'fs_alg_sel',fsas);


% --------------------------------------------------------------------
function menu_Callback(hObject, eventdata, handles)
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quit.
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if getappdata(handles.main,'waiting')
    % The GUI is still in UIWAIT, so call UIRESUME and return
    uiresume(handles.main);
    setappdata(handles.main,'waiting',0)
else
    % The GUI is no longer waiting, so destroy it now.
    close(ancestor(hObject,'figure'))
    %delete(hObject);
end

%close(ancestor(hObject,'figure'))


% --------------------------------------------------------------------
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile;
if filename == 0
    filename = [];
end
if pathname == 0
    pathname = [];
end
if ~isempty(filename) && ~isempty(pathname)
    Path = strcat(pathname,filename);
    data = load(Path);
    setappdata(handles.main,'data',data)
end

% --------------------------------------------------------------------
function save_feats_Callback(hObject, eventdata, handles)
% hObject    handle to save_feats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sel_feats = getappdata(handles.main,'sel_feats');
if ~isempty(sel_feats)
    fsalg = getappdata(handles.main,'fs_alg_sel');
    fsalg_str = fsalg{1};
    [file,path] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save selected features as',strcat(fsalg_str,'_selfeats_',datestr(now)));
    if file == 0
        file = [];
    end
    if path == 0
        path = [];
    end
    if ~isempty(file) && ~isempty(path)
        save(strcat(path,file),'sel_feats');
    end
else
    msgbox('No data to be saved','Aviso','warn');
end

% --- Executes on selection change in norm_algs.
function norm_algs_Callback(hObject, eventdata, handles)
% hObject    handle to norm_algs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns norm_algs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from norm_algs

%norm_algs = {'None','Decimal Scaling','Minimax','Z-Score'};
%set(hObject,'String',norm_algs);

index = get(hObject,'Value');    % What plot type is requested?
strlist = get(hObject,'String');        % Get the choice's name
nas = strlist(index);

%contents = cellstr(get(hObject,'String'))
%nas = contents{get(hObject,'Value')};
setappdata(handles.main,'norm_alg_sel',nas);

% --- Executes during object creation, after setting all properties.
function norm_algs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to norm_algs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
norm_algs = {'None','Decimal Scaling','Minimax','Z-Score'};
set(hObject,'String',norm_algs);

index = get(hObject,'Value');    % What plot type is requested?
strlist = get(hObject,'String');        % Get the choice's name
nas = strlist(index);
%setappdata(handles.main,'norm_alg_sel',nas);

% --- Executes on button press in run_feat_sel.
function run_feat_sel_Callback(hObject, eventdata, handles)
% hObject    handle to run_feat_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.main,'data');
if ~isempty(data)
    %cla % clear axes
    index = get(handles.norm_algs,'Value');    % What plot type is requested?
    strlist = get(handles.norm_algs,'String');        % Get the choice's name
    nas = strlist(index);
    %nas = getappdata(handles.main,'norm_alg_sel');
    
    index = get(handles.fs_algs,'Value');    % What plot type is requested?
    strlist = get(handles.fs_algs,'String');        % Get the choice's name
    fsas = strlist(index);
    %fsas = getappdata(handles.main,'fs_alg_sel');
    if ~isempty(nas)
        nas_str = nas{1};
        if ~strcmp(nas,'None')
            X = data_norm2(data.X,nas_str);
        else
            X = data.X;
        end
        if ~isempty(fsas)
            fsas_str = fsas{1};
            if strcmp(fsas_str,'ReliefF')
                prompt = {'Enter number of K nearest neighbors:','Enter threshold value:'};
                dlg_title = 'Parameters input';
                num_lines = 1;
                def = {'10','0.05'};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                if ~isempty(answer)
                    [ranked,weights] = relieff(X,data.Y,str2num(answer{1}));
                    ttsh = str2double(answer{2});
                    sel_feats = 1:size(X,2);
                    sel_feats = sel_feats(weights > ttsh);

                    set(handles.fs_table,'Data',sel_feats);

                    axes(handles.fs_plot1); % set the current axes to fs_plot1
                    cla(handles.fs_plot1); % clear current axes
                    %bar(ranked,weights(ranked));
                    bar(weights);
                    xlim([0 size(X,2)+1]);
                    xlabel('Predictors');
                    ylabel('Predictor importance weight');
                    grid on
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    axes(handles.fs_plot2); % set the current axes to fs_plot1
                    cla(handles.fs_plot2); % clear current axes
                    hb = bar(weights(ranked),'BarWidth',0.8);
                    %ylim([min(weights)-0.01 max(weights)+0.01]);
                    xlim([0 size(X,2)+1]);
                    %set(handles.fs_plot2,'XTickLabel',ranked);
                    xlabel('Ranked predictors');
                    ylabel('Predictor importance weight');
                    grid on
                    x=get(hb,'Xdata');
                    y=get(hb,'Ydata');
                    xcenter = x;
                    ytop = y;
                    for i=1:size(ranked,2)
                        %text(i,weights(ranked(i))+0.005,num2str(ranked(i)));
                        if ytop(i) > 0
                            text(xcenter(i),ytop(i),num2str(ranked(i)),...
                                'HorizontalAlignment','center', ...
                                'VerticalAlignment','bottom','FontSize',10 );
                        else
                            text(xcenter(i),ytop(i),num2str(ranked(i)),...
                                'HorizontalAlignment','center', ...
                                'VerticalAlignment','top','fontSize',10 );
                        end
                        
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    if ~isempty(sel_feats) % check if features were selected
                        setappdata(handles.main,'sel_feats',sel_feats);
                    else
                        msgbox('No features selected with current settings','Aviso','warn');
                    end
                end
            elseif strcmp(fsas_str,'T-Test')
                Title = 'Parameters input';
                
                Options.Resize = 'on';
                Options.Interpreter = 'tex';
                Options.CancelButton = 'on';
                Options.ButtonNames = {'Ok','Cancel'};
                Option.Dim = 1; % Horizontal dimension in fields

                Prompt = {};
                Formats = {};
                DefAns = struct([]);
                
                Prompt(end+1,:) = {' Control class: ','Ctrl_Class',[]};
                Formats(1,1).type = 'list';
                Formats(1,1).format = 'text';
                Formats(1,1).style = 'popupmenu';
                class_alg = unique(data.Y); % get data classes;
                Formats(1,1).size = [150 0];
                Formats(1,1).margin = [0 0];
                Formats(1,1).items = class_alg;
                
                Prompt(end+1,:) = {' Significance level: ','Sig_level',[]};
                Formats(2,1).type = 'edit';
                Formats(2,1).format = 'float';
                Formats(2,1).size = [125 20];
                Formats(2,1).margin = [0 0];
                Formats(2,1).limits = [0 inf]; % non-negative decimal number
                DefAns(1).Sig_level = 0.01;
                
                [Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);
                if ~Cancelled
                    [~,GN] = grp2idx(data.Y);
                    ctrl_idx = find(strcmp(GN, Answer.Ctrl_Class));
                    group1 = data.X(grp2idx(data.Y)==ctrl_idx,:);
                    group2 = data.X(grp2idx(data.Y)~=ctrl_idx,:);
                    [~,p,~,~] = ttest2(group1,group2,[],[],'unequal');

                    axes(handles.fs_plot1); % set the current axes to fs_plot1
                    cla(handles.fs_plot1,'reset'); % clear specific axes
                    %set(handles.fs_plot1,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w')
                    cla(handles.fs_plot2,'reset'); % clear specific axes
                    %set(handles.fs_plot2,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w')
                    
                    % In order to get a better idea of how well-separated the two groups are by
                    % each feature, we plot the empirical cumulative distribution function
                    % (CDF) of the _p-values_.
                    ecdf(p);
                    title('Empirical CDF');
                    xlabel('P Value');
                    ylabel('CDF Value');
                    grid on

                    sel_feats = find(p < Answer.Sig_level);
                    set(handles.fs_table,'Data',sel_feats);

                    if ~isempty(sel_feats) % check if features were selected
                        setappdata(handles.main,'sel_feats',sel_feats);
                    else
                        msgbox('No features selected with current settings','Aviso','warn');
                    end
                end
            elseif strcmp(fsas_str,'Sequential Forward Selection')
                % Set waiting flag in appdata
                setappdata(handles.main,'waiting',1)
                [answer,cancel] = sfs_dialog('fs_main', handles.main)
                if ~isempty(answer)
                    setappdata(handles.main,'waiting',0)
                end
            else
                msgbox('Algorithm not implemented yet','Aviso','warn');
            end
        else
            msgbox('Select feature selection algorithm','Aviso','warn');
        end
    else
        msgbox('Select normalization algorithm','Aviso','warn');
    end
else
    msgbox('No data loaded','Aviso','warn');
end


% --------------------------------------------------------------------
function save_dataplot_Callback(hObject, eventdata, handles)
% hObject    handle to save_dataplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if ~isempty(get(gcf,'CurrentAxes'))
%get(handles.data_plot)
%if ~isempty(get(handles.data_plot,'CurrentAxes'))
if ~isempty(get(handles.data_plot,'Children'))
    lgd_h = getappdata(handles.main,'lgd_h');
    tmpaxes = findobj(handles.data_plot,'Type','axes');
    Fig = figure;
    %set(Fig,'Visible','off');
    destaxes = subplot(1,1,1,'Parent',Fig);
    hf = copyobj(allchild(tmpaxes), destaxes);
    copyobj(lgd_h,Fig);
    set(lgd_h,'Location','NorthEast','Box','on');
    data = getappdata(handles.main,'data');
    xlim([0 size(data.X,2)+1]);
    grid on
    
    index = get(handles.norm_algs,'Value');    % What plot type is requested?
    strlist = get(handles.norm_algs,'String');        % Get the choice's name
    nas = strlist(index);
    %nas = getappdata(handles.main,'norm_alg_sel');
    %get(Fig,'type')
    if ~isempty(hf)
        
        [file,path,f_index] = uiputfile({'*.fig','MATLAB Figure (*.fig)';...
        '*.eps','Eps file (*.eps)';'*.jpg','JPEG image (*.jpg)';...
        '*.pdf','Portable Document Format (*.pdf)';...
        '*.png','Portable Network Graphics file (*.png)';...
        '*.tif','TIFF image (*.tif)';...
        '*.tif','TIFF no compression image (*.tif)'
        },'Save data plot as',strcat('data_plot_',nas{1},'_',datestr(now)));
        if file == 0
            file = [];
        end
        if path == 0
            path = [];
        end
        
        if ~isempty(file) && ~isempty(path)
            if f_index == 7
                saveas(Fig,strcat(path,file),'tiffn');
            else
                saveas(Fig,strcat(path,file));
            end
        end
        close(Fig)
    end
else
    msgbox('The axes is empty','Aviso','warn')
end


% --------------------------------------------------------------------
function save_fsplot1_Callback(hObject, eventdata, handles)
% hObject    handle to save_fsplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.fs_plot1,'Children'))
    tmpaxes = findobj(handles.fs_plot1,'Type','axes');
    Fig = figure;
    %set(Fig,'Visible','off');
    destaxes = subplot(1,1,1,'Parent',Fig);
    hf = copyobj(allchild(tmpaxes), destaxes);
    grid on
    
    index = get(handles.fs_algs,'Value');    % What plot type is requested?
    strlist = get(handles.fs_algs,'String');        % Get the choice's name
    fsas = strlist(index);
    %fsas = getappdata(handles.main,'fs_alg_sel');
    if ~isempty(hf)
        [file,path,f_index] = uiputfile({'*.fig','MATLAB Figure (*.fig)';...
        '*.eps','Eps file (*.eps)';'*.jpg','JPEG image (*.jpg)';...
        '*.pdf','Portable Document Format (*.pdf)';...
        '*.png','Portable Network Graphics file (*.png)';...
        '*.tif','TIFF image (*.tif)';...
        '*.tif','TIFF no compression image (*.tif)'
        },'Save data plot as',strcat(fsas{1},'_',datestr(now)));
        if file == 0
            file = [];
        end
        if path == 0
            path = [];
        end
        
        if ~isempty(file) && ~isempty(path)
            if f_index == 1
                hgsave(Fig,strcat(path,file));
            elseif f_index == 7
                saveas(Fig,strcat(path,file),'tiffn');
            else
                export_fig(strcat(path,file));
                %saveas(Fig,strcat(path,file));
            end
        end
        close(Fig)
    end
else
    msgbox('The axes is empty','Aviso','warn')
end

% --------------------------------------------------------------------
function save_fsplot2_Callback(hObject, eventdata, handles)
% hObject    handle to save_fsplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.fs_plot2,'Children'))
    tmpaxes = findobj(handles.fs_plot2,'Type','axes');
    Fig = figure;
    %set(Fig,'Visible','off');
    destaxes = subplot(1,1,1,'Parent',Fig);
    hf = copyobj(allchild(tmpaxes), destaxes);
    grid on
    
    index = get(handles.fs_algs,'Value');    % What plot type is requested?
    strlist = get(handles.fs_algs,'String');        % Get the choice's name
    fsas = strlist(index);
    %fsas = getappdata(handles.main,'fs_alg_sel');
    if ~isempty(hf)
        [file,path,f_index] = uiputfile({'*.fig','MATLAB Figure (*.fig)';...
        '*.eps','Eps file (*.eps)';'*.jpg','JPEG image (*.jpg)';...
        '*.pdf','Portable Document Format (*.pdf)';...
        '*.png','Portable Network Graphics file (*.png)';...
        '*.tif','TIFF image (*.tif)';...
        '*.tif','TIFF no compression image (*.tif)'
        },'Save data plot as',strcat(fsas{1},'_',datestr(now)));
        if file == 0
            file = [];
        end
        if path == 0
            path = [];
        end
        
        if ~isempty(file) && ~isempty(path)
            if f_index == 1
                %savefig(Fig,strcat(path,file));
                hgsave(Fig,strcat(path,file));
            elseif f_index == 7
                saveas(Fig,strcat(path,file),'tiffn');
            else
                export_fig(strcat(path,file));
                %saveas(Fig,strcat(path,file));
            end
        end
        close(Fig)
    end
else
    msgbox('The axes is empty','Aviso','warn')
end


% --- Executes when user attempts to close main.
function main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check appdata flag to see if the main GUI is in a wait state
if getappdata(handles.main,'waiting')
    % The GUI is still in UIWAIT, so call UIRESUME and return
    uiresume(hObject);
    setappdata(handles.main,'waiting',0)
else
    % The GUI is no longer waiting, so destroy it now.
    delete(hObject);
end


% --- Executes when main is resized.
function main_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
