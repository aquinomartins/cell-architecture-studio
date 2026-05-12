# Deploy em hospedagem compartilhada (SuperDomínios)

Este projeto gera **arquivos estáticos** com Vite. Em produção, não deve rodar `npm run dev`.

## 1) Estrutura recomendada no servidor

- Diretório do projeto (Git): por exemplo `~/repos/cell-architecture-studio`
- Diretório público do site: normalmente `~/public_html` (ou subpasta como `~/public_html/cell`)

## 2) Envio do projeto

### Opção A (recomendada): Git
```bash
git clone <URL_DO_REPOSITORIO> ~/repos/cell-architecture-studio
cd ~/repos/cell-architecture-studio
```

### Opção B: upload de .zip
1. Compacte o projeto localmente (sem `node_modules`).
2. Envie o `.zip` pelo gerenciador de arquivos (cPanel/DirectAdmin).
3. Descompacte no diretório do projeto (não diretamente em `public_html`).

## 3) Verificar Node e npm no servidor

```bash
node -v
npm -v
```

Se a versão do Node for antiga, altere via seletor de versão no painel da hospedagem (quando disponível).

## 4) Configurar base path (raiz ou subpasta)

Crie `.env` na raiz do projeto.

### Publicar na raiz (`https://meusite.com/`)
```env
VITE_BASE_PATH=/
```

### Publicar em subpasta (`https://meusite.com/cell/`)
```env
VITE_BASE_PATH=/cell/
```

> O valor deve começar e terminar com `/` quando for subpasta.

## 5) Instalar dependências

Com lockfile versionado, prefira:
```bash
npm ci
```

Alternativa:
```bash
npm install
```

## 6) Build de produção

```bash
npm run build:prod
```

A saída será criada em:
- `dist/`

## 7) Publicação manual para `public_html`

### Raiz do domínio
```bash
mkdir -p ../public_html
cp -a dist/. ../public_html/
```

### Subpasta
```bash
mkdir -p ../public_html/cell
cp -a dist/. ../public_html/cell/
```

## 8) Publicação automática com script

Este repositório inclui:
- `scripts/deploy-shared.sh`

Uso padrão (destino `../public_html`):
```bash
npm run deploy:shared
```

Definindo destino:
```bash
PUBLIC_DIR=../public_html npm run deploy:shared
```

Exemplo para subpasta:
```bash
PUBLIC_DIR=../public_html/cell npm run deploy:shared
```

O script:
- para em caso de erro;
- instala dependências (`npm ci` por padrão, ou `INSTALL_CMD=install`);
- executa `npm run build:prod`;
- limpa apenas artefatos comuns do build no destino (sem apagar `public_html` inteiro);
- copia `dist/` para o diretório público.

## 9) Atualização após `git pull`

```bash
cd ~/repos/cell-architecture-studio
git pull
npm ci
npm run build:prod
PUBLIC_DIR=../public_html npm run deploy:shared
```

## 10) Troubleshooting

### Tela branca / assets 404
- Causa comum: `VITE_BASE_PATH` incorreto.
- Se o site está em `/cell/`, use exatamente `VITE_BASE_PATH=/cell/`.
- Rebuild obrigatório após alterar `.env`.

### Erro de permissão ao copiar arquivos
- Ajuste permissões do diretório de destino (`public_html`) no painel.
- Confirme usuário proprietário dos arquivos.

### Erro de memória no build
Tente:
```bash
NODE_OPTIONS=--max-old-space-size=2048 npm run build:prod
```
Se necessário, aumente para `3072` (se o plano permitir).

### Limpar e refazer build
```bash
npm run clean
npm ci
npm run build:prod
```

## 11) Segurança

- Não copie a raiz do projeto inteira para `public_html`.
- Publique **apenas** o conteúdo de `dist/`.
- Não exponha arquivos sensíveis (`.env`, histórico Git, scripts internos, etc.) na pasta pública.
- O `.htaccess` final deve estar no diretório público publicado.
