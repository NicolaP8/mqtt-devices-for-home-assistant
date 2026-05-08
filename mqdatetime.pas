{
  https://www.home-assistant.io/integrations/datetime.mqtt/
  Version 2026.05.07

  State: The MQTT topic subscribed to receive date/time state updates. Date state updates should contain
    a parsable date string, e.a. ‘2025-12-01’ or ‘1 March 2025’. If a time structure is passed, the current date will be will be used.
  Command: The MQTT topic to publish the date/time value that is set in ISO format.
}
{$mode Delphi}
unit mqdatetime;

interface

Uses
  Classes, SysUtils, mqttDevice, DateUtils ; //DateUtils  is not used here but I put to remember that exists!

Type
  EDateTimeNames = dtConfig..dtValueTemplate;
  {
    dtConfig,
    dtAvailabilityMode,
    dtAvailabilityTemplate,
    dtAvailabilityTopic,
    dtCommandTemplate,
    dtCommandTopic,
    dtDefaultEntityId,
    dtEnabledByDefault,
    dtEncoding,
    dtEntityCategory,
    dtEntityPicture,
    dtJsonAttributesTemplate,
    dtJsonAttributesTopic,
    dtName,
    dtPlatform,
    dtQos,
    dtRetain,
    dtStateTopic,
    dtTimezone,
    dtUniqueId,
    dtValueTemplate
  }

Const
  CDateTimeNames : array [EDateTimeNames] of string  = (
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
    'timezone',
    'unique_id',
    'value_template'
  );

Type
  { TMQTTDateTime }
  TMQTTDateTime = Class(TMQTTBaseObject)
    private
    public
      Value : TDateTime;

      Constructor Create;
      Function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTDateTime }
constructor TMQTTDateTime.Create;
begin
  Inherited Create;
  FClass := hdcDateTime;
  FConfig.Add(CDateTimeNames, []);
  FTopics := [Ord(dtConfig), Ord(dtStateTopic), Ord(dtCommandTopic)];

  FConfig[CDateTimeNames[dtCommandTopic]] := 'set'; //required
  FConfig[CDateTimeNames[dtPlatform]] := 'datetime'; //required
  FConfig[CDateTimeNames[dtStateTopic]] := 'state';

  FConfigTopic  := dtConfig;
  FStateTopic   := dtStateTopic;
  FCommandTopic := dtCommandTopic;
  FIDTopic      := dtUniqueId;
end;

function TMQTTDateTime.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EDateTimeNames))) or (AConfigItem > Ord(High(EDateTimeNames))) then Exit;
  Result := CDateTimeNames[EDateTimeNames(AConfigItem)];
end; //FromEnumToString

function TMQTTDateTime.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := Low(EDateTimeNames) to High(EDateTimeNames) do begin
    if AName = CDateTimeNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTDateTime.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CDateTimeNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[dtCommandTemplate]           := hatTemplate;
  HATypeInfo[dtEnabledByDefault]          := hatBoolean;
  HATypeInfo[dtJsonAttributesTemplate]    := hatTemplate;
  HATypeInfo[dtQos]                       := hatInteger;
  HATypeInfo[dtRetain]                    := hatBoolean;
  HATypeInfo[dtValueTemplate]             := hatTemplate;
end.
