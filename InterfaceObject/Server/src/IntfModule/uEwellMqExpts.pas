unit uEwellMqExpts;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TCALLBACK_FUN = procedure(AMsgID,AMsg: PChar);

  TMQClass = class(TObject)
  private
    FActive: Boolean;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function GetMessageOneWay(AFid: string;var AMsg: string): Boolean;
    procedure Connect; overload;
    procedure Connect(AServerName:string); overload;
    procedure DisConnect;
    property Active: Boolean read GetActive write SetActive;
  end;

/// <summary>
///���Ӷ��й�����������������Ĭ�����ӵ�һ�����ã�����MQMGR1��
/// </summary>
/// <returns> 0��ʧ�� 1���ɹ�</returns>
function ConnectMQ(): integer; stdcall; external 'EwellMq.dll';
/// <summary>
///���Ӷ��й�������ָ�����ӵ�ĳ��������
/// </summary>
/// <params>
/// serverName �������������ͼini�У������ǡ�MQMGR1����MQMGR2��
/// </params>
/// <returns> 0��ʧ�� 1���ɹ�</returns>
function ConnectMQX(serverName: PCHAR): integer; stdcall; external 'EwellMq.dll';
  /// <summary>
/// �Ͽ�����
/// </summary>
/// <returns>0:ʧ�ܣ�1���ɹ��� </returns>
function DisConnectMQ(): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ������Ϣ������������������ϢID
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">��Ϣ����D</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
function PutMsgMQ(Fid: PChar; QMsgID: PChar; QMsg: PChar; ErrMsg: PChar):
  Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ���ݷ���Id����Ӧ�����л�ȡָ����ϢId�ĵ�һ����Ϣ
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">��Ϣ����D</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
function GetMsgMQ(Fid: PChar; WaitInterval: Integer; QMsgID: PChar; QMsg: PChar;
  ErrMsg: PChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ���ݷ���Id����Ӧ�����л�ȡָ����ϢId�ĵ�һ����Ϣ�� �����ṩ��ʱ�ȴ����ã�����waitIntervalΪ�ȴ�ʱ�䣬��λ������
/// </summary>
/// <param name=" Fid ">����id</param>
/// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">��Ϣ����</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ�����-1��δ����</returns>
function BrowseMsgMQ(Fid: PChar; WaitInterval: Integer; QMsgID: PChar; QMsg:
  PChar; ErrMsg: PChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ���ݷ���Id����Ӧ���������ָ����ϢId�ĵ�һ����Ϣ��������ṩId���������һ���������ṩ��ʱ�ȴ����ã�����waitIntervalΪ�ȴ�ʱ�䣬��λ������
/// </summary>
/// <param name=" Fid ">����id</param>
/// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
/// <param name=" QMsgID ">��ϢID�����û����ϢId�򴫿�ֵ</param>
/// <param name=" QMsg ">��Ϣ����</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ�����-1��δ����</returns>
function PutMsgWithId(Fid: PChar; QMsgID: pchar; QMsg: PChar; ErrMsg: PChar):
  Integer; stdcall; external 'EwellMq.dll';
/// <summary>
///������Ϣ�������������ȴ����շ��ش���Ϣ��Ž�����������һ��һ������
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">������Ϣ����D</param>
/// <param name=" QoutMsg ">���ش���������</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
function putMsgTC(Fid: PChar; WaitInterval: Integer; QMsgID: pchar; QinMsg:
  PChar; QoutMsg: PChar; ErrMsg: PChar): Integer; stdcall; external
  'EwellMq.dll';
/// <summary>
///������Ϣ���У�һ������Ϣ��������ȡ�����ص�����
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" func">�ص�����</param>
/// <returns>0:ʧ�ܣ�1:�ɹ��� </returns>
function MessageListener(Fid :PChar; QMsgID :PChar; func:TCALLBACK_FUN) :Integer;
  stdcall;external 'EwellMq.dll';

function Query(Fid :PChar; WaitInterval:Integer; QMsgID :pchar; QinMsg :PChar;
  QoutMsg:PChar; ErrMsg :PChar):Integer; stdcall; external 'EwellMq.dll';

implementation

{ TMQClass }

procedure TMQClass.Connect;
var
  iReturn: Integer;
begin
  iReturn := ConnectMQ;
  if iReturn < 1 then
    raise Exception.Create('���Ӷ��й�����ʧ��!');
  FActive := True;
end;

procedure TMQClass.Connect(AServerName: string);
var
  iReturn: Integer;
begin
  iReturn := ConnectMQX(PChar(AServerName));
  if iReturn < 1 then
    raise Exception.Create('���Ӷ��й����� '+ AServerName +' ʧ��!');
  FActive := True;
end;

constructor TMQClass.Create;
begin
  inherited;
  FActive := False;
end;

destructor TMQClass.Destroy;
begin
  if FActive then
    DisConnect;
  inherited;
end;

procedure TMQClass.DisConnect;
var
  iReturn: Integer;
begin
  iReturn := DisConnectMQ;
  FActive := False;
  if iReturn < 1 then
    raise Exception.Create('�Ͽ����Ӷ��й�����ʧ��!');
end;

function TMQClass.GetActive: Boolean;
begin
  Result := FActive;
end;

function TMQClass.GetMessageOneWay(AFid: string;var AMsg: string): Boolean;
var
  ErrMsg: PChar;
  MsgId: PChar;
  Msg: PChar;
  iReturn: Integer;
begin
  if not FActive then
    raise Exception.Create('δ���Ӷ��й�����!');

  GetMem(ErrMsg, 1024);
  GetMem(MsgId,48);
  GetMem(Msg, 1024);

  try
    iReturn := GetMsgMQ(PChar(AFid), 1000, @MsgId[0], @Msg[0], @ErrMsg[0]);

    if iReturn < 1 then
      raise Exception.Create('��ȡ��Ϣʧ��!��'+ AFid + '��������Ϣ:' + ErrMsg);

    AMsg := Msg;
  finally
    FreeMem(ErrMsg);
    FreeMem(MsgId);
    FreeMem(Msg);
  end;
end;

procedure TMQClass.SetActive(const Value: Boolean);
begin
  if not FActive and Value then
    Connect;

  if FActive and (not Value) then
    DisConnect;

  FActive := Value;
end;

end.

