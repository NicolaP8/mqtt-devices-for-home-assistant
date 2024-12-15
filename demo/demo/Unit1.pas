{
  Demo
  Version 2024.12.15
}
{$I+,R+,Q+,H+}
{$MODE DELPHI}
Unit Unit1;

Interface

Uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, TypInfo, IniFiles,
  mqtt, opensslsockets, mqttDevice,
  mqBinarySensor, mqButton, mqCover, mqDeviceTrigger, mqFan, mqLight, mqLock, mqSensor, mqSwitch,
  mqTagScanner, mqText, mqUpdate, mqValve;

Const
  cfgVersion                  = '2024.12.15';
  cfgDeviceName     : string  = 'HADemo';
  cfgDeviceID       : string  = 'hademo';
  cfgSerialNumber : integer = 1;

  cfgMqttHost     : string  = '';
  cfgMqttPort     : integer = 1883;
  cfgMqttID       : string  = '';
  cfgMqttUser     : string  = '';
  cfgMqttPass     : string  = '';
  cfgMqttSSL      : boolean = False;

  cfgTextMaxLength = 40;

Type
  ESubIds = (
    subIDButtonCommand,
    subIDCoverCommand,
    subIDCoverPosition,
    subIDCoverTilt,
    subIDDeviceTriggerCommand,
    subIDFanCommand,
    subIDFanDirection,
    subIDFanOscillate,
    subIDFanSpeed,
    subIDLightBrightness,
    subIDLightPower,
    subIDLockCommand,
    subIDSensorCommand,
    subIDSwitchCommand,
    subIDTagScannerCommand,
    subIDTextCommand,
    subIDUpdateCommand,
    subIDValveCommand
  );

Type
  { TForm1 }
  TForm1 = class(TForm)
    bValveClose: TButton;
    bValveOpen: TButton;
    bCoverStop: TButton;
    bCoverClose: TButton;
    bConfig: TButton;
    bConnect: TButton;
    bCoverOpen: TButton;
    bValveStop: TButton;
    bUpdate: TButton;
    cbBinarySensor: TCheckBox;
    cbFanOscillation: TCheckBox;
    cbLock: TCheckBox;
    cbSwitch: TCheckBox;
    cbFanState: TCheckBox;
    cbLight: TCheckBox;
    eText: TEdit;
    gbCover: TGroupBox;
    gbValve: TGroupBox;
    gbFan: TGroupBox;
    lText: TLabel;
    lSensor: TLabel;
    Memo: TMemo;
    Panel1: TPanel;
    rgFanDirection: TRadioGroup;
    shButton: TShape;
    stCoverPosition: TStaticText;
    stValvePosition: TStaticText;
    stValveState: TStaticText;
    stCoverTilt: TStaticText;
    stCoverState: TStaticText;
    tbValvePosition: TTrackBar;
    Timer: TTimer;
    TimerCover: TTimer;
    tbFanSpeed: TTrackBar;
    tbLight: TTrackBar;
    tbCoverPosition: TTrackBar;
    tbCoverTilt: TTrackBar;
    tbSensor: TTrackBar;
    TimerValve: TTimer;
    procedure bConfigClick(Sender: TObject);
    procedure bConnectClick(Sender: TObject);
    procedure bCoverCloseClick(Sender: TObject);
    procedure bCoverOpenClick(Sender: TObject);
    procedure bCoverStopClick(Sender: TObject);
    procedure bUpdateClick(Sender: TObject);
    procedure bValveCloseClick(Sender: TObject);
    procedure bValveOpenClick(Sender: TObject);
    procedure bValveStopClick(Sender: TObject);
    procedure cbBinarySensorClick(Sender: TObject);
    procedure cbFanOscillationChange(Sender: TObject);
    procedure cbFanStateChange(Sender: TObject);
    procedure cbLightChange(Sender: TObject);
    procedure cbLockChange(Sender: TObject);
    procedure cbSwitchClick(Sender: TObject);
    procedure eTextKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgFanDirectionClick(Sender: TObject);
    procedure tbCoverPositionChange(Sender: TObject);
    procedure tbCoverTiltChange(Sender: TObject);
    procedure tbFanSpeedChange(Sender: TObject);
    procedure tbLightChange(Sender: TObject);
    procedure tbValvePositionChange(Sender: TObject);
    procedure TimerCoverTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure tbSensorChange(Sender: TObject);
    procedure TimerValveTimer(Sender: TObject);
  private
    IsClosing : Boolean;

    Function BinarySensorData(Var AValue:string):Boolean;
    Procedure DoButtonCommand(ACmd:string);
    Function CoverData(Var AValue:string):Boolean;
    procedure DoCoverCommand(ACmd:string);
    procedure DoCoverPosition(ACmd:string);
    procedure DoCoverTilt(ACmd:string);
    procedure CoverUpdate;
    procedure DoDeviceTrigger(ACmd:string);
    Function FanData(Var AValue:string):Boolean;
    procedure DoFanCommand(ACmd:string);
    procedure DoFanDirection(ACmd:string);
    procedure DoFanOscillate(ACmd:string);
    procedure FanSendOscillate;
    procedure FanUpdateSpeed;
    procedure LightUpdateState;
    procedure LightUpdateBrightness;
    procedure DoFanSpeed(ACmd:string);
    procedure DoLightBrightness(ACmd:string);
    procedure DoLightPower(ACmd:string);
    procedure DoLockCommand(ACmd:string);
    Function LockData(Var AValue:string):Boolean;
    Function SensorData(Var AValue:string):Boolean;
    Function SwitchData(Var AValue:string):Boolean;
    Procedure SwitchCommand(ACmd:string);
    Function TextData(Var AValue:string):Boolean;
    Procedure DoTextCommand(ACmd:string);
    Function UpdateData(Var AValue:string):Boolean;
    Procedure DoUpdateCommand(ACmd:string);
    Function ValveData(Var AValue:string):Boolean;
    Procedure DoValveCommand(ACmd:string);

    procedure DoBirthEvent(ACmd:string);
    procedure DoLWTEvent(ACmd:string);
    procedure CreateDevice;
    procedure Debug(Txt: String);
    procedure OnDisconnect(Client: TMQTTClient);
    procedure OnConnect(Client: TMQTTClient);
    procedure OnReceive(Client: TMQTTClient; Msg: TMQTTRXData);
    procedure OnVerifySSL(Client: TMQTTClient; Handler: TOpenSSLSocketHandler; var Allow: Boolean);
    procedure OnDebug(Txt: String);
  public
    MyDevice : TMQTTDevice;

    BinarySensor  : TMQTTBinarySensor;
    Button        : TMQTTButton;
    Cover         : TMQTTCover;
    DeviceTrigger : TMQTTDeviceTrigger;
    Fan           : TMQTTFan;
    Light         : TMQTTLight;
    Lock          : TMQTTLock;
    Sensor        : TMQTTSensor;
    Switch        : TMQTTSwitch;
    TagScanner    : TMQTTTagScanner;
    Text          : TMQTTText;
    Update        : TMQTTUpdate;
    Valve         : TMQTTValve;
  end;

