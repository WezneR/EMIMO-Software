function serial_hub_write(hub, byte_array)
%SERIAL_HUB_WRITE Write byte array to all serial ports in the given hub
%   serial_hub_write(hub, byte_array)
%
%   This function writes the given byte_array to all the serial port
%   objects contained in the "hub" struct. The byte_array is written
%   to each serial port using the fwrite function.
%
%   hub: A struct containing serial port objects, typically created
%        using the open_serial_hub function.
%   byte_array: The array of bytes to write to each serial port. This
%               should be a numeric array.
%
%   Example:
%     hub = open_serial_hub(9600, @ReadFcn_Com);
%     init_array = hex2dec(['54';'4D';'3A'; ...
%       'AA';'BB';'CC';'DD';'EE';'FF'; ...
%       '0D';'0A']);
%     serial_hub_write(hub, init_array);



% Get all the field names in the hub struct
port_names = fieldnames(hub);
% Iterate over each port
for i = 1:numel(port_names)
    % Get the serial object for this port
    scom = hub.(port_names{i});
    
    % Write the byte array to this serial port
    fwrite(scom, byte_array);
end
end