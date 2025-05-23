function ecg = generate_realistic_ecg(sol, params)
    % Basic ECG synthesis from oscillator outputs
    base_ecg = params.mu1*sol.y(1,:) + params.mu2*sol.y(3,:) + ...
               params.mu3*sol.y(5,:) + params.mu4*sol.y(7,:) + params.mu5*sol.y(9,:);
    
    % Add realistic ECG features (PQRST waves)
    t = sol.x;
    ecg = zeros(size(base_ecg));
    
    % Find heartbeats (peaks in SA node activity)
    try
        [pks, locs] = findpeaks(sol.y(1,:), 'MinPeakProminence', 0.1, 'MinPeakDistance', 50);
    catch
        % If no peaks found, create default locations
        hr = 60; % Default heart rate (bpm)
        beat_interval = round(60/hr * 100); % Convert to samples (assuming 100Hz sampling)
        locs = 50:beat_interval:length(t)-200;
    end
    
    % Create template ECG waveform for each beat
    for i = 1:length(locs)
        if locs(i)+200 > length(t)
            continue; % Skip if beyond time range
        end
        
        % P wave (atrial depolarization)
        p_start = locs(i);
        p_dur = 20;
        if p_start+p_dur <= length(ecg)
            p_wave = 0.3 * gausswin(p_dur+1)';
            ecg(p_start:min(p_start+p_dur,length(ecg))) = ...
                ecg(p_start:min(p_start+p_dur,length(ecg))) + ...
                p_wave(1:min(length(p_wave),length(ecg)-p_start+1));
        end
        
        % QRS complex (ventricular depolarization)
        qrs_start = p_start + 40;
        qrs_dur = 30;
        if qrs_start <= length(ecg)
            end_idx = min(qrs_start+qrs_dur-1, length(ecg));
            actual_dur = end_idx - qrs_start + 1;
            
            % Create QRS wave of exact needed length
            qrs_down = linspace(0,-1,min(10,actual_dur));
            qrs_up = linspace(-1,1,min(20,actual_dur));
            qrs_wave = [qrs_down, qrs_up(1:min(length(qrs_up),actual_dur-length(qrs_down)))];
            
            if ~isempty(qrs_wave)
                ecg(qrs_start:end_idx) = ecg(qrs_start:end_idx) + qrs_wave(1:end_idx-qrs_start+1);
            end
        end
        
        % T wave (ventricular repolarization)
        t_start = qrs_start + 60;
        t_dur = 50;
        if t_start <= length(ecg)
            end_idx = min(t_start+t_dur, length(ecg));
            actual_dur = end_idx - t_start + 1;
            t_wave = 0.5 * gausswin(actual_dur+1)';
            ecg(t_start:end_idx) = ecg(t_start:end_idx) + t_wave(1:actual_dur);
        end
    end
    
    % Combine with base signal
    ecg = 0.7*ecg + 0.3*base_ecg;
    
    % Add some noise for realism
    ecg = ecg + 0.05*randn(size(ecg));
end