Var
  Form1: TForm1;

Implementation

{$R *.lfm}

Var
  //Object data used by demo, not part of internal data
  SensorValue : Double;
  CoverInternalModify : Boolean;


//*****************************************************************************
procedure TForm1.cbBinarySensorClick(Sender: TObject);
begin
  //cbBinarySensor.Checked := not cbBinarySensor.Checked; //this is automatic
  if Assigned(BinarySensor) then BinarySensor.SendState;
end;

Function TForm1.BinarySensorData(Var AValue:string):Boolean;
begin
  if cbBinarySensor.Checked then
    AValue := BinarySensor.Config[CBinarySensorNames[bsnPayloadOff]]
  else
    AValue := BinarySensor.Config[CBinarySensorNames[bsnPayloadOn]];
  Result := True;
end; //BinarySensorData

//*****************************************************************************
Procedure TForm1.DoButtonCommand(ACmd:string);
begin
  if (ACmd = Button.Config[CButtonNames[bnPayloadPress]]) then begin
    Debug('Button pressed: ' + ACmd);
    shButton.Brush.Color := clRed;
  end else
    Debug(ACmd);
end; //DoButtonCommand

//*****************************************************************************
Function TForm1.CoverData(Var AValue:string):Boolean;
begin
  AValue := Cover.Config[CCoverNames[ECoverStatesNames[Cover.State]]];
  Result := True;
end; //CoverData

procedure TForm1.DoCoverCommand(ACmd:string);
begin
  {
    OnReceive: QoS 0 1 0 homeassistant/cover/demo_device_000/set = CLOSE
    OnReceive: QoS 0 1 0 homeassistant/cover/demo_device_000/set = OPEN
    OnReceive: QoS 0 1 0 homeassistant/cover/demo_device_000/set = STOP
  }
  if (ACmd = Cover.Config[CCoverNames[cnPayloadOpen]]) then
    bCoverOpenClick(Self)
  else if (ACmd = Cover.Config[CCoverNames[cnPayloadClose]]) then
    bCoverCloseClick(Self)
  else if (ACmd = Cover.Config[CCoverNames[cnPayloadStop]]) then
    bCoverStopClick(Self)
  else
    Debug(ACmd);
end; //DoCoverCommand

procedure TForm1.DoCoverPosition(ACmd:string);
Var
  newpos : integer;
begin
  {
    OnReceive: QoS 0 2 0 homeassistant/cover/demo_device_000/setposition = 59
    OnReceive: QoS 0 2 0 homeassistant/cover/demo_device_000/setposition = 35
  }
  newpos := StrToIntDef(ACmd, Cover.Position);
  if newpos <> Cover.Position then
    tbCoverPosition.Position := newpos;
end; //DoCoverPosition

procedure TForm1.DoCoverTilt(ACmd:string);
Var
  newtilt : integer;
begin
  {
    OnReceive: QoS 0 3 0 homeassistant/cover/demo_device_000/tilt = 100
    OnReceive: QoS 0 3 0 homeassistant/cover/demo_device_000/tilt = 0
  }
  newtilt := StrToIntDef(ACmd, Cover.Tilt);
  if newTilt <> Cover.Tilt then
    tbCoverTilt.Position := newTilt;
end; //DoCoverTilt

procedure TForm1.CoverUpdate;
begin
  //Cover.SendState; //next line the alternative
  Cover.SendStateTopic(cnStateTopic, Cover.Config[CCoverNames[ECoverStatesNames[Cover.State]]]);

  Cover.SendStateTopic(cnPositionTopic, IntToStr(Cover.Position));
  Cover.SendStateTopic(cnTiltStatusTopic, IntToStr(Cover.Tilt));

  //update user interface
  stCoverPosition.Caption := IntToStr(Cover.Position);
  stCoverTilt.Caption := IntToStr(Cover.Tilt);
  stCoverState.Caption := Cover.Config[CCoverNames[ECoverStatesNames[Cover.State]]];
end; //CoverUpdate

procedure TForm1.bCoverCloseClick(Sender: TObject);
begin
  if Cover.State in [ecsClosed, ecsClosing] then Exit;
  Cover.State := ecsClosing;
  TimerCover.Enabled := True;
  CoverUpdate;
end;

procedure TForm1.bCoverOpenClick(Sender: TObject);
begin
  if Cover.State in [ecsOpen, ecsOpening] then Exit;
  Cover.State := ecsOpening;
  TimerCover.Enabled := True;
  CoverUpdate;
end;

procedure TForm1.bCoverStopClick(Sender: TObject);
begin
  if not(Cover.State in [ecsOpening, ecsClosing]) then Exit;
  TimerCover.Enabled := False;
  Cover.State := ecsStopped;
  CoverUpdate;
end;

procedure TForm1.tbCoverPositionChange(Sender: TObject);
begin
  if CoverInternalModify then Exit;
  Cover.Position := tbCoverPosition.Position;
  if tbCoverPosition.Position = 0 then begin
    Cover.State := ecsClosed;
    CoverUpdate;
    Exit;
  end else if tbCoverPosition.Position = 100 then begin
    Cover.State := ecsOpen;
    CoverUpdate;
    Exit;
  end;
  Cover.SendStateTopic(cnPositionTopic, IntToStr(Cover.Position));
  stCoverPosition.Caption := IntToStr(Cover.Position);
end;

procedure TForm1.tbCoverTiltChange(Sender: TObject);
begin
  if CoverInternalModify then Exit;
  Cover.Tilt := tbCoverTilt.Position;
  Cover.SendStateTopic(cnTiltStatusTopic, IntToStr(Cover.Tilt));
  stCoverTilt.Caption := IntToStr(Cover.Tilt);
end;

