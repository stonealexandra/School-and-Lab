'''
Created on May 2, 2019

@author: user
'''

import sys
import math
import time
import keysight.command_expert_py3 as kt

TLSaddr = "GPIB0::20::INSTR"
PMslot = "1"
TLSslot = "0"
start = "1.525E-6"
stop = "1.565E-6"
step = "5E-12"
speed = "40E-9"
TLSpower = "8"
path = "lows"
PMrange = "10"
PMavg = "100E-6"
exppoints = "8001"

# =========================================================

[sweepcheck, pmax, exptrig] = kt.run_sequence ('ConfigureTLS.iseq', [TLSaddr], \
 [TLSslot, path, start, stop, step, speed])

if sweepcheck[0] == "0":
    pass
else:
    print(sweepcheck)
    sys.exit()
    
SWPpower = 10 * math.log10(1000 * pmax)
if SWPpower < float(TLSpower):
    TLSpower = str(SWPpower)

kt.run_sequence ('TLSpower.iseq', [TLSaddr], [TLSslot, TLSpower])

exppoints = str(exptrig)
    
kt.run_sequence ('ConfigurePM.iseq', [PMaddr], [PMslot, PMrange, exppoints, \
 PMavg]) 
# sweeps can be repeated from this point
kt.run_sequence ('EnableSweep.iseq', [TLSaddr, PMaddr], [TLSslot, PMslot])

qf = kt.Sequence('FlagQuery.iseq')
tlsFlag = 0
while tlsFlag == 0:
    [flag] = qf.run_sequence ([TLSaddr], [TLSslot])
    tlsFlag = int(flag)
kt.run_sequence ('SoftTrigger.iseq', [TLSaddr], [TLSslot])    

estSweepTime = (float(stop) - float(start)) / float(speed)
time.sleep(estSweepTime)

ql = kt.Sequence('LoggingQuery.iseq')
loggingStatus = "PROGRESS"
while loggingStatus == "PROGRESS":
    [loggingStatus] = ql.run_sequence([PMaddr], [PMslot])
    time.sleep(0.1)
[powerdata] = kt.run_sequence ('LoggingResult.iseq', [PMaddr], [PMslot])

[flag] = qf.run_sequence ([TLSaddr], [TLSslot])
tlsFlag2 = int(flag)
while tlsFlag == tlsFlag2:
    [flag] = qf.run_sequence ([TLSaddr], [TLSslot])
    tlsFlag2 = int(flag)
    time.sleep(0.1)
[wavelengthdata] = kt.run_sequence ('LambdaResult.iseq', [TLSaddr], [TLSslot])    

# Open file for output.
strPath = "lambdascan.csv"
f = open(strPath, "w")
# Output  in CSV format.
for i in range(int(exppoints)):
    f.write("%9.7E, %E\n" % (wavelengthdata[i], powerdata[i]))
# Close output file.    
f.close()
