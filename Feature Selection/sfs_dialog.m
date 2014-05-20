function varargout = sfs_dialog(varargin)
% SFS_DIALOG MATLAB code for sfs_dialog.fig
%      SFS_DIALOG, by itself, creates a new SFS_DIALOG or raises the existing
%      singleton*.
%
%      H = SFS_DIALOG returns the handle to a new SFS_DIALOG or the handle to
%      the existing singleton*.
%
%      SFS_DIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SFS_DIALOG.M with the given input arguments.
%
%      SFS_DIALOG('Property','Value',...) creates a new SFS_DIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sfs_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sfs_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sfs_dialog

% Last Modified by GUIDE v2.5 14-May-2014 15:26:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sfs_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @sfs_dialog_OutputFcn, ...
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


% --- Executes just before sfs_dialog is made visible.
function sfs_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sfs_dialog (see VARARGIN)

dontOpen = false;
mainGuiInput = find(strcmp(varargin, 'fs_main'));
if (isempty(mainGuiInput)) ...
    || (length(varargin) <= mainGuiInput) ...
    || (~ishandle(varargin{mainGuiInput+1}))
    dontOpen = true;
else
    setappdata(handles.figure1,'Cancelled',0);
    % Remember the handle, and adjust our position
    handles.fsMain = varargin{mainGuiInput+1};
    
    % Obtain handles using GUIDATA with the caller's handle 
    mainHandles = guidata(handles.fsMain);
    % Set the edit text to the String of the main GUI's button
    %set(handles.editChangeMe, 'String', ...
    %    get(mainHandles.buttonChangeMe, 'String'));
    if get(handles.cv_holdout,'Value') == 1
        set(handles.cv_text2,'String','Holdout:');
        set(handles.cv_input,'Value',0.25);
        set(handles.cv_input,'String','0.25');
        set(handles.cv_text2,'Visible','on');
        set(handles.cv_input,'Visible','on');
        %set(handles.cv_settings,'Visible','on');
    elseif get(handles.cv_kfold,'Value') == 1
        set(handles.cv_text2,'String','K:');
        set(handles.cv_input,'Value',10);
        set(handles.cv_input,'String','10');
        set(handles.cv_text2,'Visible','on');
        set(handles.cv_input,'Visible','on');
        %set(handles.cv_settings,'Visible','on');
    elseif get(handles.cv_leaveout,'Value') == 1
        set(handles.cv_text2,'Visible','off');
        set(handles.cv_input,'Visible','off');
        %set(handles.cv_settings,'Visible','on');
    end
end

% Update handles structure
guidata(hObject, handles);

if dontOpen
   disp('-----------------------------------------------------');
   disp('Improper input arguments. Pass a property value pair') 
   disp('whose name is "fs_main" and value is the handle')
   disp('to the fs_main figure, e.g:');
   disp('   x = fs_main()');
   disp('   sfs(''fs_main'', x)');
   disp('-----------------------------------------------------');
else
   uiwait(hObject);
end

% Choose default command line output for sfs_dialog
%handles.output = hObject;

% UIWAIT makes sfs_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sfs_dialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
cancel = getappdata(handles.figure1,'Cancelled');
varargout{1} = getappdata(handles.figure1,'Answer');
varargout{2} = cancel;
%varargout{1} = [];
delete(hObject);


% --- Executes on selection change in class_algs.
function class_algs_Callback(hObject, eventdata, handles)
% hObject    handle to class_algs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns class_algs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from class_algs


% --- Executes during object creation, after setting all properties.
function class_algs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to class_algs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
class_alg = {'Decision Tree - Gini','Decision Tree - Deviance','Decision Tree - Twoing',...
                        'Linear Discrimination Analysis','Quadratic Discrimination Analysis'};
set(hObject,'String',class_alg);
%index = get(hObject,'Value');    % What plot type is requested?
%strlist = get(hObject,'String');        % Get the choice's name
%cas = strlist(index);

