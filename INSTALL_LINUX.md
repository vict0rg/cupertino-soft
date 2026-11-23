# Instalar ou atualizar o Cupertino Soft no Linux

Estas instruções servem para **Linux Mint, Ubuntu e outras distribuições** que executem o Obsidian pelo pacote **.deb** ou **Flatpak**. O tema é instalado no *vault*, não dentro do pacote do Obsidian. Portanto, instalar o mesmo tema nas três máquinas não requer alterar o nome do computador.

## Instalação e ativação (método recomendado)

1. **Feche o Obsidian** em todas as janelas desta máquina.
2. Abra o terminal e execute os comandos abaixo:

```bash
mkdir -p "$HOME/Downloads"
curl -fL --retry 3 \
  https://raw.githubusercontent.com/vict0rg/cupertino-soft/main/scripts/install-and-activate.sh \
  -o "$HOME/Downloads/instalar-cupertino-soft.sh"
bash "$HOME/Downloads/instalar-cupertino-soft.sh"
```

Por padrão, o instalador usa seu vault em `~/Dropbox/500-OBSIDIAN` e instala **Cupertino Soft** em `<vault>/.obsidian/themes/Cupertino Soft/`.

Para outro vault, indique o caminho como argumento:

```bash
bash "$HOME/Downloads/instalar-cupertino-soft.sh" "$HOME/caminho/para/meu-vault"
```

O instalador baixa `theme.css` e `manifest.json` do repositório, confere o nome do tema e modifica **somente** o campo `cssTheme` em `.obsidian/appearance.json`, criando antes um backup datado desse arquivo quando ele existir. As notas, os plugins, os trechos CSS (snippets) e as demais preferências permanecem intactos.

3. Abra o Obsidian novamente. Em **Configurações > Aparência**, confirme que **Cupertino Soft** está selecionado.

## Atualizar o tema

Feche o Obsidian e execute novamente:

```bash
bash "$HOME/Downloads/instalar-cupertino-soft.sh"
```

O comando baixa o código atual da ramificação principal. Para instalar uma versão específica, use os anexos **theme.css** e **manifest.json** do Release correspondente em https://github.com/vict0rg/cupertino-soft/releases e coloque-os em `<vault>/.obsidian/themes/Cupertino Soft/`.

## Restaurar o tema padrão

Feche o Obsidian e execute:

```bash
bash "$HOME/Downloads/instalar-cupertino-soft.sh" --reset
```

O comando altera apenas a seleção do tema, sem apagar o Cupertino Soft ou qualquer nota.

## Instalação manual (sem script)

Crie a pasta `<vault>/.obsidian/themes/Cupertino Soft/`, salve nela os arquivos [theme.css](https://raw.githubusercontent.com/vict0rg/cupertino-soft/main/theme.css) e [manifest.json](https://raw.githubusercontent.com/vict0rg/cupertino-soft/main/manifest.json), reinicie o Obsidian e selecione o tema nas configurações de Aparência.

## Diferença entre instalar e aparecer na galeria

A instalação acima funciona independentemente da galeria. Para aparecer em **Aparência > Gerenciar**, a versão indicada em `manifest.json` precisa ter um **GitHub Release** com os dois arquivos anexados, uma captura de tela real, submissão e aprovação do diretório oficial do Obsidian. Consulte [SUBMISSION.md](SUBMISSION.md).

A identidade visual foi inspirada no tema [Cupertino](https://github.com/svnaxis/obsidian-cupertino), de svnaxis. Esta implementação independente é mantida por **vict0rg**.
