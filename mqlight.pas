{
  https://www.home-assistant.io/integrations/light.mqtt/
  Version 2024.12.1
}
{$mode Delphi}
unit mqLight;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ELightNames = linConfig..linXyValueTemplate;
  {
    linConfig,
    linAvailabilityMode,
    linAvailabilityTemplate,
    linAvailabilityTopic,
    linBrightnessCommandTopic,
    linBrightnessCommandTemplate,
    linBrightnessScale,
    linBrightnessStateTopic,
    linBrightnessValueTemplate,
    linColorModeStateTopic,
    linColorModeValueTemplate,
    linColorTempCommandTemplate,
    linColorTempCommandTopic,
    linColorTempStateTopic,
    linColorTempValueTemplate,
    linCommandTopic,
    linEnabledByDefault,
    linEncoding,
    linEntityCategory,
    linEntityPicture,
    linEffectCommandTopic,
    linEffectCommandTemplate,
    linEffectList,
    linEffectStateTopic,
    linEffectValueTemplate,
    linHsCommandTemplate,
    linHsCommandTopic,
    linHsStateTopic,
    linHsValueTemplate,
    linIcon,
    linJsonAttributesTemplate,
    linJsonAttributesTopic,
    linMaxMireds,
    linMinMireds,
    linName,
    linObjectId,
    linOnCommandType,
    linOptimistic,
    linPayloadAvailable,
    linPayloadNotAvailable,
    linPayloadOn,
    linPayloadOff,
    linQos,
    linRetain,
    linRgbCommandTemplate,
    linRgbCommandTopic,
    linRgbStateTopic,
    linRgbValueTemplate,
    linRgbwCommandTemplate,
    linRgbwCommandTopic,
    linRgbwStateTopic,
    linRgbwValueTemplate,
    linRgbwwCommandTemplate,
    linRgbwwCommandTopic,
    linRgbwwStateTopic,
    linRgbwwValueTemplate,
    linSchema,
    linStateTopic,
    linStateValueTemplate,
    linUniqueId,
    linWhiteCommandTopic,
    linWhiteScale,
    linXyCommandTemplate,
    linXyCommandTopic,
    linXyStateTopic,
    linXyValueTemplate
  }

Const
     CLightNames : array [ELightNames] of string  = (
       'config',
       'availability_mode',
       'availability_template',
       'availability_topic',
       'brightness_command_topic',
       'brightness_command_template',
       'brightness_scale',
       'brightness_state_topic',
       'brightness_value_template',
       'color_mode_state_topic',
       'color_mode_value_template',
       'color_temp_command_template',
       'color_temp_command_topic',
       'color_temp_state_topic',
       'color_temp_value_template',
       'command_topic',
       'enabled_by_default',
       'encoding',
       'entity_category',
       'entity_picture',
       'effect_command_topic',
       'effect_command_template',
       'effect_list',
       'effect_state_topic',
       'effect_value_template',
       'hs_command_template',
       'hs_command_topic',
       'hs_state_topic',
       'hs_value_template',
       'icon',
       'json_attributes_template',
       'json_attributes_topic',
       'max_mireds',
       'min_mireds',
       'name',
       'object_id',
       'on_command_type',
       'optimistic',
       'payload_available',
       'payload_not_available',
       'payload_on',
       'payload_off',
       'qos',
       'retain',
       'rgb_command_template',
       'rgb_command_topic',
       'rgb_state_topic',
       'rgb_value_template',
       'rgbw_command_template',
       'rgbw_command_topic',
       'rgbw_state_topic',
       'rgbw_value_template',
       'rgbww_command_template',
       'rgbww_command_topic',
       'rgbww_state_topic',
       'rgbww_value_template',
       'schema',
       'state_topic',
       'state_value_template',
       'unique_id',
       'white_command_topic',
       'white_scale',
       'xy_command_template',
       'xy_command_topic',
       'xy_state_topic',
       'xy_value_template'
     );

Type
    { TMQTTLight }
  TMQTTLight = Class(TMQTTBaseObject)
    private
    public
      State : Boolean;
      Brightness : integer;

      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation

