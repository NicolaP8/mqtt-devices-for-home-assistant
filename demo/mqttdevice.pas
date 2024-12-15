{
  MQTT Abstract Device for Home Assistant: use descendants!
  Version 2024.12.15
}
{$I+,R+,Q+}
{$MODE DELPHI}
Unit mqttDevice;

Interface

Uses
  Classes, SysUtils, Contnrs, mqtt;

Const
  cfgHomeAssistant      = 'homeassistant';
  cfgConfigTopic        = 'config';

  cfgHABirthTopic   : string  = 'homeassistant/status'; //default
  cfgHABirthPayload : string  = 'online';
  cfgHABirthSubId   : integer = 100; //is constant to be used in case stmt
  cfgHALWTTopic     : string  = 'homeassistant/status';
  cfgHALWTPayload   : string  = 'offline';
  cfgHALWTSubId     : integer = 101;

    
Type
  TBroker = record
    Host     : string;
    Port     : integer; //1883
    ID       : string; //client ID
    User     : string;
    Pass     : string;
    SSL      : boolean;
  end;

  EHATypeInfo = (
    hatString,    //default == 0 == not initialized!
    hatBoolean,
    hatInteger,
    hatList,
    hatMap,
    hatTemplate
  );

  EHADeviceClasses = (
    hdcBinarySensor, hdcButton, hdcCover, hdcDeviceTrigger, hdcFan, hdcLight, hdcLock, hdcSensor,
    hdcSwitch, hdcTagScanner, hdcText, hdcUpdate, hdcValve
  );

  //common
  EDeviceNames = (
    dnDevice_ConfigurationUrl, dnDevice_HWVersion, dnDevice_Identifiers, dnDevice_Manufacturer, dnDevice_Model,
    dnDevice_ModelID, dnDevice_Name, dnDevice_SerialNumber, dnDevice_SuggestedArea, dnDevice_SWVersion
  );

  EAvailabilityNames = (
    anPayloadAvailable, anPayloadNotAvailable, anTopic, anValueTemplate
  );

  EAllNames = (
    eanNone, //used in FromStringToEnum for the not found value

  //Binary Sensor https://www.home-assistant.io/integrations/binary_sensor.mqtt/
    bsnConfig,              //the config topic MUST be the first of each block
    bsnAvailabilityMode,
    bsnAvailabilityTemplate,
    bsnAvailabilityTopic,
    bsnDeviceClass,
    bsnEnabledByDefault,
    bsnEncoding,
    bsnEntityCategory,
    bsnExpireAfter,
    bsnForceUpdate,
    bsnIcon,
    bsnJsonAttributesTemplate,
    bsnJsonAttributesTopic,
    bsnName,
    bsnObjectId,
    bsnOffDelay,
    bsnPayloadAvailable,
    bsnPayloadNotAvailable,
    bsnPayloadOff,
    bsnPayloadOn,
    bsnQos,
    bsnStateTopic,
    bsnUniqueId,
    bsnValueTemplate,

  //Button https://www.home-assistant.io/integrations/button.mqtt/
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
    bnValueTemplate,

  //Cover https://www.home-assistant.io/integrations/cover.mqtt/
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
    cnValueTemplate,

  //EDeviceTriggerNames //https://www.home-assistant.io/integrations/device_trigger.mqtt/
    dtnConfig,
    dtnAutomationType,
    dtnPayload,
    dtnQos,
    dtnTopic,
    dtnType,
    dtnSubtype,
    dtnValueTemplate,

  //EFanNames https://www.home-assistant.io/integrations/fan.mqtt/
    fnConfig,
    fnAvailabilityMode,
    fnAvailabilityTemplate,
    fnAvailabilityTopic,
    fnCommandTemplate,
    fnCommandTopic,
    fnEnabledByDefault,
    fnEncoding,
    fnEntityCategory,
    fnIcon,
    fnJsonAttributesTemplate,
    fnJsonAttributesTopic,
    fnName,
    fnObjectId,
    fnOptimistic,
    fnDirectionCommandTemplate,
    fnDirectionCommandTopic,
    fnDirectionStateTopic,
    fnDirectionValueTemplate,
    fnOscillationCommandTemplate,
    fnOscillationCommandTopic,
    fnOscillationStateTopic,
    fnOscillationValueTemplate,
    fnPayloadAvailable,
    fnPayloadNotAvailable,
    fnPayloadOff,
    fnPayloadOn,
    fnPayloadOscillationOff,
    fnPayloadOscillationOn,
    fnPayloadResetPercentage,
    fnPayloadResetPresetMode,
    fnPercentageCommandTemplate,
    fnPercentageCommandTopic,
    fnPercentageStateTopic,
    fnPercentageValueTemplate,
    fnPresetModeCommandTemplate,
    fnPresetModeCommandTopic,
    fnPresetModeStateTopic,
    fnPresetModeValueTemplate,
    fnPresetModes,
    fnQos,
    fnRetain,
    fnSpeedRangeMax,
    fnSpeedRangeMin,
    fnStateTopic,
    fnUniqueId,
    fnValueTemplate,

  //ELightNames https://www.home-assistant.io/integrations/light.mqtt/
    linConfig,
    linAvailabilityMode,
    linAvailabilityTemplate,
    linAvailabilityTopic,
    linBrightnessCommandTopic,
    linBrightnessCommandTemplate,
    linBrightnessScale,
    linBrightnessStateTopic,
    linBrightnessValueTemplate,
    linColorModeStateTopic,
    linColorModeValueTemplate,
    linColorTempCommandTemplate,
    linColorTempCommandTopic,
    linColorTempStateTopic,
    linColorTempValueTemplate,
    linCommandTopic,
    linEnabledByDefault,
    linEncoding,
    linEntityCategory,
    linEntityPicture,
    linEffectCommandTopic,
    linEffectCommandTemplate,
    linEffectList,
    linEffectStateTopic,
    linEffectValueTemplate,
    linHsCommandTemplate,
    linHsCommandTopic,
    linHsStateTopic,
    linHsValueTemplate,
    linIcon,
    linJsonAttributesTemplate,
    linJsonAttributesTopic,
    linMaxMireds,
    linMinMireds,
    linName,
    linObjectId,
    linOnCommandType,
    linOptimistic,
    linPayloadAvailable,
    linPayloadNotAvailable,
    linPayloadOn,
    linPayloadOff,
    linQos,
    linRetain,
    linRgbCommandTemplate,
    linRgbCommandTopic,
    linRgbStateTopic,
    linRgbValueTemplate,
    linRgbwCommandTemplate,
    linRgbwCommandTopic,
    linRgbwStateTopic,
    linRgbwValueTemplate,
    linRgbwwCommandTemplate,
    linRgbwwCommandTopic,
    linRgbwwStateTopic,
    linRgbwwValueTemplate,
    linSchema,
    linStateTopic,
    linStateValueTemplate,
    linUniqueId,
    linWhiteCommandTopic,
    linWhiteScale,
    linXyCommandTemplate,
    linXyCommandTopic,
    linXyStateTopic,
    linXyValueTemplate,

  //ELockNames https://www.home-assistant.io/integrations/lock.mqtt/
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
    lonValueTemplate,

  // ESensorNames https://www.home-assistant.io/integrations/sensor.mqtt/
    snConfig,
    snAvailabilityMode,
    snAvailabilityTemplate,
    snAvailabilityTopic,
    snDeviceClass,
    snEnabledByDefault,
    snEncoding,
    snEntityCategory,
    snExpireAfter,
    snForceUpdate,
    snIcon,
    snJsonAttributesTemplate,
    snJsonAttributesTopic,
    snLastResetValueTemplate,
    snName,
    snObjectId,
    snPayloadAvailable,
    snPayloadNotAvailable,
    snSuggestedDisplayPrecision,
    snQos,
    snStateClass,
    snStateTopic,
    snUniqueId,
    snUnitOfMeasurement,
    snValueTemplate,

  //ESwitchNames
    swnConfig,
    swnAvailabilityMode,
    swnAvailabilityTemplate,
    swnAvailabilityTopic,
    swnCommandTemplate,
    swnCommandTopic,
    swnDeviceClass,
    swnEnabledByDefault,
    swnEncoding,
    swnEntityCategory,
    swnIcon,
    swnJsonAttributesTemplate,
    swnJsonAttributesTopic,
    swnName,
    swnObjectId,
    swnOptimistic,
    swnPayloadAvailable,
    swnPayloadNotAvailable,
    swnPayloadOff,
    swnPayloadOn,
    swnQos,
    swnRetain,
    swnStateOff,
    swnStateOn,
    swnStateTopic,
    swnUniqueId,
    swnValueTemplate,

  //ETagScannerNames https://www.home-assistant.io/integrations/tag.mqtt/
    tsnConfig,
    tsnTopic,
    tsnValueTemplate,

  //ETextNames https://www.home-assistant.io/integrations/text.mqtt/
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
    tnValueTemplate,

  //EUpdateNames https://www.home-assistant.io/integrations/update.mqtt/
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
    unValueTemplate,

  //EValveNames //https://www.home-assistant.io/integrations/valve.mqtt/
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
    vnStateStopped,
    vnStateTopic,
    vnUniqueId,
    vnValueTemplate
  );

