
def convert(inputfilename, outfilename):
    mod_text=[]
    with open(inputfilename, "r") as f:
        text = f.readlines()
        for line in text:
            conbind_val=''
            newline = line.strip()[:79].split(',')
            # print(newline)
            for val in newline:
                conbind_val+=val[2:]
            # print(conbind_val)
            mod_text.append(conbind_val+'\n')
        # print(mod_text)


    with open(outfilename, "w") as f:
        f.writelines(mod_text)

if __name__ == "__main__":
    convert("PCtoLCD2002/ascii.TXT","PCtoLCD2002/ascii.coe")
