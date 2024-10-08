# LDSLibrary.nvim

## Introductions

This NeoVim plug in is designed to make importation of scripture references from the Church of Jesus Christ of Latter Day Saints' cannon easier. It was written to be used in conjunction with the program [Obsidian](https://obsidian.md) and with the corresponding NeoVim plug-in [obsidian.nvim](<https://github.com/epwalsh/obsidian.nvim>]. Otherwise the formatting won't make any sense.

## Usage

You can call a full chapter:

```
:Script 1 Nephi 1
```

You can call a singe verse:

```
:Script 1 Nephi 1:1
```

You can call a more complicated selection:

```
:Script 1 Nephi 1:5-6, 7, 9-10
```

You can even call multiple chapters from the same or different books at once with a ';' separating the references:

```
:Script 1 Nephi 1:5-6, 7, 9-10 ; 2 Nephi 5:5-6, 8, 11-14
```

## Requirements

- Neovim 0.7.0
- Plenary.nvim

## Installation

Using [Lazy](https://github.com/folke/lazy.nvim):

```
{
    'ingiestein/LDSLibrary.nvim',
    opts = { language = 'eng' },
    dependencies = {
        'nvim-lua/plenary.nvim',
        },
}
```

<!-- Using [packer](https://github.com/wbthomason/packer.nvim):

```
return require('packer').startup(function()
  use {
    'ingiestein/LDSLibrary.vim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('LDSLibrary').setup {
        language = 'eng'
      }
    end
  }
end)
``` -->

## Options

You can pass a language code as an option. The following codes are available at [www.churchofjesuschrist.org](www.churchofjesuschrist.org):

    orm: Afaan Oromoo
    afr: Afrikaans
    ase: American Sign Language (ASL)
    apw: Apache
    asf: Auslan
    aym: Aymar Aru
    ind: Bahasa Indonesia
    msa: Bahasa Melayu
    bam: Bambara
    tzo: Bats'i k'op
    bik: Bikol
    bis: Bislama
    cak: Cakchiquel
    cat: Català
    ceb: Cebuano
    ces: Česky
    cha: Chamoru
    nya: Chichewa
    cym: Cymraeg
    dan: Dansk
    deu: Deutsch
    nav: Diné bizaad
    cuk: Dulegaya
    yor: Èdè Yorùbá
    est: Eesti
    efi: Efik
    guz: EkeGusii
    eng: English
    spa: Español
    eus: Euskera
    ton: Faka-tonga
    fat: Fante
    hif: Fiji Hindi
    chk: Fosun Chuuk
    fon: Fɔngbè
    fra: Français
    smo: Gagana Samoa
    tvl: gana Tuvalu
    grn: Guaraní (Avañe'ẽ)
    hil: Hiligaynon
    hmo: Hiri Motu
    hmn: Hmoob
    hrv: Hrvatski
    haw: ʻŌlelo Hawaiʻi
    sto: I^ethka (Yethka)
    ibo: Igbo
    ilo: Ilokano
    nbl: isiNdebele
    xho: isiXhosa
    zul: isiZulu
    isl: Íslenska
    ita: Italiano
    kos: Kahs Kosrae
    mah: Kajin Majōl
    qvi: Kichwa
    kam: Kikamba
    kin: Kinyarwanda
    gil: Kiribati
    swa: Kiswahili
    niu: ko e vagahau Niuē
    hat: Kreyòl Ayisyen
    lav: Latviešu
    lit: Lietuvių
    lin: Lingála
    yua: maayaʼ tʼàan
    hun: Magyar
    pon: Mahsen en Pohnpei
    mlg: Malagasy
    mlt: Malti
    mam: Mam
    rar: Māori Kuki Airani
    nld: Nederlands
    bla: Nitsi’powahsin
    cag: Nivacle
    nor: Norsk
    pau: Palauan
    pam: Pampango
    pag: Pangasinan
    pap: Papiamento
    pol: Polski
    por: Português (Brasil)
    ept: Português (Portugal)
    kek: Q'eqchi'
    quh: Quechua-Bolivia
    quc: Quiché
    tah: Reo Tahiti
    ron: Română
    nso: sePêdi
    tsn: Setswana
    sna: Shona
    alb: Shqip
    ssw: siSwati
    slk: Slovenčina
    slv: Slovenščina
    sot: South Sotho
    fin: Suomi
    swe: Svenska
    tgl: Tagalog
    mri: Te Reo Māori
    yap: Thin Nu Wa'ab
    vie: Tiếng Việt
    tpi: Tok Pisin
    lua: Tshiluba
    tur: Türkçe
    twi: Twi
    fij: Vosa vakaviti
    war: Waray
    quz: Yunkay Quechua
    ell: Ελληνικά
    bul: Български
    kaz: Қазақ
    mkd: Македонски
    mon: Монгол
    rus: Русский
    srp: Српски
    ukr: Українська
    kat: ქართული
    hyw: Արեւմտահայերէն
    hye: Հայերեն
    urd: اردو
    ara: العربية
    pes: فارسی
    amh: አማርኛ
    nep: नेपाली
    hin: हिन्दी, हिंदी
    ben: বাংলা
    tam: தமிழ்
    tel: తెలుగు
    kan: ಕನ್ನಡ
    sin: සිංහල
    tha: ภาษาไทย
    lao: ພາສາລາວ
    ksw: ကညီလံာ်ခီၣ်ထံ
    mya: ဗမာစာ
    khm: ភាសាខ្មែរ
    kor: 한국어
    jpn: 日本語
    zhs: 简体中文 - 普通话
    zho: 繁體中文 - 國語
    yue: 繁體中文 - 廣東話
