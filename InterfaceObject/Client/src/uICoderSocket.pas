unit uICoderSocket;

interface

type
  ICoderSocket = interface
    ['{6C90309D-C0AA-40B9-9DAE-8C801A1DF99B}']

    /// <summary>
    ///   ���Է���ָ�����ȵ�����
    /// </summary>
    /// <returns>
    ///   ���سɹ��������ݵĳ���
    /// </returns>
    /// <param name="buf"> (Pointer) </param>
    /// <param name="len"> (Cardinal) </param>
    function SendBuf(buf:Pointer; len:Cardinal): Cardinal; stdcall;


    /// <summary>
    ///   ���Խ���ָ�����ȵ�����
    /// </summary>
    /// <returns> Cardinal
    /// </returns>
    /// <param name="buf"> (Pointer) </param>
    /// <param name="len"> (Cardinal) </param>
    function RecvBuf(buf:Pointer; len:Cardinal): Cardinal; stdcall;

    /// <summary>
    ///   �ر�����
    /// </summary>
    procedure CloseSocket; stdcall;
  end;

implementation

end.
