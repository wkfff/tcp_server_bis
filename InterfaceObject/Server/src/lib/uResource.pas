unit uResource;

interface

const
  APOSTROPHE = '''';
  CONNECTIONDEFNAME = 'BIS_POOLED';
  MQSECTION = 'ESBEntry';
  DATABASESECTION = 'DataBase';
  DIOCP_TCP_SERVER_INI_FILE = 'DIOCPTcpServer.ini';
  HOSPITAL_CODE_XMLPATH = 'interfacemessage.hospitalcode';
  HOSPITAL_CODE_ERROR = '未传入医院代码【hospitalcode】';
  HOSPITAL_INTERFACE_ERROR = '未注册对应医院接口，HospitalCode【%s】';
  HOSPITAL_INTFEXCUT_ERROR = '接口服务错误，错误信息：%s';

resourcestring
  FMutex = 'DIOCP_SERVER_MOTEX_ONLY_ONE';

implementation

end.
