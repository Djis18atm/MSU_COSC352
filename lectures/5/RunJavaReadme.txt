 1481  java -version\njava -XshowSettings:properties | grep os.arch\n
 1482  ls
 1483  javac MandelbrotJNI.java
 1484  javac -h . MandelbrotJNI.java\n
 1485  gcc -shared -o libmandelbrot.dylib -fPIC MandelbrotJNI.c \\n    -I${JAVA_HOME}/include -I${JAVA_HOME}/include/darwin -arch arm64\n
 1486  export JAVA_HOME=$(/usr/libexec/java_home -v 11)\n
 1487  printenv JAVA_HOME
 1488  echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@11' >> ~/.zshrc\necho 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc\nsource ~/.zshrc\n
 1489  touch ~/.zshrc
 1490  echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@11' >> ~/.zshrc\necho 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc\nsource ~/.zshrc\n
 1491  brew install java_home
 1492  export JAVA_HOME=/opt/homebrew/opt/openjdk@11
 1493  which java
 1494  gcc -shared -o libmandelbrot.dylib -fPIC MandelbrotJNI.c \\n    -I${JAVA_HOME}/include -I${JAVA_HOME}/include/darwin -arch arm64\n
 1495  java -Djava.library.path=. MandelbrotJNI\n
 1496  java -Djava.library.path=. MandelbrotJNI\n
