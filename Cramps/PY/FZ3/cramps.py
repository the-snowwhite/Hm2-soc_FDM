from machinekit import hal
from machinekit import rtapi as rt
from machinekit import config as c

from fdm.config import base

import os
import sys


def hardware_read():
    hal.addf('hm2_fz3_.0.read', 'servo-thread')
    hal.addf('hm2_fz3_.0.read_gpio', 'servo-thread')


def hardware_write():
    hal.addf('hm2_fz3_.0.write', 'servo-thread')
    hal.addf('hm2_fz3_.0.write_gpio', 'servo-thread')


def init_hardware():
    watchList = []

    # Python user-mode HAL module to read ADC value and generate a thermostat output for PWM
    defaultThermistor = 'semitec_103GT_2'
    hal.loadusr('hal_temp_atlas',
                name='temp',

                filter_size=20,
                channels='00:%s,01:%s,02:%s,03:%s'
                % (c.find('HBP', 'THERMISTOR', defaultThermistor),
                   c.find('EXTRUDER_0', 'THERMISTOR', defaultThermistor),
                   c.find('EXTRUDER_1', 'THERMISTOR', defaultThermistor),
                   c.find('EXTRUDER_2', 'THERMISTOR', defaultThermistor)),
                wait_name='temp')
    watchList.append(['temp', 0.1])

    base.usrcomp_status('temp', 'temp-hw', thread='servo-thread')
    base.usrcomp_watchdog(watchList, 'estop-reset', thread='servo-thread',
                          errorSignal='watchdog-error')


def setup_hardware(thread):
    # Spindle
    spindlespeed = hal.newsig('spindle-speed', hal.HAL_FLOAT)
    spindleon = hal.newsig('spindle-on', hal.HAL_BIT)
    spindlespeeddiv = hal.newsig('spindle-speed-20', hal.HAL_FLOAT)
    spindlepwmspeed = hal.newsig('spindle-pwm-speed', hal.HAL_FLOAT)
    spindlepwmspeedlimited = hal.newsig('spindle-pwm-speed-limited', hal.HAL_FLOAT)

    spindlespeed.link('spindle.0.speed-out')
    spindleon.link('spindle.0.on')
    os.system('halcmd setp hm2_fz3_.0.gpio.031.is_output true')
    hal.Pin('hm2_fz3_.0.gpio.031.out').link(spindleon)

    hal.Pin('hm2_fz3_.0.pwmgen.00.enable').link(spindleon)

    div2 = rt.newinst('div2', 'div2.spindlespeed-divfac')
    hal.addf(div2.name, 'servo-thread')
    div2.pin('in0').link(spindlespeed)
    div2.pin('in1').set(c.find('SPINDLE', 'DIVFACTOR'))
    div2.pin('out').link(spindlespeeddiv)

    sum2 = rt.newinst('sum2', 'sum2.spindle-speed-add')
    hal.addf(sum2.name, 'servo-thread')
    sum2.pin('in0').set(c.find('SPINDLE', 'ADDFACTOR'))
    sum2.pin('in1').link(spindlespeeddiv)
    sum2.pin('out').link(spindlepwmspeed)

    hal.Pin('hm2_fz3_.0.pwmgen.00.value').link(spindlepwmspeed)
    os.system('halcmd setp hm2_fz3_.0.gpio.018.invert_output true')
    os.system("halcmd setp hm2_fz3_.0.pwmgen.00.scale %s "%(c.find('SPINDLE', 'MAXRPM')))

    # GPIO
    # Adjust as needed for your switch polarity
    hal.Pin('hm2_fz3_.0.gpio.024.in_not').link('limit-0-home')   # X
    hal.Pin('hm2_fz3_.0.gpio.025.in').link('limit-1-0-home')    # YL
    hal.Pin('hm2_fz3_.0.gpio.026.in').link('limit-1-1-home')    # YR
    hal.Pin('hm2_fz3_.0.gpio.027.in_not').link('limit-2-home')    # Z

    # probe ... 74CBTD3861

#    hal.Pin('hm2_fz3_.0.capsense.00.trigged').link('probe-signal')  #
#    os.system('halcmd setp hm2_fz3_.0.capsense.00.hysteresis 0x44444444')
##    hm2_fz3_.0.pin('capsense.00.hysteresis').set(c.find('PROBE', 'HYSTERESIS'))
##    hm2_fz3_.0.pin('hysteresis').set(c.find('PROBE', 'HYSTERESIS'))
##    hm2_fz3_.0.pin('hysteresis').set(17476)
##    hal.pin('hm2_fz3_.0.capsense.00.hysteresis').set(1000))

    # machine power
    os.system('halcmd setp hm2_fz3_.0.gpio.020.is_output true')
    hal.Pin('hm2_fz3_.0.gpio.020.out').link('emcmot-0-enable')

    # Monitor estop input from hardware
    hal.Pin('hm2_fz3_.0.gpio.021.in_not').link('estop-in')
    # drive estop-sw
    os.system('halcmd setp hm2_fz3_.0.gpio.022.is_output true')
    os.system('halcmd setp hm2_fz3_.0.gpio.022.invert_output true')
    hal.Pin('hm2_fz3_.0.gpio.022.out').link('estop-out')

    # Tie machine power signal to the Parport Cape LED
    # Feel free to tie any other signal you like to the LED
    os.system('halcmd setp hm2_fz3_.0.gpio.018.is_output true')
    hal.Pin('hm2_fz3_.0.gpio.018.out').link('emcmot-0-enable')

    # link emcmot.xx.enable to stepper driver enable signals
    os.system('halcmd setp hm2_fz3_.0.gpio.019.is_output true')
    os.system('halcmd setp hm2_fz3_.0.gpio.019.invert_output true')
    hal.Pin('hm2_fz3_.0.gpio.019.out').link('emcmot-0-enable')

def setup_exp(name):
    hal.newsig('%s-pwm' % name, hal.HAL_FLOAT, init=0.0)
    hal.newsig('%s-enable' % name, hal.HAL_BIT, init=False)
