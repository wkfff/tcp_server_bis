# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import configparser
import os
from Txlogger import logger

def format_datetime(str_date):
    return time.strftime('%Y%m%d%H%M%S', time.strptime(str_date, '%Y-%m-%d %H:%M:%S'))
def param_of_method(str_xml):
    logger.debug(str_xml)
    cf = configparser.ConfigParser()
    # cf.read(os.path.dirname(os.getcwd()) + '\TCPServer.ini')
    cf.read(os.getcwd() + '\TCPServer.ini')

    user_name = cf.get('ESBEntry', 'UserName')
    pass_word = cf.get('ESBEntry', 'PassWord')
    source_code = cf.get('ESBEntry', 'SourceSysCode')
    target_code = cf.get('ESBEntry', 'TargetSysCode')

    root = ET.fromstring(str_xml)

    root = root.find('root')

    format_input = '''
    <msg>
        <body>
            <row>
                <ELECTR_REQUISITION_NO></ELECTR_REQUISITION_NO>
                <SYS_FLAG></SYS_FLAG>
                <FEE_INFO></FEE_INFO>
            </row>
        </body>
    </msg>
    '''
    record_str = '''
        <RECORD>
            <PAT_INDEX_NO>5807465</PAT_INDEX_NO>
            <INHOSP_NO>2016-0357931-0</INHOSP_NO>
            <ORDER_NO>4263541</ORDER_NO>
            <CHARGE_ITEM_CODE>12040016</CHARGE_ITEM_CODE>
            <CHARGE_DATE>20161224105155</CHARGE_DATE>
            <AMOUNT>1</AMOUNT>
            <CHARGE_STAFF_CODE>00</CHARGE_STAFF_CODE>
            <DEPT_CODE>00</DEPT_CODE>
            <EXECUT_DEPT_CODE>120026</EXECUT_DEPT_CODE>
            <EXECUT_DEPT_NAME></EXECUT_DEPT_NAME>
            <EXECUT_DR_CODE>7164</EXECUT_DR_CODE>
            <EXECUT_HS_CODE>120026</EXECUT_HS_CODE>
        </RECORD>
    '''
    

    format_xml = ET.fromstring(format_input)
    fee_info = format_xml.find('body').find('row').find('FEE_INFO')

    for child_of_child in root:
        format_xml.find('body').find('row').find('ELECTR_REQUISITION_NO').text = child_of_child.find('ELECTR_REQUISITION_NO').text
        format_xml.find('body').find('row').find('SYS_FLAG').text = child_of_child.find('SYS_FLAG').text
        record_xml = ET.fromstring(record_str)
        record_xml.find('PAT_INDEX_NO').text = child_of_child.find('PAT_INDEX_NO').text
        record_xml.find('INHOSP_NO').text = child_of_child.find('INHOSP_NO').text
        record_xml.find('ORDER_NO').text = child_of_child.find('OrderNo').text
        record_xml.find('CHARGE_ITEM_CODE').text = child_of_child.find('CHARGE_ITEM_CODE').text
        record_xml.find('CHARGE_DATE').text = format_datetime(child_of_child.find('MODIFY_DATE').text)
        record_xml.find('AMOUNT').text = child_of_child.find('AMOUNT').text
        record_xml.find('CHARGE_STAFF_CODE').text = child_of_child.find('MODIFY_STAFF_CODE').text
        record_xml.find('DEPT_CODE').text = child_of_child.find('MODIFY_DEPT_CODE').text
        record_xml.find('EXECUT_DEPT_CODE').text = child_of_child.find('EXECUT_DEPT_CODE').text
        # record_xml.find('EXECUT_DEPT_NAME').text = '血库'
        record_xml.find('EXECUT_DR_CODE').text = child_of_child.find('EXECUT_DR_CODE').text
        record_xml.find('EXECUT_HS_CODE').text = child_of_child.find('FEE_ACCOUT_CODE').text
        fee_info.append(record_xml)

    Value = '<ESBEntry>' + '<AccessControl>' + '<UserName>' + user_name + '</UserName>' + '<Password>' + pass_word + '</Password>' + '<Fid>BS15030</Fid>' + '</AccessControl>' + '<MessageHeader>' + '<Fid>BS15030</Fid>' + '<SourceSysCode>' + source_code + '</SourceSysCode>' + '<TargetSysCode>' + target_code + \
        '</TargetSysCode>' + '<MsgDate>' + time.strftime("%Y-%m-%d %H:%M:%S") + '</MsgDate>' + '</MessageHeader>' + '<RequestOption>' + '<onceFlag/>' + '<startNum/>' + \
        '<endNum/>' + '</RequestOption>' + '<MsgInfo><Msg><![CDATA[' + ET.tostring(
            format_xml, encoding='utf-8').decode('utf-8') + ']]></Msg></MsgInfo></ESBEntry>'
    return Value


def result_of_method(str_xml):
    root = ET.Element('root')
    for orderId in str_xml.split(';'):
        record = ET.SubElement(root, 'record')
        key_ele = ET.SubElement(record, 'SerialNo')
        key_ele.text = orderId
        key_ele.set('key', 'true')
        ET.SubElement(record, 'HisChargeState').text = '1'
        ET.SubElement(record, 'HisChargeTime').text = time.strftime("%Y-%m-%d %H:%M:%S")
    result = ET.tostring(root, encoding='utf-8').decode('utf-8')
    return result


