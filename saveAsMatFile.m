function saveAsMatFile( var,filename,varname )
%SAVEASMATFILE Summary of this function goes here
%   Detailed explanation goes here
if isvarname(varname)
    eval([varname '=var;']);
    save(filename,varname);
else
    error('Invalid variable name.')
end

end