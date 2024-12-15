{
  https://www.home-assistant.io/integrations/text.mqtt/
  Version 2024.12.1 - initial release

  2024.12.15
    added
      + text and maxlen variables
}
{$mode Delphi}
unit mqText;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ETextNames = tnConfig..tnValueTemplate;
  {
    tnConfig,
    tnAvailabilityTopic,
    tnAvailabilityMode,
    tnAvailabilityTemplate,
    tnCommandTemplate,
    tnCommandTopic,
    tnEnabledByDefault,
    tnEncoding,
    tnEntityCategory,
    tnEntityPicture,
    tnJsonAttributesTemplate,
    tnJsonAttributesTopic,
    tnMax,
    tnMin,
    tnMode,
    tnName,
    tnObjectId,
    tnPattern,
    tnQos,
    tnRetain,
    tnStateTopic,
    tnUniqueId,
    tnValueTemplate
  }

Const
  CTextNames : array [ETextNames] of string  = (
    'config',
    'availability_topic',
    'availability_mode',
    'availability_template',
    'command_template',
    'command_topic',
    'enabled_by_default',
    'encoding',
    'entity_category',
    'entity_picture',
    'json_attributes_template',
    'json_attributes_topic',
    'max',
    'min',
    'mode',
    'name',
    'object_id',
    'pattern',
    'qos',
    'retain',
    'state_topic',
    'unique_id',
    'value_template'
  );

Type
  { TMQTTText }
  TMQTTText = Class(TMQTTBaseObject)
    private
    public
      Text : string;
      MaxLen : integer;

      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTText }
constructor TMQTTText.Create;
begin
  Inherited Create;
  FClass := hdcText;
  FConfig.Add(CTextNames, []);
  FTopics := [Ord(tnConfig), Ord(tnCommandTopic), Ord(tnStateTopic)];
  FConfig[CTextNames[tnCommandTopic]] := 'state'; //required

  FConfig[CTextNames[tnMax]] := '255';
  FConfig[CTextNames[tnMin]] := '0';
  FConfig[CTextNames[tnMode]] := 'text'; //or 'password'

  FConfigTopic  := tnConfig;
  FStateTopic   := tnStateTopic;
  FCommandTopic := tnCommandTopic;
  FIDTopic      := tnObjectId;

  MaxLen := 255;
end;

function TMQTTText.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ETextNames))) or (AConfigItem > Ord(High(ETextNames))) then Exit;
  Result := CTextNames[ETextNames(AConfigItem)];
end; //FromEnumToString

function TMQTTText.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := tnConfig to tnValueTemplate do begin
    if AName = CTextNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTText.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CTextNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[tnAvailabilityTemplate   ] := hatTemplate;
  HATypeInfo[tnCommandTemplate        ] := hatTemplate;
  HATypeInfo[tnEnabledByDefault       ] := hatBoolean;
  HATypeInfo[tnJsonAttributesTemplate ] := hatTemplate;
  HATypeInfo[tnMax                    ] := hatInteger;
  HATypeInfo[tnMin                    ] := hatInteger;
  HATypeInfo[tnQos                    ] := hatInteger;
  HATypeInfo[tnRetain                 ] := hatBoolean;
  HATypeInfo[tnValueTemplate          ] := hatTemplate;
end.
