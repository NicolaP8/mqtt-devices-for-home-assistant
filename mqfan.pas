{
  https://www.home-assistant.io/integrations/device_trigger.mqtt/
  Version 2024.12.1
}
{$mode Delphi}
unit mqFan;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  EFanNames = fnConfig..fnValueTemplate;
  {
    fnConfig,
    fnAvailabilityMode,
    fnAvailabilityTemplate,
    fnAvailabilityTopic,
    fnCommandTemplate,
    fnCommandTopic,
    fnEnabledByDefault,
    fnEncoding,
    fnEntityCategory,
    fnIcon,
    fnJsonAttributesTemplate,
    fnJsonAttributesTopic,
    fnName,
    fnObjectId,
    fnOptimistic,
    fnDirectionCommandTemplate,
    fnDirectionCommandTopic,
    fnDirectionStateTopic,
    fnDirectionValueTemplate,
    fnOscillationCommandTemplate,
    fnOscillationCommandTopic,
    fnOscillationStateTopic,
    fnOscillationValueTemplate,
    fnPayloadAvailable,
    fnPayloadNotAvailable,
    fnPayloadOff,
    fnPayloadOn,
    fnPayloadOscillationOff,
    fnPayloadOscillationOn,
    fnPayloadResetPercentage,
    fnPayloadResetPresetMode,
    fnPercentageCommandTemplate,
    fnPercentageCommandTopic,
    fnPercentageStateTopic,
    fnPercentageValueTemplate,
    fnPresetModeCommandTemplate,
    fnPresetModeCommandTopic,
    fnPresetModeStateTopic,
    fnPresetModeValueTemplate,
    fnPresetModes,
    fnQos,
    fnRetain,
    fnSpeedRangeMax,
    fnSpeedRangeMin,
    fnStateTopic,
    fnUniqueId,
    fnValueTemplate
  }

Const
  CFanNames : array [EFanNames] of string  = (
    'config',
    'availability_mode',
    'availability_template',
    'availability_topic',
    'command_template',
    'command_topic',
    'enabled_by_default',
    'encoding',
    'entity_category',
    'icon',
    'json_attributes_template',
    'json_attributes_topic',
    'name',
    'object_id',
    'optimistic',
    'direction_command_template',
    'direction_command_topic',
    'direction_state_topic',
    'direction_value_template',
    'oscillation_command_template',
    'oscillation_command_topic',
    'oscillation_state_topic',
    'oscillation_value_template',
    'payload_available',
    'payload_not_available',
    'payload_off',
    'payload_on',
    'payload_oscillation_off',
    'payload_oscillation_on',
    'payload_reset_percentage',
    'payload_reset_preset_mode',
    'percentage_command_template',
    'percentage_command_topic',
    'percentage_state_topic',
    'percentage_value_template',
    'preset_mode_command_template',
    'preset_mode_command_topic',
    'preset_mode_state_topic',
    'preset_mode_value_template',
    'preset_modes',
    'qos',
    'retain',
    'speed_range_max',
    'speed_range_min',
    'state_topic',
    'unique_id',
    'value_template'
  );

Const //this is missing from the docs
  fanForward = 'forward';
  fanReverse = 'reverse';

  FanDirectionNames : array[Boolean] of string = (FanReverse, fanForward);

Type
  { TMQTTFan }
  TMQTTFan = Class(TMQTTBaseObject)
    private
    public
      State : boolean; //on|off
      Direction : boolean; //True -> forward
      Oscillate : boolean;
      Speed : integer; //range

      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation

{ TMQTTFan }
constructor TMQTTFan.Create;
begin
  Inherited Create;
  FClass := hdcFan;
  FConfig.Add(CFanNames, []);
  FTopics := [Ord(fnConfig), Ord(fnCommandTopic), Ord(fnDirectionCommandTopic), Ord(fnDirectionStateTopic),
    Ord(fnOscillationCommandTopic), Ord(fnOscillationStateTopic), Ord(fnPercentageCommandTopic),
    Ord(fnPercentageStateTopic), Ord(fnPresetModeCommandTopic), Ord(fnPresetModeStateTopic), Ord(fnStateTopic)];

  FConfigTopic  := fnConfig;
  FStateTopic   := fnStateTopic;
  FCommandTopic := fnCommandTopic;

  //default values
  FConfig[CFanNames[fnCommandTopic]] := 'set'; //required
  FConfig[CFanNames[fnPayloadOff]] := 'OFF';
  FConfig[CFanNames[fnPayloadOn]] := 'ON';
  Config[CFanNames[fnPayloadOscillationOff]] := 'oscillate_off';
  Config[CFanNames[fnPayloadOscillationOn]] := 'oscillate_on';
  Config[CFanNames[fnPayloadResetPercentage]] := 'None';
  Config[CFanNames[fnPayloadResetPresetMode]] := 'None';
  FConfig[CFanNames[fnSpeedRangeMax]] := '100';
  FConfig[CFanNames[fnSpeedRangeMin]] := '1';
end;

function TMQTTFan.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EFanNames))) or (AConfigItem > Ord(High(EFanNames))) then Exit;
  Result := CFanNames[EFanNames(AConfigItem)];
end; //FromEnumToString

function TMQTTFan.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := fnConfig to fnValueTemplate do begin
    if AName = CFanNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTFan.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CFanNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[fnAvailabilityTemplate       ] := hatTemplate;
  HATypeInfo[fnEnabledByDefault           ] := hatBoolean;
  HATypeInfo[fnJsonAttributesTemplate     ] := hatTemplate;
  HATypeInfo[fnOptimistic                 ] := hatBoolean;
  HATypeInfo[fnDirectionCommandTemplate   ] := hatTemplate;
  HATypeInfo[fnDirectionValueTemplate     ] := hatTemplate;
  HATypeInfo[fnOscillationCommandTemplate ] := hatTemplate;
  HATypeInfo[fnOscillationValueTemplate   ] := hatTemplate;
  HATypeInfo[fnPercentageCommandTemplate  ] := hatTemplate;
  HATypeInfo[fnPercentageValueTemplate    ] := hatTemplate;
  HATypeInfo[fnPresetModeCommandTemplate  ] := hatTemplate;
  HATypeInfo[fnPresetModeValueTemplate    ] := hatTemplate;
  HATypeInfo[fnPresetModes                ] := hatList;
  HATypeInfo[fnQos                        ] := hatInteger;
  HATypeInfo[fnRetain                     ] := hatBoolean;
  HATypeInfo[fnSpeedRangeMax              ] := hatInteger;
  HATypeInfo[fnSpeedRangeMin              ] := hatInteger;
  HATypeInfo[fnValueTemplate              ] := hatTemplate;
end.
