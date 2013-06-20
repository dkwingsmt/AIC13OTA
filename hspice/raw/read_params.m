function [ out ] = read_params( file )
%CALC_PARAM Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(file);
if fid == -1
  fprintf('File not found: %s\n', file);
  fclose(fid);   
else
  out = {};
  start = 0;
  d = 0;
  name = '';
  while(1)
    tline = fgetl(fid);
    %fprintf('Line %s\n', tline)
    if ~ischar(tline)
      break
    end
    tline = deblank(tline);
    if isempty(tline)
      %fprintf('EMPTY!\n')
      if start ~= 0
        if isstruct(d)
          out = setfield(out, name, d);
          start = 0;
          d = 0;
        end
      end
      continue
    else
      if start == 0
        d = struct();
        name = tline;
        %fprintf('Device %s\n', name)
        start = 1;
      else
        k = tline;
        v = fgetl(fid);
        %fprintf('K %s V %s\n', k, num2str(v))
        num = str2num(v);
        if ~isempty(num)
          v = num;
        end
        d = setfield(d, k, v);
      end
    end
  end
end
%fprintf('Ended\n');

end