Const
  //Note that the DeviceTrigger uses a different class name
  CHADeviceClasseNames : array[EHADeviceClasses] of string = (
    'binary_sensor', 'button', 'cover', 'device_automation', 'fan', 'light', 'lock', 'sensor',
    'switch', 'tag', 'text', 'update', 'valve'
  );

  CDeviceNames : array [EDeviceNames] of string  = (
    'configuration_url',
    'hw_version',
    'identifiers',
    'manufacturer',
    'model',
    'model_id',
    'name',
    'serial_number',
    'suggested_area',
    'sw_version'
  );

  CAvailabilityNames : array[EAvailabilityNames] of string = (
    'payload_available',
    'payload_not_available',
    'topic',                  //required
    'value_template'
  );

Var
  HATypeInfo : array[EAllNames] of EHATypeInfo; //MUST be initialized by objects

Type
  TMQTTBaseObject = class;

  { TValuePairs }
  TValuePairs = Class(TObject)
  private
    FNames, FValues : array of string;
    FCount : Integer;
    function GetNames(Index: integer): string;
    function GetValueAt(Index: integer): string;
  protected
    Procedure SetValues(Index:String; Const Value:String);
    Function GetValues(Index:String):String;
    Function GetCount:integer;
  public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Add(AName, AValue:string); Overload;
    Procedure Add(ANames, AValues:array of string); Overload;
    Function AtIndex(AName:string):Integer;

    Property Count:integer read GetCount;
    Property ValueAt[Index:integer]:string read GetValueAt;
    Property Names[Index:integer]:string read GetNames;

    Property Values[Index:string]:string read GetValues write SetValues; Default;
  end;


  TReadDataCallback = Function (Var AValue:string):Boolean of Object;

  { TMQTTCallBack } //Registered topics SubIds are unique for the MQTTClient
  TMQTTCallBack = record
    Topic : String;
    SubId : Integer;
  end;
  AMQTTCallBack = array of TMQTTCallBack;

  { TMQTTDevice } //The composite Device
  TMQTTDevice  = class(TObjectList)
  private
    FConfig : TValuePairs;
    FCallBacks : AMQTTCallBack;
    FReSubscribeOnConnect : Boolean; //done externally
    FReConnectOnDisconnect : Boolean;
    FUseBirth : Boolean;
    FUseLastWillAndTestament : Boolean;
    FClient : TMQTTClient;
    FBroker : TBroker;
  protected
    procedure SetUseBirth(AValue: Boolean);
    procedure SetUseLastWillAndTestament(AValue: Boolean);
    function GetItem(Const Index:Integer): TMQTTBaseObject;
    procedure SetItem(Const Index:Integer; AObject:TMQTTBaseObject);
    Function  CallBackIndexOf(Const ATopic: string): Integer;
    Procedure CallBackDelete(Const ANum:Integer);
  public
    Constructor Create;
    Destructor Destroy; Override;

    Function Connect:Boolean;
    Function CheckClient:Boolean;
    function Add(AObject:TMQTTBaseObject): Integer;
    function Remove(AObject:TMQTTBaseObject): Integer;
    function IndexOf(AObject:TMQTTBaseObject): Integer;
    Function BuildConfigJSON:string;

    Function Subscribe(ATopic:string; Const SubId:integer):Boolean;
    Function UnSubscribe(ATopic:string; Const Force:Boolean = False): Boolean;
    Procedure UnsubscribeAll;
    Procedure SubscribeAll;
    Procedure SendConfigAll;

    Property Broker:TBroker read FBroker write FBroker;
    Property Client:TMQTTClient read FClient write FClient;
    Property Config:TValuePairs read FConfig write FConfig;
    property Items[Index: Integer]: TMQTTBaseObject read GetItem write SetItem; default;
    Property ReSubscribeOnConnect:Boolean read FReSubscribeOnConnect write FReSubscribeOnConnect;
    Property ReConnectOnDisconnect:Boolean read FReConnectOnDisconnect write FReConnectOnDisconnect;
    Property UseBirth:Boolean read FUseBirth write SetUseBirth;
    Property UseLastWillAndTestament:Boolean read FUseLastWillAndTestament write SetUseLastWillAndTestament;
  end;

  { TAvailability }
  TAvailability  = class(TObject)
  private
    FConfig : TValuePairs;
  protected
  public
    Constructor Create;
    Destructor Destroy; Override;
    Function BuildConfigJSON:string;

    Property Config:TValuePairs read FConfig write FConfig;
  end;


  { TMQTTBaseObject } //A single sensor/switch/fan of the device, do not use it, use descendants!
  TMQTTBaseObject = class(TObject)
  private
  protected
    FParent : TMQTTDevice;
    FConfig : TValuePairs;
    FAvail : TAvailability;
    FConfigTopic : EAllNames;
    FStateTopic : EAllNames;
    FCommandTopic : EAllNames;
    FIDTopic : EAllNames;
    FTopics : array of integer; //populate at creation and never changed, small

    FRetain, FRetainConfig : boolean;
    FClass : EHADeviceClasses;
    FOnReadData : TReadDataCallback;
    FQoS: integer;
    FAddObjectId : Boolean;
    procedure SetDevice(AValue: TMQTTDevice);
  public
    Constructor Create;
    Destructor Destroy; Override;
    Function InTopics(Const AConfigItem:EAllNames):Boolean;
    Function TopicPrefix(Const AConfigItem:EAllNames):string;

    Function BuildConfigJSON:string; Virtual;
    Function SendConfig:Boolean;
    Function SendState:Boolean;
    Function SendStateTopic(Const AStateTopic:EAllNames; Const AValue:string):Boolean;
    Function Subscribe(ATopic:string; Const SubId:integer):Boolean; Overload;
    function Subscribe(ATopic: EAllNames; const SubId: integer): Boolean; Overload; Virtual; Abstract;
    Function UnSubscribe(ATopic:string):Boolean;

    Function FromEnumToString(AConfigItem:Integer):string; Virtual; Abstract;
    Function FromStringToEnum(AName:string):EAllNames; Virtual; Abstract;

    Property Config:TValuePairs read FConfig write FConfig;
    Property Availability:TAvailability read FAvail write FAvail;
    Property Device:TMQTTDevice read FParent write SetDevice;
    Property QoS:integer read FQoS write FQoS;
    Property Retain:Boolean read FRetain write FRetain;
    Property RetainConfig:Boolean read FRetainConfig write FRetainConfig;
    Property AddObjectId:Boolean read FAddObjectId write FAddObjectId;

    Property OnReadData:TReadDataCallback read FOnReadData write FOnReadData;
  end;



