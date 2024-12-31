function hub = open_serial_hub(BaudRate, HReadFcn)
%OPEN_SERIAL_HUB Open multiple USB-SERIAL CH340 devices and return as a struct
%   hub = open_serial_hub(BaudRate, HReadFcn)
%
%   This function identifies all the USB-SERIAL CH340 devices connected to
%   the computer using IdentifySerialComs(), and opens each one using
%   OpenSerial with the specified BaudRate and HReadFcn.
%
%   The returned "hub" is a struct containing the opened serial objects.
%   Each serial object can be accessed using the port number as the field
%   name, e.g. hub.com9, hub.com10 etc.
%
%   BaudRate: The baud rate to use for the serial communication
%   HReadFcn: The read callback function handle for receiving data
%
%   Example:
%     hub = open_serial_hub(9600, @ReadFcn_Com);
%     hub.com9  % access the serial object for COM9
%     hub.com10 % access the serial object for COM10

tic
devices = IdentifySerialComs();
toc
hub = struct(); % initialize output struct
for i = 1:size(devices,1)
    if strcmp(devices{i,1}, 'USB-SERIAL CH340')
        % Found a CH340 device, open it
        comstr = sprintf('com%d',devices{i,2});
        scom = OpenSerial(comstr, BaudRate, HReadFcn);
        
        % Add to struct using fieldname
        fieldname = matlab.lang.makeValidName(comstr); 
        hub.(fieldname) = scom;        
    end
end
end