procedure TForm1.TimerCoverTimer(Sender: TObject);
begin
  case Cover.State of
    ecsClosed :;
    ecsClosing : begin
        Cover.Position := Cover.Position - 10;
        if Cover.Position <= 0 then begin
          Cover.Position := 0;
          Cover.State := ecsClosed;
          TimerCover.Enabled := False;
        end;
        tbCoverPosition.Position := Cover.Position;
        CoverUpdate;
      end;
    ecsOpen :;
    ecsOpening : begin
        Cover.Position := Cover.Position + 10;
        if Cover.Position >= 100 then begin
          Cover.Position := 100;
          Cover.State := ecsOpen;
          TimerCover.Enabled := False;
        end;
        CoverUpdate;
      end;
    ecsStopped : ;
  end; //case
  if Cover.Position <> tbCoverPosition.Position then begin
    CoverInternalModify := True;
    tbCoverPosition.Position := Cover.Position;
    CoverInternalModify := False;
  end;
end;

//*****************************************************************************
procedure TForm1.DoDeviceTrigger(ACmd:string);
begin
  Debug(ACmd);
end; //DoDeviceTrigger

//*****************************************************************************
Function TForm1.FanData(Var AValue:string):Boolean;
begin
  if Fan.State then
    AValue := Fan.Config[CFanNames[fnPayloadOn]]
  else
    AValue := Fan.Config[CFanNames[fnPayloadOff]];
  Result := True;
end; //FanData

procedure TForm1.DoFanCommand(ACmd:string);
begin
  {
    OnReceive: QoS 0 5 0 homeassistant/fan/demo_device_000/set = ON
  }
  if (ACmd = Fan.Config[CFanNames[fnPayloadOff]]) then begin
    Fan.State := False;
  end else if (ACmd = Fan.Config[CFanNames[fnPayloadOn]]) then begin
    Fan.State := True;
  end else
    Debug(ACmd);

  cbFanState.Checked := Fan.State;
  if Fan.State and (Fan.Speed = 0) then begin
    Fan.Speed := 1;
    FanUpdateSpeed;
  end;
  Fan.SendState;
end; //DoFanCommand

procedure TForm1.DoFanDirection(ACmd:string);
begin
  Debug(ACmd);
  {
    OnReceive: QoS 0 6 0 homeassistant/fan/demo_device_000/direction_set = forward
    OnReceive: QoS 0 6 0 homeassistant/fan/demo_device_000/direction_set = reverse
   }
//      direction : boolean; //True -> forward
  if (ACmd = fanForward) then begin
    Fan.Direction := True;
    rgFanDirection.ItemIndex := 0;
  end else if (ACmd = fanReverse) then begin
    Fan.Direction := False;
    rgFanDirection.ItemIndex := 1;
  end;
  Fan.SendStateTopic(fnDirectionStateTopic, FanDirectionNames[Fan.Direction]);
end; //DoFanDirection

procedure TForm1.rgFanDirectionClick(Sender: TObject);
begin
  Fan.Direction := (rgFanDirection.ItemIndex = 0);
  Fan.SendStateTopic(fnDirectionStateTopic, FanDirectionNames[Fan.Direction]);
end;

procedure TForm1.FanSendOscillate;
begin
  if Fan.Oscillate then
    Fan.SendStateTopic(fnOscillationStateTopic, Fan.Config[CFanNames[fnPayloadOscillationOn]])
  else
    Fan.SendStateTopic(fnOscillationStateTopic, Fan.Config[CFanNames[fnPayloadOscillationOff]]);
end; //FanSendOscillate

procedure TForm1.DoFanOscillate(ACmd:string);
begin
  {
    OnReceive: QoS 0 7 0 homeassistant/fan/demo_device_000/oscillate = ON
  }
//      Oscillation : boolean;
  if (ACmd = Fan.Config[CFanNames[fnPayloadOscillationOff]]) then begin
    Fan.Oscillate := False;
  end else if (ACmd = Fan.Config[CFanNames[fnPayloadOscillationOn]]) then begin
    Fan.Oscillate := True;
  end else
    Debug(ACmd);

  cbFanOscillation.Checked := Fan.Oscillate;
  FanSendOscillate;
end; //DoFanOscillate

procedure TForm1.FanUpdateSpeed;
begin
  Fan.SendStateTopic(fnPercentageStateTopic, IntToStr(Fan.Speed));
  if Fan.Speed = 0 then begin
    cbFanState.Checked := False;
    //cbFanStateChange(Self);
  end;
end; //FanUpdateSpeed

procedure TForm1.DoFanSpeed(ACmd:string);
begin
  {
    OnReceive: QoS 0 8 0 homeassistant/fan/demo_device_000/speed_set = 0
    OnReceive: QoS 0 8 0 homeassistant/fan/demo_device_000/speed_set = 4
  }
  Fan.Speed := StrToIntDef(ACmd, Fan.Speed); //no check!
  tbFanSpeed.Position := Fan.Speed;
  FanUpdateSpeed;
end; //DoFanSpeed

procedure TForm1.cbFanStateChange(Sender: TObject);
begin
  Fan.State := cbFanState.Checked;
  if Fan.Speed = 0 then begin
    Fan.Speed := 1;
    FanUpdateSpeed;
  end;
  Fan.SendState;
end;

procedure TForm1.cbFanOscillationChange(Sender: TObject);
begin
  Fan.Oscillate := cbFanOscillation.Checked;
  FanSendOscillate;
end;

procedure TForm1.tbFanSpeedChange(Sender: TObject);
begin
  Fan.Speed := tbFanSpeed.Position;
  FanUpdateSpeed;
end;

//*****************************************************************************
procedure TForm1.LightUpdateState;
begin
  if Light.State then
    Light.SendStateTopic(linStateTopic, Light.Config[CLightNames[linPayloadOn]])
  else
    Light.SendStateTopic(linStateTopic, Light.Config[CLightNames[linPayloadOff]]);
end; //LightUpdateState

procedure TForm1.LightUpdateBrightness;
begin
  Light.SendStateTopic(linBrightnessStateTopic, IntToStr(Light.Brightness));
end; //LightUpdateBrightness

procedure TForm1.DoLightBrightness(ACmd:string);
begin
  Light.Brightness := StrToIntDef(ACmd, Light.Brightness);
  tbLight.Position := Light.Brightness;
end; //DoLightBrightness

procedure TForm1.DoLightPower(ACmd:string);
begin
  if (ACmd = Light.Config[CLightNames[linPayloadOff]]) then begin
    Light.State := False;
  end else if (ACmd = Light.Config[CLightNames[linPayloadOn]]) then begin
    Light.State := True;
    if Light.Brightness = 0 then begin
      Light.Brightness := 10;
      LightUpdateBrightness;
    end;
  end else
    Debug(ACmd);
  cbLight.Checked := Light.State;
