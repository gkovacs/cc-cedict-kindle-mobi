# CC-CEDICT Chinese-English Dictionary for Kindle (mobi format)

## About

These scripts generate a `.mobi` file from the CC-CEDICT Chinese-English dictionary.

You can then load this `.mobi` file to your Kindle to use it as a dictionary.

The generated dictionary includes pinyin and definitions for words.

# Running

First install nodejs and kindlegen. Then run the following commands

```bash
npm install -g livescript
lsc to_dict.ls
python tab2opf.py -utf dictionary.txt
kindlegen dictionary.opf
```

# Author

[Geza Kovacs](https://github.com/gkovacs)

# License

MIT

# Related

For version with zhuyin and jyutping (cantonese), see https://github.com/gkovacs/cantodict-kindle-mobi

