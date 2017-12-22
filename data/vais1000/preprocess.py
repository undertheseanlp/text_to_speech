from os import mkdir, listdir, remove
from os.path import join, dirname
import shutil

# === GLOBAL VARIABLE ===
SAMPLE = 20
current_folder = dirname(__file__)
raw_folder = join(current_folder, "raw")
corpus_folder = join(current_folder, "corpus_{}".format(SAMPLE))


# === FUNCTIONS ===
def make_txt():
    shutil.copytree(join(raw_folder, "txt"), join(corpus_folder, "txt"))
    content = open(join(raw_folder, "txt", "text")).readlines()[:SAMPLE]
    content = "".join(content)
    open(join(corpus_folder, "txt", "text"), "w").write(content)


def make_wav():
    shutil.copytree(join(raw_folder, "wav"), join(corpus_folder, "wav"))
    ids = open(join(raw_folder, "txt", "text")).readlines()[:SAMPLE]
    ids = [item.split("|")[0] for item in ids]
    files = [item + ".wav" for item in ids]
    for f in listdir(join(corpus_folder, "wav")):
        if f not in files:
            remove(join(corpus_folder, "wav", f))


if __name__ == '__main__':
    try:
        shutil.rmtree(corpus_folder)
    except:
        pass
    finally:
        mkdir(corpus_folder)
    shutil.copytree(join(raw_folder, "txt_gen"), join(corpus_folder, "txt_gen"))
    make_txt()
    make_wav()
