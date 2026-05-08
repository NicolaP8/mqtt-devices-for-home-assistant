# mqtt-devices-for-home-assistant
A library for interfacing a device with home-assistant using MQTT for FreePascal

This library makes use of FPC MQTT Client Component https://github.com/prof7bit/fpc-mqtt-client but you need to use my fork https://github.com/NicolaP8/fpc-mqtt-client that has a small correction.

This library is licensed with GPL 3.0 for personal use, contact me for commercial use.

At moment only this sensor/device are supported:
|Supported sensors|Done|https://www.home-assistant.io/integrations/#search/mqtt|ObjectName|
|-----------------------|--------|------------|-------|
|Alarm control panel||https://www.home-assistant.io/integrations/alarm_control_panel.mqtt/||
|Binary sensor|yes|https://www.home-assistant.io/integrations/binary_sensor.mqtt/|TMQTTBinarySensor|
|Button|yes|https://www.home-assistant.io/integrations/button.mqtt/|TMQTTButton|
|Camera||https://www.home-assistant.io/integrations/camera.mqtt/||
|Cover|yes|https://www.home-assistant.io/integrations/cover.mqtt/|TMQTTCover|
|Climate (HVAC)||https://www.home-assistant.io/integrations/climate.mqtt/||
|Date|yes|https://www.home-assistant.io/integrations/date.mqtt/|TMQTTDate|
|DateTime|yes|https://www.home-assistant.io/integrations/datetime.mqtt/|TMQTTDateTime|
|Device tracker||https://www.home-assistant.io/integrations/device_tracker.mqtt/||
|Device trigger|yes|https://www.home-assistant.io/integrations/device_trigger.mqtt/|TMQTTDeviceTrigger|
|Event||https://www.home-assistant.io/integrations/event.mqtt/||
|Fan|yes|https://www.home-assistant.io/integrations/fan.mqtt/|TMQTTFan|
|Humidifier||https://www.home-assistant.io/integrations/humidifier.mqtt/||
|Image||https://www.home-assistant.io/integrations/image.mqtt/||
|Lawn mower||https://www.home-assistant.io/integrations/lawn_mower.mqtt/||
|Light|yes|https://www.home-assistant.io/integrations/light.mqtt/|TMQTTLight|
|Lock|yes|https://www.home-assistant.io/integrations/lock.mqtt/|TMQTTLock|
|Notify||https://www.home-assistant.io/integrations/notify.mqtt/||
|Number|yes|https://www.home-assistant.io/integrations/number.mqtt/||
|Scene||https://www.home-assistant.io/integrations/scene.mqtt/||
|Select||https://www.home-assistant.io/integrations/select.mqtt/||
|Sensor|yes|https://www.home-assistant.io/integrations/sensor.mqtt/|TMQTTSensor|
|Siren||https://www.home-assistant.io/integrations/siren.mqtt/||
|Switch|yes|https://www.home-assistant.io/integrations/switch.mqtt/|TMQTTSwitch|
|Tag scanner|no|https://www.home-assistant.io/integrations/tag.mqtt/|TMQTTTagScanner|
|Text|yes|https://www.home-assistant.io/integrations/text.mqtt/|TMQTTText|
|Time|yes|https://www.home-assistant.io/integrations/time.mqtt/|TMQTTTime|
|Update|yes|https://www.home-assistant.io/integrations/update.mqtt/|TMQTTUpdate|
|Vacuum||https://www.home-assistant.io/integrations/vacuum.mqtt/||
|Valve|yes|https://www.home-assistant.io/integrations/valve.mqtt/|TMQTTValve|
|Water heater||https://www.home-assistant.io/integrations/water_heater.mqtt/||

There is a  file that contains the common parts and an abstract ancestor.
Each other component resides in its own separate file containing the necessary definitions.
There also a demo program, tested only in Windows; was developed primarly to check the components so is simple and crude.

The mqtt_device_info.xls file contains the previous table and the data extracted from home-assistant pages, in tabular form.

The library itself is compatible with Linux and Windows, my main usage is with Raspberry Pi!

# Changelog

Version of 2026.05.07

  Added
  
    + TMQTTDate, TMQTTDateTime, TMQTTTime


Version of 2026.03.04

  Added
  
    + TMQTTNumber
    
  Removed
  
    - removed ObjectId because deprecated by Home Assistant
