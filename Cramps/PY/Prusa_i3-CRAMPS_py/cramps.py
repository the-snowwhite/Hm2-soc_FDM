from machinekit import hal
from machinekit import rtapi as rt
from machinekit import config as c
from fdm.config import base

import os
import sys


def hardware_read():
    hal.addf('hm2_5i25.0.read', 'servo-thread')
    hal.addf('hm2_5i25.0.read_gpio', 'servo-thread')


def hardware_write():
    hal.addf('hm2_5i25.0.write', 'servo-thread')
    hal.addf('hm2_5i25.0.write_gpio', 'servo-thread')


def init_hardware():
    watchList = []

    # Python user-mode HAL module to read ADC value and generate a thermostat output for PWM
    defaultThermistor = 'semitec_103GT_2'
    hal.loadusr('hal_temp_atlas',
                name='temp',
                filter_size=1,
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
    # PWM
    #hal.Pin('hm2_5i25.0.pwmgen.00.pwm_frequency').set(20000)  # 100Hz
    # HBP
    hal.Pin('hm2_5i25.0.pwmgen.00.enable').set(True)
    hal.Pin('hm2_5i25.0.pwmgen.00.value').link('hbp-temp-pwm')
    # configure extruders
    for n in range(0, 2):
        hal.Pin('hm2_5i25.0.pwmgen.%02i.enable' % (n + 1)).set(True)
        hal.Pin('hm2_5i25.0.pwmgen.%02i.value' % (n + 1)).link('e%i-temp-pwm' % n)
    # configure fans
    for n in range(0, 1):
        hal.Pin('hm2_5i25.0.pwmgen.%02i.enable' % (n + 4)).link('f%i-pwm-enable' % n)
        hal.Pin('hm2_5i25.0.pwmgen.%02i.value' % (n + 4)).link('f%i-pwm' % n)
        hal.Signal('f%i-pwm-enable' % n).set(True)
    # configure exps
    for n in range(0, 1):
        hal.Pin('hm2_5i25.0.pwmgen.%02i.enable' % (n + 5)).link('exp%i-pwm-enable' % n)
        hal.Pin('hm2_5i25.0.pwmgen.%02i.value' % (n + 5)).link('exp%i-pwm' % n)
        hal.Signal('exp%i-pwm' % n).set(1.0)
    # configure leds
    # none

    # GPIO
    hal.Pin('hm2_5i25.0.gpio.046.in').link('limit-0-home')   # X
    hal.Pin('hm2_5i25.0.gpio.047.in').link('limit-0-max')    # X
    hal.Pin('hm2_5i25.0.gpio.048.in').link('limit-1-home')   # Y
    hal.Pin('hm2_5i25.0.gpio.049.in').link('limit-1-max')    # Y
#    hal.Pin('bb_gpio.p9.in-13').link('limit-2-home')   # Z
#    hal.Pin('bb_gpio.p9.in-11').link('limit-2-max')    # Z
    hal.Pin('hm2_5i25.0.gpio.050.in').link('limit-2-0-home')  # ZR
    hal.Pin('hm2_5i25.0.gpio.051.in').link('limit-2-1-home')  # ZL
    # probe ...

    # Adjust as needed for your switch polarity
    hal.Pin('hm2_5i25.0.gpio.046.in_not').set(True)
    hal.Pin('hm2_5i25.0.gpio.047.in_not').set(True)
    hal.Pin('hm2_5i25.0.gpio.048.in_not').set(True)
    hal.Pin('hm2_5i25.0.gpio.049.in_not').set(True)
    hal.Pin('hm2_5i25.0.gpio.050.in_not').set(True)
    hal.Pin('hm2_5i25.0.gpio.051.in_not').set(True)

    # ADC
    hal.Pin('hm2_5i25.0.nano_adc.sample[0]').link('temp.ch-00.input')
    hal.Pin('hm2_5i25.0.nano_adc.sample[1]').link('temp.ch-01.input')
    hal.Pin('hm2_5i25.0.nano_adc.sample[2]').link('temp.ch-02.input')
    hal.Pin('hm2_5i25.0.nano_adc.sample[3]').link('temp.ch-03.input')

    hal.Pin('temp.ch-00.value').link('hbp-temp-meas')
    hal.Pin('temp.ch-01.value').link('e0-temp-meas')
    hal.Pin('temp.ch-02.value').link('e1-temp-meas')
    hal.Pin('temp.ch-03.value').link('e2-temp-meas')

    # machine power
    hal.Pin('hm2_5i25.0.gpio.033.out').link('emcmot-0-enable')
    #hal.Pin('bb_gpio.p9.out-23.in_not').set(True)
    # Monitor estop input from hardware
    hal.Pin('hm2_5i25.0.gpio.034.in').link('estop-in')
    hal.Pin('hm2_5i25.0.gpio.034.in_not').set(True)
    # drive estop-sw
    os.system('halcmd setp hm2_5i25.0.gpio.035.is_output true')
    os.system('halcmd setp hm2_5i25.0.gpio.035.invert_output true')
    hal.Pin('hm2_5i25.0.gpio.035.out').link('estop-out')
#    hal.Pin('hm2_5i25.0.gpio.035.in_not').set(True)

    # Tie machine power signal to the Parport Cape LED
    # Feel free to tie any other signal you like to the LED
    hal.Pin('hm2_5i25.0.gpio.031.out').link('emcmot-0-enable')
    # hal.Pin('bb_gpio.p9.out-25.in_not').set(True)

    # link emcmot.xx.enable to stepper driver enable signals
    hal.Pin('hm2_5i25.0.gpio.029.out').link('emcmot-0-enable')
    hal.Pin('hm2_5i25.0.gpio.029.in_not').set(True)

def setup_exp(name):
    hal.newsig('%s-pwm' % name, hal.HAL_FLOAT, init=0.0)
    hal.newsig('%s-enable' % name, hal.HAL_BIT, init=False)
