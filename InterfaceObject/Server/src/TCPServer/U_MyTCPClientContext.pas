unit U_MyTCPClientContext;

interface

uses
  diocp_coder_tcpServer,
  Classes,
  SysUtils,
  utils_zipTools;

type
  TMyTCPClientContext = class(TIOCPCoderClientContext)
  private
  protected
    procedure OnDisconnected; override;
    procedure OnConnected; override;
  protected
    /// <summary>
    ///   接收、处理数据
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure DoContextAction(const pvDataObject: TObject); override;
  public
  end;

implementation

{ TMyTCPClientContext }

procedure TMyTCPClientContext.DoContextAction(const pvDataObject: TObject);
begin

end;

procedure TMyTCPClientContext.OnConnected;
begin
  inherited;

end;

procedure TMyTCPClientContext.OnDisconnected;
begin
  inherited;

end;

end.
