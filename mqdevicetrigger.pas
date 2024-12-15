{
  https://www.home-assistant.io/integrations/device_trigger.mqtt/
  Version 2024.12.155
}
{$mode Delphi}
unit mqDeviceTrigger;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  EDeviceTriggerNames = dtnConfig..dtnValueTemplate;
  {
    dtnConfig,
    dtnAutomationType,
    dtnPayload,
    dtnQos,
    dtnTopic,
    dtnType,
    dtnSubtype,
    dtnValueTemplate
  }

  EDeviceTriggerType = (
    dttButtonShortPress,
    dttButtonShortRelease,
    dttButtonLongPress,
    dttButtonLongRelease,
    dttButtonDoublePress,
    dttButtonTriplePress,
    dttButtonQuadruplePress,
    dttButtonQuintuplePress
  );

  EDeviceTriggerSubtype = (
    dtsTurnOn,
    dtsTurnOff,
    dtsButton1,
    dtsButton2,
    dtsButton3,
    dtsButton4,
    dtsButton5,
    dtsButton6
  );

Const
  CDeviceTriggerNames : array [EDeviceTriggerNames] of string  = (
    'config',
    'automation_type',
    'payload',
    'qos',
    'topic',
    'type',
    'subtype',
    'value_template'
  );

  CDeviceTriggerType : array [EDeviceTriggerType] of string  = (
    'button_short_press',
    'button_short_release',
    'button_long_press',
    'button_long_release',
    'button_double_press',
    'button_triple_press',
    'button_quadruple_press',
    'button_quintuple_press'
  );

  CDeviceTriggerSubtype : array [EDeviceTriggerSubtype] of string  = (
    'turn_on',
    'turn_off',
    'button_1',
    'button_2',
    'button_3',
    'button_4',
    'button_5',
    'button_6'
  );

Type
  { TMQTTDeviceTrigger }
  TMQTTDeviceTrigger = Class(TMQTTBaseObject)
    private
    public
      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTDeviceTrigger }
constructor TMQTTDeviceTrigger.Create;
begin
  Inherited Create;
  FClass := hdcDeviceTrigger;
  FConfig.Add(CDeviceTriggerNames, []);
  FTopics := [Ord(dtnConfig), Ord(dtnTopic)];

  FConfig[CDeviceTriggerNames[dtnAutomationType]] := 'trigger'; //required
  FConfig[CDeviceTriggerNames[dtnTopic]]          := 'trigger';
  FConfig[CDeviceTriggerNames[dtnType]]           := 'button_short_press';
  FConfig[CDeviceTriggerNames[dtnSubtype]]        := CDeviceTriggerSubtype[dtsTurnOn];

  FConfigTopic  := dtnConfig;
  //FStateTopic   := not used
  //FCommandTopic := not used
  FIDTopic      := eanNone;
end;

function TMQTTDeviceTrigger.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(EDeviceTriggerNames))) or (AConfigItem > Ord(High(EDeviceTriggerNames))) then Exit;
  Result := CDeviceTriggerNames[EDeviceTriggerNames(AConfigItem)];
end; //FromEnumToString

function TMQTTDeviceTrigger.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := dtnConfig to dtnValueTemplate do begin
    if AName = CDeviceTriggerNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTDeviceTrigger.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CDeviceTriggerNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe


Initialization
  HATypeInfo[dtnQos           ] := hatInteger;
  HATypeInfo[dtnValueTemplate ] := hatTemplate;
end.