end; //DoLightPower

procedure TForm1.cbLightChange(Sender: TObject);
begin
  Light.State := cbLight.Checked;
  LightUpdateState;
end;

procedure TForm1.tbLightChange(Sender: TObject);
begin
  Light.Brightness := tbLight.Position;
  if Light.Brightness = 0 then cbLight.Checked := False;
  LightUpdateBrightness;
end;

//*****************************************************************************
procedure TForm1.cbLockChange(Sender: TObject);
begin
  Lock.State := cbLock.Checked;
  Lock.SendState;
end;

procedure TForm1.DoLockCommand(ACmd:string);
begin
  if ACmd = Lock.Config[CLockNames[lonPayloadLock]] then
    Lock.State := True
  else if ACmd = Lock.Config[CLockNames[lonPayloadUnlock]] then
    Lock.State := False
  else
    Debug(ACmd);
  cbLock.Checked := Lock.State;
end; //DoLockCommand

Function TForm1.LockData(Var AValue:string):Boolean;
begin
  if Lock.State then
    AValue := Lock.Config[CLockNames[lonStateLocked]]
  else
    AValue := Lock.Config[CLockNames[lonStateUnlocked]];
  Result := True;
end; //LockData

//*****************************************************************************
Function TForm1.SensorData(Var AValue:string):Boolean;
Var
  OldDS : char;
begin //@@@ Decimal POINT, required by MY installation of HA. Need more investigations
  OldDS := DecimalSeparator;
  DecimalSeparator := '.';
  AValue := Format('%.1n', [SensorValue/10]);
  DecimalSeparator := OldDS;
  Result := True;
end; //SensorData

procedure TForm1.tbSensorChange(Sender: TObject);
begin
  SensorValue := tbSensor.Position;
  Sensor.SendState;
end;

//*****************************************************************************
Function TForm1.SwitchData(Var AValue:string):Boolean;
begin
  if Switch.State then
    AValue := Switch.Config[CSwitchNames[swnPayloadOn]]
  else
    AValue := Switch.Config[CSwitchNames[swnPayloadOff]];
  Result := True;
end; //SwitchData

Procedure TForm1.SwitchCommand(ACmd:string);
begin
  if (ACmd = Switch.Config[CSwitchNames[swnPayloadOn]]) then
    Switch.State := True
  else if (ACmd = Switch.Config[CSwitchNames[swnPayloadOn]]) then
    Switch.State := False
  else
    Debug(ACmd);
  cbSwitch.Checked := Switch.State;
end; //SwitchCommand

procedure TForm1.cbSwitchClick(Sender: TObject);
begin
  Switch.State := cbSwitch.Checked;
  Switch.SendState;
end;

//*****************************************************************************
Function TForm1.TextData(Var AValue:string):Boolean;
begin
  AValue := eText.Text;
  Result := True;
end; //TextData

Procedure TForm1.DoTextCommand(ACmd:string);
begin
  Debug(ACmd);
  eText.Text := Copy(ACmd, 1, cfgTextMaxLength);
end; //TextCommand

procedure TForm1.eTextKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    Text.SendState;
end;

//*****************************************************************************
Function TForm1.UpdateData(Var AValue:string):Boolean;
begin
  AValue := 'Version: 1.2.3';
  Result := True;
end; //UpdateData

procedure TForm1.bUpdateClick(Sender: TObject);
begin
  Update.SendState;
end;

Procedure TForm1.DoUpdateCommand(ACmd:string);
begin
  if ACmd = Update.Config[CUpdateNames[unPayloadInstall]] then
    Debug('Install update!')
  else
    Debug(ACmd);
end; //DoUpdateCommand

//*****************************************************************************
Function TForm1.ValveData(Var AValue:string):Boolean;
begin
  if True or Valve.ReportsPosition then
    AValue := IntToStr(Valve.Position)
  else
    AValue := Valve.JSONState;
  Result := True;
end; //ValveData

Procedure TForm1.DoValveCommand(ACmd:string);
begin
  if Valve.ReportsPosition then begin
    //expects the new position or vnPayloadStop
    if ACmd = Valve.Config[CValveNames[vnPayloadStop]] then begin
      bValveStopClick(Self);
    end else begin
      Valve.Position := StrToIntDef(ACmd, Valve.Position);
      tbValvePosition.Position := Valve.Position;
    end;

  end else begin
    if ACmd = Valve.Config[CValveNames[vnPayloadOpen]] then begin
      bValveOpenClick(Self);
    end else if ACmd = Valve.Config[CValveNames[vnPayloadClose]] then begin
      bValveCloseClick(Self);
    end else if ACmd = Valve.Config[CValveNames[vnPayloadStop]] then begin
      bValveStopClick(Self);
    end else
      Debug(ACmd);
  end;
end; //DoValveCommand

procedure TForm1.tbValvePositionChange(Sender: TObject);
begin
  Valve.Position := tbValvePosition.Position;
  stValvePosition.Caption := IntToStr(Valve.Position);
  Valve.SendState;
end;

procedure TForm1.bValveCloseClick(Sender: TObject);
begin
  if Valve.State in [evsClosed, evsClosing] then Exit;
  Valve.State := evsClosing;
  TimerValve.Enabled := True;
  Valve.SendState;
end;

procedure TForm1.bValveOpenClick(Sender: TObject);
begin
  if Valve.State in [evsOpen, evsOpening] then Exit;
  Valve.State := evsOpening;
  TimerValve.Enabled := True;
  Valve.SendState;
end;

procedure TForm1.bValveStopClick(Sender: TObject);
begin
  if not(Valve.State in [evsOpening, evsClosing]) then Exit;
  TimerValve.Enabled := False;
  Valve.State := evsStopped;
  Valve.SendState;
end;

procedure TForm1.TimerValveTimer(Sender: TObject);
Var
  OldState : EValveStates;
begin
  OldState := Valve.State;
  case Valve.State of
    evsClosed :;
    evsClosing : begin
        Valve.Position := Valve.Position - 10;
        if Valve.Position <= 0 then begin
          Valve.Position := 0;
          Valve.State := evsClosed;
          TimerValve.Enabled := False;
        end;
      end;
    evsOpen :;
    evsOpening : begin
        Valve.Position := Valve.Position + 10;
        if Valve.Position >= 100 then begin
          Valve.Position := 100;
          Valve.State := evsOpen;
          TimerValve.Enabled := False;
        end;
      end;
    evsStopped : ;
  end; //case
  if (Valve.Position <> tbValvePosition.Position) or (OldState <> Valve.State) then begin
    tbValvePosition.Position := Valve.Position;
  end;
