from setuptools import setup, Extension
from Cython.Build import cythonize

extensions = [Extension("hattrie", ["hattrie.pyx"], include_dirs=["tessil-hat-trie/tsl"], language='c++')]

setup(
	name = 'hat-trie-python',
	version = '0.3.0',
	url = "https://github.com/Dobatymo/hat-trie-python",
	ext_modules = cythonize(extensions)
)
