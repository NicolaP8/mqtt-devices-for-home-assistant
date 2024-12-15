{
  https://www.home-assistant.io/integrations/sensor.mqtt/
  Version 2024.12.15
}
{$mode Delphi}
unit mqSensor;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ESensorNames = snConfig..snValueTemplate;
  {
    snConfig,
    snAvailabilityMode,
    snAvailabilityTemplate,
    snAvailabilityTopic,
    snDeviceClass,
    snEnabledByDefault,
    snEncoding,
    snEntityCategory,
    snExpireAfter,
    snForceUpdate,
    snIcon,
    snJsonAttributesTemplate,
    snJsonAttributesTopic,
    snLastResetValueTemplate,
    snName,
    snObjectId,
    snPayloadAvailable,
    snPayloadNotAvailable,
    snSuggestedDisplayPrecision,
    snQos,
    snStateClass,
    snStateTopic,
    snUniqueId,
    snUnitOfMeasurement,
    snValueTemplate
  }

  ESensorDeviceClass = (
    sdcNone,
    sdcApparentPower,
    sdcAqi,
    sdcAtmosphericPressure,
    sdcBattery,
    sdcCarbonDioxide,
    sdcCarbonMonoxide,
    sdcCurrent,
    sdcDataRate,
    sdcDataSize,
    sdcDate,
    sdcDistance,
    sdcDuration,
    sdcEnergy,
    sdcEnergyStorage,
    sdcEnum,
    sdcFrequency,
    sdcGas,
    sdcHumidity,
    sdcIlluminance,
    sdcIrradiance,
    sdcMoisture,
    sdcMonetary,
    sdcNitrogenDioxide,
    sdcNitrogenMonoxide,
    sdcNitrousOxide,
    sdcOzone,
    sdcPh,
    sdcPm1,
    sdcPm25,
    sdcPm10,
    sdcPowerFactor,
    sdcPower,
    sdcPrecipitation,
    sdcPrecipitationIntensity,
    sdcPressure,
    sdcReactivePower,
    sdcSignalStrength,
    sdcSoundPressure,
    sdcSpeed,
    sdcSulphurDioxide,
    sdcTemperature,
    sdcTimestamp,
    sdcVolatileOrganicCompounds,
    sdcVolatileOrganicCompoundsParts,
    sdcVoltage,
    sdcVolume,
    sdcVolumeFlowRate,
    sdcVolumeStorage,
    sdcWater,
    sdcWeight,
    sdcWindSpeed
  );

  ESensorStateClass = (
    sscMeasurement,
    sscTotal,
    sscTotalIncreasing
  );


Const
  CSensorNames : array [ESensorNames] of string  = (
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
    'last_reset_value_template',
    'name',
    'object_id',
    'payload_available',
    'payload_not_available',
    'suggested_display_precision',
    'qos',
    'state_class',
    'state_topic',
    'unique_id',
    'unit_of_measurement',
    'value_template'
  );

  CSensorDeviceClass : array [ESensorDeviceClass] of string  = (
    '', //bug in the doc: 'None' is not supported
    'apparent_power',
    'aqi',
    'atmospheric_pressure',
    'battery',
    'carbon_dioxide',
    'carbon_monoxide',
    'current',
    'data_rate',
    'data_size',
    'date',
    'distance',
    'duration',
    'energy',
    'energy_storage',
    'enum',
    'frequency',
    'gas',
    'humidity',
    'illuminance',
    'irradiance',
    'moisture',
    'monetary',
    'nitrogen_dioxide',
    'nitrogen_monoxide',
    'nitrous_oxide',
    'ozone',
    'ph',
    'pm1',
    'pm25',
    'pm10',
    'power_factor',
    'power',
    'precipitation',
    'precipitation_intensity',
    'pressure',
    'reactive_power',
    'signal_strength',
    'sound_pressure',
    'speed',
    'sulphur_dioxide',
    'temperature',
    'timestamp',
    'volatile_organic_compounds',
    'volatile_organic_compounds_parts',
    'voltage',
    'volume',
    'volume_flow_rate',
    'volume_storage',
    'water',
    'weight',
    'wind_speed'
  );

  CSensorStateClass : array [ESensorStateClass] of string  = (
    'measurement',
    'total',
    'total_increasing'
  );

Type
  { TMQTTSensor }
  TMQTTSensor = Class(TMQTTBaseObject)
    private
    public
      Constructor Create;
      Function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTSensor }
constructor TMQTTSensor.Create;
begin
  Inherited Create;
  FClass := hdcSensor;
  FConfig.Add(CSensorNames, []);
  FTopics := [Ord(snConfig), Ord(snStateTopic)];

  FConfig[CSensorNames[snStateTopic]] := 'state'; //required

  FConfigTopic  := snConfig;
  FStateTopic   := snStateTopic;
  //FCommandTopic := not used
  FIDTopic      := snObjectId;
end;

function TMQTTSensor.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ESensorNames))) or (AConfigItem > Ord(High(ESensorNames))) then Exit;
  Result := CSensorNames[ESensorNames(AConfigItem)];
end; //FromEnumToString

function TMQTTSensor.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := snConfig to snValueTemplate do begin
    if AName = CSensorNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTSensor.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CSensorNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[snAvailabilityTemplate]      := hatTemplate;
  HATypeInfo[snEnabledByDefault]          := hatBoolean;
  HATypeInfo[snExpireAfter]               := hatInteger;
  HATypeInfo[snForceUpdate]               := hatBoolean;
  HATypeInfo[snJsonAttributesTemplate]    := hatTemplate;
  HATypeInfo[snLastResetValueTemplate]    := hatTemplate;
  HATypeInfo[snSuggestedDisplayPrecision] := hatInteger;
  HATypeInfo[snQos]                       := hatInteger;
  HATypeInfo[snValueTemplate]             := hatTemplate;
end.
