{
  https://www.home-assistant.io/integrations/lock.mqtt/
  Version 2024.12.1
}
{$mode Delphi}
unit mqLock;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ELockNames = lonConfig..lonValueTemplate;
  {
    lonConfig,
    lonAvailabilityMode,
    lonAvailabilityTemplate,
    lonAvailabilityTopic,
    lonCodeFormat,
    lonCommandTemplate,
    lonCommandTopic,
    lonEnabledByDefault,
    lonEncoding,
    lonEntityCategory,
    lonIcon,
    lonJsonAttributesTemplate,
    lonJsonAttributesTopic,
    lonName,
    lonObjectId,
    lonOptimistic,
    lonPayloadAvailable,
    lonPayloadLock,
    lonPayloadNotAvailable,
    lonPayloadUnlock,
    lonPayloadOpen,
    lonPayloadReset,
    lonQos,
    lonRetain,
    lonStateJammed,
    lonStateLocked,
    lonStateLocking,
    lonStateTopic,
    lonStateUnlocked,
    lonStateUnlocking,
    lonUniqueId,
    lonValueTemplate
  }

Const
  CLockNames : array [ELockNames] of string  = (
    'config',
    'availability_mode',
    'availability_template',
    'availability_topic',
    'code_format',
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
    'payload_available',
    'payload_lock',
    'payload_not_available',
    'payload_unlock',
    'payload_open',
    'payload_reset',
    'qos',
    'retain',
    'state_jammed',
    'state_locked',
    'state_locking',
    'state_topic',
    'state_unlocked',
    'state_unlocking',
    'unique_id',
    'value_template'
  );

Type
  { TMQTTLock }
  TMQTTLock = Class(TMQTTBaseObject)
    private
    public
      State : Boolean; //True -> Locked

      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTLock }
constructor TMQTTLock.Create;
begin
  Inherited Create;
  FClass := hdcLock;
  FConfig.Add(CLockNames, []);
  FTopics := [Ord(lonConfig), Ord(lonCommandTopic), Ord(lonStateTopic)];
  FConfig[CLockNames[lonCommandTopic]] := 'set'; //required

  FConfig[CLockNames[lonPayloadLock           ]] := 'LOCK';
  FConfig[CLockNames[lonPayloadUnlock         ]] := 'UNLOCK';
  FConfig[CLockNames[lonPayloadOpen           ]] := ''; //no default
  FConfig[CLockNames[lonPayloadReset          ]] := 'None';
  FConfig[CLockNames[lonStateJammed           ]] := 'JAMMED';
  FConfig[CLockNames[lonStateLocked           ]] := 'LOCKED';
  FConfig[CLockNames[lonStateLocking          ]] := 'LOCKING';
  FConfig[CLockNames[lonStateUnlocked         ]] := 'UNLOCKED';
  FConfig[CLockNames[lonStateUnlocking        ]] := 'UNLOCKING';

  FConfigTopic  := lonConfig;
  FStateTopic   := lonStateTopic;
  FCommandTopic := lonCommandTopic;
end;

function TMQTTLock.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ELockNames))) or (AConfigItem > Ord(High(ELockNames))) then Exit;
  Result := CLockNames[ELockNames(AConfigItem)];
end; //FromEnumToString

function TMQTTLock.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := lonConfig to lonValueTemplate do begin
    if AName = CLockNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTLock.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CLockNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[lonAvailabilityTemplate      ] := hatTemplate;
  HATypeInfo[lonCommandTemplate           ] := hatTemplate;
  HATypeInfo[lonEnabledByDefault          ] := hatBoolean;
  HATypeInfo[lonJsonAttributesTemplate    ] := hatTemplate;
  HATypeInfo[lonOptimistic                ] := hatBoolean;
  HATypeInfo[lonQos                       ] := hatInteger;
  HATypeInfo[lonRetain                    ] := hatBoolean;
  HATypeInfo[lonValueTemplate             ] := hatTemplate;
end.
