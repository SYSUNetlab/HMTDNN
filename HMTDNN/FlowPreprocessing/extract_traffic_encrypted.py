from scapy.all import *
import os
import re
import pandas as pd

load_layer("tls")

def parse_tls_pkts(read_path_prefix, save_path, match_rules):
    suffix = 1
    read_path = read_path_prefix + str(suffix) + '.pcapng'

    if not os.path.exists(save_path):
        train_set = pd.DataFrame([], columns=['pktID', 'time', 'TCPLen', 'IPLen', 'link', 'srcPort', 'dstPort', 'srcIP', 'dstIP',
                                              'TCP window'])
        train_set.to_csv(save_path)

    while os.path.exists(read_path):
        time_start = time.time()
        pkts = rdpcap(read_path)
        time_end = time.time()
        print("Reading pkts_{0} successfully, costing {1}s".format(suffix, time_end - time_start))

        tls_traffic_dict = {}
        traffic_dict = {}
        srcIP = ''

        # 遍历所有分组，找到client hello包中满足条件的所有流
        index = 0       # debug
        for pkt in pkts:
            flag = False
            if not pkt.haslayer(IP) or not pkt.haslayer(TCP):
                index += 1
                continue
            # 如果是TLS握手包且是ClientHello
            if pkt.haslayer(TLS) and pkt[TLS].type == 0x16 and pkt[TLS].msg[0].name == 'TLS Handshake - Client Hello' and pkt[TLS].msg[0].msgtype == 0x1:
                # 遍历所有的扩展
                for ext in pkt[TLS].msg[0].ext:
                    # 如果是ServerName扩展，提取servernames字段
                    if isinstance(ext, TLS_Ext_ServerName):
                        # 该扩展中可能有多个servername，遍历所有servername以及所有正则表达式匹配
                        for servername in ext.servernames:
                            for rule in match_rules:
                                if rule.match(servername.servername.decode()) != None:
                                    print(servername.servername.decode())
                                    traffic = (pkt[IP].src, pkt[IP].dst, pkt[TCP].sport, pkt[TCP].dport)
                                    if traffic not in tls_traffic_dict:
                                        if traffic not in traffic_dict:
                                            tls_traffic_dict.setdefault(traffic, 0)
                                        else:
                                            tls_traffic_dict.setdefault(traffic, traffic_dict[traffic])

            if pkt[IP].src == srcIP:
                traffic = (pkt[IP].src, pkt[IP].dst, pkt[TCP].sport, pkt[TCP].dport)
            elif pkt[IP].dst == srcIP:
                traffic = (pkt[IP].dst, pkt[IP].src, pkt[TCP].dport, pkt[TCP].sport)
            else:
                print('error')
                exit(-1)
            if traffic in traffic_dict:
                traffic_dict[traffic] += 1
            else:
                traffic_dict.setdefault(traffic, 1)
            if traffic in tls_traffic_dict:
                tls_traffic_dict[traffic] += 1

        print(tls_traffic_dict)
        traffic_pkts_dict = {}
        traffic_count = {}
        value = [0, 0., 0, 0, 0, 0, 0, '0.0.0.0', '0.0.0.0', 0]
        for traffic in tls_traffic_dict:
            traffic_pkts_dict.setdefault(traffic, [value] * tls_traffic_dict[traffic])
            traffic_count.setdefault(traffic, 0)
        index2 = 0
        for pkt in pkts:
            if not pkt.haslayer(IP) or not pkt.haslayer(TCP):
                index2 += 1
                continue
            if pkt[IP].src == srcIP:
                traffic = (pkt[IP].src, pkt[IP].dst, pkt[TCP].sport, pkt[TCP].dport)
            elif pkt[IP].dst == srcIP:
                traffic = (pkt[IP].dst, pkt[IP].src, pkt[TCP].dport, pkt[TCP].sport)
            else:
                print('error')
                exit(-1)
            if traffic not in tls_traffic_dict:
                continue
            traffic_pkts_dict[traffic][traffic_count[traffic]] = [traffic_count[traffic], pkt.time, len(pkt[TCP].payload), pkt[IP].len, -1, pkt[TCP].sport, pkt[TCP].dport, pkt[IP].src, pkt[IP].dst, pkt[TCP].window]
            traffic_count[traffic] += 1

        train_set = pd.read_csv(save_path, index_col=0)
        for traffic in traffic_pkts_dict:
            cur_traffic_init = traffic_pkts_dict[traffic]
            if len(cur_traffic_init) > 2000:
                cur_traffic = cur_traffic_init[:2000]
            else:
                cur_traffic = cur_traffic_init
            cur_traffic.append([0, 0, 0, 0, 0, 0, 0, '0', '0', 0])
            cur_traffic = pd.DataFrame(cur_traffic, columns=['pktID', 'time', 'TCPLen', 'IPLen', 'link', 'srcPort', 'dstPort', 'srcIP', 'dstIP', 'TCP window'])
            train_set = pd.concat([train_set, cur_traffic])
        train_set.to_csv(save_path,line_terminator='\n')
        suffix += 1
        read_path = read_path_prefix + str(suffix) + '.pcapng'


if __name__ == '__main__':
    read_path_prefix = './data/pkts_'
    save_path = './music443.csv'
    match_rules = [re.compile('.*pic\.xiami\.net.*')]
    parse_tls_pkts(read_path_prefix, save_path, match_rules)