Implementation


//*************************************************************************************************
{ TValuePairs }
constructor TValuePairs.Create;
begin
  FNames := [];
  FValues := [];
  FCount := 0;
end; //Create

destructor TValuePairs.Destroy;
begin
  SetLength(FNames, 0);
  SetLength(FValues, 0);
  inherited Destroy;
end; //Destroy

procedure TValuePairs.SetValues(Index: String; const Value: String);
Var
  i : integer;
  e : EAllNames;
begin
  i := AtIndex(Index);
  if (i < 0) then Exit; //Raise
  FValues[i] := Value;
end; //SetValues

function TValuePairs.GetValues(Index: String): String;
Var
  i : integer;
begin
  Result := '';
  i := AtIndex(Index);
  if (i < 0) then Exit; //Raise
  Result := FValues[i];
end; //GetValues

function TValuePairs.GetCount: integer;
begin
  Result := FCount;
end; //GetCount

procedure TValuePairs.Add(AName, AValue: string);
begin
  //if FDuplicated then Raise @@@todo
  Inc(FCount);
  SetLength(FNames, FCount);
  SetLength(FValues, FCount);
  FNames[FCount -1] := AName;
  FValues[FCount -1] := AValue;
end; //Add

procedure TValuePairs.Add(ANames, AValues: array of string);
Var
  v, n, da : integer;
  i : integer;
