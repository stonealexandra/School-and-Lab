import visa
import time
from apscheduler.schedulers.background import BackgroundScheduler

rm = visa.ResourceManager()
resource = rm.list_resources()
keysight = rm.open_resource('USB0::0x0957::0x3718::SG48101090::INSTR', read_termination='\n')

timeout = time.time() + 60*100

while True:
    #set refresh_interval to execute loop every n second
    test = 0
    if test == 1 or time.time() > timeout:
        break
    test = test - 1
    
    scheduler = BackgroundScheduler()
    scheduler.start()

    def main():
        #call function
        mySweepLogger()
        scheduler.add_job(mySweepLogger, 'interval', seconds = .1)
        while True:
            time.sleep(.1)

    def mySweepLogger():
        keysight.write(":INITiate:CHANnel:CONTinuous 1")
        query_info = keysight.query(":FETCh:CHANnel:SCALar:POWer:ALL:CSV?")
        with open ("switch_arms2.txt", 'a') as output:
            output.write(query_info + "\n")

    if __name__ == "__main__":
        main()

keysight.close()