end;

//*****************************************************************************
procedure TForm1.DoBirthEvent(ACmd:string);
begin
  //Send Config messages
  Debug(ACmd);
  MyDevice.SendConfigAll;
end; //DoBirthEvent

procedure TForm1.DoLWTEvent(ACmd:string);
begin
  Debug(ACmd);
  //do something
end; //DoLWTEvent

//*****************************************************************************
procedure TForm1.bConfigClick(Sender: TObject);
begin
  Debug('Sending config');
  MyDevice.SendConfigAll;
end; //Button1Click

procedure TForm1.bConnectClick(Sender: TObject);
begin
  MyDevice.ReConnectOnDisconnect := True; //from now only
  if not MyDevice.Connect then
    Debug('connect error');
end;

procedure TForm1.CreateDevice;
Var
  s, did : string;
  ab : TBroker;
begin
  //called only once at start
  //all the topic subscription will fail because it's not yet connected to the broker
  //after the connection all topics will be re-subscripted

  //did := 'demo_device_' + Format('%3.3d', [cfgSerialNumber]);
  did := cfgDeviceID; //Device ID
  MyDevice := TMQTTDevice.Create;
  MyDevice.Config[CDeviceNames[dnDevice_Identifiers]] := did;
  MyDevice.Config[CDeviceNames[dnDevice_Manufacturer]] := 'Nicola Perotto';
  MyDevice.Config[CDeviceNames[dnDevice_Model]] := 'Lazarus/Fpc';
  MyDevice.Config[CDeviceNames[dnDevice_Name]] := cfgDeviceName;
  MyDevice.Config[CDeviceNames[dnDevice_SWVersion]] := cfgVersion;
  if cfgMqttID = '' then
    cfgMqttID := did;
  ab.Host := cfgMqttHost;
  ab.Port := cfgMqttPort;
  ab.ID   := cfgMqttID; //this is very important for delivery of messages
  ab.User := cfgMqttUser;
  ab.Pass := cfgMqttPass;
  ab.SSL  := cfgMqttSSL;
  with MyDevice do begin
    ReConnectOnDisconnect := False; //Important: set only when you want the first connection! Eg. UseBirth := True try to connect!
    ReSubscribeOnConnect := True;
    UseBirth := True;
    UseLastWillAndTestament := True;
    Broker := ab;
  end; //With
  Memo.Lines.Add('Created device: ' + MyDevice.Config[CDeviceNames[dnDevice_Identifiers]]);

  //Client Init
  MyDevice.Client.OnDisconnect := OnDisconnect;
  MyDevice.Client.OnConnect := OnConnect;
  MyDevice.Client.OnVerifySSL := OnVerifySSL;
  MyDevice.Client.OnReceive := OnReceive;
  if FileExists('client.crt') and FileExists('client.key') then begin
    MyDevice.Client.ClientCert := 'client.crt';
    MyDevice.Client.ClientKey := 'client.key';
  end;

  BinarySensor := TMQTTBinarySensor.Create;
  with BinarySensor do begin
    Device := MyDevice;
    Config[CBinarySensorNames[bsnObjectId]]     := did + '_binarysensor';
    Config[CBinarySensorNames[bsnUniqueId]]     := Config[CBinarySensorNames[bsnObjectId]];
    Config[CBinarySensorNames[bsnName]]         := 'Binary Sensor';
    Config[CBinarySensorNames[bsnDeviceClass]]  := CBinarySensorDeviceClass[bsdcGarageDoor];
    //Config[CBinarySensorNames[bsnIcon]]       := 'mdi:speedometer'; //not necessary if DeviceClass is used (and you like the default)
    Config[CBinarySensorNames[bsnPayloadOff]]   := 'CLOSE';
    Config[CBinarySensorNames[bsnPayloadOn]]    := 'OPEN';
    //Config[CBinarySensorNames[bsnStateTopic]] := 'state'; //uses default
    Config[CBinarySensorNames[bsnQos]]          := '1'; //maximum usable for this sensor
    QoS := 1;
    Retain := False;
    RetainConfig := True; //default := True
    OnReadData := BinarySensorData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    Memo.Lines.Add('');
    //This sensor send data, doesn't accept commands
  end; //with

  Button := TMQTTButton.Create;
  with Button do begin
    Device := MyDevice;
    Config[CButtonNames[bnObjectId]]        := did + '_button';
    Config[CButtonNames[bnUniqueId]]        := Config[CButtonNames[bnObjectId]];
    Config[CButtonNames[bnName]]            := 'Button';
    //Config[CButtonNames[bnCommandTopic]]  := 'set'; //uses default
    Config[CButtonNames[bnDeviceClass]]     := CButtonDeviceClass[bdcIdentify];
    //Config[CButtonNames[bnIcon]]          := 'mdi:button-cursor'; //not necessary if DeviceClass is used (and you like the default)
    QoS := 1;
    Retain := False;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    //you can subscribe before sending config to HA
    s := TopicPrefix(bnCommandTopic) + Config[CButtonNames[bnCommandTopic]];
    if not Subscribe(s, Ord(subIDButtonCommand)) then Debug('Error: Button subscribe to ' + s);
    Memo.Lines.Add('');
    //when a message is received from CommandTopic it's processed in OnReceive event
  end; //with

  Cover := TMQTTCover.Create;
  with Cover do begin
    Device := MyDevice;
    Config[CCoverNames[cnObjectId]]         := did + '_cover';
    Config[CCoverNames[cnUniqueId]]         := Config[CCoverNames[cnObjectId]];
    Config[CCoverNames[cnName]]             := 'Window'; //a window has opening, closing and tilting
    Config[CCoverNames[cnDeviceClass]]      := CCoverDeviceClass[cdcWindow];
    //Config[CCoverNames[cnIcon]]           := 'mdi:speedometer'; //not necessary if DeviceClass is used (and you like the default)
    Config[CCoverNames[cnOptimistic]]       := 'false'; //state and position are defined
    Config[CCoverNames[cnTiltOptimistic]]   := 'false'; //tilt are used
    Config[CCoverNames[cnCommandTopic]]     := 'set'; //subscribe to receive commands
    Config[CCoverNames[cnStateTopic]]       := 'state'; //send here data
    Config[CCoverNames[cnSetPositionTopic]] := 'setposition'; //subscribe to receive commands
    Config[CCoverNames[cnPositionTopic]]    := 'position'; //send here data
    Config[CCoverNames[cnTiltCommandTopic]] := 'tilt'; //subscribe to receive commands
    Config[CCoverNames[cnTiltStatusTopic]]  := 'tilt-state'; //send here data
    {Uses defaults:
      position_closed	0
      position_open		100
      etc.
    }
    QoS := 1;
    Retain := False;
    State := ecsClosed;
    Position := 0;
    Tilt := 0;
    OnReadData := CoverData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);

    s := TopicPrefix(cnCommandTopic) + Config[CCoverNames[cnCommandTopic]];
    if not Subscribe(s, Ord(subIDCoverCommand)) then Debug('Error: Cover subscribe to ' + s);
    s := TopicPrefix(cnSetPositionTopic) + Config[CCoverNames[cnSetPositionTopic]];
    if not Subscribe(s, Ord(subIDCoverPosition)) then Debug('Error: Cover subscribe to ' + s);
    s := TopicPrefix(cnTiltCommandTopic) + Config[CCoverNames[cnTiltCommandTopic]];
    if not Subscribe(s, Ord(subIDCoverTilt)) then Debug('Error: Cover subscribe to ' + s);
    CoverUpdate;
    Memo.Lines.Add('');
  end; //With

  DeviceTrigger := TMQTTDeviceTrigger.Create;
  with DeviceTrigger do begin
    Device := MyDevice;
    //default: Config[CDeviceTriggerNames[dtnAutomationType]] := 'trigger'; //required
    //default: Config[CDeviceTriggerNames[dtnTopic]]          := 'trigger';
    Config[CDeviceTriggerNames[dtnType]]           := 'button_short_press';
    Config[CDeviceTriggerNames[dtnSubtype]]        := CDeviceTriggerSubtype[dtsTurnOn];
    QoS := 0;
    Retain := False;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);

    s := TopicPrefix(dtnTopic) + Config[CDeviceTriggerNames[dtnTopic]];
    if not Subscribe(s, Ord(subIDDeviceTriggerCommand)) then Debug('Error: DeviceTrigger subscribe to ' + s);
    Memo.Lines.Add('');
  end; //With

  Fan := TMQTTFan.Create;
  with Fan do begin
    Device := MyDevice;
    Config[CFanNames[fnObjectId]]                 := did + '_fan';
    Config[CFanNames[fnUniqueId]]                 := Config[CFanNames[fnObjectId]];
    Config[CFanNames[fnName]]                     := 'Ventilator';
    Config[CFanNames[fnCommandTopic]]             := 'set';
    Config[CFanNames[fnIcon]]                     := 'mdi:fan';
    Config[CFanNames[fnDirectionCommandTopic]]    := 'direction_set';
    Config[CFanNames[fnDirectionStateTopic]]      := 'direction';
    Config[CFanNames[fnOscillationCommandTopic]]  := 'oscillate';
    Config[CFanNames[fnOscillationStateTopic]]    := 'oscillation';
    Config[CFanNames[fnPayloadOff]]               := 'OFF';
    Config[CFanNames[fnPayloadOn]]                := 'ON';
    Config[CFanNames[fnPayloadOscillationOff]]    := 'OFF';
    Config[CFanNames[fnPayloadOscillationOn]]     := 'ON';
    Config[CFanNames[fnPercentageCommandTopic]]   := 'speed_set';
    Config[CFanNames[fnPercentageStateTopic]]     := 'speed';
    Config[CFanNames[fnSpeedRangeMax]]            := '4';
    Config[CFanNames[fnSpeedRangeMin]]            := '1';
    Config[CFanNames[fnStateTopic]]               := 'state'; //send fnPayloadOff or fnPayloadOn
    QoS := 1;
    Retain := False;
    OnReadData := FanData;
    State := False;
    Direction := True; //Forward
    Oscillate := False;
    Speed := 0;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);

    s := TopicPrefix(fnCommandTopic) + Config[CFanNames[fnCommandTopic]];
    if not Subscribe(s, Ord(subIDFanCommand)) then Debug('Error: Fan subscribe to ' + s);
    s := TopicPrefix(fnDirectionCommandTopic) + Config[CFanNames[fnDirectionCommandTopic]];
    if not Subscribe(s, Ord(subIDFanDirection)) then Debug('Error: Fan subscribe to ' + s);
    s := TopicPrefix(fnOscillationCommandTopic) + Config[CFanNames[fnOscillationCommandTopic]];
    if not Subscribe(s, Ord(subIDFanOscillate)) then Debug('Error: Fan subscribe to ' + s);
    s := TopicPrefix(fnPercentageCommandTopic) + Config[CFanNames[fnPercentageCommandTopic]];
    if not Subscribe(s, Ord(subIDFanSpeed)) then Debug('Error: Fan subscribe to ' + s);
    Memo.Lines.Add('');
  end; //With

  Light := TMQTTLight.Create;
  with Light do begin
    Device := MyDevice;
    Config[CLightNames[linObjectId]]                := did + '_light';
    Config[CLightNames[linUniqueId]]                := Config[CLightNames[linObjectId]];
    Config[CLightNames[linName]]                    := 'Light';
    Config[CLightNames[linBrightnessCommandTopic]]  := 'brightness_set';
    Config[CLightNames[linBrightnessScale]]         := '100';
    Config[CLightNames[linBrightnessStateTopic]]    := 'brightness';
    Config[CLightNames[linCommandTopic]]            := 'set';
    Config[CLightNames[linIcon]]                    := 'mdi:ceiling-light';
    Config[CLightNames[linStateTopic]]              := 'state'; //send fnPayloadOff or fnPayloadOn
    QoS := 1;
    Retain := False;
    State := False;
    Brightness := 0;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);

    //s := TopicPrefix(linBrightnessCommandTopic) + Config[CLightNames[linBrightnessCommandTopic]];
    if not Subscribe(linBrightnessCommandTopic, Ord(subIDLightBrightness)) then Debug('Error: Light subscribe to ' + CLightNames[linBrightnessCommandTopic]);
    //s := TopicPrefix(linCommandTopic) + Config[CLightNames[linCommandTopic]];
    if not Subscribe(linCommandTopic, Ord(subIDLightPower)) then Debug('Error: Light subscribe to ' + CLightNames[linCommandTopic]);
    Memo.Lines.Add('');
  end; //With

  Lock := TMQTTLock.Create;
  with Lock do begin
    Device := MyDevice;
    Config[CLockNames[lonObjectId]]                := did + '_lock';
    Config[CLockNames[lonUniqueId]]                := Config[CLockNames[lonObjectId]];
    Config[CLockNames[lonName]]                    := 'Lock';
    Config[CLockNames[lonCommandTopic]]            := 'set';
    Config[CLockNames[lonIcon]]                    := 'mdi:lock';
    Config[CLockNames[lonStateTopic]]              := 'state';
    //@@@ todo: learn how to use lonCodeFormat
    QoS := 1;
    Retain := False;
    State := False;
    OnReadData := LockData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);

    if not Subscribe(lonCommandTopic, Ord(subIDLockCommand)) then Debug('Error: Lock subscribe to ' + CLockNames[lonCommandTopic]);
    Memo.Lines.Add('');
  end; //With

  Sensor := TMQTTSensor.Create;
  with Sensor do begin
    Device := MyDevice;
    Config[CSensorNames[snObjectId]]                  := did + '_sensor';
    Config[CSensorNames[snUniqueId]]                  := Config[CSensorNames[snObjectId]];
    Config[CSensorNames[snName]]                      := 'Sensor';
    Config[CSensorNames[snDeviceClass]]               := CSensorDeviceClass[sdcTemperature];
    Config[CSensorNames[snIcon]]                      := 'hass:thermometer';
    Config[CSensorNames[snSuggestedDisplayPrecision]] := '1';
    Config[CSensorNames[snQos]]                       := '0';
    Config[CSensorNames[snStateClass]]                := CSensorStateClass[sscMeasurement];
    Config[CSensorNames[snStateTopic]]                := 'thermometer'; //not the default :-)
    Config[CSensorNames[snUnitOfMeasurement]]         := '°C';
    QoS := 1;
    Retain := False;
    OnReadData := SensorData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    Memo.Lines.Add('');

    //this is not part of the Sensor object
    SensorValue := 10;
  end; //With

  Switch := TMQTTSwitch.Create;
  with Switch do begin
    Device := MyDevice;
    Config[CSwitchNames[swnObjectId]]     := did + '_relay';
    Config[CSwitchNames[swnUniqueId]]     := Config[CSwitchNames[swnObjectId]];
    Config[CSwitchNames[swnName]]         := 'Switch';
    //Config[CSwitchNames[swnConfig]]       := 'relay1/config'; //in case of multiple switches
    //Config[CSwitchNames[swnCommandTopic]] := 'set'; //required, default
    Config[CSwitchNames[swnStateTopic]]   := 'state'; //the first part is built by object
    Config[CSwitchNames[swnDeviceClass]]  := CSwitchDeviceClass[swdcSwitch];
    Config[CSwitchNames[swnIcon]]         := 'mdi:toggle-switch';
    Config[CSwitchNames[swnQos]]          := '1';
    QoS := 1;
    Retain := False;
    State := False;
    OnReadData := SwitchData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    if not Subscribe(swnCommandTopic, Ord(subIDSwitchCommand)) then Debug('Error: Switch subscribe to ' + CSwitchNames[swnCommandTopic]);
    Memo.Lines.Add('');
  end;