begin
  n := Length(ANames);
  if (n = 0) then Exit;
  v := Length(AValues);
  da := FCount;
  FCount := FCount + n;
  SetLength(FNames, FCount);
  SetLength(FValues, FCount);
  for i := 0 to n -1 do begin
    FNames[da + i] := ANames[i];
    if v > i then FValues[da + i] := AValues[i]; //in questo modo posso passare un vettore vuoto e inizializzare lo stesso
  end;
end; //Add

function TValuePairs.AtIndex(AName: string): Integer;
Var
  i : integer;
begin //-1 : not found
  Result := -1;
  for i := 0 to FCount -1 do begin
    if CompareText(FNames[i], AName) = 0 then begin
      Result := i;
      Break;
    end;
  end; //for
end; //AtIndex

function TValuePairs.GetNames(Index: integer): string;
begin
  Result := '';
  if (Index < 0) or (Index >= FCount) then Exit; //@@@ Raise
  Result := FNames[Index];
end; //GetNames

function TValuePairs.GetValueAt(Index: integer): string;
begin
  Result := '';
  if (Index < 0) or (Index >= FCount) then Exit; //@@@ Raise
  Result := FValues[Index];
end; //GetValueAt

//*************************************************************************************************
{ TMQTTDevice }
constructor TMQTTDevice.Create;
begin
  Inherited Create;
  OwnsObjects := False;
  FClient := TMQTTClient.Create(Nil);
  FConfig := TValuePairs.Create;
  FConfig.Add(CDeviceNames, []);
  SetLength(FCallBacks, 0);
  FReSubscribeOnConnect := True;
  FReConnectOnDisconnect := True;
  FUseBirth := False; //@@@ todo
  FUseLastWillAndTestament := False; //@@@ todo
