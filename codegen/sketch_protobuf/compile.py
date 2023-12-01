import os, subprocess, sys
from fix_protobuf_imports.fix_protobuf_imports import fix_protobuf_imports
PROTO_PATH = './protos'
PYTHON_OUT_PATH = './python_pb'

def compile_directory(dir_prefix: str):
    files = [each for each in os.listdir(dir_prefix) if os.path.isfile(f'{dir_prefix}/{each}')]
    proto_files = [file for file in files if file[-6:] == '.proto']
    dirs = [each for each in os.listdir(dir_prefix) if not os.path.isfile(f'{dir_prefix}/{each}')]
    for file in proto_files:
        if file[-6:] == '.proto':
            process = subprocess.run(f"protoc --proto_path={PROTO_PATH} \
                        --python_out={PYTHON_OUT_PATH} \
                        {dir_prefix}/{file}",\
                        shell=True, check=True)
            if process.returncode == 0:
                print(f'{dir_prefix}/{file} compiled')
    
    # create __init__.py
    if proto_files:
        cur_py_path = dir_prefix[len(PROTO_PATH):]
        if cur_py_path:
            cur_py_path = f'{PYTHON_OUT_PATH}/{cur_py_path}'
        else:
            cur_py_path = PYTHON_OUT_PATH
        with open(f'{cur_py_path}/__init__.py', 'a'):
            pass

    for dir in dirs:
        compile_directory(dir_prefix=f'{dir_prefix}/{dir}')

if __name__ == '__main__':
    try:
        os.mkdir(PYTHON_OUT_PATH)
    except:
        pass
    compile_directory(PROTO_PATH)
    sys.argv.append(PYTHON_OUT_PATH)
    sys.exit(fix_protobuf_imports())
