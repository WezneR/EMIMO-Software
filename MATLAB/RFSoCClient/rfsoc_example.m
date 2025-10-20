%% RFSoC ZU47DR MATLAB Client Example
% This script demonstrates how to use the RFSoC_Client class to communicate
% with RFSoC ZU47DR boards for DAC/ADC data transmission and calibration

clear all; close all; clc;

%% Configuration
% Modify these parameters according to your setup
RFSOC_IP = '192.168.1.2';  % Replace with your RFSoC board IP
RFSOC_PORT = 6001;           % TCP port (should match server)

% RFSOC_IP = '127.0.0.1';  % 用于连接本地 Net assistant 测试
% RFSOC_PORT = 8080;           % TCP port (should match server)
% Create and connect to RFSoC client
fprintf('=== RFSoC ZU47DR MATLAB Client Example ===\n');

% Create client instance
client = RFSoC_Client(RFSOC_IP, RFSOC_PORT);

% Connect to server
success = client.connect();
if ~success
    error('Failed to connect to RFSoC server at %s:%d', RFSOC_IP, RFSOC_PORT);
end

try
%     %% Example 1: Show server menu
%     fprintf('\n--- Example 1: Server Menu ---\n');
%     client.showMenu();

%     %% Example 2: Generate and write DAC data
%     fprintf('\n--- Example 2: Write DAC Data ---\n');
%     
%     % Generate test signal (complex baseband)
%     fs = 1e6;                    % Sample rate (1 MHz)
%     f_signal = 100e3;            % Signal frequency (100 kHz)
%     num_samples = 32*1024;       % 32K samples
%     t = (0:num_samples-1) / fs;
%     
%     % Create complex test signal
%     dac_signal = 0.5 * (cos(2*pi*f_signal*t) + 1j*sin(2*pi*f_signal*t));
%     
%     % Add some noise for realism
%     dac_signal = dac_signal + 0.01 * (randn(size(t)) + 1j*randn(size(t)));
%     
%     fprintf('Generated %d samples of test signal\n', length(dac_signal));
%     
%     % Write to RFSoC
%     success = client.writeDacData(dac_signal);
%     if success
%         fprintf('DAC data written successfully!\n');
%     else
%         fprintf('Failed to write DAC data.\n');
%     end

%     %% Example 3: Write DAC data from file (if available)
%     fprintf('\n--- Example 3: Write DAC Data from File ---\n');
%     
%     % Check if dac_output.bin exists
%     if exist('dac_output.bin', 'file')
%         success = client.writeDacData([], 'dac_output.bin');
%         if success
%             fprintf('DAC data from file written successfully!\n');
%         else
%             fprintf('Failed to write DAC data from file.\n');
%         end
%     else
%         fprintf('dac_output.bin not found, skipping file example.\n');
%         
%         % Optionally create the file for future use
%         fprintf('Creating example dac_output.bin file...\n');
%         create_dac_output_file();
%     end

%     %% Example 4: Read ADC data
%     fprintf('\n--- Example 4: Read ADC Data ---\n');
%     
%     [adcData, success] = client.readAdcData();
%     if success
%         fprintf('ADC data read successfully!\n');
%         
%         % Display information about received data
%         field_names = fieldnames(adcData);
%         for i = 1:length(field_names)
%             data = adcData.(field_names{i});
%             fprintf('  %s: %d samples, Power: %.2f dB\n', ...
%                    field_names{i}, length(data), ...
%                    10*log10(mean(abs(data).^2)));
%         end
%         
%         % Plot first few channels
%         plot_adc_data(adcData);
%         
%     else
%         fprintf('Failed to read ADC data.\n');
%     end

    %% Example 5: Calibration parameter management