{In the future, when an appropriate docs will be!
  TagScanner := TMQTTTagScanner.Create;
  with TagScanner do begin
    Device := MyDevice;
    Config[CTagScannerNames[tsnTopic]]   := 'tag_scanned';
    QoS := 1;
    Retain := False;
    OnReadData := TagData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    Memo.Lines.Add('');
  end; //With
}

  Text := TMQTTText.Create;
  with Text do begin
    Device := MyDevice;
    Config[CTextNames[tnObjectId]]     := did + '_text';
    Config[CTextNames[tnUniqueId]]     := Config[CTextNames[tnObjectId]];
    Config[CTextNames[tnName]]         := 'Text';
    Config[CTextNames[tnCommandTopic]] := 'set';
    Config[CTextNames[tnStateTopic]]   := 'text';
    Config[CTextNames[tnMode]]         := 'text'; //or 'password'
    Config[CTextNames[tnMax]]          := IntToStr(cfgTextMaxLength);
    QoS := 1;
    Retain := False;
    OnReadData := TextData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    if not Subscribe(tnCommandTopic, Ord(subIDTextCommand)) then Debug('Error: Text subscribe to ' + CTextNames[tnCommandTopic]);
    Memo.Lines.Add('');

    Text := cfgDeviceName + ' ' + cfgVersion;
    eText.Text := Text;
    eText.MaxLength := cfgTextMaxLength;
  end; //With

  Update := TMQTTUpdate.Create;
  with Update do begin
    Device := MyDevice;
    Config[CUpdateNames[unObjectId]]        := did + '_update';
    Config[CUpdateNames[unUniqueId]]        := Config[CUpdateNames[unObjectId]];
    Config[CUpdateNames[unCommandTopic]]    := 'install';
    Config[CUpdateNames[unPayloadInstall]]  := 'GO!';
    Config[CUpdateNames[unStateTopic]]      := 'version';
    Config[CUpdateNames[unName]]            := 'Update';
    Config[CUpdateNames[unDeviceClass]]     := 'firmware';
    Config[CUpdateNames[unReleaseSummary]]  := 'There is a new software version'; //max 255 chars
    Config[CUpdateNames[unTitle]]           := 'MQTT Device Library Demo';
    QoS := 1;
    Retain := True; //retain
    OnReadData := UpdateData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    if not Subscribe(unCommandTopic, Ord(subIDUpdateCommand)) then Debug('Error: Update subscribe to ' + CUpdateNames[unCommandTopic]);
    Memo.Lines.Add('');
  end; //With

  Valve := TMQTTValve.Create;
  with Valve do begin
    Device := MyDevice;
    Config[CValveNames[vnObjectId]]     := did + '_valve';
    Config[CValveNames[vnUniqueId]]     := Config[CValveNames[vnObjectId]];
    Config[CValveNames[vnName]]         := 'Valve';
    Config[CValveNames[vnDeviceClass]]  := 'water'; //none, water, gas
    Config[CValveNames[vnCommandTopic]] := 'set';
    Config[CValveNames[vnPayloadStop]]  := 'STOP'; //to be defined if HA can send a stop command
    Config[CValveNames[vnStateTopic]]   := 'state';

    ReportsPosition := True;
    if ReportsPosition then begin
      Config[CValveNames[vnReportsPosition]] := 'true';
      Config[CValveNames[vnPayloadClose]] := '';
      Config[CValveNames[vnPayloadOpen]] := '';
      Config[CValveNames[vnStateClosed]] := '';
      Config[CValveNames[vnStateClosing]] := '';
      Config[CValveNames[vnStateOpen]] := '';
      Config[CValveNames[vnStateOpening]] := '';
      Config[CValveNames[vnStateStopped]] := '';
      Config[CValveNames[vnOptimistic]] := 'false';
    end;
    Config[CValveNames[vnPayloadStop]] := 'STOP'; //this is because I want to be stopped from HA, in both modes
    QoS := 1;
    Retain := False;
    State := evsClosed;
    Position := 0;
    OnReadData := ValveData;
    Memo.Lines.Add('New sensor: ' + BuildConfigJSON);
    if not Subscribe(vnCommandTopic, Ord(subIDValveCommand)) then Debug('Error: Valve subscribe to ' + CValveNames[vnCommandTopic]);
    Memo.Lines.Add('');
  end; //With
