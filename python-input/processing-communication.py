# Echo server program
import socket

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 5001              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
data = [5, 4, 1, 6, 4, 3]

#conn.sendall(data.encode())
conn.sendall(bytes(data))
conn.close()
# optionally put a loop here so that you start
# listening again after the connection closes
