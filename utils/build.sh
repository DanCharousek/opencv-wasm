git clone https://github.com/opencv/opencv.git
cd opencv
git checkout 4.3.0

# Add non async flag before compiling in the python build_js.py script
#         flags += "-s WASM_ASYNC_COMPILATION=0 "
#         flags += "-s SINGLE_FILE=0 "
#         flags += "-s WASM=1 "
docker run --rm --workdir /code -v "$PWD":/code "trzeci/emscripten:sdk-tag-1.38.32-64bit" python ./platforms/js/build_js.py build_wasm --build_wasm --build_test

# Backup the default build_wasm resukt
cp -a ./build_wasm/ ./build_wasm_backup

# test the compilation result (use node LTS)
cd build_wasm/bin
npm install
node tests.js # make sure 0 failed

# separate wasm
cd ../../..
node seperateBinaryFile.js
cd opencv/build_wasm/bin

# beautify opencv.js using js-beautify
npx js-beautify opencv.js -r

# test again
node tests.js # make sure 0 failed

# copy results to utils
cd ../../..
cp ./opencv/build_wasm/bin/opencv.wasm .
cp ./opencv/build_wasm/bin/opencv.js .

