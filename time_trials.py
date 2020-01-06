import visa
import time
import re
import matplotlib.pyplot as plt
import numpy as np

rm = visa.ResourceManager() 
keithley = rm.open_resource('ASRL4::INSTR', read_termination='\r')
timeout = time.time() + 60*7

while True:
    test = 0
    if test == 1 or time.time() > timeout:
        break
    test = test - 1
    keithley.write("*RST")
    keithley.write(":SENS:VOLT:DC:NPLC 1")
    keithley.write(":TRIG:SOUR BUS")
    keithley.write(":TRIG:DEL 0")
    keithley.write(":TRIG:COUN 1")
    keithley.write(":SAMP:COUN 1")
    keithley.write(":INIT")
    keithley.write(":*TRG")
    mv = keithley.query(":FETC?")
    with open('ch7_testing18.txt' , 'a') as output:
        output.write(mv + "\n")
        
keithley.close()

with open('ch7_testing18.txt', 'r') as input_text:
    lines = input_text.read()
regex = '[+](\d+[.]\d+)["E"]'
regexed = re.findall(regex, lines)
out_str= "\n".join(regexed)
with open('ch7_18.txt', 'a') as output:
    output.write(out_str)

data = np.loadtxt("ch7_18.txt")
plt.plot(data)
plt.ylabel('Voltage')
plt.show()
        
