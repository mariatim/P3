# Echo server program
import socket

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 5001              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
data = str([1, 1, 1])

#conn.sendall(data.encode())
conn.sendall(bytes(data, "ascii"))
conn.close()
# optionally put a loop here so that you start
# listening again after the connection closes
