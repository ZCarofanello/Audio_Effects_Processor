Fs           = 48e3;         % Sampling Frequency in Hz
Fpass        = 9.6e3;        % Passband Frequency in Hz
Fstop        = 12e3;         % Stopband Frequency in Hz
Apass        = 1;            % Passband Ripple in dB
Astop        = 90;           % Stopband Attenuation in dB

lpSpec = fdesign.lowpass( 'Fp,Fst,Ap,Ast',...
    Fpass, Fstop, Apass, Astop, Fs);



lpFilter = design(lpSpec, 'equiripple', 'filterstructure', 'dffir',...
    'SystemObject', true);

inputDataType = numerictype(1,24,0);
outputDataType = inputDataType;
coeffsDataType = numerictype(1,16,16);

lpFilter.FullPrecisionOverride = false;
lpFilter.CoefficientsDataType = 'Custom';
lpFilter.CustomCoefficientsDataType = coeffsDataType;
lpFilter.OutputDataType = 'Custom';
lpFilter.CustomOutputDataType = outputDataType;

% Now check the filter response with fvtool.
fvtool(lpFilter,'Fs',Fs,'Arithmetic','fixed');

FL = length(lpFilter.Numerator);

dalut = [ones(1, floor(FL/8))*8, mod(FL, 8)];

workingdir = tempname;
generatehdl(lpFilter, 'DALUTPartition', dalut, ...
                'TargetDirectory', workingdir, ...
                'InputDataType', inputDataType);