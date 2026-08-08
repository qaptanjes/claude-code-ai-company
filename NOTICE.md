# Üçüncü Taraf İçerik / Third-Party Content

MIT lisansı bu deponun **kendi** içeriğini kapsar: ajan tanımları, `CLAUDE.md`,
kurulum scriptleri, dokümantasyon ve görseller.

*The MIT license covers this repository's **own** content: agent definitions,
`CLAUDE.md`, setup scripts, documentation and artwork.*

---

## `arsiv/` klasörü kapsam dışı / not covered

`arsiv/` altındaki içerik üçüncü taraflara aittir ve bu deponun lisansı altında
dağıtılmaz. Her kaydın kendi lisansı `_catalog.json` içindeki `license` alanında,
kaynak reposu `github_url` alanındadır.

*Content under `arsiv/` belongs to third parties and is not distributed under this
repository's license. Each entry's license is in the `license` field of
`_catalog.json`; its source repository is in `github_url`.*

| Kaynak / Source | İçerik / Content |
|---|---|
| [mdskills.ai](https://www.mdskills.ai) | skills, rules, mcp, plugins |
| [ripienaar/free-for-dev](https://github.com/ripienaar/free-for-dev) | dev (free-for.dev) |

**Bu depo arşivi paketlemez.** `arsiv-indir.ps1` scripti içeriği çalıştırma anında
doğrudan kaynağından indirir. Bu hem lisans açısından doğru olan, hem de veriyi güncel
tutan yaklaşımdır.

***This repository does not bundle the archive.*** *The `arsiv-indir.ps1` script fetches
it from the original sources at run time — both the correct thing to do license-wise and
the way to keep the data current.*
