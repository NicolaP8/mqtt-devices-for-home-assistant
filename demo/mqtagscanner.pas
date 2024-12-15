{
  https://www.home-assistant.io/integrations/tag.mqtt/
  Version 2024.12.15
}
{$mode Delphi}
unit mqTagScanner;

interface

Uses
  Classes, SysUtils, mqttDevice;

Type
  ETagScannerNames = tsnConfig..tsnValueTemplate;
  {
    tsnConfig,
    tsnTopic,
    tsnValueTemplate
  }

Const
  CTagScannerNames : array [ETagScannerNames] of string  = (
    'config',
    'topic',
    'value_template'
  );

Type
  { TMQTTTagScanner }
  TMQTTTagScanner = Class(TMQTTBaseObject)
    private
    public
      Constructor Create;
      function FromEnumToString(AConfigItem:Integer):string; Override;
      function FromStringToEnum(AName: string): EAllNames; Override;
      function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Override;
  end;


implementation


{ TMQTTTagScanner }
constructor TMQTTTagScanner.Create;
begin
  Inherited Create;
  FClass := hdcTagScanner;
  FConfig.Add(CTagScannerNames, []);
  FTopics := [Ord(tsnConfig), Ord(tsnTopic)];
  FConfig[CTagScannerNames[tsnTopic]] := 'state'; //required

  FConfigTopic  := tsnConfig;
  //FStateTopic   := not used
  //FCommandTopic := not used
  //FIDTopic      := not used
end;

function TMQTTTagScanner.FromEnumToString(AConfigItem:Integer):string;
begin
  Result := '';
  if (AConfigItem < Ord(Low(ETagScannerNames))) or (AConfigItem > Ord(High(ETagScannerNames))) then Exit;
  Result := CTagScannerNames[ETagScannerNames(AConfigItem)];
end; //FromEnumToString

function TMQTTTagScanner.FromStringToEnum(AName: string): EAllNames;
Var
  m : EAllNames;
begin
  Result := eanNone;
  for m := tsnConfig to tsnValueTemplate do begin
    if AName = CTagScannerNames[m] then begin
      Result := m;
      Break;
    end;
  end; //for
end; //FromStringToEnum

function TMQTTTagScanner.Subscribe(ATopic: EAllNames; const SubId: integer): Boolean;
Var
  CompleteTopic : string;
begin
  Result := False;
  if not Assigned(FParent) then Exit; //        **********
  CompleteTopic := TopicPrefix(ATopic) + Config[CTagScannerNames[ATopic]];
  Result := FParent.Subscribe(CompleteTopic, SubId);
end; //Subscribe

Initialization
  HATypeInfo[tsnValueTemplate] := hatTemplate;
end.
