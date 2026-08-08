# 🤝 Katkı Rehberi / Contributing

Katkılar memnuniyetle. / Contributions welcome.

## 🇹🇷 Türkçe

### Yeni rol eklemek

1. `.claude/agents/<rol-adi>.md` oluştur
2. Frontmatter'ı doldur: `name`, `description`, `tools`, `model`
3. Sistem promptunu yaz — **ortak sözleşme bloğunu dosyanın sonuna ekle** (diğer ajanlardan kopyala)
4. `CLAUDE.md`'deki kadro tablosuna ekle
5. `README.md`'deki kadro tablosuna ekle

### Model önerisi

Bir rolün modelini değiştirmeyi öneriyorsan **gerekçesini yaz.** Bu depoda model ataması
fiyata göre değil, yetenek–süre dengesine göre yapılıyor:

- **Fable 5** → en zor muhakeme + uzun tur kabul edilebilir
- **Opus 5** → geri kalan her şey
- 🔒 Güvenlik rolü Fable 5'e **alınmaz** (siber içerik sınıflandırıcıları)

### Çeviri

Ajan talimatları Türkçe. İngilizce sürüm isteyen varsa `.claude/agents-en/` altında
paralel bir set olarak katkı verilebilir.

### PR açmadan önce

- `.\kur.ps1` (veya `./kur.sh`) hatasız çalışıyor mu?
- 20 ajan dosyası da yerinde mi?
- README'deki tablolar güncel mi?

---

## 🇬🇧 English

### Adding a role

1. Create `.claude/agents/<role-name>.md`
2. Fill the frontmatter: `name`, `description`, `tools`, `model`
3. Write the system prompt — **append the shared contract block** (copy from another agent)
4. Add it to the roster table in `CLAUDE.md` and `README.md`

### Proposing a model change

State your reasoning. Assignment here is capability-vs-latency, not price:
Fable 5 for the hardest reasoning where a long turn is acceptable, Opus 5 for everything
else. Security is deliberately **not** on Fable 5 (cyber classifiers).

### Before opening a PR

- Does `./kur.sh` / `.\kur.ps1` run clean?
- Are all 20 agent files present?
- Are the README tables up to date?