end; //CreateDevice

//*****************************************************************************
procedure TForm1.FormCreate(Sender: TObject);
Var
  Ini : TIniFile;
begin
  IsClosing := False;

  try
    Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    cfgSerialNumber := Ini.ReadInteger('common', 'SerialNumber', cfgSerialNumber);
    cfgDeviceName := Ini.ReadString('common', 'DeviceName', cfgDeviceName);
    cfgDeviceID  := Ini.ReadString('common', 'DeviceID', cfgDeviceID);

    cfgMqttHost := Ini.ReadString('broker', 'host', cfgMqttHost);
    cfgMqttPort := Ini.ReadInteger('broker', 'port', cfgMqttPort);
    cfgMqttID   := Ini.ReadString('broker', 'id', cfgMqttID);
    cfgMqttUser := Ini.ReadString('broker', 'user', cfgMqttUser);
    cfgMqttPass := Ini.ReadString('broker', 'pass', cfgMqttPass);
    cfgMqttSSL  := Ini.ReadBool('broker', 'ssl', cfgMqttSSL);
  finally
    FreeAndNil(Ini);
  end;
  CoverInternalModify := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  IsClosing := True;
  MyDevice.UnsubscribeAll;
  MyDevice.Client.Disconnect;
  FreeAndNil(MyDevice);

  FreeAndNil(BinarySensor);
  FreeAndNil(Button);
  FreeAndNil(Cover);
  FreeAndNil(DeviceTrigger);
  FreeAndNil(Fan);
  FreeAndNil(Light);
  FreeAndNil(Lock);
  FreeAndNil(Sensor);
  FreeAndNil(Switch);
  FreeAndNil(TagScanner);
  FreeAndNil(Text);
  FreeAndNil(Update);
  FreeAndNil(Valve);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  CreateDevice;
