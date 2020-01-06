import qontrol
import time

#open connection to qontrol and keysight
serial_port_name2 = "COM6"
q = qontrol.QXOutput(serial_port_name=serial_port_name2, response_timeout=0.1)

q.v[:] = 0

def increment_voltage():
    for channel in range(4,10):
        set_voltage = 0
        limit = 6
        while set_voltage < limit:
            set_voltage += .01
            q.v[channel] = set_voltage
            measured_voltage = q.v[channel]
            print(measured_voltage)
            time.sleep(10.31)

for i in range(1):
    increment_voltage()

q.v[:] = 0
q.close()

