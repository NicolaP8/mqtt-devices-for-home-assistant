{
  https://www.home-assistant.io/integrations/cover.mqtt/
  Version 2024.12.1
}
{$mode Delphi}
unit mqCover;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ECoverNames = cnConfig..cnValueTemplate;
  {
    cnConfig,
    cnAvailabilityMode,
    cnAvailabilityTemplate,
    cnAvailabilityTopic,
    cnCommandTopic,
    cnDeviceClass,
    cnEnabledByDefault,
    cnEncoding,
    cnEntityCategory,
    cnIcon,
    cnJsonAttributesTemplate,
    cnJsonAttributesTopic,
    cnName,
    cnObjectId,
    cnOptimistic,
    cnPayloadAvailable,
    cnPayloadClose,
    cnPayloadNotAvailable,
    cnPayloadOpen,
    cnPayloadStop,
    cnPositionClosed,
    cnPositionOpen,
    cnPositionTemplate,
    cnPositionTopic,
    cnQos,
    cnRetain,
    cnSetPositionTemplate,
    cnSetPositionTopic,
    cnStateClosed,
    cnStateClosing,
    cnStateOpen,
    cnStateOpening,
    cnStateStopped,
    cnStateTopic,
    cnTiltClosedValue,
    cnTiltCommandTemplate,
    cnTiltCommandTopic,
    cnTiltMax,
    cnTiltMin,
    cnTiltOpenedValue,
    cnTiltOptimistic,
    cnTiltStatusTemplate,
    cnTiltStatusTopic,
    cnUniqueId,
    cnValueTemplate
  }

  ECoverDeviceClass = (
    cdcNone,
    cdcAwning,
    cdcBlind,
    cdcCurtain,
    cdcDamper,
    cdcDoor,
    cdcGarage,
    cdcGate,
    cdcShade,
    cdcShutter,
    cdcWindow
  );

Const
    CCoverNames : array [ECoverNames] of string  = (
    'config',
    'availability_mode',
    'availability_template',
    'availability_topic',
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
    'payload_close',
    'payload_not_available',
    'payload_open',
    'payload_stop',
    'position_closed',
    'position_open',
    'position_template',
    'position_topic',
    'qos',
    'retain',
    'set_position_template',
    'set_position_topic',
    'state_closed',
    'state_closing',
    'state_open',
    'state_opening',
    'state_stopped',
    'state_topic',
    'tilt_closed_value',
    'tilt_command_template',
    'tilt_command_topic',
    'tilt_max',
    'tilt_min',
    'tilt_opened_value',
    'tilt_optimistic',
    'tilt_status_template',
    'tilt_status_topic',
    'unique_id',
    'value_template'
  );

  CCoverDeviceClass : array [ECoverDeviceClass] of string  = (
    'None',
    'awning',
    'blind',
    'curtain',
    'damper',
    'door',
    'garage',
    'gate',
    'shade',
    'shutter',
    'window'
  );

Type
  ECoverStates = (ecsClosed, ecsClosing, ecsOpen, ecsOpening, ecsStopped);

Const //@@@compiler bug: need to reinitialize in Initialization
  ECoverStatesNames : array [ECoverStates] of ECoverNames = (
    cnStateClosed, cnStateClosing, cnStateOpen, cnStateOpening, cnStateStopped
  );

Type
  { TMQTTCover }
  TMQTTCover = Class(TMQTTBaseObject)
    private
    public
      State : ECoverStates; //only for convenience
      Position : integer;
      Tilt : integer;

      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTCover }
constructor TMQTTCover.Create;
begin
  Inherited Create;
  FClass := hdcCover;
  FConfig.Add(CCoverNames, []);
  FTopics := [Ord(cnConfig), Ord(cnCommandTopic), Ord(cnPositionTopic), Ord(cnSetPositionTopic),
    Ord(cnStateTopic), Ord(cnTiltCommandTopic), Ord(cnTiltStatusTopic)];

  FConfig[CCoverNames[cnPayloadClose]] := 'CLOSE';
  FConfig[CCoverNames[cnPayloadOpen]] := 'OPEN';
  FConfig[CCoverNames[cnPayloadStop]] := 'STOP';
  FConfig[CCoverNames[cnPositionClosed]] := '0'; //integer
  FConfig[CCoverNames[cnPositionOpen]] := '100';
  FConfig[CCoverNames[cnStateClosed]] := 'closed';
  FConfig[CCoverNames[cnStateClosing]] := 'closing';
  FConfig[CCoverNames[cnStateOpen]] := 'open';
  FConfig[CCoverNames[cnStateOpening]] := 'opening';
  FConfig[CCoverNames[cnStateStopped]] := 'stopped';
  FConfig[CCoverNames[cnTiltClosedValue]] := '0';
  FConfig[CCoverNames[cnTiltMax]] := '100';
  FConfig[CCoverNames[cnTiltMin]] := '0';
  FConfig[CCoverNames[cnTiltOpenedValue]] := '100';

  FConfigTopic  := cnConfig;
  FStateTopic   := cnStateTopic; //also cnPositionTopic and cnTiltStatusTopic
  FCommandTopic := cnCommandTopic;
end;

function TMQTTCover.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ECoverNames))) or (AConfigItem > Ord(High(ECoverNames))) then Exit;
  Result := CCoverNames[ECoverNames(AConfigItem)];
end; //FromEnumToString

function TMQTTCover.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := cnConfig to cnValueTemplate do begin
    if AName = CCoverNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTCover.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CCoverNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe


Initialization
  ECoverStatesNames[ecsClosed]  := cnStateClosed;
  ECoverStatesNames[ecsClosing] := cnStateClosing;
  ECoverStatesNames[ecsOpen]    := cnStateOpen;
  ECoverStatesNames[ecsOpening] := cnStateOpening;
  ECoverStatesNames[ecsStopped] := cnStateStopped;

  HATypeInfo[cnAvailabilityTemplate]    := hatTemplate;
  HATypeInfo[cnEnabledByDefault]        := hatBoolean;
  HATypeInfo[cnJsonAttributesTemplate]  := hatTemplate;
  HATypeInfo[cnOptimistic]              := hatBoolean;
  HATypeInfo[cnPositionClosed]          := hatInteger;
  HATypeInfo[cnPositionOpen]            := hatInteger;
  HATypeInfo[cnPositionTemplate]        := hatTemplate;
  HATypeInfo[cnQos]                     := hatInteger;
  HATypeInfo[cnRetain]                  := hatBoolean;
  HATypeInfo[cnSetPositionTemplate]     := hatTemplate;
  HATypeInfo[cnTiltClosedValue]         := hatInteger;
  HATypeInfo[cnTiltCommandTemplate]     := hatTemplate;
  HATypeInfo[cnTiltMax]                 := hatInteger;
  HATypeInfo[cnTiltMin]                 := hatInteger;
  HATypeInfo[cnTiltOpenedValue]         := hatInteger;
  HATypeInfo[cnTiltOptimistic]          := hatBoolean;
  HATypeInfo[cnTiltStatusTemplate]      := hatTemplate;
  HATypeInfo[cnValueTemplate]           := hatTemplate;
end.
