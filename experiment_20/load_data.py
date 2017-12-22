from os.path import dirname, join

from shutil import rmtree, copytree

SAMPLE = 20

current_folder = dirname(__file__)
try:
    rmtree(join(current_folder, "data"))
except:
    pass
finally:
    corpus_folder = join(dirname(current_folder), "data", "vais1000", "corpus_{}".format(SAMPLE))
    copytree(corpus_folder, join(current_folder, "data"))