end; //Create

destructor TMQTTDevice.Destroy;
Var
  i : integer;
begin
  UnsubscribeAll;
  //@@@ todo: delete all items
  FreeAndNil(FConfig);
  FreeAndNil(FClient);
  Inherited Destroy;
end; //Destroy

function TMQTTDevice.Connect: Boolean;
Var
  me : TMQTTError;
begin //because the client ha only a "complex" function to connect
  //function Connect(Host: String; Port: Word; ID, User, Pass: String; SSL, CleanStart: Boolean): TMQTTError;
  me := FClient.Connect(FBroker.Host, FBroker.Port, FBroker.ID, FBroker.User, FBroker.Pass, FBroker.SSL, False);
  Result := (me = mqeNoError);
end; //Connect

function TMQTTDevice.CheckClient: Boolean;
begin
  Result := False;
  if not Assigned(FClient) then Exit;
  if not FClient.Connected then begin
    if FReConnectOnDisconnect then begin
      Connect;
      if not FClient.Connected then Exit;
    end else
      Exit;
  end;
  Result := True;
end; //CheckClient

function TMQTTDevice.Add(AObject: TMQTTBaseObject): Integer;
begin
  Result := Inherited Add(AObject);
end; //Add

function TMQTTDevice.Remove(AObject: TMQTTBaseObject): Integer;
begin
  Result := Inherited Remove(AObject);
end; //Remove

function TMQTTDevice.IndexOf(AObject: TMQTTBaseObject): Integer;
begin
  Result := Inherited IndexOf(AObject);
end; //IndexOf

procedure TMQTTDevice.SetUseBirth(AValue: Boolean);
begin
  if FUseBirth = AValue then Exit;
  FUseBirth := AValue;
  if FUseBirth then
    Subscribe(cfgHABirthTopic, cfgHABirthSubId)
  else
    Unsubscribe(cfgHABirthTopic);