% --- Executes on button press in cv_ok.
function cv_ok_Callback(hObject, eventdata, handles)
% hObject    handle to cv_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main = handles.fsMain;
% Obtain handles using GUIDATA with the caller's handle 
if(ishandle(main))
    mainHandles = guidata(main);
    index = get(handles.class_algs,'Value');    % What plot type is requested?
    strlist = get(handles.class_algs,'String');        % Get the choice's name
    cas = strlist(index);
    % {'Linear Discrimination Analysis','Quadratic Discrimination Analysis'}
    if strcmp(cas{1},'Decision Tree - Gini')
        answer.ClassAlg = 'dt_gdi';
    elseif strcmp(cas{1},'Decision Tree - Deviance')
        answer.ClassAlg = 'dt_deviance';
    elseif strcmp(cas{1},'Decision Tree - Twoing')
        answer.ClassAlg = 'dt_twoing';
    elseif strcmp(cas{1},'Linear Discrimination Analysis')
        answer.ClassAlg = 'cd_linear';
    elseif strcmp(cas{1},'Quadratic Discrimination Analysis')
        answer.ClassAlg = 'cd_quadratic';
    else
        msgbox('No classification algorithm matched','Aviso','warn');
    end
            
    
    if get(handles.cv_holdout,'Value') == 1
        answer.Crossval = get(handles.cv_holdout,'String');
        answer.CrossvalInput = str2double(get(handles.cv_input,'String'));
    elseif get(handles.cv_kfold,'Value') == 1
        answer.Crossval = get(handles.cv_kfold,'String');
        answer.CrossvalInput = str2double(get(handles.cv_input,'String'));
    elseif get(handles.cv_leaveout,'Value') == 1
        answer.Crossval = get(handles.cv_leaveout,'String');
        answer.CrossvalInput = [];
    end
    setappdata(handles.figure1,'Answer',answer);
    %changeMeButton = mainHandles.buttonChangeMe;
    %set(changeMeButton, 'String', text);
end
uiresume(handles.figure1);

% --- Executes on button press in cv_cancel.
function cv_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cv_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1,'Cancelled',1);
uiresume(handles.figure1);


function cv_input_Callback(hObject, eventdata, handles)
% hObject    handle to cv_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cv_input as text
%        str2double(get(hObject,'String')) returns contents of cv_input as a double
if get(handles.cv_holdout,'Value') == 1
    xlower = 0.0;
    xupper = 1.0;
    v = str2double(get(hObject,'String')); %get recently entered string
    if ~isnan(v)
        if v > xupper
            warndlg(['input should not exceed ' num2str(xupper)])
            set(handles.cv_input,'Value',0.25); %set string to previous value
            set(handles.cv_input,'String','0.25');
        elseif v < xlower
            warndlg(['input should not be less than ' num2str(xlower)])
            set(handles.cv_input,'Value',0.25); %set string to previous value
            set(handles.cv_input,'String','0.25');
        else
            handles.xval = v; %update saved value
        end
    else
        warndlg('input should be numeric')
        set(handles.cv_input,'Value',0.25); %set string to previous value
        set(handles.cv_input,'String','0.25');
    end
elseif get(handles.cv_kfold,'Value') == 1
    xlower = 0;
    data = getappdata(handles.fsMain,'data');
    xupper = size(data.X,2)-1;
    v = str2double(get(hObject,'String')); %get recently entered string
    if ~isnan(v)
        v = round(v);
        if v > xupper
          warndlg(['input should not exceed ' num2str(xupper)])
          set(handles.cv_input,'Value',10); %set string to previous value
          set(handles.cv_input,'String','10');
        elseif v < xlower
          warndlg(['input should not be less than ' num2str(xlower)])
          set(handles.cv_input,'Value',10); %set string to previous value
          set(handles.cv_input,'String','10');
        else
          handles.xval = v; %update saved value
        end
    else
        warndlg('input should be numeric')
        set(handles.cv_input,'Value',10); %set string to previous value
        set(handles.cv_input,'String','10');
    end
elseif get(handles.cv_leaveout,'Value') == 1
    set(handles.cv_text2,'Visible','off');
    set(handles.cv_input,'Visible','off');
    %set(handles.cv_settings,'Visible','on');
end


% --- Executes during object creation, after setting all properties.
function cv_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cv_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in cv_mode.
function cv_mode_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in cv_mode 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cv_holdout,'Value') == 1
    set(handles.cv_text2,'String','Holdout:');
    set(handles.cv_input,'Value',0.25);
    set(handles.cv_input,'String','0.25');
    set(handles.cv_text2,'Visible','on');
    set(handles.cv_input,'Visible','on');
    %set(handles.cv_settings,'Visible','on');
elseif get(handles.cv_kfold,'Value') == 1
    set(handles.cv_text2,'String','K:');
    set(handles.cv_input,'Value',10);
    set(handles.cv_input,'String','10');
    set(handles.cv_text2,'Visible','on');
    set(handles.cv_input,'Visible','on');
    %set(handles.cv_settings,'Visible','on');
elseif get(handles.cv_leaveout,'Value') == 1
    set(handles.cv_text2,'Visible','off');
    set(handles.cv_input,'Visible','off');
    %set(handles.cv_settings,'Visible','on');
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);
uiresume(hObject);
