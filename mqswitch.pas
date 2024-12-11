{
  https://www.home-assistant.io/integrations/switch.mqtt/
  Version 2024.12.1
}
{$mode Delphi}
unit mqSwitch;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ESwitchNames = swnConfig..swnValueTemplate;
  {
    swnConfig,
    swnAvailabilityMode,
    swnAvailabilityTemplate,
    swnAvailabilityTopic,
    swnCommandTemplate,
    swnCommandTopic,
    swnDeviceClass,
    swnEnabledByDefault,
    swnEncoding,
    swnEntityCategory,
    swnIcon,
    swnJsonAttributesTemplate,
    swnJsonAttributesTopic,
    swnName,
    swnObjectId,
    swnOptimistic,
    swnPayloadAvailable,
    swnPayloadNotAvailable,
    swnPayloadOff,
    swnPayloadOn,
    swnQos,
    swnRetain,
    swnStateOff,
    swnStateOn,
    swnStateTopic,
    swnUniqueId,
    swnValueTemplate
  }

  ESwitchDeviceClass = (
    swdcNone,
    swdcOutlet,
    swdcSwitch
  );

Const
  CSwitchNames : array [ESwitchNames] of string  = (
    'config',
    'availability_mode',
    'availability_template',
    'availability_topic',
    'command_template',
    'command_topic',
    'device_class',
    'enabled_by_default',
    'encoding',
    'entity_category',
    'icon',
    'json_attributes_template',
    'json_attributes_topic',
    'name',
    'object_id',
    'optimistic',
    'payload_available',
    'payload_not_available',
    'payload_off',
    'payload_on',
    'qos',
    'retain',
    'state_off',
    'state_on',
    'state_topic',
    'unique_id',
    'value_template'
  );

  CSwitchDeviceClass : array [ESwitchDeviceClass] of string  = (
    'None',
    'outlet',
    'switch'
  );

Type
  { TMQTTSwitch }
  TMQTTSwitch = Class(TMQTTBaseObject)
    private
    public
      State : Boolean;

      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTSwitch }
constructor TMQTTSwitch.Create;
begin
  Inherited Create;
  FClass := hdcSwitch;
  FConfig.Add(CSwitchNames, []);
  FTopics := [Ord(swnConfig), Ord(swnCommandTopic), Ord(swnStateTopic)];

  FConfigTopic  := swnConfig;
  FStateTopic   := swnStateTopic;
  FCommandTopic := swnCommandTopic;

  //default values
  FConfig[CSwitchNames[swnCommandTopic]] := 'set'; //required
  FConfig[CSwitchNames[swnPayloadOn]] := 'ON';
  FConfig[CSwitchNames[swnPayloadOff]] := 'OFF';
end;

function TMQTTSwitch.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ESwitchNames))) or (AConfigItem > Ord(High(ESwitchNames))) then Exit;
  Result := CSwitchNames[ESwitchNames(AConfigItem)];
end; //FromEnumToString

function TMQTTSwitch.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := swnConfig to swnValueTemplate do begin
    if AName = CSwitchNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTSwitch.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CSwitchNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe


Initialization
  HATypeInfo[swnAvailabilityTemplate    ] := hatTemplate;
  HATypeInfo[swnCommandTemplate         ] := hatTemplate;
  HATypeInfo[swnEnabledByDefault        ] := hatBoolean;
  HATypeInfo[swnJsonAttributesTemplate  ] := hatTemplate;
  HATypeInfo[swnOptimistic              ] := hatBoolean;
  HATypeInfo[swnQos                     ] := hatInteger;
  HATypeInfo[swnRetain                  ] := hatBoolean;
  HATypeInfo[swnValueTemplate           ] := hatTemplate;
end.
