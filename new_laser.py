import visa
import time
import re

rm = visa.ResourceManager()
venturi = rm.open_resource('GPIB0::4::INSTR', read_termination='\n')
keysight = rm.open_resource('USB0::0X0957::0X3718::MY48102366::INSTR', read_termination='\n')

start_wavelength = 1520
stop_wavelength = 1560


for wave in range(start_wavelength, stop_wavelength, .1):
    try:
        venturi.write("*RST")
        venturi.write(":SOURce:CHANnel:WAVelength:FIXed" wave "NM")
        venturi.write(":INIT")
        venturi.write("*:TRIG")
    except Exception as ex:
        print ex
        raw_input()

def mySweepLogger():
    keysight.write(":TRIGger:CHANnel:INPut MMeasure") 
    keysight.write(":INITiate:CHANnel:IMMediate")
    keysight.write(":SENS:POW:UNIT 1")
    query_info = keysight.query(":FETCh:CHANnel:SCALar:POWer:ALL:CSV?")
    with open ("k_to_v_test1.txt", 'a') as output:
        output.write(query_info + "\n")

venturi.close()
keysight.close()

