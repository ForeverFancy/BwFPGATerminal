def init(outfile):
    string = "Wow, that is awesome!"
    with open(outfile, "w") as f:
        # f.write("memory_initialization_radix=16\nmemory_initialization_vector=\n")
        for ch in string:
            num = hex(ord(ch) - 32)[2:]
            wn='0'*(2-len(num))+num
            print(wn)
            # print(ord(ch) - 32)
            # f.write(wn+'\n')
        # for i in range(0, 200):
            # f.write('00\n')
if __name__ == "__main__":
    init("init.txt")