{ TMQTTLight }
constructor TMQTTLight.Create;
begin
  Inherited Create;
  FClass := hdcLight;
  FConfig.Add(CLightNames, []);
  FTopics := [Ord(linConfig), Ord(linBrightnessCommandTopic), Ord(linBrightnessStateTopic), Ord(linColorModeStateTopic),
    Ord(linColorTempCommandTopic), Ord(linColorTempStateTopic), Ord(linCommandTopic),
    Ord(linEffectCommandTopic), Ord(linEffectStateTopic), Ord(linHsCommandTopic),
    Ord(linHsStateTopic), Ord(linRgbCommandTopic), Ord(linRgbStateTopic),
    Ord(linRgbwCommandTopic), Ord(linRgbwStateTopic), Ord(linRgbwwCommandTopic),
    Ord(linRgbwwStateTopic), Ord(linStateTopic), Ord(linWhiteCommandTopic),
    Ord(linXyCommandTopic), Ord(linXyStateTopic)];

  FConfig[CLightNames[linCommandTopic]] := 'set'; //required
  FConfig[CLightNames[linBrightnessScale]] := '255';
  FConfig[CLightNames[linPayloadOn]] := 'ON';
  FConfig[CLightNames[linPayloadOff]] := 'OFF';
  FConfig[CLightNames[linWhiteScale]] := '255';

  FConfigTopic  := linConfig;
  FStateTopic   := linStateTopic;
  FCommandTopic := linCommandTopic;
end;

function TMQTTLight.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ELightNames))) or (AConfigItem > Ord(High(ELightNames))) then Exit;
  Result := CLightNames[ELightNames(AConfigItem)];
end; //FromEnumToString

function TMQTTLight.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := linConfig to linXyValueTemplate do begin
    if AName = CLightNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTLight.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit;
  CompleteTopic := TopicPrefix(ATopic) + Config[CLightNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[linAvailabilityTemplate        ] := hatTemplate;
  HATypeInfo[linBrightnessCommandTemplate   ] := hatTemplate;
  HATypeInfo[linBrightnessScale             ] := hatInteger;
  HATypeInfo[linBrightnessValueTemplate     ] := hatTemplate;
  HATypeInfo[linColorModeValueTemplate      ] := hatTemplate;
  HATypeInfo[linColorTempCommandTemplate    ] := hatTemplate;
  HATypeInfo[linColorTempValueTemplate      ] := hatTemplate;
  HATypeInfo[linEnabledByDefault            ] := hatBoolean;
  HATypeInfo[linEffectCommandTemplate       ] := hatTemplate;
  HATypeInfo[linEffectList                  ] := hatList;
  HATypeInfo[linEffectValueTemplate         ] := hatTemplate;
  HATypeInfo[linHsCommandTemplate           ] := hatTemplate;
  HATypeInfo[linHsValueTemplate             ] := hatTemplate;
  HATypeInfo[linJsonAttributesTemplate      ] := hatTemplate;
  HATypeInfo[linMaxMireds                   ] := hatInteger;
  HATypeInfo[linMinMireds                   ] := hatInteger;
  HATypeInfo[linOptimistic                  ] := hatBoolean;
  HATypeInfo[linQos                         ] := hatInteger;
  HATypeInfo[linRetain                      ] := hatBoolean;
  HATypeInfo[linRgbCommandTemplate          ] := hatTemplate;
  HATypeInfo[linRgbValueTemplate            ] := hatTemplate;
  HATypeInfo[linRgbwCommandTemplate         ] := hatTemplate;
  HATypeInfo[linRgbwValueTemplate           ] := hatTemplate;
  HATypeInfo[linRgbwwCommandTemplate        ] := hatTemplate;
  HATypeInfo[linRgbwwValueTemplate          ] := hatTemplate;
  HATypeInfo[linStateValueTemplate          ] := hatTemplate;
  HATypeInfo[linWhiteScale                  ] := hatInteger;
  HATypeInfo[linXyCommandTemplate           ] := hatTemplate;
  HATypeInfo[linXyValueTemplate             ] := hatTemplate;
end.