end;

procedure TMQTTDevice.SetUseLastWillAndTestament(AValue: Boolean);
begin
  if FUseLastWillAndTestament = AValue then Exit;
  FUseLastWillAndTestament := AValue;
  if FUseLastWillAndTestament then
    Subscribe(cfgHALWTTopic, cfgHALWTSubId)
  else
    Unsubscribe(cfgHALWTTopic);
end;

function TMQTTDevice.GetItem(const Index: Integer): TMQTTBaseObject;
begin
  Result := TMQTTBaseObject(Inherited Items[Index]);
end; //GetItem

procedure TMQTTDevice.SetItem(const Index: Integer; AObject: TMQTTBaseObject);
begin
  Inherited Items[Index] := AObject;
end; //SetItem

function TMQTTDevice.CallBackIndexOf(const ATopic: string): Integer;
Var
  i : integer;
begin
  Result := -1;
  for i := Low(FCallBacks) to High(FCallBacks) do begin
    if (FCallBacks[i].Topic = ATopic) then begin
      Result := i;
      Exit;
    end; //if
  end; //for
end; //CallBackIndexOf

procedure TMQTTDevice.CallBackDelete(const ANum: Integer);
Var
  i : integer;
begin
  if (ANum < 0) or (ANum > High(FCallBacks)) then Exit;
  for i := ANum to High(FCallBacks) -1 do begin
    FCallBacks[i].Topic := FCallBacks[i +1].Topic;
    FCallBacks[i].SubId := FCallBacks[i +1].SubId;
  end; //for
  FCallBacks[High(FCallBacks)].Topic := '';
  SetLength(FCallBacks, Length(FCallBacks) -1);
end; //CallBackDelete

procedure TMQTTDevice.UnsubscribeAll;
Var
  i : integer;
begin
  if not CheckClient then Exit;
  for i := 0 to Length(FCallBacks) -1 do begin
    FClient.UnSubscribe(FCallBacks[i].Topic); //@@@ ignore errors
    FCallBacks[i].Topic := '';
  end;
  SetLength(FCallBacks, 0);
end; //UnsubscribeAll

procedure TMQTTDevice.SubscribeAll;
Var
  i : integer;
begin
  if not CheckClient then Exit;
  if not Assigned(FCallBacks) then Exit;
  for i := 0 to Length(FCallBacks) -1 do
    Subscribe(FCallBacks[i].Topic, Integer(FCallBacks[i].SubId));
end;

procedure TMQTTDevice.SendConfigAll;
Var
  i : integer;
begin
  for i := 0 to Count -1 do begin
    TMQTTBaseObject(Inherited Items[i]).SendConfig;
    {$IFDEF LINUX}
      CheckSynchronize;
    {$ENDIF}
  end;
end;

function TMQTTDevice.Subscribe(ATopic: string; const SubId: integer): Boolean;
Var
  n : integer;
  me : TMQTTError;
begin
  Result := False;
  if ATopic = '' then Exit;
//register the subscription even if not connected
  n := CallBackIndexOf(ATopic); //Already subscribed?
  if n < 0 then begin
    n := Length(FCallBacks);
    SetLength(FCallBacks, n + 1);
    FCallBacks[n].Topic := ATopic;
    FCallBacks[n].SubId := SubId; //@@@ no check on uniqueness
  end else begin
    FCallBacks[n].SubId := SubId; //@@@ what if was different?
  end; //if                        //QoS

  if not CheckClient then Exit;
  me := FClient.Subscribe(ATopic, 1, SubID);
  Result := (me = mqeNoError);
end; //Subscribe

function TMQTTDevice.UnSubscribe(ATopic: string; const Force: Boolean): Boolean;
Var
  n : integer;
  me : TMQTTError;
begin
  Result := False;
  if not CheckClient then Exit;
  if ATopic = '' then Exit;
  n := CallBackIndexOf(ATopic); //Already subscribed?
  if (n < 0) and not Force then
      Exit; //@@@ or try to unsubscribe in any case?
  CallBackDelete(n); //no need to check for range here
  me := FClient.UnSubscribe(ATopic);
  Result := (me = mqeNoError);
