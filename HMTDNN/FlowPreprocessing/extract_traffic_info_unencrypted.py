from scapy.all import *
import pandas as pd
import numpy as np
import time
import re
import pathlib
from array import *
try:
    import scapy.all as scapy
except ImportError:
    import scapy
import pandas as pd
try:
    # This import works from the project directory
    import scapy_http.http
except ImportError:
       # If you installed this package via pip, you just need to execute this
 from scapy.layers import http
video_domain_match_rule = [re.compile(".*news.*")]
host_ip_src_address = '172.18.218.96'

def get_pkt_info(pkt):
    if pkt[IP].src == host_ip_src_address:
        traffic_dst_address = pkt[IP].dst
        if pkt.haslayer(TCP):
            traffic_src_port = pkt[TCP].sport
            traffic_dst_port = pkt[TCP].dport
            traffic_protocol = 0
        else:
            traffic_src_port = pkt[UDP].sport
            traffic_dst_port = pkt[UDP].dport
            traffic_protocol = 1
    else:
        traffic_dst_address = pkt[IP].src
        if pkt.haslayer(TCP):
            traffic_src_port = pkt[TCP].dport
            traffic_dst_port = pkt[TCP].sport
            traffic_protocol = 0
        else:
            traffic_src_port = pkt[UDP].dport
            traffic_dst_port = pkt[UDP].sport
            traffic_protocol = 1
    return traffic_src_port, traffic_dst_address, traffic_dst_port, traffic_protocol

# 提取DNS信息
def extract_traffic_info(suffix):
    path = './pkts_' + str(suffix) + '.pcapng'
    print('Reading ', path, ' currently')

    time_start = time.time()
    packets = scapy.rdpcap(path)
    time_end = time.time()
    print('Reading pcap file costs: ', time_end - time_start)

    video_dict = {}
    reverse_video_list = []
    video_ip_address = []
    pkt_num = 0
    dns_pkt_num =0
    for pkt in packets:
        if pkt.haslayer("HTTPRequest"):
            if "news" or "people" in str(pkt["HTTPRequest"].fields['Path']):
                traffic_src_port, traffic_dst_address, traffic_dst_port, traffic_protocol = get_pkt_info(pkt)
                video_ip_address.append(traffic_dst_address)
    traffic_dict = {}
    host_ip_src_address = '172.18.218.96'
    for pkt in packets:
        traffic_src_port, traffic_dst_address, traffic_dst_port, traffic_protocol = get_pkt_info(pkt)
        if traffic_dst_address not in video_ip_address:
            continue
        traffic = (host_ip_src_address, traffic_src_port, traffic_dst_address, traffic_dst_port, traffic_protocol)
        if traffic in traffic_dict:
            traffic_dict[traffic][1] = pkt.time
            traffic_dict[traffic][2] += 1
            if pkt[IP].src == host_ip_src_address:
                traffic_dict[traffic][3] += 1
            else:
                traffic_dict[traffic][4] += 1
        else:
            if pkt[IP].src == host_ip_src_address:
                traffic_dict.setdefault(traffic, [pkt.time, pkt.time, 1, 1, 0])
            else:
                traffic_dict.setdefault(traffic, [pkt.time, pkt.time, 1, 0, 1])
    traffic_pkts_dict = {}
    traffic_count = {}
    value = [0, 0., 0, 0, 0, 0, 0, '0.0.0.0', '0.0.0.0', 0]
    for traffic in traffic_dict:
        traffic_pkts_dict.setdefault(traffic, [value] * traffic_dict[traffic][2])
        traffic_count.setdefault(traffic, 0)
    for pkt in packets:
        traffic_src_port, traffic_dst_address, traffic_dst_port, traffic_protocol = get_pkt_info(pkt)
        if (traffic_dst_address not in video_ip_address) or (pkt[TCP].flags & 4 != 0):
            continue
        traffic = (host_ip_src_address, traffic_src_port, traffic_dst_address, traffic_dst_port, traffic_protocol)
        traffic_pkts_dict[traffic][traffic_count[traffic]] = [traffic_count[traffic], pkt.time, len(pkt[TCP].payload), pkt[IP].len, -1, pkt[TCP].sport, pkt[TCP].dport, pkt[IP].src, pkt[IP].dst, pkt[TCP].window]
        traffic_count[traffic] += 1

    path = './traffic_news_people.csv'
    traffic_detail_file = pathlib.Path('./traffic_news_people.csv')
    if not traffic_detail_file.exists():
        train_set = pd.DataFrame([], columns=['pktID', 'time', 'TCPLen', 'IPLen', 'link', 'srcPort', 'dstPort', 'srcIP', 'dstIP', 'TCP window'])
        train_set.to_csv(path)
    traffic_detail = pd.read_csv(path, index_col=0)
    print(len(traffic_detail))
    for traffic in traffic_dict:
        cur_traffic_detail = traffic_pkts_dict[traffic]
        print(len(traffic))
        cur_traffic_detail.append([0, 0, 0, 0, 0, 0, 0, '0', '0', 0])
        cur_traffic_detail = pd.DataFrame(cur_traffic_detail, columns=['pktID', 'time', 'TCPLen', 'IPLen', 'link', 'srcPort', 'dstPort', 'srcIP', 'dstIP', 'TCP window'])
        traffic_detail = pd.concat([traffic_detail, cur_traffic_detail])
    traffic_detail.to_csv(path)


if __name__  == '__main__':
    for i in range(1, 505):
        extract_traffic_info(i)