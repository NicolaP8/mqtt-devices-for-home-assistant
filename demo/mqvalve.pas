{
  https://www.home-assistant.io/integrations/valve.mqtt/
  Version 2024.12.15
}
{$mode Delphi}
unit mqValve;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  EValveNames = vnConfig..vnValueTemplate;
  {
    vnConfig,
    vnAvailabilityMode,
    vnAvailabilityTemplate,
    vnAvailabilityTopic,
    vnCommandTemplate,
    vnCommandTopic,
    vnDeviceClass,
    vnEnabledByDefault,
    vnEncoding,
    vnEntityCategory,
    vnIcon,
    vnJsonAttributesTemplate,
    vnJsonAttributesTopic,
    vnName,
    vnObjectId,
    vnOptimistic,
    vnPayloadAvailable,
    vnPayloadClose,
    vnPayloadNotAvailable,
    vnPayloadOpen,
    vnPayloadStop,
    vnPositionClosed,
    vnPositionOpen,
    vnQos,
    vnReportsPosition,
    vnRetain,
    vnStateClosed,
    vnStateClosing,
    vnStateOpen,
    vnStateOpening,
    vnStateStopped, //@@@ not existing yet
    vnStateTopic,
    vnUniqueId,
    vnValueTemplate
  }

Const
  CValveNames : array [EValveNames] of string  = (
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
    'optimistic',
    'payload_available',
    'payload_close',
    'payload_not_available',
    'payload_open',
    'payload_stop',
    'position_closed',
    'position_open',
    'qos',
    'reports_position',
    'retain',
    'state_closed',
    'state_closing',
    'state_open',
    'state_opening',
    'state_stopped',
    'state_topic',
    'unique_id',
    'value_template'
  );

Type                                                         //@@@this is yet missing in HA
  EValveStates = (evsClosed, evsClosing, evsOpen, evsOpening, evsStopped);

Const //@@@compiler bug: need to reinitialize in Initialization
  EValveStatesNames : array [EValveStates] of EValveNames = (
    vnStateClosed, vnStateClosing, vnStateOpen, vnStateOpening, vnStateStopped
  );

Type
  { TMQTTValve }
  TMQTTValve = Class(TMQTTBaseObject)
    private
    public
      State : EValveStates;
      Position : integer;
      ReportsPosition : Boolean;

      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;

      Function JSONState:string;
  end;


implementation


{ TMQTTValve }
constructor TMQTTValve.Create;
begin
  Inherited Create;
  FClass := hdcValve;
  FConfig.Add(CValveNames, []);
  FTopics := [Ord(vnConfig), Ord(vnCommandTopic), Ord(vnStateTopic)];

  FConfig[CValveNames[vnPositionClosed]] := '0';
  FConfig[CValveNames[vnPositionOpen]] := '100';

  ReportsPosition := False;
  FConfig[CValveNames[vnReportsPosition]] := 'false'; //if true the following has to be empty
  FConfig[CValveNames[vnPayloadClose]] := 'CLOSE';
  FConfig[CValveNames[vnPayloadOpen]] := 'OPEN';
  //FConfig[CValveNames[vnPayloadStop]] := 'STOP'; //no default
  FConfig[CValveNames[vnStateClosed]] := 'closed';
  FConfig[CValveNames[vnStateClosing]] := 'closing';
  FConfig[CValveNames[vnStateOpen]] := 'open';
  FConfig[CValveNames[vnStateOpening]] := 'opening';
  FConfig[CValveNames[vnStateStopped]] := 'stopped';

  FConfigTopic  := vnConfig;
  FStateTopic   := vnStateTopic;
  FCommandTopic := vnCommandTopic;
  FIDTopic      := vnObjectId;
end;

function TMQTTValve.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EValveNames))) or (AConfigItem > Ord(High(EValveNames))) then Exit;
  Result := CValveNames[EValveNames(AConfigItem)];
end; //FromEnumToString

function TMQTTValve.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := vnConfig to vnValueTemplate do begin
    if AName = CValveNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTValve.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CValveNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

function TMQTTValve.JSONState: string;
begin //{"state": "opening", "position": 10}
  Result := Format('{"state":"%s", "position": %d}',
    [
    FConfig[CValveNames[EValveStatesNames[State]]],
    Position
    ]);
end;

Initialization
  EValveStatesNames[evsClosed] := vnStateClosed;
  EValveStatesNames[evsClosing] := vnStateClosing;
  EValveStatesNames[evsOpen] := vnStateOpen;
  EValveStatesNames[evsOpening] := vnStateOpening;
  EValveStatesNames[evsStopped] := vnStateStopped;

  HATypeInfo[vnAvailabilityTemplate   ] := hatTemplate;
  HATypeInfo[vnCommandTemplate        ] := hatTemplate;
  HATypeInfo[vnEnabledByDefault       ] := hatBoolean;
  HATypeInfo[vnJsonAttributesTemplate ] := hatTemplate;
  HATypeInfo[vnOptimistic             ] := hatBoolean;
  HATypeInfo[vnPositionClosed         ] := hatInteger;
  HATypeInfo[vnPositionOpen           ] := hatInteger;
  HATypeInfo[vnQos                    ] := hatInteger;
  HATypeInfo[vnReportsPosition        ] := hatBoolean;
  HATypeInfo[vnRetain                 ] := hatBoolean;
  HATypeInfo[vnValueTemplate          ] := hatTemplate;
end.
