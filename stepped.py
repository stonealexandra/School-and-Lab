import visa
import time
import re

rm = visa.ResourceManager()
laser = rm.open_resource('GPIB0::20::INSTR', read_termination='\n')
keysight = rm.open_resource('USB0::0X0957::0X3718::MY48102366::INSTR', read_termination='\n')

def mySweepLogger():
    keysight.write(":TRIGger:CHANnel:INPut SMEasure")
    keysight.write(":INITiate:CHANnel:IMMediate")
    keysight.write(":SENS:POW:UNIT 1")
    query_info = keysight.query(":FETCh:CHANnel:SCALar:POWer:ALL:CSV?")
    with open("step_run1.txt", 'a') as output:
        output.write(query_info + "\n")

def wavelength_query():
    query_wave = laser.query(":CONFigure:WAVelength:VALue:WAVelength?")
    with open("laser_query.txt", 'a') as output:
        output.write(laser_query + "\n")
try:
    laser.write("*RST")
    laser.write(":SOURce:CHANnel:WAVelength:SWEep:MODE STEP")
    laser.write(":SOURce:CHANnel:WAVelength:SWEep:STARt 1520")
    laser.write(":SOURce:CHANnel:WAVelength:SWEep:STOP 1560")
    laser.write(":SOURce:CHANnel:WAVelength:SWEep:STEP .05NM")
    laser.write(":TRIGger:CHANnel:OUTPut STFinished")
    laser.write(":INIT")
    laser.write("*:TRIG")
    mySweepLogger()
except Exception as ex:
    print ex
    raw_input()

laser.close()
keysight.close()

