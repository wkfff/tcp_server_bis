unit VersionInfofrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Contnrs,
  System.StrUtils,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  SynEdit,
  Vcl.StdCtrls,
  Vcl.WinXCtrls,
  Vcl.Mask,
  Vcl.FileCtrl,
  RzEdit,
  RzBtnEdt,

  qplugins_base,
  QPlugins,
  qplugins_formsvc,
  qplugins_vcl_formsvc,
  qplugins_vcl_messages,
  qplugins_params,
  qxml,
  Vcl.ExtCtrls;

type
  TfrmVersionInfo = class(TForm)
    btnChange: TButton;
    sedtMain: TSynEdit;
    btnDIR: TRzButtonEdit;
    dlgOpenDEV: TOpenDialog;
    pnlTop: TPanel;
    pnlMain: TPanel;
    FileOpenDialog1: TFileOpenDialog;
    procedure btnChangeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure btnDIRButtonClick(Sender: TObject);
  private
    { Private declarations }
    FModuleList: array of string;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure EnumFileInQueue(path: PChar; fileExt: string; fileList: TStringList);  
var 
   searchRec: TSearchRec;  
   found: Integer;  
   tmpStr: string;  
   curDir: string;  
   dirs: TQueue;  
   pszDir: PChar;  
begin 
   dirs := TQueue.Create; //����Ŀ¼����  
   dirs.Push(path); //����ʼ����·�����  
   pszDir := dirs.Pop;  
   curDir := StrPas(pszDir); //����  
   {��ʼ����,ֱ������Ϊ��(��û��Ŀ¼��Ҫ����)} 
   while (True) do 
   begin 
      //����������׺,�õ�����'c:\*.*' ��'c:\windows\*.*'������·��  
      tmpStr := curDir + '\*.*';  
      //�ڵ�ǰĿ¼���ҵ�һ���ļ�����Ŀ¼  
      found := FindFirst(tmpStr, faAnyFile, searchRec);  
      while found = 0 do //�ҵ���һ���ļ���Ŀ¼��  
      begin 
          //����ҵ����Ǹ�Ŀ¼  
         if (searchRec.Attr and faDirectory) <> 0 then 
         begin 
          {�������Ǹ�Ŀ¼(C:\��D:\)�µ���Ŀ¼ʱ�����'.','..'��"����Ŀ¼" 
          ����Ǳ�ʾ�ϲ�Ŀ¼���²�Ŀ¼�ɡ�����Ҫ���˵��ſ���} 
            if (searchRec.Name <> '.') and (searchRec.Name <> '..') then 
            begin 
               {���ڲ��ҵ�����Ŀ¼ֻ�и�Ŀ¼��������Ҫ�����ϲ�Ŀ¼��·�� 
                searchRec.Name = 'Windows'; 
                tmpStr:='c:\Windows'; 
                �Ӹ��ϵ��һ������� 
               } 
               tmpStr := curDir + '\' + searchRec.Name;  
               {����������Ŀ¼��ӡ����������š� 
                ��ΪTQueue���������ֻ����ָ��,����Ҫ��stringת��ΪPChar 
                ͬʱʹ��StrNew������������һ���ռ�������ݣ������ʹ�Ѿ��� 
                ����е�ָ��ָ�򲻴��ڻ���ȷ������(tmpStr�Ǿֲ�����)��} 
               dirs.Push(StrNew(PChar(tmpStr)));  
            end;  
         end 
         else //����ҵ����Ǹ��ļ�  
         begin 
             {Result��¼�����������ļ���������������CreateThread�����߳� 
              �����ú����ģ���֪����ô�õ��������ֵ�������Ҳ�����ȫ�ֱ���} 
            //���ҵ����ļ��ӵ�Memo�ؼ�  
            if fileExt = '.*' then 
               fileList.Add(curDir + '\' + searchRec.Name)  
            else 
            begin 
               if SameText(RightStr(curDir + '\' + searchRec.Name, Length(fileExt)), fileExt) then 
                  fileList.Add(curDir + '\' + searchRec.Name);  
            end;
         end;  
          //������һ���ļ���Ŀ¼  
         found := FindNext(searchRec);  
      end;  
      {��ǰĿ¼�ҵ������������û�����ݣ����ʾȫ���ҵ��ˣ� 
        ������ǻ�����Ŀ¼δ���ң�ȡһ�������������ҡ�} 
      if dirs.Count > 0 then 
      begin 
         pszDir := dirs.Pop;  
         curDir := StrPas(pszDir);  
         StrDispose(pszDir);  
      end 
      else 
         break;  
   end;  
   //�ͷ���Դ  
   dirs.Free;  
   FindClose(searchRec);  
end;  

procedure TfrmVersionInfo.btnChangeClick(Sender: TObject);
var
  I: Integer;
  AFileList: TStringList;
  ATemp: TStream;
begin
  if btnDIR.Text = '' then
    Exit;

  SetLength(FModuleList, 0);
  AFileList := TStringList.Create;
  
  for I := 0 to sedtMain.Lines.Count - 1 do
  begin
    if Trim(sedtMain.LineText) = '' then
      Continue;
    SetLength(FModuleList, High(FModuleList) + 1);
    FModuleList[I] := sedtMain.LineText;
  end;
  
  try
    EnumFileInQueue(PWideChar(btnDIR.Text), '.dproj', AFileList);
    for I := 0 to AFileList.Count - 1 do
    begin
      sedtMain.Lines.Add(AFileList.Strings[I]);
    end;
  finally
    AFileList.Free;
  end;
end;

procedure TfrmVersionInfo.btnDIRButtonClick(Sender: TObject);
var
  strDIR: string;
begin
  SelectDirectory('', '', strDIR);
  btnDIR.Text := strDIR;
end;

procedure TfrmVersionInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmVersionInfo.FormResize(Sender: TObject);
begin
  btnDIR.Left := 0;
  btnDIR.Top := 8;
  btnDIR.Width := pnlTop.Width - btnChange.Width - 2;
  btnChange.Left := pnlTop.Width - btnChange.Width;
  btnChange.Top := 6;
end;

initialization
  RegisterFormService('/Services/Docks/Forms', 'VersionInfo', TfrmVersionInfo, False);

finalization
  UnregisterServices('/Services/Docks/Forms', ['VersionInfo']);

end.

