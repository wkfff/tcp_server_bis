unit U_SendInfobyTcpClient;

interface

uses
  System.SysUtils,
  U_GetHisInfoIntf;

function IntfGetHisInfo(const ASendData:PChar): PChar; stdcall;

implementation

function IntfGetHisInfo(const ASendData:PChar): PChar;
var
  FIntf: TGetHisInfoIntf;
  ARecvData: string;
begin
  FIntf := TGetHisInfoIntf.Create;
  try
    try
      FIntf.Execute(ASendData, ARecvData);
      Result := PWideChar(ARecvData);
    except
      on E: Exception do
      begin
        Result := PWideChar(E.Message);
        FIntf.Free;
      end;
    end;
  finally
    FIntf.Free;
  end;
end;
end.
