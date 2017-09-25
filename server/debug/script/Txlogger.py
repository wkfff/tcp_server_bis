import logging
import logging.config
import time
import os

log_file_path = 'log'
if not os.path.exists(log_file_path):
    os.mkdir(log_file_path)

logger = logging.getLogger('simple_example')
logger.setLevel(logging.DEBUG)

log_file_path = log_file_path + '\python_script'+ time.strftime("%Y-%m-%d")  +'.log'
ch = logging.FileHandler(log_file_path)
ch.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

ch.setFormatter(formatter)

logger.addHandler(ch)