function out = detect(ecg2canals,debug)

if nargin<2
    debug=0;
end
    ecg=ecg2canals(1:10000,1);
    % These time constants may need adjustment for pediatric or
    % small mammal ECGs.
    time = 0;
    now = 10;

    freq = 250;
    ms160 = ceil(0.16*freq);
    ms200 = ceil(0.2*freq);
    s2 = ceil(2*freq);
    scmin = 50;
    % number of ADC units corresponding to scmin microvolts
    % scmin = muvadu(signal, scmin); 
    scmax = 10 * scmin;
    slopecrit = 10 * scmin;
    maxslope = 0;
    nslope = 0;
    out = [];

    while (now < length(ecg)) %   && (to == 0)
        filter = [1 4 6 4 1 -1 -4 -6 -4 -1] * ecg((now-9):now);
        if (mod(time, s2) == 0)
	    % Adjust slope 
            if (nslope == 0)
	      slopecrit = max(slopecrit - slopecrit/16, scmin);
            elseif (nslope >= 5)
	      slopecrit = min(slopecrit + slopecrit/16, scmax);
            end
        end
        if (nslope == 0  && (abs(filter) > slopecrit))
            nslope = nslope + 1; 
	    maxtime = ms160;
	    if (filter > 0) 
	      sign = 1;
	    else
	      sign = -1;
	    end
            qtime = time;
        end
        if (nslope ~= 0)
            if (filter * sign < -slopecrit)
                sign = -sign;
		nslope = nslope + 1;
		if (nslope > 4) 
		  maxtime = ms200;
		else
		  maxtime = ms160;
		end
            elseif (filter * sign > slopecrit &&  abs(filter) > maxslope)
                maxslope = abs(filter);
	    end
            if (maxtime < 0)
                if (2 <= nslope && nslope <= 4)
                    slopecrit = slopecrit + ((maxslope/4) - slopecrit)/8;
                    if (slopecrit < scmin)
		      slopecrit = scmin;
                    elseif (slopecrit > scmax) 
		      slopecrit = scmax;
		    end
                    out = [out; now - (time - qtime) - 4];
                    %annot.anntyp = NORMAL; 
                    time = 0;
                elseif (nslope >= 5)
                    out = [out; now - (time - qtime) - 4];
                    %annot.anntyp = ARFCT; 
                end
                nslope = 0;
            end
	    maxtime = maxtime - 1;
        end
	time = time + 1;
	now = now + 1;
    end

out=out-1; % adjust for 1 sample offset problem.


%    plot(ecg,'b');
%    hold on;
%    plot(out,1000,'m*'); 
end
