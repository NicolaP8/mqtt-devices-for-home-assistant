{
  https://www.home-assistant.io/integrations/time.mqtt/
  Version 2026.05.07

  State:
  Command: The MQTT topic to publish the time value that is set in ISO format.
}
{$mode Delphi}
unit mqtime;

interface

Uses
  Classes, SysUtils, mqttDevice, DateUtils ; //DateUtils  is not used here but I put to remember that exists!

Type
  ETimeNames = ttConfig..ttValueTemplate;
  {
    ttConfig,
    ttAvailabilityMode,
    ttAvailabilityTemplate,
    ttAvailabilityTopic,
    ttCommandTemplate,
    ttCommandTopic,
    ttDefaultEntityId,
    ttEnabledByDefault,
    ttEncoding,
    ttEntityCategory,
    ttEntityPicture,
    ttIcon,
    ttJsonAttributesTemplate,
    ttJsonAttributesTopic,
    ttName,
    ttPlatform,
    ttQos,
    ttRetain,
    ttStateTopic,
    ttUniqueId,
    ttValueTemplate
  }

Const
  CTimeNames : array [ETimeNames] of string  = (
    'config',
    'availability_mode',
    'availability_template',
    'availability_topic',
    'command_template',
    'command_topic',
    'default_entity_id',
    'enabled_by_default',
    'encoding',
    'entity_category',
    'entity_picture',
    'icon',
    'json_attributes_template',
    'json_attributes_topic',
    'name',
    'platform',
    'qos',
    'retain',
    'state_topic',
    'unique_id',
    'value_template'
  );

Type
  { TMQTTTime }
  TMQTTTime = Class(TMQTTBaseObject)
    private
    public
      Value : TDateTime;

      Constructor Create;
      Function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTTime }
constructor TMQTTTime.Create;
begin
  Inherited Create;
  FClass := hdcTime;
  FConfig.Add(CTimeNames, []);
  FTopics := [Ord(ttConfig), Ord(ttStateTopic), Ord(ttCommandTopic)];

  FConfig[CTimeNames[ttCommandTopic]] := 'set'; //required
  FConfig[CTimeNames[ttPlatform]] := 'time'; //required
  FConfig[CTimeNames[ttStateTopic]] := 'state';

  FConfigTopic  := ttConfig;
  FStateTopic   := ttStateTopic;
  FCommandTopic := ttCommandTopic;
  FIDTopic      := ttUniqueId;
end;

function TMQTTTime.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ETimeNames))) or (AConfigItem > Ord(High(ETimeNames))) then Exit;
  Result := CTimeNames[ETimeNames(AConfigItem)];
end; //FromEnumToString

function TMQTTTime.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := Low(ETimeNames) to High(ETimeNames) do begin
    if AName = CTimeNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTTime.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CTimeNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[ttCommandTemplate]           := hatTemplate;
  HATypeInfo[ttEnabledByDefault]          := hatBoolean;
  HATypeInfo[ttJsonAttributesTemplate]    := hatTemplate;
  HATypeInfo[ttQos]                       := hatInteger;
  HATypeInfo[ttRetain]                    := hatBoolean;
  HATypeInfo[ttValueTemplate]             := hatTemplate;
end.
