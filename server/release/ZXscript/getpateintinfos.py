# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
                    
def param_of_method(str_xml):
    rcv_xml = ET.fromstring(str_xml)
    patienttype = rcv_xml.find('interfaceparms').find('patienttype').text
    patientid = rcv_xml.find('interfaceparms').find('patientid').text
    patientnumber = rcv_xml.find('interfaceparms').find('patientnumber').text
    inpatientid = rcv_xml.find('interfaceparms').find('inpatientid').text
    sql = 'select * from ythis.patient where patienttype = ' + patienttype
    if not patientid is None:
        sql = sql + ' and patientid = \'' + patientid + '\''
    if not patientnumber is None:
        sql = sql + ' and patientnumber = \'' + patientnumber + '\''
    if not inpatientid is None:
        sql = sql + ' and inpatientid = \'' + inpatientid + '\''
    return sql

def result_of_method(str_xml):
    return_root = ET.Element('root')
    from_root = ET.fromstring(str_xml)

    for child_element in from_root:
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'GetId') 
        key_element.text = child_element.find('PATIENTID').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'PatientId').text = child_element.find('PATIENTID').text
        ET.SubElement(data_element, 'PatientNumber').text = child_element.find('PATIENTNUMBER').text
        ET.SubElement(data_element, 'InPatientId').text = child_element.find('INPATIENTID').text
        ET.SubElement(data_element, 'InHospitalTime').text = child_element.find('INHOSPITALTIME').text
        ET.SubElement(data_element, 'PatientType').text = child_element.find('PATIENTTYPE').text
        ET.SubElement(data_element, 'PatientName').text = child_element.find('PATIENTNAME').text
        ET.SubElement(data_element, 'PatientSex').text = child_element.find('PATIENTSEX').text
        ET.SubElement(data_element, 'PatientAge').text = child_element.find('PATIENTAGE').text
        ET.SubElement(data_element, 'AgeUnit').text = child_element.find('AGEUNIT').text
        ET.SubElement(data_element, 'WardCode').text = child_element.find('WARDCODE').text
        ET.SubElement(data_element, 'WardName').text = child_element.find('WARDNAME').text
        ET.SubElement(data_element, 'DeptName').text = child_element.find('DEPTNAME').text
        ET.SubElement(data_element, 'DeptCode').text = child_element.find('DEPTCODE').text
        ET.SubElement(data_element, 'BedNo').text = child_element.find('BEDNO').text
        ET.SubElement(data_element, 'DigCode').text = child_element.find('DIGCODE').text
        ET.SubElement(data_element, 'DiagnosesID').text = child_element.find('DIAGNOSESID').text
        ET.SubElement(data_element, 'Diagnoses').text = child_element.find('DIAGNOSES').text
        ET.SubElement(data_element, 'Address').text = child_element.find('ADDRESS').text
        ET.SubElement(data_element, 'CompanyName').text = child_element.find('COMPANYNAME').text
        ET.SubElement(data_element, 'TelePhoneNo').text = child_element.find('TELEPHONENO').text
        ET.SubElement(data_element, 'MobilePhoneNo').text = child_element.find('MOBILEPHONENO').text
        ET.SubElement(data_element, 'IdCardNo').text = child_element.find('IDCARDNO').text
        ET.SubElement(data_element, 'MCardNo').text = child_element.find('MCARDNO').text
        ET.SubElement(data_element, 'FCardNo').text = child_element.find('FCARDNO').text
        ET.SubElement(data_element, 'HCardNo').text = child_element.find('HCARDNO').text

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#     str_xml = '''
#         <root>
#             <record>
#                 <PATIENTID>PATIENTID</PATIENTID>
#                 <PATIENTNUMBER>PATIENTNUMBER</PATIENTNUMBER>
#                 <INPATIENTID>INPATIENTID</INPATIENTID>
#                 <INHOSPITALTIME>INHOSPITALTIME</INHOSPITALTIME>
#                 <PATIENTTYPE>PATIENTTYPE</PATIENTTYPE>
#                 <PATIENTNAME>PATIENTNAME</PATIENTNAME>
#                 <PATIENTSEX>PATIENTSEX</PATIENTSEX>
#                 <PATIENTAGE>PATIENTAGE</PATIENTAGE>
#                 <AGEUNIT>AGEUNIT</AGEUNIT>
#                 <BIRTHDAY>BIRTHDAY</BIRTHDAY>
#                 <WARDCODE>WARDCODE</WARDCODE>
#                 <WARDNAME>WARDNAME</WARDNAME>
#                 <DEPTCODE>DEPTCODE</DEPTCODE>
#                 <DEPTNAME>DEPTNAME</DEPTNAME>
#                 <BEDNO>DIGCODE</BEDNO>
#                 <DIGCODE>DIGCODE</DIGCODE>
#                 <DIAGNOSESID>DIAGNOSESID</DIAGNOSESID>
#                 <DIAGNOSES>DIAGNOSES</DIAGNOSES>
#                 <ADDRESS>ADDRESS</ADDRESS>
#                 <COMPANYNAME>COMPANYNAME</COMPANYNAME>
#                 <TELEPHONENO>TELEPHONENO</TELEPHONENO>
#                 <MOBILEPHONENO>MOBILEPHONENO</MOBILEPHONENO>
#                 <IDCARDNO>IDCARDNO</IDCARDNO>
#                 <MCARDNO>MCARDNO</MCARDNO>
#                 <FCARDNO>FCARDNO</FCARDNO>
#                 <HCARDNO>HCARDNO</HCARDNO>
#             </record>
#         </root>
#     '''
#     print(result_of_method(str_xml))

#     str_xml = '''
#        <interfacemessage>
#            <hospitalcode>hospitalcode</hospitalcode>
#            <interfacename>getpateintinfos</interfacename>
#            <interfaceparms>
#                <patienttype>1</patienttype>
#                <patientid>patientid</patientid>
#                <patientnumber>patientnumber</patientnumber>
#                <inpatientid>inpatientid</inpatientid>
#            </interfaceparms>
#        </interfacemessage>
#     '''
#     print(param_of_method(str_xml))
