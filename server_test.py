import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

sock.bind(('', 3200))

while True:
	buf = sock.recv(16)
	print(buf)
