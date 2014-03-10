function data = xlsreadstruct(file)

%DATA = XLSREADSTRUCT(FILE)
%XLSREADSTRUCT reads the concents of FILE, the name of an .xls or .csv file
%that has text and numeric data. Outputs DATA, a structure with fields that
%correspond to the file's columns.
%
%Written by Juan Manuel Contreras (jmcontr@fas.harvard.edu) on 02/25/13.
%Please email me with questions or comments about XLSREADSTRUCT.

%read data
[num txt] = xlsread(file);

%separate header from data
header = txt(1,:);
txt = txt(2:end,:);

%determine number of fields and number of observations
[nObs nFields] = size(txt);

%determine which columns are text
colIsTxt = sum(strcmp(txt,''))~=nObs;

%create data structure
data = struct;

%fill in data structure
colCount = 1;
for iField = 1:nFields
    if colIsTxt(iField)
        data.(header{iField}) = txt(:,colCount);
    else
        data.(header{iField}) = num(:,colCount);
    end
    colCount = colCount+1;
end