end; //UnSubscribe

function TMQTTDevice.BuildConfigJSON:string;
Var
  i : integer;
  c, s, t, u : string;
begin
(*
"identifiers": ["Name_of_the_Device"],
"manufacturer": "Raspberry Pi",
"model": "Raspberry Pi Zero W Rev 1.2",
"name": "short_name",
"sw_version": "Raspbian GNU/Linux 12 (bookworm)"
*)
  Result := '';
  c := '';
  for i := 0 to FConfig.Count -1 do begin
    s := FConfig.Names[i];
    t := FConfig.ValueAt[i];
    if (s = '') or (t = '') then Continue;

    if (s = CDeviceNames[dnDevice_Identifiers]) then begin
      u := Format('"%s": ["%s"]', [s, t]);
    end else begin
      u := Format('"%s": "%s"', [s, t]);
    end; //if

    if (c <> '') then c := c + ', ';
    c := c + u;
  end; //for
  if c <> '' then
    c := '"device": {' + c + '}';
  Result := c;
end; //BuildConfigJSON

//*************************************************************************************************
{ TAvailability }
constructor TAvailability.Create;
begin
  FConfig := TValuePairs.Create;
  FConfig.Add(CAvailabilityNames, []);
end;

destructor TAvailability.Destroy;
begin
  FreeAndNil(FConfig);
  inherited Destroy;
end;

function TAvailability.BuildConfigJSON: string;
Var
  i : integer;
  c, s, t, u : string;
begin
  Result := '';
  c := '';
  for i := 0 to FConfig.Count -1 do begin
    s := FConfig.Names[i];
    t := FConfig.ValueAt[i];
    if (s = '') or (t = '') then Continue;

    u := Format('"%s": "%s"', [s, t]);
    if (c <> '') then c := c + ', ';
    c := c + u;
  end; //for
  if c <> '' then
    c := '"availability": [{' + c + '}]';
  Result := c;
end; //BuildConfigJSON

procedure TMQTTBaseObject.SetDevice(AValue: TMQTTDevice);
begin
  if FParent = AValue then Exit;
  if not Assigned(AValue) then begin
    FParent.Remove(Self);
  end else begin
    AValue.Add(Self);
  end;
  FParent := AValue;
end; //SetDevice

//*************************************************************************************************
{ TMQTTBaseObject }
constructor TMQTTBaseObject.Create;
begin
  FQoS    := 0;
  FRetain := False;
  FRetainConfig := True;
  FConfig := TValuePairs.Create;
  FAvail  := TAvailability.Create;
  FAddObjectId := True;
  SetLength(FTopics, 0);

  //FConfigTopic  := ; //Must be set in descendants
  //FStateTopic   := ;
  //FCommandTopic := ;
  //FIDTopic := ;
end; //Create

destructor TMQTTBaseObject.Destroy;
begin
  SetLength(FTopics, 0);
  FreeAndNil(FConfig);
  FreeAndNil(FAvail);
  inherited Destroy;
end; //Destroy

function TMQTTBaseObject.InTopics(const AConfigItem: EAllNames): Boolean;
Var
  i : integer;
begin
  for i := Low(FTopics) to High(FTopics) do begin
    if (FTopics[i] = Ord(AConfigItem)) then begin
      Result := True;
      Exit;
    end; //if
  end; //for
  Result := False;
end; //InTopics

function TMQTTBaseObject.TopicPrefix(const AConfigItem: EAllNames): string;
Var
  v : string;
begin
  if Assigned(FParent) and InTopics(AConfigItem) then begin
    Result := Format('%s/%s/%s/', [
      cfgHomeAssistant,
      CHADeviceClasseNames[FClass],
      FParent.Config[CDeviceNames[dnDevice_Identifiers]] //@@@
      ]);
    if FAddObjectId and (FIDTopic <> eanNone) then
      v := FConfig.Values[FromEnumToString(Ord(FIDTopic))];
      if v <> '' then
        Result := Result + v + '/';
  end else begin
    Result := '';
  end; //if
end; //TopicPath

function TMQTTBaseObject.BuildConfigJSON: string;
Var
  i, j : integer;
  c, s, t, u : string;
  n : integer;
  b : boolean;
  m : EAllNames;
