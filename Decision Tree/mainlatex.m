minimos = min(X,[],1);
maximos = max(X,[],1);
media = mean(X);
desvio_padrao = std(X);
data_stt = horzcat(minimos',maximos',media',desvio_padrao');

%field1 = 'Id'; value1 = (1:60)';
%field2 = 'Minimo'; value2 = minimos';
%field3 = 'Maximo'; value3 = maximos';
%field4 = 'Media'; value4 = media';
%field5 = 'SD'; value5 = desvio_padrao';

%data_struct = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5);


% row labels (set empty string for multiline rows):
%input.tableRowLabels = {'Id','Min','Max','Media','SD'};
input.tableRowLabels = array2cellarray((1:60)');
%
% % numeric values you want to tabulate:
input.tableData = data_stt(:,2:end);
%
% % Optional fields (if not set default values will be used):
%
% input.tableDataRowFormat = {'%.3f'};
%
% % Define how NaN values in input.tableData should be printed in the LaTex table:
input.tableDataNanString = '-';
%
% % Column alignment ('l'=left-justified, 'c'=centered,'r'=right-justified):
input.tableColumnAlignment = 'c';
%
% % Switch table borders on/off:
% input.tableBorders = 1; 
%
% % LaTex table caption:
input.tableCaption = 'Estatisticas da base de dados';
%
% % LaTex table label:
input.tableLabel = 'data-stt';
%
% % Switch to generate a complete LaTex document or just a table:
% input.makeCompleteLatexDocument = 0;
%
% % Now call the function to generate LaTex code:
latex = latexTable(input);