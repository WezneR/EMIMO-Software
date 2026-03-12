classdef subArray_controller < handle
    %SUBARRAY_CONTROLLER Control class for Sub Array board via STM32 UART
    %   Communicates with STM32F103 to configure Sub Array board with
    %   Spartan-6 FPGA for phased array control.
    %   Frame format: [Header(2B) | Data(4B) | Tail(2B)] = 8 bytes total
    %   
    %   Two types of instructions distinguished by tail bytes:
    %   - MCU local processing: tail = 0x0A, 0x0D
    %   - FPGA forwarding via SPI: tail = 0x0D, 0x0A
    %
    % Example Usage:
    %
    %     % Create controller and connect
    %     sa = subArray_controller('COM3');  % Windows
    %     % sa = subArray_controller('/dev/ttyUSB0');  % Linux
    %
    %     %% MCU Commands (processed locally by STM32)
    %     % Set developer mode
    %     sa.mcu_setDevMode(true);           % Enable DEV_MODE
    %     sa.mcu_setDevMode(false);          % Disable DEV_MODE
    %
    %     % Re-transmit init values from EEPROM to FPGA
    %     sa.mcu_reInitFromEEPROM();
    %
    %     % Read init values from EEPROM
    %     sa.mcu_readBoardID();              % Read Module_ID and Board_ID
    %     sa.mcu_readInitPhase('tx');        % Read TX initial phases
    %     sa.mcu_readInitPhase('rx');        % Read RX initial phases
    %     sa.mcu_readInitAtten('tx');        % Read TX initial attenuations
    %     sa.mcu_readInitAtten('rx');        % Read RX initial attenuations
    %
    %     % Write init values to EEPROM
    %     sa.mcu_writeBoardID(0x12);         % Write Board_ID (Module_ID=1, Board_ID=2)
    %     sa.mcu_writeInitPhase(0, 0, 128);  % Write phase for Chip0, Ch0
    %     sa.mcu_writeInitAtten(0, 1, 64);   % Write atten for Chip0, Ch1
    %
    %     %% FPGA Commands (forwarded to FPGA via SPI)
    %     % Beam control
    %     sa.fpga_setBeamAngle(15, -10);     % Set azimuth=15, pitch=-10 degrees
    %
    %     % Initialize all channels
    %     sa.fpga_init();
    %
    %     % Write phase to specific channel
    %     sa.fpga_writePhase(0, 0, 'BF', 128); % Chip0, Ch0, BF register, phase=128
    %     sa.fpga_writePhase(4, 1, 'AC', 64);  % Chip4, Ch1, AC register, phase=64
    %
    %     % Write attenuation
    %     sa.fpga_writeAtten(0, 0, 32);      % Chip0, Ch0, atten=32
    %
    %     % Control TX/RX switches (requires DEV_MODE)
    %     sa.fpga_switchTXRX(0, 'tx');       % Turn on TX for FEM chip 0
    %     sa.fpga_switchTXRX(3, 'rx');       % Turn on RX for FEM chip 3
    %     sa.fpga_switchTXRX(8, 'off');      % Turn off all channels
    %
    %     % Update phase (send LP pulse)
    %     sa.fpga_updatePhase();
    %
    %     % Power down all channels
    %     sa.fpga_powerDown();
    %
    %     % Modify FPGA's local Board_ID
    %     sa.fpga_setBoardID(0x12);
    %
    %     % Send initial phase/atten to FPGA
    %     sa.fpga_sendInitPhase(0, 0, 128);
    %     sa.fpga_sendInitAtten(0, 1, 64);
    %
    %     % Write IF DSA attenuation
    %     sa.fpga_writeIFDSA(0, 32, false);  % TX IF DSA, atten=32, no load
    %     sa.fpga_writeIFDSA(1, 16, true);   % RX IF DSA, atten=16, load all
    %
    %     % Disconnect when done
    %     sa.disconnect();
    %     % or just: clear sa
    
    properties
        serialObj           % Serial port object
        baudrate = 115200;
        Header = [hex2dec('55'); hex2dec('5D')];
        Tail_FPGA = [hex2dec('0D'); hex2dec('0A')];  % Tail for FPGA forwarding
        Tail_MCU = [hex2dec('0A'); hex2dec('0D')];   % Tail for MCU local processing
        portName            % COM port name
        isConnected = false;
        
        % Target board addressing
        targetModuleID = 0;    % Default Module_ID (0-15)
        targetBoardID = 8;     % Default Board_ID (8 = broadcast)
    end
    
    properties (Constant)
        % Board ID special values
        BID_BROADCAST = 8;     % All modules, all boards
        BID_MODULE_ONLY = 9;   % All boards in specified module
        
        % FPGA Command addresses
        CMD_PHASE_ARRAY_CAL = 0;
        CMD_INIT = 1;
        CMD_WRITE_PHASE = 2;
        CMD_WRITE_ATTEN = 3;
        CMD_SWITCH_TXRX = 4;
        CMD_UPDATE_PHASE = 5;
        CMD_POWER_DOWN = 6;
        CMD_RECV_BOARD_ID = 7;
        CMD_RECV_PHASE_INIT = 8;
        CMD_RECV_ATTEN_INIT = 9;
        CMD_WRITE_IFDSA = 10;  % 0xA
        CMD_BEAM_SCAN_CONFIG = 11;
        CMD_BEAM_SCAN_ADD_DIR  = 12;
        CMD_BEAM_SCAN_ARM      = 13;
        CMD_BEAM_SCAN_DISARM   = 14;

        % MCU Command addresses (local processing)
        MCU_CMD_DEV_MODE = 0;
        MCU_CMD_REINIT = 1;
        MCU_CMD_READ_INIT = 2;
        MCU_CMD_WRITE_BID = 7;
        MCU_CMD_WRITE_PHASE = 8;
        MCU_CMD_WRITE_ATTEN = 9;
    end
    
    methods
        %% Constructor
        function obj = subArray_controller(portName)
            % SUBARRAY_CONTROLLER Construct an instance of this class
            %   obj = subArray_controller('COM3') or subArray_controller('/dev/ttyUSB0')
            if nargin > 0
                if (strcmp(obj.portName, portName) == true && obj.isConnected == true)
                    warning('Already Connected');
                else
                    obj.portName = portName;
                    obj.connect();
                end
            end
        end
        
        %% Connection Management
        function connect(obj, portName)
            % CONNECT Connect to the serial port
            if nargin > 1
                obj.portName = portName;
            end
            
            if isempty(obj.portName)
                error('Port name not specified');
            end
            
            try
                % Close existing connection if any
                if ~isempty(obj.serialObj) && isvalid(obj.serialObj)
                    delete(obj.serialObj);
                end
                
                % Create serial port object
                obj.serialObj = serialport(obj.portName, obj.baudrate);
                configureTerminator(obj.serialObj, "CR/LF");
                obj.isConnected = true;
                fprintf('Connected to %s at %d baud\n', obj.portName, obj.baudrate);
                
                % Flush any existing data
                flush(obj.serialObj);
            catch ME
                error('Failed to connect: %s', ME.message);
            end
        end
        
        function disconnect(obj)
            % DISCONNECT Close the serial port connection
            if ~isempty(obj.serialObj) && isvalid(obj.serialObj)
                delete(obj.serialObj);
                obj.isConnected = false;
                fprintf('Disconnected from %s\n', obj.portName);
            end
        end
        
        %% Target Board Addressing
        function setTarget(obj, moduleID, boardID)
            % SETTARGET Set target Module_ID and Board_ID for commands
            %   setTarget(moduleID, boardID)
            %   moduleID: 0-15 (module number)
            %   boardID: 0-7 (board number), 8 (broadcast), 9 (module only)
            
            if moduleID < 0 || moduleID > 15
                error('Module_ID must be 0-15');
            end
            if boardID < 0 || boardID > 9
                error('Board_ID must be 0-9 (0-7 for specific board, 8=broadcast, 9=module only)');
            end
            
            obj.targetModuleID = moduleID;
            obj.targetBoardID = boardID;
            fprintf('Target set to Module_ID=%d, Board_ID=%d\n', moduleID, boardID);
        end
        
        function setTargetBroadcast(obj)
            % SETTARGETBROADCAST Set target to broadcast mode (all boards)
            obj.targetBoardID = obj.BID_BROADCAST;
            fprintf('Target set to Broadcast mode\n');
        end
        
        function setTargetModule(obj, moduleID)
            % SETTARGETMODULE Set target to module-only mode
            %   All boards in the specified module
            obj.targetModuleID = moduleID;
            obj.targetBoardID = obj.BID_MODULE_ONLY;
            fprintf('Target set to Module %d (all boards)\n', moduleID);
        end
        
        %% ================================================================
        %% MCU Commands (processed locally by STM32, tail = 0x0A 0x0D)
        %% ================================================================
        
        function mcu_setDevMode(obj, enable)
            % MCU_SETDEVMODE Enable or disable developer mode
            %   mcu_setDevMode(true)  - Enable DEV_MODE (TR switch controlled by SPI)
            %   mcu_setDevMode(false) - Disable DEV_MODE (TR switch controlled by external pins)
            
            if islogical(enable) || isnumeric(enable)
                stateVal = uint8(logical(enable));
            else
                error('Enable must be true/false or 1/0');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = obj.MCU_CMD_DEV_MODE;
            
            data = [byte2; byte3; 0; stateVal];
            obj.sendCommandMCU(data);
            obj.readResponse();
        end
        
        function mcu_reInitFromEEPROM(obj)
            % MCU_REINITFROMEEPROM Re-read init values from EEPROM and send to FPGA
            %   STM32 reads ID, phase, and attenuation info from EEPROM,
            %   then sends them to FPGA.
            
            byte2 = obj.getTargetByte();
            byte3 = obj.MCU_CMD_REINIT;
            
            data = [byte2; byte3; 0; 0];
            obj.sendCommandMCU(data);
            obj.readResponse();
        end
        
        function result = mcu_readBoardID(obj)
            % MCU_READBOARDID Read Module_ID and Board_ID from EEPROM
            %   Returns the board ID as hex string
            
            byte2 = obj.getTargetByte();
            select = 0;  % Select=0 for ID
            byte3 = bitor(bitshift(select, 4), obj.MCU_CMD_READ_INIT);
            
            data = [byte2; byte3; 0; 0];
            obj.sendCommandMCU(data);
            result = obj.readResponse();
        end
        
        function result = mcu_readInitPhase(obj, txrx)
            % MCU_READINITPHASE Read initial phase values from EEPROM
            %   mcu_readInitPhase('tx') - Read TX initial phases (8 channels)
            %   mcu_readInitPhase('rx') - Read RX initial phases (8 channels)
            
            if strcmpi(txrx, 'tx')
                select = 1;
            elseif strcmpi(txrx, 'rx')
                select = 2;
            else
                error('txrx must be ''tx'' or ''rx''');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(select, 4), obj.MCU_CMD_READ_INIT);
            
            data = [byte2; byte3; 0; 0];
            obj.sendCommandMCU(data);
            result = obj.readResponse();
        end
        
        function result = mcu_readInitAtten(obj, txrx)
            % MCU_READINITATTEN Read initial attenuation values from EEPROM
            %   mcu_readInitAtten('tx') - Read TX initial attenuations (8 channels)
            %   mcu_readInitAtten('rx') - Read RX initial attenuations (8 channels)
            
            if strcmpi(txrx, 'tx')
                select = 3;
            elseif strcmpi(txrx, 'rx')
                select = 4;
            else
                error('txrx must be ''tx'' or ''rx''');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(select, 4), obj.MCU_CMD_READ_INIT);
            
            data = [byte2; byte3; 0; 0];
            obj.sendCommandMCU(data);
            result = obj.readResponse();
        end
        
        function mcu_writeBoardID(obj, generalBID)
            % MCU_WRITEBOARDID Write Module_ID and Board_ID to EEPROM
            %   mcu_writeBoardID(generalBID)
            %   generalBID: 8-bit value where upper 4 bits = Module_ID, lower 4 bits = Board_ID
            %   Example: mcu_writeBoardID(0x12) sets Module_ID=1, Board_ID=2
            
            if generalBID < 0 || generalBID > 255
                error('generalBID must be 0-255');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = obj.MCU_CMD_WRITE_BID;
            
            data = [byte2; byte3; 0; uint8(generalBID)];
            obj.sendCommandMCU(data);
            obj.readResponse();
        end
        
        function mcu_writeInitPhase(obj, chipID, channelID, phase)
            % MCU_WRITEINITPHASE Write initial phase value to EEPROM
            %   mcu_writeInitPhase(chipID, channelID, phase)
            %   chipID: 0-7 (0-3 for TX, 4-7 for RX)
            %   channelID: 0 or 1
            %   phase: 0-255 phase code
            
            if chipID < 0 || chipID > 7
                error('chipID must be 0-7');
            end
            if channelID < 0 || channelID > 1
                error('channelID must be 0 or 1');
            end
            if phase < 0 || phase > 255
                error('phase must be 0-255');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(chipID, 4), obj.MCU_CMD_WRITE_PHASE);
            byte4 = uint8(channelID);
            
            data = [byte2; byte3; byte4; uint8(phase)];
            obj.sendCommandMCU(data);
            obj.readResponse();
        end
        
        function mcu_writeInitAtten(obj, chipID, channelID, atten)
            % MCU_WRITEINITTATTEN Write initial attenuation value to EEPROM
            %   mcu_writeInitAtten(chipID, channelID, atten)
            %   chipID: 0-7 (0-3 for TX, 4-7 for RX)
            %   channelID: 0 or 1
            %   atten: 0-127 attenuation code (7-bit)
            
            if chipID < 0 || chipID > 7
                error('chipID must be 0-7');
            end
            if channelID < 0 || channelID > 1
                error('channelID must be 0 or 1');
            end
            if atten < 0 || atten > 127
                error('atten must be 0-127');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(chipID, 4), obj.MCU_CMD_WRITE_ATTEN);
            byte4 = uint8(channelID);
            
            data = [byte2; byte3; byte4; uint8(atten)];
            obj.sendCommandMCU(data);
            obj.readResponse();
        end
        
        %% ================================================================
        %% FPGA Commands (forwarded to FPGA via SPI, tail = 0x0D 0x0A)
        %% ================================================================
        
        function fpga_setBeamAngle(obj, azimuth, pitch)
            % FPGA_SETBEAMANGLE Set beam pointing angles
            %   azimuth: double, quantize to -90° to 89.296875°
            %   pitch: double, quantize to -90° to 89.296875°
            %   0 = normal to array face, negative = towards element #0
            

            if azimuth < -90 || azimuth > 90
                error('Azimuth must be -90 to 90');
            end
            if pitch < -90 || pitch > 90
                error('Pitch must be -90 to 90');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = obj.CMD_PHASE_ARRAY_CAL;
            byte4 = uint8(typecast(int8(azimuth./90*128), 'uint8'));
            byte5 = uint8(typecast(int8(pitch./90*128), 'uint8'));
            
            data = [byte2; byte3; byte4; byte5]
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_init(obj)
            % FPGA_INIT Initialize all channels
            %   Reloads BF registers with initial phases, clears AC registers,
            %   loads initial attenuations to DSA, and triggers LP pulse.
            
            byte2 = obj.getTargetByte();
            byte3 = obj.CMD_INIT;
            
            data = [byte2; byte3; 0; 0];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_writePhase(obj, PS_Chip_ID, channelID, regType, phase)
            % FPGA_WRITEPHASE Write phase value to PE44951 phase shifter
            %   fpga_writePhase(chipID, channelID, regType, phase)
            %   chipID: 0-7 (individual), 8 (all), 9 (TX 0-3), 10 (RX 4-7)
            %   channelID: 0 or 1
            %   regType: 'BF' (base) or 'AC' (accumulator)
            %   phase: 0-255 phase code
            
            if PS_Chip_ID < 0 || PS_Chip_ID > 10
                error('chipID must be 0-10');
            end
            if channelID < 0 || channelID > 1
                error('channelID must be 0 or 1');
            end
            if phase < 0 || phase > 255
                error('phase must be 0-255');
            end
            
            if strcmpi(regType, 'BF')
                phaseReg = 0;
            elseif strcmpi(regType, 'AC')
                phaseReg = 1;
            else
                error('regType must be ''BF'' or ''AC''');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(PS_Chip_ID, 4), obj.CMD_WRITE_PHASE);
            byte4 = bitor(bitshift(phaseReg, 1), channelID);
            
            data = [byte2; byte3; byte4; uint8(phase)];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_writeAtten(obj, PS_Chip_ID, channelID, atten)
            %   Write 8-bit DSA attenuation value to PE44951
            %   fpga_writeAtten(chipID, channelID, atten)
            %   chipID: 0-7 (individual), 8 (all), 9 (TX 0-3), 10 (RX 4-7)
            %   channelID: 0 or 1
            %   atten: 0-255 attenuation code (8-bit)
            
            if PS_Chip_ID < 0 || PS_Chip_ID > 10
                error('chipID must be 0-10');
            end
            if channelID < 0 || channelID > 1
                error('channelID must be 0 or 1');
            end
            if atten < 0 || atten > 255
                error('atten must be 0-255');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(PS_Chip_ID, 4), obj.CMD_WRITE_ATTEN);
            byte4 = uint8(channelID);
            
            data = [byte2; byte3; byte4; uint8(atten)];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_switchTXRX(obj, FEM_Chip_ID, mode)
            % FPGA_SWITCHTXRX Control FEM TX/RX switches (requires DEV_MODE)
            %   fpga_switchTXRX(femChipID, mode)
            %   femChipID: 0-7 (individual FEM), 8 (all FEMs)
            %   mode: 'tx', 'rx', or 'off'
            
            if FEM_Chip_ID < 0 || FEM_Chip_ID > 8
                error('femChipID must be 0-8');
            end
            
            if strcmpi(mode, 'tx')
                txOn = 1;
                rxOn = 0;
            elseif strcmpi(mode, 'rx')
                txOn = 0;
                rxOn = 1;
            elseif strcmpi(mode, 'off')
                txOn = 0;
                rxOn = 0;
            else
                error('mode must be ''tx'', ''rx'', or ''off''');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(FEM_Chip_ID, 4), obj.CMD_SWITCH_TXRX);
            byte4 = bitor(bitshift(txOn, 1), rxOn);
            
            data = [byte2; byte3; byte4; 0];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_updatePhase(obj)
            % FPGA_UPDATEPHASE Send LP pulse to update phase shifter outputs
            %   Triggers a Latch Phase pulse to transfer register values to outputs.
            
            byte2 = obj.getTargetByte();
            byte3 = obj.CMD_UPDATE_PHASE;
            
            data = [byte2; byte3; 0; 0];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_powerDown(obj)
            % FPGA_POWERDOWN Power down all channels
            %   Turns off all TX and RX channels.
            
            byte2 = obj.getTargetByte();
            byte3 = obj.CMD_POWER_DOWN;
            
            data = [byte2; byte3; 0; 0];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_setBoardID(obj, generalBID)
            % FPGA_SETBOARDID Set FPGA's local Board_ID
            %   fpga_setBoardID(generalBID)
            %   generalBID: 8-bit value (upper 4 bits = Module_ID, lower 4 bits = Board_ID)
            
            if generalBID < 0 || generalBID > 255
                error('generalBID must be 0-255');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = obj.CMD_RECV_BOARD_ID;
            
            data = [byte2; byte3; 0; uint8(generalBID)];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_sendInitPhase(obj, chipID, channelID, phase)
            % FPGA_SENDINITPHASE Send initial phase value to FPGA
            %   fpga_sendInitPhase(chipID, channelID, phase)
            %   chipID: 0-7 (individual), 8 (all), 9 (TX 0-3), 10 (RX 4-7)
            %   channelID: 0 or 1
            %   phase: 0-255 phase code
            
            if chipID < 0 || chipID > 10
                error('chipID must be 0-10');
            end
            if channelID < 0 || channelID > 1
                error('channelID must be 0 or 1');
            end
            if phase < 0 || phase > 255
                error('phase must be 0-255');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(chipID, 4), obj.CMD_RECV_PHASE_INIT);
            byte4 = uint8(channelID);
            
            data = [byte2; byte3; byte4; uint8(phase)];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_sendInitAtten(obj, chipID, channelID, atten)
            % FPGA_SENDINITATTEN Send initial attenuation value to FPGA
            %   fpga_sendInitAtten(chipID, channelID, atten)
            %   chipID: 0-7 (individual), 8 (all), 9 (TX 0-3), 10 (RX 4-7)
            %   channelID: 0 or 1
            %   atten: 0-127 attenuation code (7-bit)
            
            if chipID < 0 || chipID > 10
                error('chipID must be 0-10');
            end
            if channelID < 0 || channelID > 1
                error('channelID must be 0 or 1');
            end
            if atten < 0 || atten > 127
                error('atten must be 0-127');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(chipID, 4), obj.CMD_RECV_ATTEN_INIT);
            byte4 = uint8(channelID);
            
            data = [byte2; byte3; byte4; uint8(atten)];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end
        
        function fpga_writeIFDSA(obj, ifdsaID, atten, loadNow)
            % FPGA_WRITEIFDSA Write IF DSA (Digital Step Attenuator) value
            %   fpga_writeIFDSA(ifdsaID, atten, loadNow)
            %   ifdsaID: 0 (TX), 1 (RX), 2 (both)
            %   atten: 0-63 attenuation code (6-bit)
            %   loadNow: true to immediately load to hardware, false to just store
            
            if ifdsaID < 0 || ifdsaID > 2
                error('ifdsaID must be 0-2 (0=TX, 1=RX, 2=both)');
            end
            if atten < 0 || atten > 63
                error('atten must be 0-63');
            end
            if islogical(loadNow) || isnumeric(loadNow)
                loadVal = uint8(logical(loadNow));
            else
                error('loadNow must be true/false or 1/0');
            end
            
            byte2 = obj.getTargetByte();
            byte3 = bitor(bitshift(ifdsaID, 4), obj.CMD_WRITE_IFDSA);
            byte4 = uint8(loadVal);
            
            data = [byte2; byte3; byte4; uint8(atten)];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end

        function fpga_beamscan_cfg(obj, azimuth_list, pitch_list, mode)
            % FPGA_BEAMSCAN_CFG config beamscan state machines on SubArray
            %   azimuth_list: N_dir x 1 vector of azimuth angles in sequence of beamscan
            %   pitch_list: N_dir x 1 vector of pitch angles in sequence of beamscan
            %   mode: 'tx', 'rx', or 'both'. 

            num_dir = length(azimuth_list);
            if num_dir ~= length(pitch_list)
                error('Size miss match between azimuth and pitch angles');
            end

            if strcmpi(mode, 'tx')
                byte5 = uint8(hex2dec('0x00'));
            elseif strcmpi(mode, 'rx')
                byte5 = uint8(hex2dec('0x10'));
            elseif strcmpi(mode, 'both')
                byte5 = uint8(hex2dec('0x20'));
            else
                error('mode must be ''tx'', ''rx'', or ''both''');
            end

            byte2 = obj.getTargetByte();
            byte3 = obj.CMD_BEAM_SCAN_CONFIG;
            byte4 = num_dir;

            data = [byte2; byte3; byte4; byte5];
            obj.sendCommandFPGA(data);
            obj.readResponse();


            % convert angles to int8 values (-90deg~89.296875deg => -128~127 or 0x80~0x7F)
            azi = int8(azimuth_list./90*128);
            pit = int8(pitch_list./90*128);

            for idx = 0:num_dir-1
                byte3 = bitor(bitshift(idx, 4), obj.CMD_BEAM_SCAN_ADD_DIR);
                byte4 = uint8(typecast(int8(azi(idx+1)), 'uint8'));
                byte5 = uint8(typecast(int8(pit(idx+1)), 'uint8'));
                data = [byte2; byte3; byte4; byte5]
                obj.sendCommandFPGA(data);
                obj.readResponse();
            end

            % arm once
            byte3 = obj.CMD_BEAM_SCAN_ARM;
            byte4 = 0;
            byte5 = 0;
            data = [byte2; byte3; byte4; byte5];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end

        function fpga_beamscan_disarm(obj)
            % FPGA_BEAMSCAN_DISARM reset beamscan state machines on SubArray

            % disarm
            byte2 = obj.getTargetByte();
            byte3 = obj.CMD_BEAM_SCAN_DISARM;
            byte4 = 0;
            byte5 = 0;
            data = [byte2; byte3; byte4; byte5];
            obj.sendCommandFPGA(data);
            obj.readResponse();
        end

        %% ================================================================
        %% Convenience Methods
        %% ================================================================
        
        function setAllChannelsPhase(obj, phase)
            % SETALLCHANNELSPHASE Set all channels to the same phase
            %   setAllChannelsPhase(phase) - Set all 16 channels to same phase
            
            obj.fpga_writePhase(8, 0, 'AC', phase);  % chipID=8 selects all
        end
        
        function setAllChannelsAtten(obj, atten)
            % SETALLCHANNELSATTEN Set all channels to the same attenuation
            %   setAllChannelsAtten(atten) - Set all 16 channels to same atten
            
            obj.fpga_writeAtten(8, 0, atten);  % chipID=8 selects all
        end
        
        function txOn(obj, femChipID)
            % TXON Turn on TX for specified FEM chip(s)
            %   txOn(femChipID) - Turn on TX (0-7 individual, 8 for all)
            obj.fpga_switchTXRX(femChipID, 'tx');
        end
        
        function rxOn(obj, femChipID)
            % RXON Turn on RX for specified FEM chip(s)
            %   rxOn(femChipID) - Turn on RX (0-7 individual, 8 for all)
            obj.fpga_switchTXRX(femChipID, 'rx');
        end
        
        function allOff(obj)
            % ALLOFF Turn off all TX and RX channels
            obj.fpga_powerDown();
        end
        
        %% ================================================================
        %% Low-level Command Sending
        %% ================================================================
        
        function sendCommandFPGA(obj, data)
            % SENDCOMMANDFPGA Send command to be forwarded to FPGA
            %   Internal method - sends 8-byte packet with FPGA tail (0x0D 0x0A)
            
            if ~obj.isConnected
                error('Not connected to serial port');
            end
            
            if length(data) ~= 4
                error('Data must be 4 bytes');
            end
            
            % Build complete 8-byte frame with FPGA tail
            frame = uint8([obj.Header; data(:); obj.Tail_FPGA]);
            
            % Send via serial port
            write(obj.serialObj, frame, "uint8");
        end
        
        function sendCommandMCU(obj, data)
            % SENDCOMMANDMCU Send command to be processed locally by MCU
            %   Internal method - sends 8-byte packet with MCU tail (0x0A 0x0D)
            
            if ~obj.isConnected
                error('Not connected to serial port');
            end
            
            if length(data) ~= 4
                error('Data must be 4 bytes');
            end
            
            % Build complete 8-byte frame with MCU tail
            frame = uint8([obj.Header; data(:); obj.Tail_MCU]);
            
            % Send via serial port
            write(obj.serialObj, frame, "uint8");
        end
        
        function response = readResponse(obj, timeout)
            % READRESPONSE Read text response from STM32
            %   response = readResponse() - Read with 1s timeout
            %   response = readResponse(timeout) - Read with specified timeout
            
            if nargin < 2
                timeout = 0.1;
            end
            
            if ~obj.isConnected
                error('Not connected to serial port');
            end
            
            response = '';
            tic;
            while toc < timeout
                if obj.serialObj.NumBytesAvailable > 0
                    response = [response, char(read(obj.serialObj, ...
                                obj.serialObj.NumBytesAvailable, "uint8"))]; %#ok<AGROW>
                end
                pause(0.01);
            end
            
            if ~isempty(response)
                fprintf('Response: %s', response);
            end
        end
        
        %% ================================================================
        %% Helper Methods
        %% ================================================================
        
        function byte = getTargetByte(obj)
            % GETTARGETBYTE Get the combined Module_ID and Board_ID byte
            %   Returns: (Module_ID << 4) | Board_ID
            byte = uint8(bitor(bitshift(obj.targetModuleID, 4), obj.targetBoardID));
        end
        
        %% Destructor
        function delete(obj)
            % DELETE Clean up serial port on object deletion
            obj.disconnect();
        end
    end
end