# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import configparser 
import os

root = ET.Element('root')
test = ET.SubElement(root, 'test')
test.set('key', 'true')
print(test.attrib)
print(ET.dump(root))