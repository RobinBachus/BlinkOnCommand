# BlinkOnDemand
A combination of a C++ Arduino script and a Powershell module. 
It allows you to make an LED blink by typing blink into the Powershell comandline.

The way it works is by using a powershell command to send a number to the serial monitor of the arduino, which upon recieving that specific number blinks the LED and lets Powershell now that the led has blinked.

I made this project mainly to get more confortable using Powershell.

Powershell Commands:
- Blink:  Blinks LED once on the first serial port it detects
  Parameters:
  - -r:   (Optional) reloads the module before excecution (Use after making changes to the module)  

- BlinkAt:  Blinks LED on specified serial port(s) for a specified amount of times
  Parameters:
  - Ports:    (Mandatory) serial port(s) on which to blink LED
  - Blinks:   (Mandatory) amount of times to blink LED on each board 
  - -r:       (Optional) reloads the module before excecution (Use after making changes to the module)