# if __name__ == '__main__':
    # str_xml = '''
    #     <ESBEntry>
    #         <MessageHeader>
    #             <Fid>BS20011</Fid>
    #             <SourceSysCode>S11</SourceSysCode>
    #             <TargetSysCode>S11</TargetSysCode>
    #             <MsgDate>2017-09-05 10:37:10</MsgDate>
    #         </MessageHeader>
    #         <RequestOption>
    #             <onceFlag>0</onceFlag>
    #         </RequestOption>
    #         <MsgCount>1</MsgCount>
    #         <MsgInfo>
    #             <Msg>
    #             <![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>10003046</INHOSP_INDEX_NO><INHOSP_NO>2017-0847280-0</INHOSP_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>DBIL</TEST_SIMPLE_NAME><BAR_CODE_NO>6709020008</BAR_CODE_NO><RECEIVE_DATE>2017-09-02T12:00:22</RECEIVE_DATE><TEST_ITEM_NAME>*直接胆红素</TEST_ITEM_NAME><TEST_ITEM_CODE>100020</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>umol/L</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>23</TEST_RESULT_VALUE><PAT_INDEX_NO>7094247</PAT_INDEX_NO><REFERENCE_VALUE>0-8</REFERENCE_VALUE><REPORT_DATE>2017-09-02T15:47:18</REPORT_DATE><REPORT_NO>6709020008</REPORT_NO></row></body></msg>]]>
    #             </Msg>
    #         </MsgInfo>
    #         <RetInfo>
    #             <RetCode>1</RetCode>
    #             <RetCon>查询成功</RetCon>
    #         </RetInfo>
    #         </ESBEntry>
    # '''
    # print(result_of_method(str_xml))

#         str_xml = '''
#           <xml>
#     <root>
#         <record>
#             <OperationType>1</OperationType>
#             <ChargeType>1</ChargeType>
#             <ChargeSource>0</ChargeSource>
#             <PAT_INDEX_NO>000476507400</PAT_INDEX_NO>
#             <PatientNumber>914799</PatientNumber>
#             <INHOSP_NO>4246305</INHOSP_NO>
#             <ELECTR_REQUISITION_NO>0181717001856</ELECTR_REQUISITION_NO>
#             <SYS_FLAG>2</SYS_FLAG>
#             <ChargeCode>45</ChargeCode>
#             <CHARGE_ITEM_CODE>F5008</CHARGE_ITEM_CODE>
#             <ChargeName>血液交叉费聚凝法</ChargeName>
#             <ChargePrice>5</ChargePrice>
#             <AMOUNT>2</AMOUNT>
#             <OrderNo>16</OrderNo>
#             <ChargeAmount>2</ChargeAmount>
#             <MODIFY_DATE>2017-09-06 13:44:59</MODIFY_DATE>
#             <MODIFY_STAFF_CODE>00</MODIFY_STAFF_CODE>
#             <MODIFY_DEPT_CODE>12006</MODIFY_DEPT_CODE>
#             <EXECUT_DR_CODE>00</EXECUT_DR_CODE>
#             <EXECUT_DEPT_CODE>12006</EXECUT_DEPT_CODE>
#             <FEE_ACCOUT_CODE>12006</FEE_ACCOUT_CODE>
#             <ProduceNo>48</ProduceNo>
#         </record>
#         <record>
#             <OperationType>1</OperationType>
#             <ChargeType>1</ChargeType>
#             <ChargeSource>0</ChargeSource>
#             <PAT_INDEX_NO>000476507400</PAT_INDEX_NO>
#             <PatientNumber>914799</PatientNumber>
#             <INHOSP_NO>4246305</INHOSP_NO>
#             <ELECTR_REQUISITION_NO>0181717001856</ELECTR_REQUISITION_NO>
#             <SYS_FLAG>2</SYS_FLAG>
#             <ChargeCode>45</ChargeCode>
#             <CHARGE_ITEM_CODE>F5008</CHARGE_ITEM_CODE>
#             <ChargeName>血液交叉费聚凝法</ChargeName>
#             <ChargePrice>5</ChargePrice>
#             <AMOUNT>2</AMOUNT>
#             <ChargeAmount>2</ChargeAmount>
#             <MODIFY_DATE>2017-09-06 13:44:59</MODIFY_DATE>
#             <MODIFY_STAFF_CODE>00</MODIFY_STAFF_CODE>
#             <MODIFY_DEPT_CODE>12006</MODIFY_DEPT_CODE>
#             <EXECUT_DR_CODE>00</EXECUT_DR_CODE>
#             <EXECUT_DEPT_CODE>12006</EXECUT_DEPT_CODE>
#             <FEE_ACCOUT_CODE>12006</FEE_ACCOUT_CODE>
#             <ProduceNo>48</ProduceNo>
#             <OrderNo>16</OrderNo>
#         </record>
#     </root>
#     <interfacemessage>
#         <hospitalcode>00001</hospitalcode>
#         <interfacename>chargefees</interfacename>
#         <interfaceparms>
#             <patienttype>patienttype</patienttype>
#             <patientid>patientid</patientid>
#             <patientnumber>patientnumber</patientnumber>
#             <inpatientid>inpatientid</inpatientid>
#             <chargetype>chargetype</chargetype>
#             <produceno>48</produceno>
#         </interfaceparms>
#     </interfacemessage>
# </xml>
#         '''
#         print(param_of_method(str_xml))
