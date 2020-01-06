import visa
import time
import qontrol
import os
import sys
from multiprocessing import Process

#open connection to keysight and control
#serial_port_name2 = "COM6"
#q = qontrol.QXOutput(serial_port_name=serial_port_name2, response_timeout=1)
#rm = visa.ResourceManager()
#resource = rm.list_resources()
#keysight = rm.open_resource('USB0::0x0957::0x3718::SG48101090::INSTR', read_termination='\n')

def keysight_record():
    rm = visa.ResourceManager()
    resource = rm.list_resources()
    keysight = rm.open_resource('USB0::0x0957::0x3718::SG48101090::INSTR', read_termination='\n')
    timeout = time.time() + 60 * 1
    while True:
        test = 0
        if test == 1 or time.time () > timeout:
            break
        test = test - 1
        keysight.write(":INITiate:CHANnel:CONTinuous 1")
        query_info = keysight.query(":FETCh:CHANnel:SCALar:POWer:ALL:CSV?")
        with open ("lc.txt", 'a') as output:
            output.write(query_info + "\n")
        time.sleep(.1)
    keysight.close()

def increment_voltage():
    serial_port_name2 = "COM6"
    q = qontrol.QXOutput(serial_port_name=serial_port_name2, response_timeout=0.1)
    for channel in range(4,10):
        set_voltage = 0
        limit = 6
        while set_voltage < limit:
            set_voltage += .01
            q.v[channel] = set_voltage
            measured_voltage = q.v[channel]
            print(measured_voltage)
            time.sleep(1)
    

if __name__ == '__main__':
    #p1 = Process(target = increment_voltage)
    #p1.start()
    p2 = Process(target = keysight_record)
    p2.start()