begin
  Result := '';
  try
    //add device json
    if Assigned(FParent) then begin
      c := FParent.BuildConfigJSON;
    end;
    //Availability
    u := FAvail.BuildConfigJSON;
    if u <> '' then begin
      if (c <> '') then c := c + ', ';
      c := c + u;
    end;

    for i := 0 to FConfig.Count -1 do begin
      s := FConfig.Names[i];
      t := FConfig.ValueAt[i];
      if (s = '') or (t = '') then Continue;
      if (s = 'config') then continue;

      b := False; //the topic is from the set of that can be subscribed?
      for j := Low(FTopics) to High(FTopics) do begin
        if s = FromEnumToString(FTopics[j]) then begin
          if FAddObjectId and (FIDTopic <> eanNone) then begin
            u := FConfig.Values[FromEnumToString(Ord(FIDTopic))];
            if u <> '' then
              t :=  u + '/' + t;
          end;
          t := Format('%s/%s/%s/%s', [
            cfgHomeAssistant,
            CHADeviceClasseNames[FClass],
            FParent.Config[CDeviceNames[dnDevice_Identifiers]],
            t]);
          b := True;
          Break;
        end;
      end; //for

      if b then
        m := EAllNames(FTopics[j])
      else
        m := FromStringToEnum(s);
      case HATypeInfo[m] of
        //@@@to do: complex types...
        hatString, hatList, hatMap, hatTemplate : u := Format('"%s": "%s"', [s, t]);
        hatBoolean : u := Format('"%s": %s', [s, t]);
        hatInteger : u := Format('"%s": %s', [s, t]);
      end; //case
      if (c <> '') then c := c + ', ';
      c := c + u;
    end; //for

    c := '{' + c + '}';
    Result := c;
  except
    on E:Exception do ;
  end;
end; //BuildConfigJSON

function TMQTTBaseObject.SendConfig:Boolean;
Var
  cfgtop, topic, cfgmsg : string;
  me : TMQTTError;
begin
  Result := False;
  if not Assigned(FParent) then Exit;
  cfgmsg := BuildConfigJSON;
  if cfgmsg = '' then Exit;
  cfgtop := FConfig.Values['config'];
  if cfgtop = '' then begin
    cfgtop := 'config';
  end;
  topic := TopicPrefix(FConfigTopic) + cfgtop;
  me := FParent.Client.Publish(Topic, cfgmsg, FQoS, FRetainConfig);
  Result := (me = mqeNoError);
end; //SendConfig

function TMQTTBaseObject.SendState:Boolean;
Var
  topic, value : string;
  me : TMQTTError;
begin
  Result := False;
  if not Assigned(FParent) then Exit;
  if Assigned(FOnReadData) then begin
    if not FOnReadData(value) then Exit;
    topic := TopicPrefix(FStateTopic) + FConfig.Values[FromEnumToString(Ord(FStateTopic))];
    me := FParent.FClient.Publish(Topic, Value, FQoS, FRetain);
    Result := (me = mqeNoError);
  end;
end; //SendState

function TMQTTBaseObject.SendStateTopic(Const AStateTopic:EAllNames; Const AValue:string):Boolean;
Var
  topic : string;
  me : TMQTTError;
begin
  Result := False;
  if not Assigned(FParent) then Exit;
  topic := TopicPrefix(AStateTopic) + FConfig.Values[FromEnumToString(Ord(AStateTopic))];
  me := FParent.FClient.Publish(Topic, AValue, FQoS, FRetain);
  Result := (me = mqeNoError);
end; //SendStateTopic

function TMQTTBaseObject.Subscribe(ATopic: string; const SubId: integer): Boolean;
begin
  Result := False;
  if not Assigned(FParent) then Exit;
  Result := FParent.Subscribe(ATopic, SubId);
end; //Subscribe

function TMQTTBaseObject.UnSubscribe(ATopic: string): Boolean;
Var
  i, n : integer;
  me : TMQTTError;
begin
  Result := False;
  if not Assigned(FParent) then Exit;
  Result := FParent.UnSubscribe(ATopic);
end; //UnSubscribe

Initialization
  HATypeInfo[eanNone] := hatString;
Finalization
end.
