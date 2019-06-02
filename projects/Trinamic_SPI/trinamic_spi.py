# HAL file for Trinamic SPI configuration
import os
from machinekit import hal
from machinekit import rtapi as rt
from machinekit import config as c
#from fdm.config import motion
from fdm_local.config import motion
from fdm.config import base
import cramps as hardware

# initialize the RTAPI command client
rt.init_RTAPI()
# loads the ini file passed by linuxcnc
c.load_ini(os.environ['INI_FILE_NAME'])

motion.setup_motion()

# reading functions
hardware.hardware_read()
hal.addf('motion-command-handler', 'servo-thread')


# Axis-of-motion Specific Configs (not the GUI)

# X [0] Axis
base.setup_stepper(section='AXIS_0', axisIndex=0, stepgenIndex=0, stepgenType='hm2_5i25.0.stepgen')

# Standard I/O - EStop, Enables, Limit Switches, Etc
#errorSignals = ['watchdog-error']
errorSignals = []
#for i in range(0, numExtruders):
#    errorSignals.append('e%i-error' % i)
#base.setup_estop(errorSignals, thread='servo-thread')
base.setup_estop(errorSignals, thread='servo-thread')
base.setup_tool_loopback()
# Probe
#base.setup_probe(thread='servo-thread')
# Setup Hardware
hardware.setup_hardware(thread='servo-thread')

# write out functions
hal.addf('motion-controller', 'servo-thread')
hardware.hardware_write()


rt.loadrt('trinamic_dbspi', dbspi_chans='hm2_5i25.0.dbspi.0')
#i2c_dbspi = hal.Component('i2c_dbspi.0')
#sgval = hal.newsig('sg-val-signed', hal.HAL_S32)
#i2c_dbspi.pin('sg.val').link(sgval)

# we need a thread to execute the component functions
#rt.newthread('main-thread', 1000000, fp=False)

# create the signal for connecting the components
input0 = hal.newsig('input0', hal.HAL_BIT)
input1 = hal.newsig('input1', hal.HAL_BIT)
output = hal.newsig('output', hal.HAL_BIT)

# and2 component
and2 = rt.newinst('and2', 'and2.demo')
and2.pin('in0').link(input0)
and2.pin('in1').link(input1)
and2.pin('out').link(output)
hal.addf(and2.name, 'servo-thread')

# create remote component
rcomp = hal.RemoteComponent('TrinamicSPI', timer=100)
rcomp.newpin('button0', hal.HAL_BIT, hal.HAL_OUT)
rcomp.newpin('button1', hal.HAL_BIT, hal.HAL_OUT)
rcomp.newpin('led', hal.HAL_BIT, hal.HAL_IN)
#rcomp.newpin('logChart', hal.HAL_S32, hal.HAL_IN)
rcomp.ready()

# link remote component pins
rcomp.pin('button0').link(input0)
rcomp.pin('button1').link(input1)
rcomp.pin('led').link(output)
#rcomp.pin('logChart').link(value)

# ready to start the threads
hal.start_threads()

# start haltalk server after everything is initialized
# else binding the remote components on the UI might fail
hal.loadusr('haltalk')
