import sys
from io import open

from Cython.Build import cythonize
from setuptools import Extension, setup

if sys.platform.startswith("linux"):
    cflags = ["-O2"]
elif sys.platform == "win32":
    cflags = ["/O2"]
elif sys.platform == "darwin":
    cflags = ["-std=c++11", "-O2"]
else:
    cflags = []

extensions = [
    Extension(
        "hattrie",
        ["hattrie.pyx"],
        include_dirs=["include", "tessil-hat-trie/include/tsl"],
        extra_compile_args = cflags, 
        language="c++",
    )
]

with open("README.md", "r", encoding="utf-8") as fr:
    long_description = fr.read()

setup(
    author="Dobatymo",
    name="hat-trie-python",
    version="0.6.0",
    url="https://github.com/Dobatymo/hat-trie-python",
    description="Python bindings for Tessil/hat-trie",
    long_description=long_description,
    long_description_content_type="text/markdown",
    ext_modules=cythonize(extensions),
    python_requires=">=2.7",
    use_2to3=False,
    zip_safe=False,
)
