{
  https://www.home-assistant.io/integrations/number.mqtt/
  Version 2026.03.04

  State: The MQTT topic subscribed to receive number values. An empty payload is ignored.
  Command: The MQTT topic to publish commands to change the number.
}
{$mode Delphi}
unit mqNumber;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ENumberNames = nnConfig..nnValueTemplate;
  {
    nnAvailabilityMode,
    nnAvailabilityTopic,
    nnCommandTemplate,
    nnCommandTopic,
    nnDefaultEntityId,
    nnDeviceClass,
    nnEnabledByDefault,
    nnEncoding,
    nnEntityCategory,
    nnEntityPicture,
    nnIcon,
    nnJsonAttributesTemplate,
    nnJsonAttributesTopic,
    nnMax,
    nnMin,
    nnMode,
    nnName,
    nnOptimistic,
    nnPayloadReset,
    nnPlatform,
    nnQos,
    nnRetain,
    nnStateTopic,
    nnStep,
    nnUniqueId,
    nnUnitOfMeasurement,
    nnValueTemplate
  }

Const
  CNumberNames : array [ENumberNames] of string  = (
    'config',
    'availability_mode',
    'availability_topic',
    'command_template',
    'command_topic',
    'default_entity_id',
    'device_class',
    'enabled_by_default',
    'encoding',
    'entity_category',
    'entity_picture',
    'icon',
    'json_attributes_template',
    'json_attributes_topic',
    'max',
    'min',
    'mode',
    'name',
    'optimistic',
    'payload_reset',
    'platform',
    'qos',
    'retain',
    'state_topic',
    'step',
    'unique_id',
    'unit_of_measurement',
    'value_template'
  );

Type
  { TMQTTNumber }
  TMQTTNumber = Class(TMQTTBaseObject)
    private
    public
      Value : Double;

      Constructor Create;
      Function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTNumber }
constructor TMQTTNumber.Create;
begin
  Inherited Create;
  FClass := hdcNumber;
  FConfig.Add(CNumberNames, []);
  FTopics := [Ord(nnConfig), Ord(nnStateTopic), Ord(nnCommandTopic)];

  FConfig[CNumberNames[nnCommandTopic]] := 'set'; //required
  FConfig[CNumberNames[nnPlatform]] := 'number'; //required
  FConfig[CNumberNames[nnStateTopic]] := 'state';

  FConfigTopic  := nnConfig;
  FStateTopic   := nnStateTopic;
  FCommandTopic := nnCommandTopic;
  FIDTopic      := nnDefaultEntityId;
end;

function TMQTTNumber.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ENumberNames))) or (AConfigItem > Ord(High(ENumberNames))) then Exit;
  Result := CNumberNames[ENumberNames(AConfigItem)];
end; //FromEnumToString

function TMQTTNumber.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := Low(ENumberNames) to High(ENumberNames) do begin
    if AName = CNumberNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTNumber.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CNumberNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[nnCommandTemplate]           := hatTemplate;
  HATypeInfo[nnEnabledByDefault]          := hatBoolean;
  HATypeInfo[nnJsonAttributesTemplate]    := hatTemplate;
  HATypeInfo[nnMax]                       := hatFloat;
  HATypeInfo[nnMin]                       := hatFloat;
  HATypeInfo[nnOptimistic]                := hatBoolean;
  HATypeInfo[nnQos]                       := hatInteger;
  HATypeInfo[nnRetain]                    := hatBoolean;
  HATypeInfo[nnStep]                      := hatFloat;
  HATypeInfo[nnValueTemplate]             := hatTemplate;
end.
