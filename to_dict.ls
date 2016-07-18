require! {
  fs
}

dict_lines = fs.readFileSync('cedict_1_0_ts_utf-8_mdbg.txt', 'utf-8').split("\n")
output = []
simp_to_trad = {}
trad_to_simp = {}
for line in dict_lines
  if line[0] == '#'
    continue
  split_by_space = line.split(' ')
  trad = split_by_space[0]
  simp = split_by_space[1]
  pinyin_and_defs = split_by_space[2 to].join(' ').trim()
  pinyin = pinyin_and_defs.split(']')[0].substr(1).trim()
  defs = pinyin_and_defs.split(']')[1 to].join(' ').trim().split('/').filter(-> it.length > 0).join("\\n")
  if trad != simp
    if not trad_to_simp[trad]?
      trad_to_simp[trad] = simp
    if not simp_to_trad[simp]?
      simp_to_trad[simp] = trad
    output.push [simp, " [#{trad}] (#{pinyin})\\n#{defs}"].join('\t')
    output.push [trad, " [#{simp}] (#{pinyin})\\n#{defs}"].join('\t')
  else
    output.push [simp, "(#{pinyin})\\n#{defs}"].join('\t')
fs.writeFileSync 'dictionary.txt', output.join('\n')
#fs.writeFileSync 'trad_to_simp.json', JSON.stringify(trad_to_simp)
#fs.writeFileSync 'simp_to_trad.json', JSON.stringify(simp_to_trad)
