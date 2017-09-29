unit ManagerEntity;

interface
{
  描述：队列管理器管理
}

uses
  Windows,
  Classes,
  MQClass;

type
  TCALLBACK_FUN = function(msg: PAnsiChar): BOOL; stdcall;

  TQueueManager = class
  public
    QmName: AnsiString;          //队列管理器名称
    QmTag: AnsiString;          //标识
    QmPort: Integer;         //端口
    QmCC: AnsiString;          //通道
    QmIP: AnsiString;
    QmCSID: Integer;         //CCSID 字符集编码
    QmMQ: TMQClass;
  public
    destructor Destroy; override;
  end;

  TQueueModel = class
  public
    QName: AnsiString;          //队列名称
    MsgId: AnsiString;          //消息ID
    Func: TCALLBACK_FUN;   //回调函数
  end;

implementation

{ TQueueManager }

destructor TQueueManager.Destroy;
begin
  QmMQ.Free;
  inherited;
end;

end.

