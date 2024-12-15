{
  https://www.home-assistant.io/integrations/binary_sensor.mqtt/
  Version 2024.12.15
}
{$mode Delphi}
unit mqBinarySensor;

interface

uses
  Classes, SysUtils, mqttDevice;

Type
  EBinarySensorNames = bsnConfig..bsnValueTemplate;
  {
    bsnConfig,
    bsnAvailabilityMode,
    bsnAvailabilityTemplate,
    bsnAvailabilityTopic,
    bsnDeviceClass,
    bsnEnabledByDefault,
    bsnEncoding,
    bsnEntityCategory,
    bsnExpireAfter,
    bsnForceUpdate,
    bsnIcon,
    bsnJsonAttributesTemplate,
    bsnJsonAttributesTopic,
    bsnName,
    bsnObjectId,
    bsnOffDelay,
    bsnPayloadAvailable,
    bsnPayloadNotAvailable,
    bsnPayloadOff,
    bsnPayloadOn,
    bsnQos,
    bsnStateTopic,
    bsnUniqueId,
    bsnValueTemplate
  }

  EBinarySensorDeviceClass = ( //values for bsnDeviceClass
    bsdcNone,
    bsdcBattery,
    bsdcBatteryCharging,
    bsdcCarbonMonoxide,
    bsdcCold,
    bsdcConnectivity,
    bsdcDoor,
    bsdcGarageDoor,
    bsdcGas,
    bsdcHeat,
    bsdcLight,
    bsdcLock,
    bsdcMoisture,
    bsdcMotion,
    bsdcMoving,
    bsdcOccupancy,
    bsdcOpening,
    bsdcPlug,
    bsdcPower,
    bsdcPresence,
    bsdcProblem,
    bsdcRunning,
    bsdcSafety,
    bsdcSmoke,
    bsdcSound,
    bsdcTamper,
    bsdcUpdate,
    bsdcVibration,
    bsdcWindow
  );

Const
  CBinarySensorNames : array[EBinarySensorNames] of string = (
    'config',
    'availability_mode',
    'availability_template',
    'availability_topic',
    'device_class',
    'enabled_by_default',
    'encoding',
    'entity_category',
    'expire_after',
    'force_update',
    'icon',
    'json_attributes_template',
    'json_attributes_topic',
    'name',
    'object_id',
    'off_delay',
    'payload_available',
    'payload_not_available',
    'payload_off',
    'payload_on',
    'qos',
    'state_topic',
    'unique_id',
    'value_template'
  );

  CBinarySensorDeviceClass : array[EBinarySensorDeviceClass] of string = (
    'None',
    'battery',
    'battery_charging',
    'carbon_monoxide',
    'cold',
    'connectivity',
    'door',
    'garage_door',
    'gas',
    'heat',
    'light',
    'lock',
    'moisture',
    'motion',
    'moving',
    'occupancy',
    'opening',
    'plug',
    'power',
    'presence',
    'problem',
    'running',
    'safety',
    'smoke',
    'sound',
    'tamper',
    'update',
    'vibration',
    'window'
  );

Type
  { TMQTTBinarySensor }
  TMQTTBinarySensor = Class(TMQTTBaseObject)
    private
    public
      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTBinarySensor }
constructor TMQTTBinarySensor.Create;
begin
  Inherited Create;
  FClass := hdcBinarySensor;
  FConfig.Add(CBinarySensorNames, []);
  FTopics := [Ord(bsnConfig), Ord(bsnStateTopic)];

  FConfigTopic  := bsnConfig;
  FStateTopic   := bsnStateTopic;
  //FCommandTopic := not used
  FIDTopic      := bsnObjectId;

  //default values
  FConfig[CBinarySensorNames[bsnPayloadOn]] := 'ON';
  FConfig[CBinarySensorNames[bsnPayloadOff]] := 'OFF';
  FConfig[CBinarySensorNames[bsnStateTopic]] := 'state'; //required
end;

function TMQTTBinarySensor.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EBinarySensorNames))) or (AConfigItem > Ord(High(EBinarySensorNames))) then Exit;
  Result := CBinarySensorNames[EBinarySensorNames(AConfigItem)];
end; //FromEnumToString

function TMQTTBinarySensor.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := bsnConfig to bsnValueTemplate do begin
    if AName = CBinarySensorNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTBinarySensor.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CBinarySensorNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe


Initialization
  HATypeInfo[bsnAvailabilityTemplate]   := hatTemplate;
  HATypeInfo[bsnEnabledByDefault]       := hatBoolean;
  HATypeInfo[bsnExpireAfter]            := hatInteger;
  HATypeInfo[bsnForceUpdate]            := hatBoolean;
  HATypeInfo[bsnJsonAttributesTemplate] := hatTemplate;
  HATypeInfo[bsnOffDelay]               := hatInteger;
  HATypeInfo[bsnQos]                    := hatInteger;
  HATypeInfo[bsnValueTemplate]          := hatTemplate;
end.
