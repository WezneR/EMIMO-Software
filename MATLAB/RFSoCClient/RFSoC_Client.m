classdef RFSoC_Client < handle
    % RFSoC_Client - MATLAB TCP client for RFSoC ZU47DR communication
    % This class provides interface to communicate with RFSoC ZU47DR boards
    % for DAC data transmission, ADC data reception, and calibration management
    
    properties (Access = private)
        tcpClient
        isConnected = false
        serverIP
        serverPort = 6001
        timeout = 3  % seconds
    end
    
    properties (Constant)
        TX_BRAM_SIZE = 128*1024;    % 128KB for TX BRAM
        RX_BRAM_SIZE = 256*1024;    % 256KB per RX BRAM
        NUM_RX_CHANNELS = 8;        % 8 ADC channels
        SAMPLES_PER_RX_BRAM = 128*1024;  % 128K samples per BRAM
        SAMPLES_PER_TX_BRAM = 64*1024;   % 64K samples for TX BRAM
    end
    
    methods
        function obj = RFSoC_Client(ip_address, port)
            % Constructor
            % Usage: client = RFSoC_Client('192.168.1.100', 6001)
            if nargin >= 1
                obj.serverIP = ip_address;
            end
            if nargin >= 2
                obj.serverPort = port;
            end
        end
        
        function delete(obj)
            % Destructor
            obj.disconnect();
        end
        
        function success = connect(obj, ip_address, port)
            % Connect to RFSoC server
            % Usage: success = client.connect('192.168.1.100', 6001)
            if nargin >= 2
                obj.serverIP = ip_address;
            end
            if nargin >= 3
                obj.serverPort = port;
            end
            
            try
                if obj.isConnected
                    obj.disconnect();
                end
                
                fprintf('Connecting to RFSoC at %s:%d...\n', obj.serverIP, obj.serverPort);
                obj.tcpClient = tcpclient(obj.serverIP, obj.serverPort, ...
                    'ConnectTimeout', obj.timeout);

                obj.isConnected = true;

                % Read welcome message and menu
                welcome = obj.readTextResponse();
                fprintf('Connected successfully!\n');
                fprintf('Server response:\n%s\n', welcome);
                success = true;
                
            catch ME
                fprintf('Connection failed: %s\n', ME.message);
                obj.isConnected = false;
                success = false;
            end
        end
        
        function disconnect(obj)
            % Disconnect from RFSoC server
            if obj.isConnected && ~isempty(obj.tcpClient)
                try
                    delete(obj.tcpClient);
                catch
                    % Ignore errors during cleanup
                end
                obj.tcpClient = [];
                obj.isConnected = false;
                fprintf('Disconnected from RFSoC server.\n');
            end
        end
        
        function showMenu(obj)
            % Show server menu
            if ~obj.checkConnection()
                return;
            end
            
            try
                obj.sendCommand('MENU');
                response = obj.readTextResponse();
                fprintf('%s\n', response);
            catch ME
                fprintf('Error getting menu: %s\n', ME.message);
            end
        end
        
        function success = writeDacData(obj, data, filename)
            % Write DAC data to TX BRAM
            % Usage: 
            %   success = client.writeDacData(complex_data)
            %   success = client.writeDacData([], 'dac_output.bin')
            
            if ~obj.checkConnection()
                success = false;
                return;
            end
            
            try
                if nargin >= 3 && ~isempty(filename)
                    % Read from file
                    fprintf('Reading DAC data from file: %s\n', filename);
                    if ~exist(filename, 'file')
                        error('File not found: %s', filename);
                    end
                    
                    fid = fopen(filename, 'rb');
                    if fid == -1
                        error('Cannot open file: %s', filename);
                    end
                    
                    % Read as int16 (I/Q interleaved, 2^16 = 64k samples in total, 32k samples for I or Q)
                    raw_data = fread(fid, 2^16 ,'int16', 0, 'ieee-le');
                    fclose(fid);

                    % Convert to binary for transmission
                    data_bytes = typecast(uint16(raw_data), 'uint8');

                    % data_bytes = fread(fid, 2^16 ,'int16', 0, 'ieee-le');

                    
                elseif ~isempty(data)
                    % Convert complex data to I/Q format
                    if ~isnumeric(data)
                        error('Data must be numeric');
                    end

                    % Ensure data is complex
                    if isreal(data)
                        error('Data must be complex (I+jQ)');
                    end

                    % Limit to maximum samples
                    if length(data) > obj.SAMPLES_PER_TX_BRAM
                        warning('Data truncated to %d samples', obj.SAMPLES_PER_TX_BRAM);
                        data = data(1:obj.SAMPLES_PER_TX_BRAM);
                    end

                    % Convert to I/Q interleaved format (16-bit each)
                    I = int16(real(data) * 32767);  % Normalize to 16-bit range
                    Q = int16(imag(data) * 32767);

                    % Interleave I and Q, then convert to 32-bit words
                    iq_data = zeros(1, length(data), 'uint32');
                    for i = 1:length(data)
                        iq_data(i) = bitor(uint32(uint16(I(i))), ...
                                          bitshift(uint32(uint16(Q(i))), 16));
                    end

                    % Convert to bytes for transmission
                    data_bytes = typecast(iq_data, 'uint8');
                    
                else
                    error('Either data or filename must be provided');
                end
                
                data_size = length(data_bytes);
                if data_size > obj.TX_BRAM_SIZE
                    error('Data size (%d) exceeds TX BRAM size (%d)', ...
                          data_size, obj.TX_BRAM_SIZE);
                end
                
                
                %
                pause(0.5)
                %

                % Send write command
                cmd = sprintf('WRITE_DAC %d', data_size);
                obj.sendCommand(cmd);
                
                % Wait for ready response
                response = obj.readTextResponse();
                if ~startsWith(response, 'OK')
                    error('Server not ready: %s', response);
                else
                    fprintf('Server response received.\n');
                end

                fprintf('Writing %d bytes of DAC data, 2KB per chunk...\n', data_size);

                % Send data
                N_chunk = data_size/2048; % 2KB per chunk
                for chunk_i = 1:N_chunk
                    pause(0.1)
                    dataOffset = chunk_i*2048;
                    fprintf('Sending chunk %d.\n', chunk_i);
                    write(obj.tcpClient, data_bytes(dataOffset : dataOffset + 2048));
                end

                pause(0.5)

                % Wait for completion response
                response = obj.readTextResponse();
                if startsWith(response, 'OK')
                    fprintf('DAC data written successfully.\n');
                    success = true;
                else
                    error('Write failed: %s', response);
                end
                
            catch ME
                fprintf('Error writing DAC data: %s\n', ME.message);
                success = false;
            end
        end
        
        function [adcData, success] = readAdcData(obj)
            % Read ADC data from all RX BRAMs
            % Returns: adcData - struct with fields adc0, adc1, ..., adc7
            
            adcData = [];
            success = false;
            
            if ~obj.checkConnection()
                return;
            end
            
            try
                fprintf('Reading ADC data from all channels...\n');
                
                % Send read command
                obj.sendCommand('READ_ADC');
                
                % Wait for data follows response
                response = obj.readTextResponse();
                if ~startsWith(response, 'DATA_FOLLOWS')
                    error('Unexpected response: %s', response);
                else
                    fprintf('已收到Response code\n');
                end
                
                
                % Read all BRAM data
                total_bytes = obj.RX_BRAM_SIZE * obj.NUM_RX_CHANNELS;
                fprintf('Expecting %d bytes of ADC data...\n', total_bytes);
                
                all_data = uint8([]);
                bytes_received = 0;
                % Read data in chunks
                last_received_time = tic;
                while bytes_received < total_bytes
                    % Check if there is data available
                    if obj.tcpClient.NumBytesAvailable > 0
                        chunk = read(obj.tcpClient, obj.tcpClient.NumBytesAvailable);
                        all_data = [all_data chunk];
                        bytes_received = length(all_data);
                        fprintf('Received %d/%d bytes\n', bytes_received, total_bytes);
                        last_received_time = tic;  % Reset the timer when data is received
                    else
                        pause(0.1);  % Small delay
                    end
                    
                    % Timeout check
                    elapsed_time = toc(last_received_time);  % Calculate time since last data received
                    if elapsed_time > 5  % If 5 seconds have passed without receiving any data
                        fprintf('Timeout: No data received for 5 seconds\n');
                        break;  % Exit the loop if no data has been received in 5 seconds
                    end
                    
                    % Timeout check for no data received from the server
                    if bytes_received == 0
                        elapsed_time = toc(last_received_time);
                        if elapsed_time > 1
                            error('No data received from server');
                        end
                    end
                end

                
                fprintf('All ADC data received.\n');
                
                % Parse data into separate ADC channels
                adcData = obj.parseAdcData(all_data);
                success = true;
                
            catch ME
                % 获取错误堆栈信息
                if ~isempty(ME.stack)
                    stack_info = ME.stack(1); % 获取最内层的错误位置
                    fprintf('Error reading ADC data in %s (line %d): %s\n', ...
                        stack_info.name, stack_info.line, ME.message);
                else
                    fprintf('Error reading ADC data: %s\n', ME.message);
                end
                success = false;
            end
        end
        
        function success = setCalibration(obj, channel_type, channel, param_type, value)
            % Set calibration parameter for a single channel
            % Usage: success = client.setCalibration('TX', 0, 'PHASE', 1000)
            %        success = client.setCalibration('RX', 2, 'AMP', 2000)
            
            if ~obj.checkConnection()
                success = false;
                return;
            end
            
            try
                % Validate inputs
                if ~ismember(upper(channel_type), {'TX', 'RX'})
                    error('channel_type must be TX or RX');
                end
                if ~ismember(upper(param_type), {'PHASE', 'AMP'})
                    error('param_type must be PHASE or AMP');
                end
                if channel < 0 || channel > 7
                    error('channel must be 0-7');
                end
                if value < 0 || value > 65535
                    error('value must be 0-65535');
                end
                
                cmd = sprintf('SET_CALIB %s %d %s %d', ...
                             upper(channel_type), channel, upper(param_type), value);
                obj.sendCommand(cmd);
                
                response = obj.readTextResponse();
                if startsWith(response, 'OK')
                    fprintf('Calibration set: %s CH%d %s = %d\n', ...
                           upper(channel_type), channel, upper(param_type), value);
                    success = true;
                else
                    error('Set calibration failed: %s', response);
                end
                
            catch ME
                fprintf('Error setting calibration: %s\n', ME.message);
                success = false;
            end
        end
        
        function [value, success] = getCalibration(obj, channel_type, channel, param_type)
            % Get calibration parameter for a single channel
            % Usage: [value, success] = client.getCalibration('TX', 0, 'PHASE')
            
            value = [];
            success = false;
            
            if ~obj.checkConnection()
                return;
            end
            
            try
                % Validate inputs
                if ~ismember(upper(channel_type), {'TX', 'RX'})
                    error('channel_type must be TX or RX');
                end
                if ~ismember(upper(param_type), {'PHASE', 'AMP'})
                    error('param_type must be PHASE or AMP');
                end
                if channel < 0 || channel > 7
                    error('channel must be 0-7');
                end
                
                cmd = sprintf('GET_CALIB %s %d %s', ...
                             upper(channel_type), channel, upper(param_type));
                obj.sendCommand(cmd);
                
                response = obj.readTextResponse();
                if startsWith(response, 'OK')
                    parts = split(response);
                    if length(parts) >= 2
                        value = str2double(parts{2});
                        success = true;
                    else
                        error('Invalid response format');
                    end
                else
                    error('Get calibration failed: %s', response);
                end
                
            catch ME
                fprintf('Error getting calibration: %s\n', ME.message);
                success = false;
            end
        end
        
        function success = setAllCalibration(obj, channel_type, param_type, values)
            % Set calibration parameters for all channels
            % Usage: success = client.setAllCalibration('RX', 'PHASE', [1000,1100,1200,1300,1400,1500,1600,1700])
            
            if ~obj.checkConnection()
                success = false;
                return;
            end
            
            try
                % Validate inputs
                if ~ismember(upper(channel_type), {'TX', 'RX'})
                    error('channel_type must be TX or RX');
                end
                if ~ismember(upper(param_type), {'PHASE', 'AMP'})
                    error('param_type must be PHASE or AMP');
                end
                
                if strcmp(upper(channel_type), 'RX')
                    num_channels = 8;
                else
                    num_channels = 1;
                end
                if length(values) ~= num_channels
                    error('values must have %d elements for %s channels', num_channels, channel_type);
                end
                
                % Build command
                cmd = sprintf('SET_ALL_CALIB %s %s', upper(channel_type), upper(param_type));
                for i = 1:length(values)
                    cmd = sprintf('%s %d', cmd, values(i));
                end
                
                obj.sendCommand(cmd);
                
                response = obj.readTextResponse();
                if startsWith(response, 'OK')
                    fprintf('All %s %s calibration values set.\n', channel_type, param_type);
                    success = true;
                else
                    error('Set all calibration failed: %s', response);
                end
                
            catch ME
                fprintf('Error setting all calibration: %s\n', ME.message);
                success = false;
            end
        end
        
        function [values, success] = getAllCalibration(obj, channel_type, param_type)
            % Get calibration parameters for all channels
            % Usage: [values, success] = client.getAllCalibration('RX', 'PHASE')
            
            values = [];
            success = false;
            
            if ~obj.checkConnection()
                return;
            end
            
            try
                % Validate inputs
                if ~ismember(upper(channel_type), {'TX', 'RX'})
                    error('channel_type must be TX or RX');
                end
                if ~ismember(upper(param_type), {'PHASE', 'AMP'})
                    error('param_type must be PHASE or AMP');
                end
                
                cmd = sprintf('GET_ALL_CALIB %s %s', upper(channel_type), upper(param_type));
                obj.sendCommand(cmd);
                
                response = obj.readTextResponse();
                if startsWith(response, 'OK')
                    parts = split(response);
                    if length(parts) >= 2
                        values = str2double(parts(2:end));
                        values = values(~isnan(values));  % Remove any NaN values
                        success = true;
                    else
                        error('Invalid response format');
                    end
                else
                    error('Get all calibration failed: %s', response);
                end
                
            catch ME
                fprintf('Error getting all calibration: %s\n', ME.message);
                success = false;
            end
        end

        function [success] = trig_mts(obj)
            % trigger a dacMTSwl section in RFSoC
            if ~obj.isConnected
                fprintf('Not connected. Please connect first.\n');
                return;
            end

            try
                cmd = sprintf('TRIG_MTS');
                obj.sendCommand(cmd);
                
                pause(1)
                % Wait for ready response
                response = obj.readTextResponse();
                if ~startsWith(response, 'OK')
                    error('Server not ready: %s', response);
                else
                    fprintf('MTS section is running on board %s:%d\n', obj.serverIP, obj.serverPort);
                end
                success = true;
                
            catch ME
                fprintf('Error triggering MTS: %s\n', ME.message);
                success = false;
            end
        end
    
        
        function runInteractiveMenu(obj)
            % Run interactive command menu
            if ~obj.isConnected
                fprintf('Not connected. Please connect first.\n');
                return;
            end
            
            while true
                fprintf('\n=== RFSoC Client Menu ===\n');
                fprintf('1. Show server menu\n');
                fprintf('2. Write DAC data from file\n');
                fprintf('3. Write DAC data from workspace\n');
                fprintf('4. Read ADC data\n');
                fprintf('5. Set calibration parameter\n');
                fprintf('6. Get calibration parameter\n');
                fprintf('7. Set all calibration parameters\n');
                fprintf('8. Get all calibration parameters\n');
                fprintf('9. Trigger an MTS operation\n');
                fprintf('0. Exit\n');
                
                choice = input('Enter choice: ', 's');
                
                switch choice
                    case '1'
                        obj.showMenu();
                    case '2'
                        filename = input('Enter filename (e.g., dac_output.bin): ', 's');
                        if ~isempty(filename)
                            obj.writeDacData([], filename);
                        end
                    case '3'
                        var_name = input('Enter variable name: ', 's');
                        if ~isempty(var_name) && evalin('base', ['exist(''' var_name ''', ''var'')'])
                            data = evalin('base', var_name);
                            obj.writeDacData(data);
                        else
                            fprintf('Variable not found in workspace.\n');
                        end
                    case '4'
                        [adcData, success] = obj.readAdcData();
                        if success
                            assignin('base', 'adcData', adcData);
                            fprintf('ADC data saved to workspace variable ''adcData''.\n');
                        end
                    case '5'
                        type = input('Channel type (TX/RX): ', 's');
                        ch = str2double(input('Channel number (0-7): ', 's'));
                        param = input('Parameter (PHASE/AMP): ', 's');
                        val = str2double(input('Value (0-65535): ', 's'));
                        obj.setCalibration(type, ch, param, val);
                    case '6'
                        type = input('Channel type (TX/RX): ', 's');
                        ch = str2double(input('Channel number (0-7): ', 's'));
                        param = input('Parameter (PHASE/AMP): ', 's');
                        [val, success] = obj.getCalibration(type, ch, param);
                        if success
                            fprintf('Value: %d\n', val);
                        end
                    case '7'
                        type = input('Channel type (TX/RX): ', 's');
                        param = input('Parameter (PHASE/AMP): ', 's');
                        if strcmp(upper(type), 'RX')
                            num_ch = 8;
                        else
                            num_ch = 1;
                        end
                        values = [];
                        for i = 1:num_ch
                            val = str2double(input(sprintf('Value for channel %d: ', i-1), 's'));
                            values = [values, val];
                        end
                        obj.setAllCalibration(type, param, values);
                    case '8'
                        type = input('Channel type (TX/RX): ', 's');
                        param = input('Parameter (PHASE/AMP): ', 's');
                        [values, success] = obj.getAllCalibration(type, param);
                        if success
                            fprintf('Values: ');
                            fprintf('%d ', values);
                            fprintf('\n');
                        end
                    case '9'
                        obj.trig_mts();
                        return;
                    case '0'
                        obj.disconnect();
                        return;
                    otherwise
                        fprintf('Invalid choice.\n');
                end
            end
        end
    end
    
    methods (Access = private)
        function success = checkConnection(obj)
            if ~obj.isConnected || isempty(obj.tcpClient)
                fprintf('Not connected to RFSoC server.\n');
                success = false;
            else
                success = true;
            end
        end
        
        function sendCommand(obj, cmd)
                % Send command to server
                cmd_with_newline = sprintf('%s\n', cmd);
                write(obj.tcpClient, uint8(cmd_with_newline));
            end
            
        function response = readTextResponse(obj)
            % Read text response from server with proper boundary handling
            response = '';
            start_time = tic;
            
            while toc(start_time) < obj.timeout
                if obj.tcpClient.NumBytesAvailable > 0
                    % Read data byte by byte or in small chunks to avoid over-reading
                    available_bytes = obj.tcpClient.NumBytesAvailable;
                    
                    % For single-line responses, read character by character until newline
                    while available_bytes > 0 && toc(start_time) < obj.timeout
                        data = read(obj.tcpClient, 1); % Read one byte at a time
                        new_char = char(data);
                        response = [response, new_char];
                        available_bytes = available_bytes - 1;
                        
                        % Check for end of response
                        if new_char == char(10) || new_char == char(13) % \n or \r
                            % For menu responses, continue reading until complete
                            if contains(response, '===') && contains(response, 'Menu')
                                % Keep reading until closing ===
                                if contains(response, '===========================')
                                    response = strtrim(response);
                                    return;
                                end
                                % Continue reading for complete menu
                                continue;
                            else
                                % Single line response complete
                                response = strtrim(response);
                                response = regexprep(response, '^[\r\n]+|[\r\n]+$', '');
                                return;
                            end
                        end
                    end
                else
                    pause(0.001); % Shorter pause for better responsiveness
                end
            end
            
            if isempty(response)
                error('Timeout waiting for server response');
            end
            
            response = strtrim(response);
        end
        
        function adcData = parseAdcData(obj, raw_data)
            % Parse raw ADC data into structured format
            spx_per_bram = obj.RX_BRAM_SIZE/2;
            
            % Initialize structure
            adcData = struct();
            int16_array = typecast(raw_data, 'int16');

            for ch = 0:7
                start_idx = ch * spx_per_bram + 1;
                end_idx = (ch + 1) * spx_per_bram;
                
                if end_idx > length(int16_array)
                    error('Insufficient data for channel %d', ch);
                end
                
                % Extract channel data
                channel_spx_arr = int16_array(start_idx:end_idx);
                
                % Convert to 16-bit I and Q components directly
                I = channel_spx_arr(1:2:end);   % Odd-indexed bytes (1st, 3rd, 5th, ...)
                Q = channel_spx_arr(2:2:end);   % Even-indexed bytes (2nd, 4th, 6th, ...)
                
                % Convert to complex data
                complex_data = double(I) + 1j * double(Q);
                
                % Store in structure
                field_name = sprintf('adc%d', ch);
                adcData.(field_name) = complex_data;
            end
        end

    end
end