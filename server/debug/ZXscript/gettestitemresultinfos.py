# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
                    
def param_of_method(str_xml):
    rcv_xml = ET.fromstring(str_xml)
    testitemid = rcv_xml.find('interfaceparms').find('testitemid').text
    testitemid_list = testitemid.split(',')
    patienttype = rcv_xml.find('interfaceparms').find('patienttype').text
    patientid = rcv_xml.find('interfaceparms').find('patientid').text
    patientnumber = rcv_xml.find('interfaceparms').find('patientnumber').text
    inpatientid = rcv_xml.find('interfaceparms').find('inpatientid').text
    sql = 'select * from ytlis.v_xx_result where ' 
    awhere = ''
    for testitemid in testitemid_list:
        if awhere == '':
            awhere = '(testitemid = \'' + testitemid + '\''
        else:
            awhere = awhere + ' or testitemid = \'' + testitemid + '\''
    awhere = awhere + ')'
    sql = sql + awhere
    #if not patientid is None:
    #    sql = sql + ' and patientid = \'' + patientid + '\''
    #if not patientnumber is None:
    #    sql = sql + ' and patientnumber = \'' + patientnumber + '\''
    if not inpatientid is None:
        sql = sql + ' and inpatientid = \'' + inpatientid + '\''
    return sql

def result_of_method(str_xml):        
    return_root = ET.Element('root')
    from_root = ET.fromstring(str_xml)
    records_xml = from_root.find('root')

    for child_element in records_xml:
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'GetId') 
        key_element.text = child_element.find('PATIENTID').text + child_element.find('TEST_NO').text + child_element.find('TESTITEMID').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'PatientId').text = from_root.find('interfacemessage').find('interfaceparms').find('patientid').text
        ET.SubElement(data_element, 'PatientNumber').text = from_root.find('interfacemessage').find('interfaceparms').find('patientnumber').text
        ET.SubElement(data_element, 'InPatientId').text = from_root.find('interfacemessage').find('interfaceparms').find('inpatientid').text
        ET.SubElement(data_element, 'TestPurposeCH').text = child_element.find('TESTPURPOSECH').text
        ET.SubElement(data_element, 'Barcode').text = child_element.find('TEST_NO').text
        ET.SubElement(data_element, 'TestDate').text = child_element.find('TESTDATE').text
        ET.SubElement(data_element, 'ReportTime').text = child_element.find('REPORTTIME').text
        ET.SubElement(data_element, 'TestItemId').text = child_element.find('TESTITEMID').text
        ET.SubElement(data_element, 'TestItemCN').text = child_element.find('TESTITEMCN').text
        ET.SubElement(data_element, 'TestItemEN').text = child_element.find('TESTITEMEN').text
        ET.SubElement(data_element, 'TestIResult1').text = child_element.find('TESTIRESULT').text

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#     str_xml = '''
#         <Root>
#         <interfacemessage>
#             <hospitalcode>00003</hospitalcode>
#             <interfacename>getpateintinfos</interfacename>
#             <interfaceparms>
#                 <patienttype>1</patienttype>
#                 <patientid>patientid</patientid>
#                 <patientnumber>patientnumber</patientnumber>
#                 <inpatientid>inpatientid</inpatientid>
#                 <testitemid>ABO+Rh,DAT,FK,YK</testitemid>
#             </interfaceparms>
#         </interfacemessage>
#         <root>
#             <record>
#                 <PATIENTID>0002000195</PATIENTID>
#                 <PATIENTNUMBER>ZY010002000195</PATIENTNUMBER>
#                 <INPATIENTID>ZY010002000195</INPATIENTID>
#                 <TEST_NO>2000201830</TEST_NO>
#                 <TESTPURPOSECH>新生儿溶血病检测</TESTPURPOSECH>
#                 <TESTDATE>2017-08-06 16:19:46</TESTDATE>
#                 <REPORTTIME>2017-08-06 16:19:46</REPORTTIME>
#                 <TESTITEMID>ABO+Rh</TESTITEMID>
#                 <TESTITEMCN>ABO+Rh</TESTITEMCN>
#                 <TESTITEMEN>ABO+Rh</TESTITEMEN>
#                 <TESTIRESULT>B+</TESTIRESULT>
#             </record>
#             <record>
#                 <PATIENTID>0002000195</PATIENTID>
#                 <PATIENTNUMBER>ZY010002000195</PATIENTNUMBER>
#                 <INPATIENTID>ZY010002000195</INPATIENTID>
#                 <TEST_NO>2000201830</TEST_NO>
#                 <TESTPURPOSECH>新生儿溶血病检测</TESTPURPOSECH>
#                 <TESTDATE>2017-08-06 16:19:46</TESTDATE>
#                 <REPORTTIME>2017-08-06 16:19:46</REPORTTIME>
#                 <TESTITEMID>DAT</TESTITEMID>
#                 <TESTITEMCN>直接抗人球蛋白实验</TESTITEMCN>
#                 <TESTITEMEN>DAT</TESTITEMEN>
#                 <TESTIRESULT>阴性(-)</TESTIRESULT>
#             </record>
#             <record>
#                 <PATIENTID>0002000195</PATIENTID>
#                 <PATIENTNUMBER>ZY010002000195</PATIENTNUMBER>
#                 <INPATIENTID>ZY010002000195</INPATIENTID>
#                 <TEST_NO>2000201830</TEST_NO>
#                 <TESTPURPOSECH>新生儿溶血病检测</TESTPURPOSECH>
#                 <TESTDATE>2017-08-06 16:19:46</TESTDATE>
#                 <REPORTTIME>2017-08-06 16:19:46</REPORTTIME>
#                 <TESTITEMID>FK</TESTITEMID>
#                 <TESTITEMCN>放散抗体实验</TESTITEMCN>
#                 <TESTITEMEN>FK</TESTITEMEN>
#                 <TESTIRESULT>阴性(-)</TESTIRESULT>
#             </record>
#             <record>
#                 <PATIENTID>0002000195</PATIENTID>
#                 <PATIENTNUMBER>ZY010002000195</PATIENTNUMBER>
#                 <INPATIENTID>ZY010002000195</INPATIENTID>
#                 <TEST_NO>2000201830</TEST_NO>
#                 <TESTPURPOSECH>新生儿溶血病检测</TESTPURPOSECH>
#                 <TESTDATE>2017-08-06 16:19:46</TESTDATE>
#                 <REPORTTIME>2017-08-06 16:19:46</REPORTTIME>
#                 <TESTITEMID>YK</TESTITEMID>
#                 <TESTITEMCN>游离抗体实验</TESTITEMCN>
#                 <TESTITEMEN>YK</TESTITEMEN>
#                 <TESTIRESULT>阴性(-)</TESTIRESULT>
#             </record>
#         </root>
#         </Root>
#     '''
#     print(result_of_method(str_xml))

#     str_xml = '''
#        <interfacemessage>
#            <hospitalcode>00003</hospitalcode>
#            <interfacename>getpateintinfos</interfacename>
#            <interfaceparms>
#                <patienttype>1</patienttype>
#                <patientid>patientid</patientid>
#                <patientnumber>patientnumber</patientnumber>
#                <inpatientid>inpatientid</inpatientid>
#                <testitemid>ABO+Rh,DAT,FK,YK</testitemid>
#            </interfaceparms>
#        </interfacemessage>
#     '''
#     print(param_of_method(str_xml))
