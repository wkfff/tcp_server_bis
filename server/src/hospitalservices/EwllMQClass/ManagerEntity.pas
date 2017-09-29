unit ManagerEntity;

interface
{
  ���������й���������
}

uses
  Windows,
  Classes,
  MQClass;

type
  TCALLBACK_FUN = function(msg: PAnsiChar): BOOL; stdcall;

  TQueueManager = class
  public
    QmName: AnsiString;          //���й���������
    QmTag: AnsiString;          //��ʶ
    QmPort: Integer;         //�˿�
    QmCC: AnsiString;          //ͨ��
    QmIP: AnsiString;
    QmCSID: Integer;         //CCSID �ַ�������
    QmMQ: TMQClass;
  public
    destructor Destroy; override;
  end;

  TQueueModel = class
  public
    QName: AnsiString;          //��������
    MsgId: AnsiString;          //��ϢID
    Func: TCALLBACK_FUN;   //�ص�����
  end;

implementation

{ TQueueManager }

destructor TQueueManager.Destroy;
begin
  QmMQ.Free;
  inherited;
end;

end.

