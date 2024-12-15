{
  https://www.home-assistant.io/integrations/button.mqtt/
  Version 2024.12.15
}
{$mode Delphi}
unit mqButton;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  EButtonNames = bnConfig..bnValueTemplate;
  {
    bnConfig,
    bnAvailabilityMode,
    bnAvailabilityTemplate,
    bnAvailabilityTopic,
    bnCommandTemplate,
    bnCommandTopic,
    bnDeviceClass,
    bnEnabledByDefault,
    bnEncoding,
    bnEntityCategory,
    bnIcon,
    bnJsonAttributesTemplate,
    bnJsonAttributesTopic,
    bnName,
    bnObjectId,
    bnPayloadAvailable,
    bnPayloadNotAvailable,
    bnPayloadPress,
    bnQos,
    bnRetain,
    bnUniqueId,
    bnValueTemplate
  }

  EButtonDeviceClass = ( //bnDeviceClass
    bdcNone,
    bdcIdentify,
    bdcRestart,
    bdcUpdate
  );

Const
  CButtonNames : array[EButtonNames] of string = (
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
    'payload_available',
    'payload_not_available',
    'payload_press',
    'qos',
    'retain',
    'unique_id',
    'value_template'
  );

  CButtonDeviceClass : array [EButtonDeviceClass] of string = (
    'None',
    'identify',
    'restart',
    'update'
  );

Type
  { TMQTTButton }
  TMQTTButton = Class(TMQTTBaseObject)
    private
    public
      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation

{ TMQTTButton }
constructor TMQTTButton.Create;
begin
  Inherited Create;
  FClass := hdcButton;
  FConfig.Add(CButtonNames, []);
  FTopics := [Ord(bnConfig), Ord(bnCommandTopic)];

  FConfig[CButtonNames[bnCommandTopic]] := 'set'; //required
  FConfig[CButtonNames[bnPayloadPress]] := 'PRESS';

  FConfigTopic  := bnConfig;
  //FStateTopic   := not used
  FCommandTopic := bnCommandTopic;
  FIDTopic      := bnObjectId;
end;

function TMQTTButton.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EButtonNames))) or (AConfigItem > Ord(High(EButtonNames))) then Exit;
  Result := CButtonNames[EButtonNames(AConfigItem)];
end; //FromEnumToString

function TMQTTButton.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := bnConfig to bnValueTemplate do begin
    if AName = CButtonNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTButton.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit;
  CompleteTopic := TopicPrefix(ATopic) + Config[CButtonNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[bnAvailabilityTemplate]    := hatTemplate;
  HATypeInfo[bnEnabledByDefault]        := hatTemplate;
  HATypeInfo[bnJsonAttributesTemplate]  := hatTemplate;
  HATypeInfo[bnQos]                     := hatInteger;
  HATypeInfo[bnRetain]                  := hatBoolean;
  HATypeInfo[bnValueTemplate]           := hatTemplate;
end.
