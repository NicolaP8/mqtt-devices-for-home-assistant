{
  https://www.home-assistant.io/integrations/update.mqtt/
  Version 2024.12.15
}
{$mode Delphi}
unit mqUpdate;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  EUpdateNames = unConfig..unValueTemplate;
  {
    unConfig,
    unAvailabilityTopic,
    unAvailabilityMode,
    unAvailabilityTemplate,
    unCommandTopic,
    unDeviceClass,
    unDisplayPrecision,
    unEnabledByDefault,
    unEncoding,
    unEntityCategory,
    unEntityPicture,
    unIcon,
    unJsonAttributesTemplate,
    unJsonAttributesTopic,
    unLatestVersionTemplate,
    unLatestVersionTopic,
    unName,
    unObjectId,
    unPayloadInstall,
    unQos,
    unReleaseSummary,
    unReleaseUrl,
    unRetain,
    unStateTopic,
    unTitle,
    unUniqueId,
    unValueTemplate
  }

Const
  CUpdateNames : array [EUpdateNames] of string  = (
    'config',
    'availability_topic',
    'availability_mode',
    'availability_template',
    'command_topic',
    'device_class',
    'display_precision',
    'enabled_by_default',
    'encoding',
    'entity_category',
    'entity_picture',
    'icon',
    'json_attributes_template',
    'json_attributes_topic',
    'latest_version_template',
    'latest_version_topic',
    'name',
    'object_id',
    'payload_install',
    'qos',
    'release_summary',
    'release_url',
    'retain',
    'state_topic',
    'title',
    'unique_id',
    'value_template'
  );

Type
  { TMQTTUpdate }
  TMQTTUpdate = Class(TMQTTBaseObject)
    private
    public
      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTUpdate }
constructor TMQTTUpdate.Create;
begin
  Inherited Create;
  FClass := hdcUpdate;
  FConfig.Add(CUpdateNames, []);
  FTopics := [Ord(unConfig), Ord(unCommandTopic), Ord(unLatestVersionTopic), Ord(unStateTopic)];

  FConfig[CUpdateNames[unDisplayPrecision]] := '0';

  FConfigTopic  := unConfig;
  FStateTopic   := unStateTopic;
  FCommandTopic := unCommandTopic;
  FIDTopic      := unObjectId;
end;

function TMQTTUpdate.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EUpdateNames))) or (AConfigItem > Ord(High(EUpdateNames))) then Exit;
  Result := CUpdateNames[EUpdateNames(AConfigItem)];
end; //FromEnumToString

function TMQTTUpdate.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := unConfig to unValueTemplate do begin
    if AName = CUpdateNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTUpdate.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CUpdateNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[unAvailabilityTemplate   ] := hatTemplate;
  HATypeInfo[unDisplayPrecision       ] := hatInteger;
  HATypeInfo[unEnabledByDefault       ] := hatBoolean;
  HATypeInfo[unJsonAttributesTemplate ] := hatTemplate;
  HATypeInfo[unLatestVersionTemplate  ] := hatTemplate;
  HATypeInfo[unQos                    ] := hatInteger;
  HATypeInfo[unRetain                 ] := hatBoolean;
  HATypeInfo[unValueTemplate          ] := hatTemplate;
end.