%     fprintf('\n--- Example 5: Calibration Parameters ---\n');
%     
%     % Set individual calibration parameters
%     fprintf('Setting TX phase calibration...\n');
%     success = client.setCalibration('TX', 0, 'PHASE', 1000);
%     
%     fprintf('Setting RX amplitude calibration for channel 2...\n');
%     success = client.setCalibration('RX', 2, 'AMP', 2500);
%     
%     % Get individual calibration parameters
%     [tx_phase, success] = client.getCalibration('TX', 0, 'PHASE');
%     if success
%         fprintf('TX Channel 0 Phase: %d\n', tx_phase);
%     end
%     
%     [rx_amp, success] = client.getCalibration('RX', 2, 'AMP');
%     if success
%         fprintf('RX Channel 2 Amplitude: %d\n', rx_amp);
%     end
%     
%     % Set all RX phase calibrations
%     fprintf('Setting all RX phase calibrations...\n');
%     rx_phase_values = [1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700];
%     success = client.setAllCalibration('RX', 'PHASE', rx_phase_values);
%     
%     % Get all RX phase calibrations
%     [all_rx_phases, success] = client.getAllCalibration('RX', 'PHASE');
%     if success
%         fprintf('All RX Phase values: ');
%         fprintf('%d ', all_rx_phases);
%         fprintf('\n');
%     end
%     
%     % Set all RX amplitude calibrations
%     fprintf('Setting all RX amplitude calibrations...\n');
%     rx_amp_values = [2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700];
%     success = client.setAllCalibration('RX', 'AMP', rx_amp_values);
%     
%     % Get all RX amplitude calibrations
%     [all_rx_amps, success] = client.getAllCalibration('RX', 'AMP');
%     if success
%         fprintf('All RX Amplitude values: ');
%         fprintf('%d ', all_rx_amps);
%         fprintf('\n');
%     end

    %% Example 6: Interactive menu (optional)
%     fprintf('\n--- Example 6: Interactive Menu ---\n');
%     user_choice = input('Do you want to run interactive menu? (y/n): ', 's');
%     if strcmpi(user_choice, 'y')
        client.runInteractiveMenu();
%     end

catch ME
    fprintf('Error during execution: %s\n', ME.message);
    fprintf('Stack trace:\n');
    for i = 1:length(ME.stack)
        fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
    end
end

%% Cleanup
fprintf('\n--- Cleanup ---\n');
client.disconnect();
fprintf('Example completed.\n');

%% Helper Functions

function create_dac_output_file()
    % Create an example dac_output.bin file
    
    % Generate 64K samples (32K I + 32K Q)
    num_samples = 32*1024;
    
    % Create test waveform
    fs = 1e6;
    f1 = 100e3;  % 100 kHz tone
    f2 = 250e3;  % 250 kHz tone
    t = (0:num_samples-1) / fs;
    
    % Multi-tone signal
    I = 0.3 * cos(2*pi*f1*t) + 0.2 * cos(2*pi*f2*t);
    Q = 0.3 * sin(2*pi*f1*t) + 0.2 * sin(2*pi*f2*t);
    
    % Scale to 16-bit range
    I_16 = int16(I * 32767 * 0.8);  % Leave some headroom
    Q_16 = int16(Q * 32767 * 0.8);
    
    % Interleave I and Q into 32-bit words
    iq_words = zeros(1, num_samples, 'uint32');
    for i = 1:num_samples
        iq_words(i) = bitor(uint32(uint16(I_16(i))), ...
                           bitshift(uint32(uint16(Q_16(i))), 16));
    end
    
    % Write to file
    fid = fopen('dac_output.bin', 'wb');
    if fid == -1
        error('Cannot create dac_output.bin');
    end
    
    fwrite(fid, iq_words, 'uint32');
    fclose(fid);
    
    fprintf('Created dac_output.bin with %d samples (%.1f KB)\n', ...
           num_samples, length(iq_words)*4/1024);
end

function plot_adc_data(adcData)
    % Plot ADC data from first 4 channels
    
    figure('Name', 'RFSoC ADC Data', 'Position', [100, 100, 1200, 800]);
    
    channels_to_plot = min(4, length(fieldnames(adcData)));
    
    for ch = 1:channels_to_plot
        field_name = sprintf('adc%d', ch-1);
        if isfield(adcData, field_name)
            data = adcData.(field_name);
            
            % Limit to first 1000 samples for display
            samples_to_plot = min(1000, length(data));
            data_plot = data(1:samples_to_plot);
            
            subplot(2, 2, ch);
            
            % Time domain plot
            t = (0:samples_to_plot-1);
            plot(t, real(data_plot), 'b-', 'LineWidth', 1);
            hold on;
            plot(t, imag(data_plot), 'r-', 'LineWidth', 1);
            grid on;
            xlabel('Sample');
            ylabel('Amplitude');
            title(sprintf('ADC Channel %d (Time Domain)', ch-1));
            legend('I', 'Q', 'Location', 'best');
            
            % Calculate and display statistics
            power_db = 10*log10(mean(abs(data).^2));
            text(0.02, 0.95, sprintf('Power: %.1f dB\nSamples: %d', ...
                 power_db, length(data)), ...
                 'Units', 'normalized', 'VerticalAlignment', 'top', ...
                 'BackgroundColor', 'white');
        end
    end
    
    % Add overall title
    sgtitle('RFSoC ADC Data Analysis', 'FontSize', 14, 'FontWeight', 'bold');
end