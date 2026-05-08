{
  https://www.home-assistant.io/integrations/date.mqtt/
  Version 2026.05.07

  State: The MQTT topic subscribed to receive date state updates. Date state updates should contain
    a parsable date string, e.a. ‘2025-12-01’ or ‘1 March 2025’. If a date/time structure is passed, only the date component will be used.
  Command: The MQTT topic to publish the date value that is set in ISO format.
}
{$mode Delphi}
unit mqdate;

interface

Uses
  Classes, SysUtils, mqttDevice, DateUtils ; //DateUtils  is not used here but I put to remember that exists!

Type
  EDateNames = ddConfig..ddValueTemplate;
  {
    ddAvailabilityMode,
    ddAvailabilityTemplate,
    ddAvailabilityTopic,
    ddCommandTemplate,
    ddCommandTopic,
    ddDefaultEntityId,
    ddEnabledByDefault,
    ddEncoding,
    ddEntityCategory,
    ddEntityPicture,
    ddJsonAttributesTemplate,
    ddJsonAttributesTopic,
    ddName,
    ddPlatform,
    ddQos,
    ddRetain,
    ddStateTopic,
    ddUniqueId,
    ddValueTemplate
  }

Const
  CDateNames : array [EDateNames] of string  = (
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
  { TMQTTDate }
  TMQTTDate = Class(TMQTTBaseObject)
    private
    public
      Value : TDateTime;

      Constructor Create;
      Function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTDate }
constructor TMQTTDate.Create;
begin
  Inherited Create;
  FClass := hdcDate;
  FConfig.Add(CDateNames, []);
  FTopics := [Ord(ddConfig), Ord(ddStateTopic), Ord(ddCommandTopic)];

  FConfig[CDateNames[ddCommandTopic]] := 'set'; //required
  FConfig[CDateNames[ddPlatform]] := 'date'; //required
  FConfig[CDateNames[ddStateTopic]] := 'state';

  FConfigTopic  := ddConfig;
  FStateTopic   := ddStateTopic;
  FCommandTopic := ddCommandTopic;
  FIDTopic      := ddUniqueId;
end;

function TMQTTDate.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EDateNames))) or (AConfigItem > Ord(High(EDateNames))) then Exit;
  Result := CDateNames[EDateNames(AConfigItem)];
end; //FromEnumToString

function TMQTTDate.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := Low(EDateNames) to High(EDateNames) do begin
    if AName = CDateNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTDate.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CDateNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[ddCommandTemplate]           := hatTemplate;
  HATypeInfo[ddEnabledByDefault]          := hatBoolean;
  HATypeInfo[ddJsonAttributesTemplate]    := hatTemplate;
  HATypeInfo[ddQos]                       := hatInteger;
  HATypeInfo[ddRetain]                    := hatBoolean;
  HATypeInfo[ddValueTemplate]             := hatTemplate;
end.
