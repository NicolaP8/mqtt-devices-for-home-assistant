# mqtt-devices-for-home-assistant
A library for interfacing a device with home-assistant using MQTT for FreePascal

This library makes use of FPC MQTT Client Component https://github.com/prof7bit/fpc-mqtt-client that you need to download separately.

This library is licensed with GPL 3.0 for personal use, contact me for commercial use.

At moment only this sensor/device are supported:
|  Supported sensors|Done|https://www.home-assistant.io/integrations/#search/mqtt|ObjectName|
|-----------------------|--------|------------|-------|
|MQTT Alarm control panel||||
|MQTT binary sensor|yes|https://www.home-assistant.io/integrations/binary_sensor.mqtt/|TMQTTBinarySensor|
|MQTT button|yes|https://www.home-assistant.io/integrations/button.mqtt/|TMQTTButton|
|MQTT Camera||||
|MQTT Cover|yes|https://www.home-assistant.io/integrations/cover.mqtt/|TMQTTCover|
|MQTT device tracker||||
|MQTT Device trigger|yes|https://www.home-assistant.io/integrations/device_trigger.mqtt/|TMQTTDeviceTrigger|
|MQTT Event||||
|MQTT Eventstream||||
|MQTT Fan|yes|https://www.home-assistant.io/integrations/fan.mqtt/|TMQTTFan|
|MQTT Humidifier||||
|MQTT HVAC||||
|MQTT Image||||
|MQTT JSON||||
|MQTT lawn mower||||
|MQTT Light|yes|https://www.home-assistant.io/integrations/light.mqtt/|TMQTTLight|
|MQTT Lock|yes|https://www.home-assistant.io/integrations/lock.mqtt/|TMQTTLock|
|MQTT notify||||
|MQTT Number||||
|MQTT room presence||||
|MQTT Scene||||
|MQTT Select||||
|MQTT Sensor|yes|https://www.home-assistant.io/integrations/sensor.mqtt/|TMQTTSensor|
|MQTT Siren||||
|MQTT Statestream||||
|MQTT Switch|yes|https://www.home-assistant.io/integrations/switch.mqtt/|TMQTTSwitch|
|MQTT tag scanner|no|https://www.home-assistant.io/integrations/tag.mqtt/|TMQTTTagScanner|
|MQTT Text|yes|https://www.home-assistant.io/integrations/text.mqtt/|TMQTTText|
|MQTT Update|yes|https://www.home-assistant.io/integrations/update.mqtt/|TMQTTUpdate|
|MQTT Vacuum||||
|MQTT Valve|yes|https://www.home-assistant.io/integrations/valve.mqtt/|TMQTTValve|
|MQTT water heater||||

There is a  file that contains the common parts and an abstract ancestor.
Each other component resides in its own separate file containing the necessary definitions.
There also a demo program, tested only in Windows; was developed primarly to check the components so is simple and crude.

The mqtt_device_info.xls file contains the previous table and the data extracted from home-assistant pages, in tabular form.

The library itself is compatible with Linux and my main usage is with Raspberry Pi!