end;

procedure TForm1.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  if shButton.Brush.Color = clRed then shButton.Brush.Color := clWhite;
  Timer.Enabled := True;
end;

procedure TForm1.Debug(Txt: String);
begin
  Memo.Lines.Add(Txt);
end; //Debug

//*****************************************************************************
procedure TForm1.OnDisconnect(Client: TMQTTClient);
begin
  Debug('Disconnect');
end;

procedure TForm1.OnConnect(Client: TMQTTClient);
begin
  Debug('Connect');
  if MyDevice.ReSubscribeOnConnect then
    MyDevice.SubscribeAll;
end;

procedure TForm1.OnReceive(Client: TMQTTClient; Msg: TMQTTRXData);
var
  I: Integer;
begin
  Debug(Format('OnReceive: QoS %d %d %d %s = %s', [Msg.QoS, Msg.SubsID, Msg.ID, Msg.Topic, Msg.Message]));
  if Msg.RespTopic <> '' then
    Debug(Format('           Response Topic: %s', [Msg.RespTopic]));
  if Msg.CorrelData <> '' then
    Debug(Format('           Correlation Data: %s', [Msg.CorrelData]));
  with Msg.UserProps do begin
    if Count > 0 then begin
      for I := 0 to Count - 1 do begin
        Debug(Format('           Prop %s: %s', [GetKey(I), GetVal(I)]));
      end;
    end;
  end;

  //check the range
  i := Msg.SubsID;
  if (i < Ord(Low(ESubIds))) or (i > Ord(High(ESubIds))) then Exit;

  case ESubIds(i) of
  subIDButtonCommand        : DoButtonCommand(Msg.Message);

  subIDCoverCommand         : DoCoverCommand(Msg.Message);
  subIDCoverPosition        : DoCoverPosition(Msg.Message);
  subIDCoverTilt            : DoCoverTilt(Msg.Message);

  subIDDeviceTriggerCommand : DoDeviceTrigger(Msg.Message);

  subIDFanCommand           : DoFanCommand(Msg.Message);
  subIDFanDirection         : DoFanDirection(Msg.Message);
  subIDFanOscillate         : DoFanOscillate(Msg.Message);
  subIDFanSpeed             : DoFanSpeed(Msg.Message);

  subIDLightBrightness      : DoLightBrightness(Msg.Message);
  subIDLightPower           : DoLightPower(Msg.Message);

  subIDLockCommand          : DoLockCommand(Msg.Message);

  subIDSensorCommand        : ;

  subIDSwitchCommand        : SwitchCommand(Msg.Message);

  subIDTagScannerCommand    : ;

  subIDTextCommand          : DoTextCommand(Msg.Message);

  subIDUpdateCommand        : DoUpdateCommand(Msg.Message);

  subIDValveCommand         : DoValveCommand(Msg.Message);
  else begin
      if Msg.SubsID = cfgHABirthSubId then
        DoBirthEvent(Msg.Message)
      else if Msg.SubsID = cfgHALWTSubId then
        DoLWTEvent(Msg.Message);
    end;
  end; //case
end; //OnReceive

procedure TForm1.OnVerifySSL(Client: TMQTTClient; Handler: TOpenSSLSocketHandler; var Allow: Boolean);
var
  C: Char;
  S: String = '';
begin
  for C in Handler.SSL.PeerFingerprint('SHA256') do begin
    S += IntToHex(Ord(C), 2);
  end;
  Debug('OnVerifySSL cert fingerprint: ' + S);
  Allow := True;
end;

procedure TForm1.OnDebug(Txt: String);
begin
  Debug(Txt);
end; //OnDebug

end.
