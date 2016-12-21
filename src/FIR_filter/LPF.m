Fpass = 0.45; % Passband Frequency
Fstop = 0.55; % Stopband Frequency
Apass = 1;    % Passband Attenuation (dB)
Astop = 60;   % Stopband Attenuation (dB)

f = fdesign.lowpass('Fp,Fst,Ap,Ast',Fpass,Fstop,Apass,Astop)
