unit uEwellMqExpts;

interface

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

function Query(Fid :PChar; WaitInterval:Integer; QMsgID :pchar; QinMsg :PChar;
  QoutMsg:PChar; ErrMsg :PChar):Integer; stdcall; external 'EwellMq.dll';

implementation

end.

