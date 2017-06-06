unit U_GetHisInfoIntf;

interface

uses
  System.SysUtils,
  U_SendInfobyTCPClient;

function IntfGetHisInfo(const ASendData:PChar): PChar; stdcall;

implementation

function IntfGetHisInfo(const ASendData:PChar): PChar;
var
  FIntf: TSendInfobyTCPClient;
  ARecvData: string;
begin
  FIntf := TSendInfobyTCPClient.Create;
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
