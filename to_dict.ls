require! {
  fs
}

dict_lines = fs.readFileSync('cedict_1_0_ts_utf-8_mdbg.txt', 'utf-8').split("\n")
output = []
simp_to_trad = {}
trad_to_simp = {}
word_to_pinyin_to_def_list = {}
for line in dict_lines
  if line[0] == '#'
    continue
  split_by_space = line.split(' ')
  trad = split_by_space[0]
  simp = split_by_space[1]
  pinyin_and_defs = split_by_space[2 to].join(' ').trim()
  pinyin = pinyin_and_defs.split(']')[0].substr(1).trim()
  defs = pinyin_and_defs.split(']')[1 to].join(']').trim().split('/').filter(-> it.length > 0).join("\\n")
  if trad != simp
    if not trad_to_simp[trad]?
      trad_to_simp[trad] = simp
    if not simp_to_trad[simp]?
      simp_to_trad[simp] = trad
    if not word_to_pinyin_to_def_list[simp]?
      word_to_pinyin_to_def_list[simp] = {}
    if not word_to_pinyin_to_def_list[trad]?
      word_to_pinyin_to_def_list[trad] = {}
    if not word_to_pinyin_to_def_list[simp][pinyin]?
      word_to_pinyin_to_def_list[simp][pinyin] = []
    if not word_to_pinyin_to_def_list[trad][pinyin]?
      word_to_pinyin_to_def_list[trad][pinyin] = []
    word_to_pinyin_to_def_list[simp][pinyin].push defs
    word_to_pinyin_to_def_list[trad][pinyin].push defs
  else
    if not word_to_pinyin_to_def_list[simp]?
      word_to_pinyin_to_def_list[simp] = {}
    if not word_to_pinyin_to_def_list[simp][pinyin]?
      word_to_pinyin_to_def_list[simp][pinyin] = []
    word_to_pinyin_to_def_list[simp][pinyin].push defs

for word,pinyin_to_def_list of word_to_pinyin_to_def_list
  alt_form = word
  need_alt_form = false
  if simp_to_trad[word]?
    need_alt_form = true
    alt_form = simp_to_trad[word]
  if trad_to_simp[word]?
    need_alt_form = true
    alt_form = trad_to_simp[word]
  def_lines = []
  #if word != alt_form
  #  def_lines.push "[#{}]"
  prev_pinyin = ''
  for pinyin,def_list of pinyin_to_def_list
    if prev_pinyin != pinyin
      cur_def = ''
      if need_alt_form
        cur_def += "[#{alt_form}] "
        need_alt_form = false
      cur_def += "(#{pinyin})"
      prev_pinyin = pinyin
      def_lines.push cur_def
      cur_def = ''
    for def in def_list
      def_lines.push def
  definitions = def_lines.join('\\n')
  output.push [word, definitions].join('\t')

fs.writeFileSync 'dictionary.txt', output.join('\n')
#fs.writeFileSync 'trad_to_simp.json', JSON.stringify(trad_to_simp)
#fs.writeFileSync 'simp_to_trad.json', JSON.stringify(simp_to_trad)
