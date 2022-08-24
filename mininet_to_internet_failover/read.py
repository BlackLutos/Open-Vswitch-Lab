import os


f = open('ping_result2.log','r')
text = f.readlines()
info = ''
for i in text[-2]:
    info += i
print(info)
posi = info.find('received')
print(info[posi-3:posi-2])