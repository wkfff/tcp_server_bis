unit IHospitalBISServiceIntf;

interface

uses
  qxml;

type
  IHospitalBISService = interface
    ['{EE5EF622-653F-4158-A161-3316AC006B88}']
    function GetTestItemResultInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetPateintInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetTestItemInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetDiagnosesInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetSurgeryInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetTreatmentItemInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetChargeItemInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetStaffInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetWardInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function GetDeptInfos(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function SendClinicalRequisitionOrder(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function SendPatientConsts(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
    function DeleteClinicalRequisitionOrder(const ARecvXML: TQXML;var ASendXML: TQXML): Boolean;
  end;

implementation

end.
